"""把整体任务交付复制为 week12 结构检查器的原生布局，不改写原交付。

输出 translation_config.json、02-java-skeleton、05-cangjie-skeleton；
仅调整副本中的文件入口，原始成员 ID、方法体和映射状态保留。
"""
import argparse
import hashlib
import json
from pathlib import Path
import shutil
import sys


def load(path):
    return json.loads(path.read_text(encoding="utf-8-sig"))


def save(path, value):
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(value, ensure_ascii=True, indent=2) + "\n", encoding="utf-8")


def prepare(task_file, output, bundle_id=None):
    task_file, output = Path(task_file).resolve(), Path(output).resolve()
    task = load(task_file)
    base = task_file.parent

    def path(value):
        if not value:
            raise ValueError("检查适配缺少必需的实际路径")
        return (base / value).resolve()

    project = path(task["project_root"])
    bundles = [b for b in task["skeleton_bundles"] if not bundle_id or b["id"] == bundle_id]
    if len(bundles) != 1:
        raise ValueError("请指定唯一骨架 bundle")
    bundle = bundles[0]
    skeleton = path(bundle["skeleton_root"])
    if output.exists() or any(output.is_relative_to(root) or root.is_relative_to(output) for root in [project, skeleton]):
        raise ValueError("检查输出必须为与项目/骨架互不包含的新目录")
    targets = [t for t in task["targets"] if t["skeleton_bundle_id"] == bundle["id"]]
    if not targets:
        raise ValueError("没有所选骨架对应的任务目标")
    extraction_ids = {t["java_extraction_id"] for t in targets}
    extractions = [e for e in task["java_extractions"] if e["id"] in extraction_ids]
    if len(extractions) != len(extraction_ids):
        raise ValueError("任务缺少对应 Java 提取入口")
    output.mkdir(parents=True)
    try:
        tables, source_files, selectors, evidence = {}, set(), [], []
        selected_files = {t["source_file"] for t in targets}
        selected_types = {t["source_type"].replace("$", ".") for t in targets}
        for number, extraction in enumerate(extractions):
            root = path(extraction["extraction_root"])
            members_file = path(extraction["members_file"])
            if output.is_relative_to(root) or root.is_relative_to(output):
                raise ValueError("检查输出不能与 Java 提取目录互相包含")
            if not members_file.is_relative_to(root):
                raise ValueError("成员表不在声明的提取目录中")
            table = load(members_file)
            for file in table["files"]:
                actual = (Path(table["input_root"]) / file["source_file"]).resolve()
                if not actual.is_relative_to(project):
                    raise ValueError("Java 成员表来源不在任务项目中")
                if hashlib.sha256(actual.read_bytes()).hexdigest() != file["source_sha256"]:
                    raise ValueError("Java 提取与任务源码摘要不符")
                source_files.add(actual.relative_to(project).as_posix())
            destination = output / "02-java-skeleton" / str(number)
            shutil.copytree(root, destination)
            copied = destination / members_file.relative_to(root)
            tables[members_file] = copied.relative_to(output).as_posix()
            for invocation in table.get("test_invocations", []):
                if invocation["execution_class"].replace("$", ".") in selected_types:
                    selectors.append(invocation["selector"])
            evidence.append({"source": str(members_file), "copy": copied.relative_to(output).as_posix(),
                             "sha256": hashlib.sha256(members_file.read_bytes()).hexdigest()})
        shutil.copytree(skeleton, output / "05-cangjie-skeleton")
        mapping = load(path(bundle["mapping_file"]))
        if not isinstance(mapping, list):
            raise ValueError("骨架映射须为数组")
        member_base = path(bundle["source_members_base"])
        target_base = path(bundle["target_files_base"])
        adapted = []
        for row in mapping:
            item = dict(row)
            if item.get("source_member_id") is not None:
                original = (member_base / item["source_members_file"]).resolve()
                if original not in tables:
                    raise ValueError("映射引用了任务范围外的 Java 成员表")
                item["source_members_file"] = tables[original]
            target = (target_base / item["target_file"]).resolve() if item.get("target_file") else None
            if item["status"] != "blocked":
                if target is None:
                    raise ValueError("有效映射缺少目标路径")
                if target.is_relative_to(skeleton):
                    item["target_file"] = target.relative_to(skeleton).as_posix()
                elif item["status"] == "reused":
                    item["target_file"] = str(target)
                else:
                    raise ValueError("mapped 目标不在骨架目录内")
            adapted.append(item)
        save(output / "05-cangjie-skeleton/member_mapping.json", adapted)
        if not selected_files <= source_files:
            raise ValueError("任务所选测试文件不在提取结果中")
        config = {"project_root": str(project), "test_files": sorted(selected_files),
                  "test_support_files": sorted(source_files - selected_files)}
        # 执行类选择器能定位继承自支持文件的测试；旧表无此字段时保持检查器默认行为。
        if selectors:
            config["selected_test_methods"] = sorted(set(selectors))
        save(output / "translation_config.json", config)
        save(output / "adapter_manifest.json", {"task": str(task_file), "inputs": evidence,
             "scope": "PATH_ADAPTATION_COPY_ONLY", "source_member_ids": "UNCHANGED",
             "config_kind": "week12-checker-native-not-whole-task"})
        return {"status": "PREPARED", "run": str(output), "selected_source_invocations": len(set(selectors))}
    except Exception as exc:
        save(output / "FAILED.json", {"message": str(exc)})
        raise


def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument("--task", required=True)
    p.add_argument("--output", required=True)
    p.add_argument("--bundle")
    args = p.parse_args()
    try:
        result = prepare(args.task, args.output, args.bundle)
        print(json.dumps(result, ensure_ascii=True, indent=2))
        return 0
    except Exception as exc:
        print(json.dumps({"status": "ERROR", "message": str(exc)}, ensure_ascii=True))
        return 1


if __name__ == "__main__":
    sys.exit(main())
