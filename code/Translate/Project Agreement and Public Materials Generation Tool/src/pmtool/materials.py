"""Draft, evidence checks, conservative merge, deterministic Markdown export."""
from __future__ import annotations
import html
import json
from collections import Counter
from pathlib import Path
from typing import Literal
from pydantic import Field, model_validator
from . import db
from .models import CATEGORIES, StrictModel, Evidence, Issue, MaterialItem, Materials
from .util import stable_id, write_json, read_json

class Contribution(StrictModel):
    snapshot_id: str
    reviewed_file_ids: list[str] = Field(min_length=1)
    reviewed_categories: list[str] = Field(min_length=1)
    items: list[MaterialItem] = Field(default_factory=list)
    issues: list[Issue] = Field(default_factory=list)
    analysis_notes: list[str] = Field(min_length=1)

    @model_validator(mode="after")
    def meaningful_notes(self):
        if not any(note.strip() for note in self.analysis_notes):
            raise ValueError("分析记录不能全为空白")
        return self

def source(file: dict, start=1, end=None, member_id=None) -> Evidence | None:
    lines=file.get("content","").splitlines()
    if not lines: return None
    begin=max(1,min(start,len(lines)))
    finish=min(end or begin,len(lines))
    quote="\n".join(lines[begin-1:finish])
    if not quote.strip(): return None
    return Evidence(file_id=file["id"],start_line=begin,end_line=finish,quote=quote,member_id=member_id)

def draft(index: Path) -> Materials:
    meta=db.metadata(index)
    files={f["id"]:f for f in db.records(index,"files")}
    members={m["id"]:m for m in db.records(index,"members")}
    result=Materials(project_name=meta["project_name"],snapshot_id=meta["snapshot_id"],
        read_scope={"config":meta["config"],"versions":meta["versions"],"coverage":meta["coverage"],
                    "scope_note":"仅声明/语法草稿；未进行语义核验。未出现的分类需要Codex检查，不能视为项目不存在。",
                    "parser_source_hashes":meta.get("parser_source_hashes",{}),
                    "parser_environment":meta.get("parser_environment",{}),
                    "reviewable_file_ids":sorted(f["id"] for f in files.values() if f.get("content") and f.get("evidence_allowed",True))},
        analysis_notes=["程序草稿：未调用模型、未运行输入项目、未确认候选等价。"])
    def add(category, subject, title, content, evidence, status="extracted", basis="source_fact", limits=None, related=None):
        evidence=[e for e in evidence if e]
        if not evidence: return
        result.items.append(MaterialItem(id="P-"+stable_id(category,subject,title),category=category,
            subject=subject,title=title,content=content,basis=basis,status=status,sources=evidence,
            limitations=limits or [],related_members=related or [],scope="本次扫描："+subject))
    for f in files.values():
        if not f.get("content") or not f.get("evidence_allowed",True):continue
        first_member=min((m["start_line"] for m in members.values() if m["file_id"]==f["id"]),default=9)
        header_end=max(1,min(first_member-1,len(f["content"].splitlines())))
        add("C01",f["id"],"文件位置、包与导入",
            {k:f.get(k) for k in ("relative_path","root","module","language","role","effective_role","package","imports","status")},
            [source(f,1,header_end)],
            limits=["包/导入为空可能因为解析失败，不能直接认定没有声明。"] if f["status"]=="parse_failure" else [])
    for m in members.values():
        f=files[m["file_id"]]
        evidence=source(f,m["start_line"],min(m["end_line"],m["start_line"]+30),m["id"])
        if m["language"]=="cangjie":
            data={k:v for k,v in m.items() if k not in {"local_key"}}
            add("C03",m["id"],"目标签名与结构："+m["name"],data,[evidence],
                related=[m["id"]],limits=["语法事实，不保证类型已解析或接口行为等价。"])
            if m["kind"] in {"class","interface","struct","enum","extension","type_alias"}:
                add("C07",m["id"],"已有目标定义："+m["name"],
                    {"member_id":m["id"],"file_id":f["id"],"availability":"definition_present",
                     "runtime_verification":"not_run"},[evidence],related=[m["id"]])
        elif m.get("role") in {"test","setup","cleanup"}:
            add("C11",m["id"],"源测试机制观察："+m["role"],
                {"member_id":m["id"],"annotations":m.get("annotations",[]),"observed_role":m["role"]},
                [evidence],related=[m["id"]],
                limits=["观察到机制不代表翻译工具支持它；本条不是某测试输入或预期值。"])
    for fact in db.records(index,"facts"):
        f=files[fact["file_id"]]
        add(fact["category"],fact["id"],"配置声明："+fact["name"],
            {"key":fact["name"],"value":fact["value"]},
            [source(f,fact["start_line"],fact["end_line"])],limits=[fact["note"]] if fact.get("note") else [])
    for c in db.records(index,"candidates"):
        s,t=members[c["source_member"]],members[c["target_member"]]
        add("C02",c["id"],"待核对对应："+s["name"],
            {"source_member":s["id"],"target_member":t["id"],"signals":c["signals"],"ambiguous":c["ambiguous"]},
            [source(files[s["file_id"]],s["start_line"],min(s["end_line"],s["start_line"]+10),s["id"]),
             source(files[t["file_id"]],t["start_line"],min(t["end_line"],t["start_line"]+10),t["id"])],
            status="pending",basis="heuristic_candidate",limits=[c["note"]],related=[s["id"],t["id"]])
    result.issues=[Issue.model_validate(i) for i in db.records(index,"issues")]
    return result

