from __future__ import annotations
import fnmatch
import json
import os
import re
import stat
import subprocess
from collections import defaultdict
from pathlib import Path
from . import db
from .config_extract import extract_config
from .frontends import java_extract, cangjie_extract, runtime_fingerprints
from .models import ProjectConfig
from .util import digest, run, stable_id, write_json, TOOL_ROOT

IGNORED_DIRS = {".git", ".venv", "venv", "node_modules", "__pycache__", "target",
                "build", "bin", "obj", ".idea", ".gradle", ".build"}
DOC_SUFFIXES = {".md", ".txt", ".json", ".toml", ".xml", ".properties", ".yaml", ".yml", ".ps1", ".sh", ".gradle", ".kts"}
TARGET_TEST = ("*_test.cj", "*test.cj", "*tests.cj", "test_*.cj")

def matches(path, patterns):
    return any(fnmatch.fnmatchcase(path, p) or (p.startswith("**/") and fnmatch.fnmatchcase(path,p[3:])) for p in patterns)

def linked(path: Path):
    info = path.lstat()
    return path.is_symlink() or bool(getattr(info,"st_file_attributes",0) & getattr(stat,"FILE_ATTRIBUTE_REPARSE_POINT",0))

def git_info(root: Path):
    cwd = root if root.is_dir() else root.parent
    try:
        prefix=["git","--no-optional-locks","-c","core.fsmonitor=false"]
        top = run(prefix+["-C",str(cwd),"rev-parse","--show-toplevel"], timeout=15).stdout.strip()
        commit = run(prefix+["-C",top,"rev-parse","HEAD"], timeout=15).stdout.strip()
        dirty = bool(run(prefix+["-C",top,"status","--porcelain","--untracked-files=normal","--ignore-submodules=all"], timeout=15).stdout.strip())
        return {"root":top,"commit":commit,"working_tree_dirty":dirty,
                "note":"文件哈希才是本次实际读取内容依据，dirty状态不证明与HEAD相同"}
    except (RuntimeError, OSError, TimeoutError, subprocess.TimeoutExpired):
        return {"root":str(cwd),"commit":None,"note":"非可读Git工作副本；使用逐文件SHA-256"}

