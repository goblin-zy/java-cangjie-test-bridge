"""Collect project method coverage in a fresh JVM for each JUnit selector."""
import argparse
import hashlib
import json
from pathlib import Path
import subprocess
import sys
import xml.etree.ElementTree as ET


def read(path):
    return json.loads(path.read_text(encoding="utf-8-sig"))


def write(path, value):
    path.write_text(json.dumps(value, ensure_ascii=False, indent=2), encoding="utf-8")


def run(command, log, cwd, timeout):
    try:
        result = subprocess.run(command, cwd=cwd, capture_output=True, timeout=timeout)
        log.write_bytes(result.stdout + result.stderr)
        return result.returncode
    except (OSError, subprocess.TimeoutExpired) as error:
        log.write_text(str(error), encoding="utf-8")
        return -1


def collect(config):
    project = Path(config["project_root"]).resolve()
    out = Path(config["output_dir"]).resolve()
    if out.exists() or out.is_relative_to(project):
        raise ValueError("输出须为项目之外的新目录")
    out.mkdir(parents=True)
    report = {"schema_version": "1.0", "scope": "whole selected test invocation including fixtures",
              "tests": [], "status": "running", "class_hashes": {}}
    write(out / "java_coverage.json", report)
    timeout = config.get("timeout_seconds", 120)
    for i, command in enumerate(config.get("build_commands", [])):
        if run(command, out / f"build-{i}.log", project, timeout):
            report["status"] = "build_failed"
            write(out / "java_coverage.json", report)
            return report
    classes = [Path(p).resolve() for p in config["business_classes"]]
    if not classes or any(not p.is_dir() for p in classes):
        raise ValueError("business_classes 必须为实际业务 class 目录")
    for root in classes:
        for path in root.rglob("*.class"):
            report["class_hashes"][str(path)] = hashlib.sha256(path.read_bytes()).hexdigest()
    if not report["class_hashes"]:
        raise ValueError("没有业务 class 文件")
    for selector in config["tests"]:
        key = hashlib.sha256(selector.encode()).hexdigest()[:16]
        folder = out / key
        folder.mkdir()
        execution = folder / "coverage.exec"
        xml = folder / "coverage.xml"
        junit = folder / "junit"
        cmd = [config["java"], f'-javaagent:{config["agent_jar"]}=destfile={execution},append=false',
               "-jar", config["junit_jar"], "execute", "--class-path",
               ";".join(config["classpath"]) if sys.platform == "win32" else ":".join(config["classpath"]),
               "--select-method", selector, "--reports-dir", str(junit),
               "--fail-if-no-tests", "--disable-ansi-colors"]
        code = run(cmd, folder / "test.log", project, timeout)
        cases = []
        for result in junit.glob("*.xml"):
            cases.extend(ET.parse(result).getroot().iter("testcase"))
        executed = [c for c in cases if c.find("skipped") is None]
        failed = any(c.find("failure") is not None or c.find("error") is not None for c in executed)
        item = {"test": selector, "test_result": "failed" if failed else "passed",
                "executed_cases": len(executed), "exit_code": code,
                "coverage_status": "unavailable", "executed_methods": [], "evidence": key}
        if not executed or code not in (0, 1) or (code != 0 and not failed):
            item["test_result"] = "not_completed"
        if len(executed) != 1:
            item["reason"] = "第一版要求一次选择实际执行一个测试用例"
        elif execution.exists() and item["test_result"] != "not_completed":
            args = [config["java"], "-jar", config["cli_jar"], "report", str(execution)]
            for root in classes:
                args += ["--classfiles", str(root)]
            args += ["--xml", str(xml)]
            rc = run(args, folder / "report.log", project, timeout)
            log = (folder / "report.log").read_text(encoding="utf-8", errors="replace")
            if rc == 0 and xml.exists() and "does not match" not in log:
                for cls in ET.parse(xml).getroot().iter("class"):
                    for method in cls.findall("method"):
                        hit = any(c.get("type") == "INSTRUCTION" and int(c.get("covered", "0")) > 0
                                  for c in method.findall("counter"))
                        if hit:
                            item["executed_methods"].append({"class": cls.get("name").replace("/", "."),
                                "name": method.get("name"), "descriptor": method.get("desc"),
                                "line": method.get("line")})
                item["coverage_status"] = "collected"
            else:
                item["reason"] = "报告失败或 class 版本不匹配，查看 report.log"
        else:
            item["reason"] = "没有可用的执行数据，查看 test.log"
        report["tests"].append(item)
        write(out / "java_coverage.json", report)
    changed = [p for p,h in report["class_hashes"].items()
               if not Path(p).exists() or hashlib.sha256(Path(p).read_bytes()).hexdigest() != h]
    if changed:
        for item in report["tests"]:
            item["coverage_status"] = "invalidated"
            item["reason"] = "采集期间业务 class 发生变化"
    report["status"] = "complete" if report["tests"] and all(
        t["coverage_status"] == "collected" for t in report["tests"]) else "partial"
    write(out / "java_coverage.json", report)
    return report


if __name__ == "__main__":
    sys.stdout.reconfigure(encoding="utf-8")
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--config", type=Path, required=True)
    args = parser.parse_args()
    try:
        print(json.dumps(collect(read(args.config)), ensure_ascii=False))
    except (OSError, ValueError, KeyError, ET.ParseError) as error:
        print(str(error), file=sys.stderr)
        sys.exit(1)