def check(materials: Materials, index: Path, *, check_live=False) -> dict:
    meta=db.metadata(index)
    files={f["id"]:f for f in db.records(index,"files")}
    members={m["id"]:m for m in db.records(index,"members")}
    errors,warnings=[],[]
    if materials.snapshot_id!=meta["snapshot_id"]:errors.append("snapshot_id 与索引不一致：不能混用不同扫描的分析。")
    if materials.project_name!=meta["project_name"]:errors.append("project_name 与索引不一致")
    if materials.read_scope.get("config")!=meta["config"]:errors.append("read_scope.config 与扫描配置不一致")
    if materials.read_scope.get("versions")!=meta["versions"]:errors.append("read_scope.versions 与扫描版本不一致")
    if materials.read_scope.get("coverage")!=meta["coverage"]:errors.append("read_scope.coverage 与扫描覆盖记录不一致")
    if materials.read_scope.get("parser_environment")!=meta.get("parser_environment",{}):errors.append("parser_environment 与扫描不一致")
    if materials.read_scope.get("parser_source_hashes")!=meta.get("parser_source_hashes",{}):errors.append("工具源码版本记录与扫描不一致")
    allowed_files={f["id"] for f in files.values() if f.get("content") and f.get("evidence_allowed",True)}
    if set(materials.read_scope.get("reviewable_file_ids",[]))!=allowed_files:errors.append("可分析文件范围与索引不一致")
    if not set(materials.reviewed_file_ids)<=allowed_files:errors.append("已读范围含未知或被隔离的文件")
    if not set(materials.reviewed_categories)<=set(CATEGORIES):errors.append("已分析分类无效")
    if materials.phase=="codex_reviewed" and (set(materials.reviewed_file_ids)!=allowed_files or set(materials.reviewed_categories)!=set(CATEGORIES)):
        errors.append("codex_reviewed需要明确覆盖所有可分析文件及十一类；部分分析应保持codex_partial")
    def evidence_ok(e, owner):
        f=files.get(e.file_id)
        if not f or not f.get("content") or not f.get("evidence_allowed",True) or f["status"] in {"excluded","read_failure"}:
            errors.append(f"{owner}: 来源不可用 {e.file_id}");return
        lines=f["content"].splitlines()
        if not 1<=e.start_line<=e.end_line<=len(lines):
            errors.append(f"{owner}: 来源行号越界 {e.file_id}");return
        fragment="\n".join(lines[e.start_line-1:e.end_line])
        quote=e.quote.replace("\r\n","\n").replace("\r","\n")
        if quote not in fragment:
            errors.append(f"{owner}: 引文与快照行范围不匹配 {e.file_id}")
        if e.member_id:
            m=members.get(e.member_id)
            if not m or m["file_id"]!=e.file_id:
                errors.append(f"{owner}: member_id 不存在或与文件不符")
            elif not (m["start_line"]<=e.start_line<=e.end_line<=m["end_line"]):
                errors.append(f"{owner}: 引用行范围不在所标成员内")
    semantic_keys=Counter()
    item_ids={i.id for i in materials.items}
    for item in materials.items:
        for e in item.sources:evidence_ok(e,item.id)
        for mid in item.related_members:
            if mid not in members:errors.append(f"{item.id}: 未知 related_members {mid}")
        semantic_keys[(item.category,item.subject,item.title)]+=1
        if item.basis=="ai_analysis" and item.status=="confirmed":
            warnings.append(f"{item.id}: AI分析被标confirmed；需人工检查 confirmation_note 是否足以支持，程序不确认语义。")
    for key,count in semantic_keys.items():
        if count>1:errors.append("重复材料定位："+str(key))
    for issue in materials.issues:
        for e in issue.sources:evidence_ok(e,issue.id)
        for iid in issue.related_items:
            if iid not in item_ids:errors.append(f"{issue.id}: related_items 未找到 {iid}")
    for category in CATEGORIES:
        if not any(i.category==category for i in materials.items):
            warnings.append(f"{category}: 当前无条目；需结合覆盖范围确认，不能自动宣称项目没有。")
    if materials.phase!="codex_reviewed":
        warnings.append("当前为程序草稿或部分分析，AI综合整理尚未完成。")
    if check_live:
        from .util import digest
        from .models import ProjectConfig
        from .frontends import runtime_fingerprints
        current=runtime_fingerprints(ProjectConfig.model_validate(meta["config"]).parsers)
        if current!=meta.get("parser_environment"):errors.append("解析助手或classpath/环境已变化，请重新扫描")
        from .util import TOOL_ROOT
        for relative,expected in meta.get("parser_source_hashes",{}).items():
            path=TOOL_ROOT/relative
            if not path.is_file() or digest(path.read_bytes())!=expected:
                errors.append("工具实现源码已变化，请重新扫描："+relative)
        for f in files.values():
            if not f.get("sha256") or not f.get("content"):continue
            try:
                if digest(Path(f["path"]).read_bytes())!=f["sha256"]:
                    errors.append("输入已变更，请重新扫描："+f["id"])
            except OSError:errors.append("输入已不可读："+f["id"])
    return {"structurally_valid":not errors,"errors":errors,"warnings":warnings,
            "semantic_equivalence_verified":False,"execution":"未运行输入项目/测试"}

