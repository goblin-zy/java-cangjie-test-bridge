"""调用 javac/java 运行 SymbolFacts.java；只解析输入项目，使用已随包提供的依赖。"""
from pathlib import Path
import os
import shutil
import subprocess
import tempfile

from common import load, save, sha

HERE = Path(__file__).resolve().parent


def analyze(context, output, java="java", javac="javac", classpath=(), timeout=300, syntax_only=False):
    """编译本工具的解析代码，再运行解析；输入工程不会加入运行时 classpath。

    JavaParser.parse 一次返回结构事实与引用分析结果。项目 JAR 仅供
    JarTypeSolver 读取声明，不参与运行本工具，也不执行项目构建脚本。
    """
    folder = Path(output)
    library = HERE / "vendor/java-libs"
    manifest = load(library / "manifest.json")
    for entry in manifest:
        if sha(library / entry["file"]) != entry["sha256"]:
            raise ValueError("本地解析依赖摘要不符: " + entry["file"])
    jars = [Path(p).resolve() for p in classpath]
    for path in jars:
        if not path.is_file() or path.suffix.lower() != ".jar":
            raise ValueError("classpath当前只接受本地JAR文件: " + str(path))
    roots = sorted({str(context.project / p) for values in context.scope["source_roots"].values() for p in values})
    if not roots:
        roots = [str(context.project)]
    folder.mkdir(parents=True)
    frozen = []
    for i, path in enumerate(jars):
        target = folder / "classpath" / (str(i) + "-" + path.name)
        target.parent.mkdir(exist_ok=True)
        shutil.copyfile(path, target)
        if sha(path) != sha(target):
            raise ValueError("JAR在复制过程中变化")
        frozen.append(target)
    job = {"source_roots": roots, "classpath": [str(p) for p in frozen], "syntax_only": syntax_only,
           "files": [str(context.project / f["file"]) for f in context.files.values() if f["parse_input"]]}
    save(folder / "job.json", job)
    with tempfile.TemporaryDirectory(prefix="context-symbol-helper-") as name:
        classes = Path(name)
        commands = [[javac, "-encoding", "UTF-8", "--release", "17", "-cp", str(library / "*"),
                     "-d", str(classes), str(HERE / "tools/SymbolFacts.java")],
                    [java, "-Xmx1536m", "-Dfile.encoding=UTF-8", "-cp", str(classes) + os.pathsep + str(library / "*"),
                     "SymbolFacts", str(folder / "job.json"), str(folder / "semantic.json")]]
        for i, command in enumerate(commands):
            process = subprocess.run(command, capture_output=True, timeout=timeout,
                                     creationflags=getattr(subprocess, "CREATE_NO_WINDOW", 0))
            (folder / f"command-{i}.stdout.log").write_bytes(process.stdout)
            (folder / f"command-{i}.stderr.log").write_bytes(process.stderr)
            if process.returncode:
                raise ValueError("运行 SymbolFacts.java 失败: " + process.stderr.decode("utf-8", errors="replace")[-4000:])
    fingerprint = {"helper_sha256": sha(HERE / "tools/SymbolFacts.java"),
                   "libraries": manifest, "project_classpath": [{"file": p.relative_to(folder.parent).as_posix(), "sha256": sha(p)} for p in frozen]}
    return load(folder / "semantic.json"), fingerprint
