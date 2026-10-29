"""Build this tool's adapters only. Never build or run the analyzed project."""
from __future__ import annotations
import argparse
import hashlib
import json
import os
from pathlib import Path
import subprocess
import urllib.request

ROOT = Path(__file__).resolve().parents[1]
# Fixed compile/runtime dependency set. Parent POM 3.26.3 pins Javassist/Guava below.
ARTIFACTS = [
    ("com/github/javaparser", "javaparser-core", "3.26.3"),
    ("com/github/javaparser", "javaparser-symbol-solver-core", "3.26.3"),
    ("org/javassist", "javassist", "3.30.2-GA"),
    ("com/google/guava", "guava", "33.3.1-jre"),
    ("com/google/guava", "failureaccess", "1.0.2"),
    ("com/google/guava", "listenablefuture", "9999.0-empty-to-avoid-conflict-with-guava"),
    ("com/google/code/findbugs", "jsr305", "3.0.2"),
    ("org/checkerframework", "checker-qual", "3.43.0"),
    ("com/google/errorprone", "error_prone_annotations", "2.28.0"),
    ("com/google/j2objc", "j2objc-annotations", "3.0.0"),
    ("com/google/code/gson", "gson", "2.11.0"),
]
def execute(args):
    print("执行工具自身构建：", args[0], flush=True)
    subprocess.run(args, check=True, cwd=ROOT, timeout=180, shell=False)

def dependencies(offline):
    folder = ROOT / ".build/java/lib"
    folder.mkdir(parents=True, exist_ok=True)
    manifest = []
    for group, artifact, version in ARTIFACTS:
        filename = f"{artifact}-{version}.jar"
        target = folder / filename
        url = f"https://repo.maven.apache.org/maven2/{group}/{artifact}/{version}/{filename}"
        if not target.exists():
            if offline:
                raise RuntimeError(f"离线缺少依赖：{target}")
            data = urllib.request.urlopen(url, timeout=40).read()
            # Maven Central publishes SHA-1 alongside these artifacts. Persist SHA-256 locally too.
            expected = urllib.request.urlopen(url + ".sha1", timeout=25).read().decode().split()[0].lower()
            if hashlib.sha1(data).hexdigest() != expected:
                raise RuntimeError(f"依赖校验失败：{filename}")
            target.write_bytes(data)
        manifest.append({"artifact": filename, "url": url,
                         "sha256": hashlib.sha256(target.read_bytes()).hexdigest()})
    lock = ROOT / ".build/java/artifacts.json"
    if lock.exists():
        previous = {x["artifact"]: x["sha256"] for x in json.loads(lock.read_text())}
        for m in manifest:
            if m["artifact"] in previous and previous[m["artifact"]] != m["sha256"]:
                raise RuntimeError(f"本地依赖哈希变化：{m['artifact']}，请人工核对")
    lock.write_text(json.dumps(manifest, indent=2) + "\n", encoding="utf-8")
    return folder

def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument("--java", action="store_true", help="构建 Java 助手")
    p.add_argument("--cangjie", action="store_true", help="构建仓颉助手，需要可用 SDK 1.2.0")
    p.add_argument("--javac", default="javac")
    p.add_argument("--cjc", default="cjc")
    p.add_argument("--offline", action="store_true", help="只使用已下载的 Java 依赖")
    args = p.parse_args()
    if not args.java and not args.cangjie:
        p.error("至少指定 --java 或 --cangjie")
    if args.java:
        lib = dependencies(args.offline)
        classes = ROOT / ".build/java/classes"
        classes.mkdir(parents=True, exist_ok=True)
        execute([args.javac, "-encoding", "UTF-8", "--release", "17", "-cp", str(lib / "*"),
                 "-d", str(classes), str(ROOT / "adapters/java/ProjectExtractor.java")])
        (ROOT / ".build/java/build.json").write_text(json.dumps({
            "source_sha256":hashlib.sha256((ROOT / "adapters/java/ProjectExtractor.java").read_bytes()).hexdigest(),
            "compiler":args.javac,"release":"17","execution":"built_only_not_run"
        },indent=2)+"\n",encoding="utf-8")
    if args.cangjie:
        folder = ROOT / ".build/cangjie"
        folder.mkdir(parents=True, exist_ok=True)
        exe = folder / ("ast_dump.exe" if os.name == "nt" else "ast_dump")
        execute([args.cjc, str(ROOT / "adapters/cangjie/ast_dump.cj"), "-o", str(exe)])
    print("构建命令完成；没有运行输入项目，也没有执行解析或测试实验。")

if __name__ == "__main__":
    main()