def merge(base: Materials, additions: list[Contribution], replace_ids: set[str], mark_complete=False) -> tuple[Materials, list]:
    result=base.model_copy(deep=True)
    records={x.id:x for x in result.items}
    issue_map={x.id:x for x in result.issues}
    changes=[]
    for part in additions:
        if part.snapshot_id!=base.snapshot_id:
            raise ValueError("分析贡献与基础材料 snapshot_id 不一致")
        result.reviewed_file_ids=sorted(set(result.reviewed_file_ids+part.reviewed_file_ids))
        result.reviewed_categories=sorted(set(result.reviewed_categories+part.reviewed_categories))
        for item in part.items:
            if item.id in records:
                old=records[item.id]
                if old==item:continue
                if item.id not in replace_ids:
                    raise ValueError(f"条目 {item.id} 已存在且内容不同；保留旧记录。核对后显式使用 --replace-id。")
                if old.basis=="human_confirmation" or old.status=="confirmed":
                    raise ValueError(f"拒绝自动替换已确认/人工记录 {item.id}；请人工处理冲突")
                changes.append({"id":item.id,"previous":old.model_dump(),"replacement":item.model_dump()})
            records[item.id]=item
        for issue in part.issues:
            if issue.id in issue_map and issue_map[issue.id]!=issue:
                raise ValueError(f"问题编号冲突 {issue.id}，请使用新编号或人工处理")
            issue_map[issue.id]=issue
        result.analysis_notes.extend(n for n in part.analysis_notes if n not in result.analysis_notes)
    result.items=list(records.values());result.issues=list(issue_map.values())
    result.phase="codex_reviewed" if mark_complete else "codex_partial"
    if changes:result.analysis_notes.append("合并包含显式替换的未确认条目；旧内容保留在 merge_audit.json。")
    # Revalidate assignment changes, not just individual item objects.
    return Materials.model_validate(result.model_dump()),changes