def scan(config: ProjectConfig, config_path: Path):
    out = Path(config.output_dir)
    index = out / "index.sqlite"
    if index.exists() or (out / "scan.json").exists():
        raise FileExistsError("输出目录已有扫描；请更换 output_dir，避免覆盖人工结果和旧证据。")
    for source in config.sources:
        p = Path(source.path)
        if out == p or out in p.parents:
            raise ValueError("输出目录不能等于输入根或包含输入根")
        if p == TOOL_ROOT or TOOL_ROOT in p.parents:
            raise ValueError("不要将本工具代码目录作为待分析项目")
    out.mkdir(parents=True, exist_ok=True)
    files, members, refs, facts, candidates, issues = [], [], [], [], [], []
    seen_paths = {}
    root_versions = {}
    def issue(kind, subject, description, file=None):
        record = {"id":"I-"+stable_id(kind,subject,description),"kind":kind,"subject":subject,
                  "description":description, "sources":[],"related_items":[]}
        if file and file.get("content"):
            line = file["content"].splitlines()
            if line: record["sources"]=[{"file_id":file["id"],"start_line":1,"end_line":1,"quote":line[0]}] if line[0] else []
        if record["id"] not in {i["id"] for i in issues}: issues.append(record)
    def module_for(path, root, name):
        # Nearest build descriptor within the configured root; no assumption across roots.
        parent = path.parent
        boundary = root if root.is_dir() else root.parent
        while parent == boundary or boundary in parent.parents:
            if any((parent/x).is_file() for x in ("pom.xml","cjpm.toml","build.gradle","build.gradle.kts")):
                return name+"::"+parent.relative_to(boundary).as_posix()
            if parent == boundary: break
            parent = parent.parent
        return name
    for source in config.sources:
        root = Path(source.path)
        root_versions[source.name] = git_info(root)
        if not root.exists():
            issue("read_failure",source.name,f"输入不存在：{root}"); continue
        try:
            if linked(root):
                issue("excluded",source.name,"输入根是链接/联接，未遍历"); continue
        except OSError as ex:
            issue("read_failure",source.name,str(ex));continue
        iterator = []
        if root.is_file():
            iterator = [root]
        else:
            for folder, dirs, names in os.walk(root, followlinks=False,
                    onerror=lambda ex: issue("read_failure",source.name,str(ex))):
                parent = Path(folder)
                for d in list(dirs):
                    child = parent/d
                    relative = child.relative_to(root).as_posix()
                    try:
                        reason = "依赖/生成目录" if d in IGNORED_DIRS else "输出目录" if child.resolve()==out.resolve() else "链接/联接" if linked(child) else "排除规则" if matches(relative, config.exclude+source.exclude) or matches(relative+"/",config.exclude+source.exclude) else ""
                        if reason:
                            dirs.remove(d); issue("excluded",source.name+":"+relative,reason)
                    except OSError as ex:
                        dirs.remove(d); issue("read_failure",str(child),str(ex))
                iterator.extend(parent/n for n in names)
        for path in sorted(iterator):
            rel = path.relative_to(root).as_posix() if root.is_dir() else path.name
            fid = source.name+":"+rel
            record = {"id":fid,"file_id":fid,"name":path.name,"module":module_for(path,root,source.name),
                      "root":source.name,"path":str(path.resolve()),"relative_path":rel,
                      "language":source.language,"role":source.role,"status":"collected","content":"",
                      "package":"","imports":[],"parser":None}
            def skip(reason):
                record["status"]="excluded";record["reason"]=reason
                files.append(record)
            try:
                if linked(path): skip("链接/联接"); continue
            except OSError as ex:
                record.update(status="read_failure",reason=str(ex));files.append(record)
                issue("read_failure",fid,str(ex));continue
            if not matches(rel,source.include) or matches(rel,config.exclude+source.exclude):
                skip("include/exclude规则");continue
            if source.language=="cangjie" and not config.allow_target_tests and (source.role=="test" or any(fnmatch.fnmatchcase(path.name.lower(),p) for p in TARGET_TEST)):
                skip("默认排除目标参考测试"); continue
            if source.language=="java" and path.suffix.lower()!=".java" and path.suffix.lower() not in DOC_SUFFIXES:
                skip("非Java源码/已支持文本配置");continue
            if source.language=="cangjie" and path.suffix.lower()!=".cj" and path.suffix.lower() not in DOC_SUFFIXES:
                skip("非仓颉源码/已支持文本配置");continue
            if source.language=="documents" and path.suffix.lower() not in DOC_SUFFIXES:
                skip("不支持的文档格式");continue
            canonical = os.path.normcase(str(path.resolve()))
            if canonical in seen_paths:
                raise ValueError(f"输入范围重叠：{path}，已由 {seen_paths[canonical]} 收集。请调整 roots/include/exclude。")
            seen_paths[canonical] = fid
            try:
                if path.stat().st_size > config.max_file_bytes:
                    skip("文件超过max_file_bytes");continue
                before = path.stat()
                data = path.read_bytes()
                after = path.stat()
                if (before.st_size,before.st_mtime_ns)!=(after.st_size,after.st_mtime_ns):
                    raise ValueError("读取期间文件发生变化，请在稳定工作副本重试")
                text = data.decode(source.encoding)
                if "\x00" in text: raise ValueError("文件包含NUL，不能按文本处理")
                record.update(content=text,sha256=digest(data),text_sha256=digest(text),
                              size_bytes=len(data),line_count=len(text.splitlines()),
                              mtime_ns=after.st_mtime_ns,encoding=source.encoding)
                files.append(record)
                if path.suffix.lower() not in {".java",".cj"}:
                    try:
                        extracted, problems = extract_config(str(path),text)
                        for fact in extracted:
                            fact.update(id="F-"+stable_id(fid,fact["name"],fact["value"],fact["start_line"]),
                                        file_id=fid,module=record["module"],category="C08")
                            facts.append(fact)
                        for note in problems: issue("pending",fid,note,record)
                    except Exception as ex:
                        issue("parse_failure",fid,"配置解析失败："+str(ex),record)
            except (OSError, UnicodeError, ValueError) as ex:
                record["status"]="read_failure"; record["content"]=""
                if record not in files: files.append(record)
                issue("read_failure",fid,str(ex))

    def attach(file, result, parser_name):
        file["parser"]=parser_name
        file["status"]=result.get("status","parsed")
        file["package"]=result.get("package","")
        file["imports"]=result.get("imports",[])
        raw_members=result.get("members",[])
        if file["language"]=="cangjie" and not config.allow_target_tests and (result.get("contains_test_annotations") or any(m.get("role")=="test" for m in raw_members)):
            file.update(status="excluded",reason="AST识别出目标测试注解",content="")
            issue("excluded",file["id"],"按AST注解排除目标测试文件");return
        is_java_test=file["role"]=="test" or (file["language"]=="java" and (
            "/test/" in "/"+file["relative_path"] or any(m.get("role") in {"test","setup","cleanup"} for m in raw_members)))
        file["effective_role"]="test" if is_java_test else file["role"]
        for m in raw_members:
            begin,end=m.get("start_line",0),m.get("end_line",0)
            if not (1<=begin<=end<=max(1,len(file["content"].splitlines()))):
                issue("parse_failure",file["id"],"成员源码行号超出快照范围："+m.get("name",""));continue
            m.update(id="M-"+stable_id(file["id"],m["kind"],m.get("qualified_name"),m.get("local_key")),
                     file_id=file["id"],module=file["module"],language=file["language"],
                     file_role=file["effective_role"],package=file["package"],parser=parser_name)
            members.append(m)
        for n,r in enumerate(result.get("references",[])):
            r.update(id="R-"+stable_id(file["id"],r.get("start_line"),r.get("expression"),n),
                     file_id=file["id"],module=file["module"],language=file["language"])
            refs.append(r)
            if r.get("resolution")=="unresolved":
                issue("unresolved_reference",r["id"],r.get("reason","未解析调用"),file)
        for problem in result.get("issues",[]):
            issue("parse_failure" if result.get("status")=="parse_failure" else "coverage",file["id"],str(problem),file)

    java_files=[f for f in files if f["content"] and f["relative_path"].lower().endswith(".java") and f["language"]=="java"]
    if java_files:
        try:
            roots=config.parsers.java_source_roots or sorted(set(str(Path(s.path)) for s in config.sources if s.language=="java" and Path(s.path).is_dir()))
            # Source roots nested under conventional Maven layouts are needed by JavaSymbolSolver.
            if not config.parsers.java_source_roots:
                roots=sorted(set(roots + [str(p) for s in config.sources if s.language=="java" for suffix in ("src/main/java","src/test/java") if (p:=Path(s.path)/suffix).is_dir()]))
            result=java_extract(java_files,config.parsers,out/"parser_artifacts",roots)
            lookup={os.path.normcase(str(Path(r["path"]).resolve())):r for r in result["files"]}
            for f in java_files:
                parsed=lookup.get(os.path.normcase(f["path"]))
                if parsed is None:
                    f["status"]="parse_failure"; issue("parse_failure",f["id"],"Java助手未返回此文件",f)
                else: attach(f,parsed,result["parser"])
            for problem in result.get("setup_issues",[]): issue("coverage","java_solver",problem)
        except Exception as ex:
            for f in java_files:
                f["status"]="parse_failure";issue("parse_failure",f["id"],str(ex),f)
    for f in files:
        if f["content"] and f["language"]=="cangjie" and f["relative_path"].lower().endswith(".cj"):
            try: attach(f,cangjie_extract(f,config.parsers,out/"parser_artifacts"),"std.ast-1.2-dump")
            except Exception as ex:
                f["status"]="parse_failure";issue("parse_failure",f["id"],str(ex),f)
            if f["status"] in {"parse_failure","partial"} and not config.allow_target_tests and not config.allow_unparsed_target_evidence:
                f["evidence_allowed"]=False
                issue("coverage",f["id"],"目标文件未完整分类，暂时隔离正文，防止无解析器时漏入任意名称的参考测试。核对业务范围后可明确配置allow_unparsed_target_evidence并新建扫描。")
    blocked={f["id"] for f in files if not f.get("evidence_allowed",True) or f["status"]=="excluded"}
    members=[m for m in members if m["file_id"] not in blocked]
    refs=[r for r in refs if r["file_id"] not in blocked]
    facts=[f for f in facts if f["file_id"] not in blocked]
    for problem in issues:
        if any(e["file_id"] in blocked for e in problem["sources"]):
            problem["sources"]=[e for e in problem["sources"] if e["file_id"] not in blocked]
            problem["description"]+="；相关正文已隔离，问题保留文件标识但不输出引文。"
    # Parsers read isolated UTF-8 snapshots. Live changes are reported, never merged into that snapshot.
    changed=set()
    for f in files:
        if f.get("sha256") and f["content"]:
            try:
                if digest(Path(f["path"]).read_bytes())!=f["sha256"]: changed.add(f["id"])
            except OSError: changed.add(f["id"])
    if changed:
        for f in files:
            if f["id"] in changed:
                issue("pending",f["id"],"扫描后原文件变化；结构与证据仍对应所保存快照。交付前请check --live并重新扫描。",f)
    by_signature=defaultdict(list)
    for m in members:
        if m.get("resolved_signature"):by_signature[m["resolved_signature"]].append(m["id"])
        if m.get("kind")=="field":by_signature[m["qualified_name"]].append(m["id"])
    for r in refs:
        targets=by_signature.get(r.get("target_signature",""),[])
        r["target_member_ids"]=targets
        if len(targets)>1:
            r["resolution"]="ambiguous";issue("unresolved_reference",r["id"],"多个声明匹配同一解析签名，保留歧义")
        elif r.get("resolution")=="resolved" and not targets:
            r["resolution"]="external_or_unindexed"
    source_members=[m for m in members if m["language"]=="java" and m["file_role"]!="test"]
    target_members=[m for m in members if m["language"]=="cangjie" and m["file_role"]!="test"]
    def type_name(m):return m.get("owner","").split(".")[-1].split("(")[0]
    for s in source_members:
        choices=[]
        for t in target_members:
            if s["kind"]!=t["kind"]:continue
            same_name=s["name"]==t["name"] or s["kind"]=="constructor" and type_name(s)==type_name(t)
            if not same_name:continue
            features=["same_kind","same_name_or_constructor_owner"]
            if type_name(s)==type_name(t):features.append("same_owner_simple_name")
            if len(s.get("parameters",[]))==len(t.get("parameters",[])):features.append("same_arity")
            choices.append((t,features))
        for t,features in choices:
            candidates.append({"id":"C-"+stable_id(s["id"],t["id"]),"file_id":s["file_id"],"module":s["module"],
                "name":s["name"],"source_member":s["id"],"target_member":t["id"],
                "signals":features,"status":"pending","ambiguous":len(choices)>1,
                "note":"仅语法/名称候选；不证明行为、类型或异常等价，需要Codex根据证据分析。"})
        if not choices:
            issue("pending",s["id"],"未生成目标对应候选；可能是缺失、改名、目标解析不可用或范围外，不能直接断言目标不存在。")
    parser_fingerprints={str(p.relative_to(TOOL_ROOT)):digest(p.read_bytes()) for p in [
        TOOL_ROOT/"adapters/java/ProjectExtractor.java",TOOL_ROOT/"adapters/cangjie/ast_dump.cj",
        *sorted((TOOL_ROOT/"src/pmtool").glob("*.py"))] if p.is_file()}
    environment_fingerprints=runtime_fingerprints(config.parsers)
    snapshot_id=stable_id(config.model_dump(),[(f["id"],f.get("sha256"),f["status"]) for f in files],parser_fingerprints,environment_fingerprints)
    meta={"schema_version":"1.0","project_name":config.project_name,"snapshot_id":snapshot_id,
          "config":config.model_dump(),"config_path":str(config_path.resolve()),
          "versions":root_versions,"parser_source_hashes":parser_fingerprints,
          "parser_environment":environment_fingerprints,
          "coverage":{"files":len(files),"members":len(members),"references":len(refs),
                      "issues":len(issues),"status_counts":{s:sum(f["status"]==s for f in files) for s in sorted({f["status"] for f in files})}},
          "analysis_state":"program_only","execution":"未运行输入项目或测试"}
    db.create(index)
    db.save(index,meta,{"files":files,"members":members,"references":refs,"facts":facts,
                        "candidates":candidates,"issues":issues})
    write_json(out/"scan.json",meta)
    return meta

