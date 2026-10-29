from __future__ import annotations
import json
import os
import shutil
from pathlib import Path
from .util import TOOL_ROOT, run, write_json, read_json, digest
from .cj_ast import normalize_dump

def java_extract(files, settings, job_dir: Path, source_roots):
    classes = TOOL_ROOT / ".build/java/classes"
    jars = TOOL_ROOT / ".build/java/lib"
    if not (classes / "ProjectExtractor.class").is_file():
        raise RuntimeError("Java 助手未构建。先执行 python scripts/build_adapters.py --java。")
    build_manifest = TOOL_ROOT / ".build/java/build.json"
    if not build_manifest.is_file() or read_json(build_manifest).get("source_sha256") != digest((TOOL_ROOT / "adapters/java/ProjectExtractor.java").read_bytes()):
        raise RuntimeError("Java构建记录缺失或源码已变化，请重新构建助手。")
    job_dir.mkdir(parents=True, exist_ok=True)
    def mirrored(path):
        original = Path(path).resolve()
        drive = original.drive.replace(":", "").replace("\\", "_") or "root"
        return job_dir / "java_snapshot" / drive / Path(*original.parts[1:])
    original_paths = {}
    snapshot_paths = []
    for file in files:
        staged = mirrored(file["path"])
        staged.parent.mkdir(parents=True, exist_ok=True)
        with staged.open("w", encoding="utf-8", newline="") as handle:
            handle.write(file["content"])
        original_paths[os.path.normcase(str(staged.resolve()))] = file["path"]
        snapshot_paths.append(str(staged.resolve()))
    staged_roots = []
    for root in source_roots:
        staged = mirrored(root)
        staged.mkdir(parents=True, exist_ok=True)
        staged_roots.append(str(staged.resolve()))
    job = job_dir / "java-job.json"
    write_json(job, {"files": snapshot_paths, "source_roots": staged_roots,
                     "classpath": settings.java_classpath,
                     "language_level": settings.java_language_level}, overwrite=True)
    cp = os.pathsep.join([str(classes), str(jars / "*")])
    response = run([settings.java, "-Dfile.encoding=UTF-8", "-cp", cp, "ProjectExtractor", str(job)],
                   timeout=settings.timeout_seconds)
    result = json.loads(response.stdout)
    if result.get("protocol") != "java-ast-v1":
        raise ValueError("Java 助手协议不匹配")
    for file in result["files"]:
        file["path"] = original_paths[os.path.normcase(str(Path(file["path"]).resolve()))]
    write_json(job_dir / "java-result.json", result, overwrite=True)
    return result

def cangjie_extract(file: dict, settings, job_dir: Path):
    configured = settings.cangjie_helper
    helper = Path(configured) if configured else TOOL_ROOT / ".build/cangjie" / ("ast_dump.exe" if os.name == "nt" else "ast_dump")
    if not helper.is_file():
        raise RuntimeError("仓颉助手未构建/未配置。安装可用 SDK 1.2.0 后构建，或配置 parsers.cangjie_helper；不会静默改用正则。")
    staged = job_dir / "cangjie_snapshot" / (__import__("hashlib").sha256(file["id"].encode()).hexdigest() + ".cj")
    staged.parent.mkdir(parents=True, exist_ok=True)
    with staged.open("w", encoding="utf-8", newline="") as handle:
        handle.write(file["content"])
    response = run([str(helper), str(staged)], timeout=settings.timeout_seconds)
    raw = response.stdout
    artifact = job_dir / "cangjie" / (Path(file["path"]).name + "-" + __import__("hashlib").sha256(file["id"].encode()).hexdigest()[:12] + ".ast.txt")
    artifact.parent.mkdir(parents=True, exist_ok=True)
    artifact.write_text(raw, encoding="utf-8")
    result = normalize_dump(raw)
    result["raw_ast"] = str(artifact)
    return result

def doctor(settings):
    def locate(command):
        path = Path(command)
        return str(path.resolve()) if path.is_file() else shutil.which(command)
    return {
        "java": locate(settings.java), "javac": locate(settings.javac), "cjc": locate(settings.cjc),
        "java_adapter_built": (TOOL_ROOT / ".build/java/classes/ProjectExtractor.class").is_file(),
        "cangjie_adapter_built": (Path(settings.cangjie_helper).is_file() if settings.cangjie_helper
            else (TOOL_ROOT / ".build/cangjie" / ("ast_dump.exe" if os.name == "nt" else "ast_dump")).is_file()),
        "note": "仅检查路径和构建产物，不执行版本命令，不代表解析/运行验证通过。",
    }

def runtime_fingerprints(settings):
    """Fingerprint actual helpers, configured classpath and selected runtime metadata."""
    def file_record(path):
        p = Path(path)
        return {"path":str(p.resolve()),"sha256":digest(p.read_bytes()) if p.is_file() else None}
    result = {"classpath":[file_record(p) for p in settings.java_classpath],
              "java_libraries":[file_record(p) for p in sorted((TOOL_ROOT/".build/java/lib").glob("*.jar"))],
              "java_classes":[file_record(p) for p in sorted((TOOL_ROOT/".build/java/classes").glob("*.class"))],
              "environment":{k:os.environ.get(k) for k in ("JAVA_HOME","CANGJIE_HOME")}}
    for name in ("java","cjc"):
        configured = getattr(settings,name)
        located = str(Path(configured).resolve()) if Path(configured).is_file() else shutil.which(configured)
        result[name] = file_record(located) if located else {"configured":configured,"available":False}
        if located and name=="java":
            release = Path(located).parent.parent/"release"
            if release.is_file():result["jdk_release"]=file_record(release)
    cj = Path(settings.cangjie_helper) if settings.cangjie_helper else TOOL_ROOT/".build/cangjie"/("ast_dump.exe" if os.name=="nt" else "ast_dump")
    result["cangjie_helper"] = file_record(cj)
    result["limitations"] = "记录已识别助手、JAR、JDK元数据及环境根；不保证穷尽系统动态库，也不证明SDK运行正确。"
    return result