def safe_text(value):
    return html.escape(str(value)).replace("\n"," ").replace("\r"," ").replace("|","\\|")

def code_block(value):
    text=json.dumps(value,ensure_ascii=False,indent=2)
    import re
    longest=max((len(m.group()) for m in re.finditer(r"\x60+",text)),default=0)
    fence="\x60"*max(3,longest+1)
    return fence+"json\n"+text+"\n"+fence

def render(materials: Materials, report: dict) -> str:
    lines=["# 项目约定与公共材料","",
           f"项目：{safe_text(materials.project_name)}",
           f"扫描：{safe_text(materials.snapshot_id)}",
           f"阶段：{materials.phase}","",
           "> 直接事实、分析推断与确认状态分别记录；结构检查不证明语义等价。未运行输入项目或测试。",
           "", "## 读取范围与版本","",code_block(materials.read_scope),""]
    lines.extend(["已读文件："+safe_text(", ".join(materials.reviewed_file_ids) or "尚未记录"),
                  "已分析分类："+safe_text(", ".join(materials.reviewed_categories) or "尚未记录"),""])
    for category,name in CATEGORIES.items():
        lines.extend([f"## {category} {name}",""])
        items=[i for i in materials.items if i.category==category]
        if not items:
            lines.extend(["当前没有条目。请结合读取范围和问题清单核对；不等于项目中不存在。",""])
        for item in items:
            lines.extend([f"### {safe_text(item.id)} · {safe_text(item.title)}","",
                f"- 对象：{safe_text(item.subject)}",
                f"- 依据类型：{item.basis}；状态：{item.status}",
                f"- 适用范围：{safe_text(item.scope)}",
                f"- 确认说明：{safe_text(item.confirmation_note) or '未确认'}","",
                code_block(item.content),"","来源：",""])
            if not item.sources:lines.extend(["- 没有足够来源，必须保持缺失或待确认状态。",""])
            for e in item.sources:
                lines.append(f"- {safe_text(e.file_id)}，第{e.start_line}—{e.end_line}行"+
                             (f"；成员 {safe_text(e.member_id)}" if e.member_id else ""))
                lines.extend(["",code_block({"quote":e.quote}),""])
            lines.extend(["关联成员："+safe_text(", ".join(item.related_members) or "无"),""])
            for limit in item.limitations:lines.append("- 限制："+safe_text(limit))
            lines.append("")
    lines.extend(["## 缺失、冲突与待确认问题",""])
    for issue in materials.issues:
        lines.extend([f"### {safe_text(issue.id)} · {issue.kind}","",
                      safe_text(issue.subject),"",safe_text(issue.description),""])
        if issue.sources:lines.extend([code_block([e.model_dump() for e in issue.sources]),""])
        if issue.related_items:lines.extend(["关联条目："+safe_text(", ".join(issue.related_items)),""])
    lines.extend(["## 分析记录","",*[("- "+safe_text(n)) for n in materials.analysis_notes],"",
                  "## 结构与来源检查","",code_block(report),""])
    return "\n".join(lines)

def export_files(materials: Materials, index: Path, output: Path, *, overwrite=False):
    report=check(materials,index)
    if report["errors"]:raise ValueError("检查未通过：\n"+"\n".join(report["errors"]))
    json_path,md_path=output/"project_materials.json",output/"project_materials.md"
    if not overwrite and (json_path.exists() or md_path.exists()):
        raise FileExistsError("最终文件已存在，请换目录或明确使用 --overwrite；先保留人工改动。")
    output.mkdir(parents=True,exist_ok=True)
    write_json(json_path,materials.model_dump(),overwrite=overwrite)
    md_path.write_text(render(materials,report),encoding="utf-8")
    return report

