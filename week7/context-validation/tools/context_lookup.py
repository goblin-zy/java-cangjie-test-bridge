"""Source-backed context export using week7's existing skeleton extractor.

Dependency selection is explicit human/agent input, not automatic type analysis.
Python 3.9+; index additionally needs JDK 17+.
"""
from pathlib import Path
import argparse
import hashlib
import json
import subprocess
import tempfile


def read_json(path):
    return json.loads(Path(path).read_text(encoding="utf-8-sig"))


def write_json(path, value):
    Path(path).write_text(json.dumps(value, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")


def sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def inside(root, relative):
    root = Path(root).resolve()
    path = (root / relative).resolve()
    if not path.is_relative_to(root):
        raise ValueError("Path escapes its declared root: " + str(relative))
    return path


def fresh(path):
    path = Path(path).resolve()
    if path.exists() and (not path.is_dir() or any(path.iterdir())):
        raise ValueError("Use a new or empty output directory: " + str(path))
    return path


def source_text(path, location):
    # Upstream offsets are Java UTF-16 units, not Python character offsets.
    text = Path(path).read_bytes().decode("utf-8")
    raw = text.encode("utf-16-le")
    start = location["start_offset_utf16"] * 2
    end = location["end_offset_utf16_exclusive"] * 2
    if not 0 <= start <= end <= len(raw):
        raise ValueError("Invalid upstream UTF-16 source range")
    return raw[start:end].decode("utf-16-le")


def index_repository(repo, output, java="java", javac="javac", test_root="week7/src/test/java", main_root="week7/src/main/java/study/translation"):
    repo = Path(repo).resolve()
    output = fresh(output)
    extractor = repo / "week7/src/main/java/JavaTestSkeletonExtractor.java"
    if not extractor.is_file():
        raise ValueError("Existing week7 extractor missing: " + str(extractor))
    roots = {"test": test_root, "main": main_root}
    for relative in roots.values():
        if not inside(repo, relative).is_dir():
            raise ValueError("Missing source root: " + relative)
    for relative in roots.values():
        if output.is_relative_to(inside(repo, relative)):
            raise ValueError("Output must be outside source roots")
    output.mkdir(parents=True, exist_ok=True)
    catalog = {"schema_version": "context-catalog-1.0", "owner": "蒋逸舟", "extractor_sha256": sha(extractor), "files": [], "members": [], "classes": [], "limitations": ["JDK parse only; no symbol attribution", "Dependencies must be selected by a human or agent", "Inherited lifecycle, resources and dynamic dispatch are not resolved"]}
    with tempfile.TemporaryDirectory(prefix="week7_extractor_") as temp:
        subprocess.run([javac, "-encoding", "UTF-8", "--add-modules", "jdk.compiler", "-d", temp, str(extractor)], check=True)
        for group, relative in roots.items():
            destination = output / (group + "-members")
            process = subprocess.run([java, "-Dfile.encoding=UTF-8", "--add-modules", "jdk.compiler", "-cp", temp, "JavaTestSkeletonExtractor", "--input", str(inside(repo, relative)), "--output", str(destination)], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
            (output / (group + "-extraction.stdout.log")).write_bytes(process.stdout)
            (output / (group + "-extraction.stderr.log")).write_bytes(process.stderr)
            process.check_returncode()
            data = read_json(destination / "members.json")
            if data.get("schema_version") != "1.0" or data["summary"].get("errors", 0):
                raise ValueError("Unsupported or unsuccessful upstream extraction")
            data["input_root"] = relative  # Portable metadata; member IDs/offsets unchanged.
            write_json(destination / "members.json", data)
            by_source = {}
            for file in data["files"]:
                if file["status"] != "extracted":
                    raise ValueError("Unextracted source: " + file["source_file"])
                live = inside(repo, (Path(relative) / file["source_file"]).as_posix())
                snapshot = destination / file["original_file"]
                if sha(live) != file["source_sha256"] or sha(snapshot) != file["source_sha256"]:
                    raise ValueError("Source changed during indexing")
                record = {"group": group, "source_file": file["source_file"], "repository_path": live.relative_to(repo).as_posix(), "snapshot": snapshot.relative_to(output).as_posix(), "sha256": file["source_sha256"], "package": file["package"], "imports": file["imports"]}
                catalog["files"].append(record)
                by_source[file["original_file"]] = record
            for category in ("members", "classes"):
                for item in data[category]:
                    file = by_source[item["source_location"]["file"]]
                    symbol = item["id"].split("::", 1)[1]
                    catalog[category].append({"group": group, "symbol": symbol, "upstream_id": item["id"], "source": file, "upstream": item, "content": source_text(output / file["snapshot"], item["source_location"])})
    write_json(output / "catalog.json", catalog)
    lines = ["# 成员索引", "", "负责人：蒋逸舟。此表是源码索引，不是自动选择的依赖闭包。", "", "| 分组 | 上游成员标识 | 角色 |", "| --- | --- | --- |"]
    lines += [f"| {m['group']} | `{m['upstream_id']}` | {m['upstream'].get('role', 'class')} |" for m in catalog["members"]]
    (output / "index.md").write_text("\n".join(lines) + "\n", encoding="utf-8")
    return catalog


def export_context(catalog_path, selection_path, repo, output):
    catalog_path = Path(catalog_path).resolve()
    catalog = read_json(catalog_path)
    selection = read_json(selection_path)
    repo = Path(repo).resolve()
    output = fresh(output)
    if catalog.get("schema_version") != "context-catalog-1.0" or selection.get("schema_version") != "context-selection-1.0":
        raise ValueError("Unsupported catalog/selection schema")
    if not selection.get("units"):
        raise ValueError("Selection must contain at least one target")
    lookup = {}
    for member in catalog["members"] + catalog["classes"]:
        key = (member["group"], member["symbol"])
        if key in lookup:
            raise ValueError("Ambiguous symbol; fix source roots or duplicate classes: " + str(key))
        lookup[key] = member
    for file in catalog["files"]:
        snapshot = inside(catalog_path.parent, file["snapshot"])
        if sha(snapshot) != file["sha256"] or sha(inside(repo, file["repository_path"])) != file["sha256"]:
            raise ValueError("Stale index or changed source: " + file["repository_path"])
    def evidence(reference):
        key = (reference["group"], reference["symbol"])
        if key not in lookup:
            raise ValueError("Selected member not found: " + str(key))
        item = lookup[key]
        if not reference.get("reason", "").strip():
            raise ValueError("Every selected member requires a reason")
        text = source_text(inside(catalog_path.parent, item["source"]["snapshot"]), item["upstream"]["source_location"])
        if text != item["content"]:
            raise ValueError("Catalog content changed: " + item["upstream_id"])
        return {"group": item["group"], "symbol": item["symbol"], "upstream_id": item["upstream_id"], "role": item["upstream"].get("role", "class"), "content": text, "reason": reference["reason"], "source": {"file": "inputs/" + item["source"]["repository_path"], "sha256": item["source"]["sha256"], "location": item["upstream"]["source_location"]}}
    results, seen = [], set()
    for number, unit in enumerate(selection["units"], 1):
        target = evidence({**unit["target"], "reason": "本轮完整待译测试"})
        key = (target["group"], target["symbol"])
        if key in seen:
            raise ValueError("Duplicate target: " + target["symbol"])
        seen.add(key)
        if target["role"] != "test":
            raise ValueError("Only ordinary @Test methods are currently accepted")
        owner = target["symbol"].split("#", 1)[0]
        cls = evidence({"group": target["group"], "symbol": owner, "reason": "保留完整所在测试类，供人工核对准备和辅助方法"})
        context = [evidence(r) for r in unit.get("evidence", [])]
        unresolved = selection.get("unresolved", []) + unit.get("unresolved", [])
        result = {"schema_version": "test-context-1.0", "owner": "蒋逸舟", "selection_author": selection.get("selection_author", "UNSPECIFIED"), "selection_review": selection.get("human_review", "PENDING"), "target": target, "original_test_class": cls, "imports": lookup[key]["source"]["imports"], "context": context, "unresolved": unresolved, "resource_status": "NOT_ANALYZED", "dependency_completeness": "NOT_ESTABLISHED", "selection_note": unit.get("use", ""), "catalog_sha256": sha(catalog_path), "selection_sha256": sha(selection_path), "limitations": catalog["limitations"], "target_reference_answer_included": False}
        results.append((f"context_{number:02d}", result))
    output.mkdir(parents=True, exist_ok=True)
    copied = set()
    for _, result in results:
        for entry in [result["target"], result["original_test_class"], *result["context"]]:
            relative = entry["source"]["file"]
            if relative not in copied:
                live = inside(repo, relative[len("inputs/"):])
                if sha(live) != entry["source"]["sha256"]:
                    raise ValueError("Source changed while exporting: " + str(live))
                target = inside(output, relative)
                target.parent.mkdir(parents=True, exist_ok=True)
                target.write_bytes(live.read_bytes())
                copied.add(relative)
    write_json(output / "selection.json", selection)
    checks = []
    for name, result in results:
        write_json(output / (name + ".json"), result)
        text = ["# " + result["target"]["symbol"], "", "负责人：蒋逸舟。选择与使用方案由人工/智能体提供；人工审核状态：" + result["selection_review"], "", "依赖完整性尚未证明；未分析资源；不包含仓颉参考答案。", "", "## 使用方案", "", result["selection_note"], "", "## 导入", "", "```java", *result["imports"], "```"]
        for title, entries in [("完整原测试", [result["target"]]), ("完整所在测试类", [result["original_test_class"]]), ("已选择上下文", result["context"])]:
            text += ["", "## " + title]
            for e in entries:
                loc = e["source"]["location"]
                text += ["", "### " + e["symbol"], "", "上游标识：`" + e["upstream_id"] + "`", "", f"来源：[{e['source']['file']}]({e['source']['file']})，行{loc['start_line']}—{loc['end_line']}。", "", "选择理由：" + e["reason"], "", "```java", e["content"], "```"]
        text += ["", "## 未解决项", ""] + ["- " + x for x in result["unresolved"]] + ["", "## 限制", ""] + ["- " + x for x in result["limitations"]]
        # Normalize before Windows text I/O, otherwise CRLF snippets become CRCRLF.
        markdown = ("\n".join(text) + "\n").replace("\r\n", "\n")
        (output / (name + ".md")).write_text(markdown, encoding="utf-8")
        checks.append({"target": result["target"]["symbol"], "json": name + ".json", "markdown": name + ".md", "source_and_content": "PASS", "checked_entries": 2 + len(result["context"])})
    write_json(output / "checks.json", {"owner": "蒋逸舟", "outputs": checks, "checks_scope": "source hashes, upstream UTF-16 ranges and selected text; not dependency completeness or semantic equivalence", "human_review": "PENDING"})
    return checks


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    commands = parser.add_subparsers(dest="command", required=True)
    default_repo = Path(__file__).resolve().parents[3]
    index = commands.add_parser("index")
    index.add_argument("--repo-root", type=Path, default=default_repo)
    index.add_argument("--output", type=Path, required=True)
    index.add_argument("--java", default="java")
    index.add_argument("--javac", default="javac")
    index.add_argument("--test-root", default="week7/src/test/java")
    index.add_argument("--main-root", default="week7/src/main/java/study/translation")
    export = commands.add_parser("export")
    export.add_argument("--repo-root", type=Path, default=default_repo)
    export.add_argument("--index", type=Path, required=True)
    export.add_argument("--selection", type=Path, required=True)
    export.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    try:
        if args.command == "index":
            result = index_repository(args.repo_root, args.output, args.java, args.javac, args.test_root, args.main_root)
            print("Indexed", len(result["files"]), "files and", len(result["members"]), "members")
        else:
            print(json.dumps(export_context(args.index, args.selection, args.repo_root, args.output), ensure_ascii=False, indent=2))
    except (ValueError, KeyError, OSError, subprocess.CalledProcessError) as error:
        parser.exit(1, str(error) + "\n")


if __name__ == "__main__":
    main()
