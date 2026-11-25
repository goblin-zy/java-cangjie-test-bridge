"""接收 week12 Java 提取结果：先核对同版原文，再关联声明成员与源侧执行类。

这些信息来自源码分析，不是 JUnit 运行时发现结果；不会修改静态调用绑定。
"""
from collections import defaultdict
from pathlib import Path
import shutil

from common import load, save, sha

ROLE_MAP = {"test": "test", "lifecycle_BeforeEach": "setup", "lifecycle_AfterEach": "cleanup",
            "lifecycle_BeforeAll": "class_setup", "lifecycle_AfterAll": "class_cleanup",
            "test_ParameterizedTest": "parameterized_test", "test_RepeatedTest": "repeated_test",
            "test_TestFactory": "dynamic_test", "test_TestTemplate": "template_test"}
JUNIT3 = "junit.framework.TestCase"


def canonical(name):
    return name.replace("$", ".")


def import_members(paths, source, original_project, files, types, members, output):
    """只接受当前原项目或其冻结副本内提取的表；拒绝陈旧摘要和含糊成员。"""
    result = {"tables": [], "member_links": [], "test_invocations": [], "test_parent_edges": {},
              "basis": "HASH_CHECKED_SOURCE_METADATA_NOT_RUNTIME_DISCOVERY"}
    if not paths:
        return result
    original = Path(original_project).resolve()
    by_type = defaultdict(list)
    for key, node in types.items():
        by_type[canonical(node["id"])].append(key)

    def parent_of(key):
        node = types[key]
        spelling = node.get("extends")
        if not spelling:
            return None
        name = spelling.split("<", 1)[0].strip()
        file = files[node["file"]]
        imported = [i["name"] for i in file["imports"] if not i["static"] and i["name"].endswith("." + name)]
        if "." in name:
            names = [name]
        elif imported:
            names = imported
        else:
            local = (file["package"] + "." + name).lstrip(".")
            names = [local] if by_type.get(canonical(local)) else [i["name"][:-1] + name for i in file["imports"] if not i["static"] and i["name"].endswith(".*")]
        resolved = set()
        for full in names:
            if full == JUNIT3:
                resolved.add(JUNIT3)
            resolved.update(by_type.get(canonical(full), []))
        return next(iter(resolved)) if len(resolved) == 1 else None

    def lineage(key):
        chain, seen = [], set()
        while key and key not in seen:
            seen.add(key)
            chain.append(key)
            if key == JUNIT3:
                break
            key = parent_of(key)
        return chain

    all_links = {}
    for number, filename in enumerate(paths):
        path = Path(filename).resolve()
        table = load(path)
        input_root = Path(table["input_root"]).resolve()
        file_map = {}
        for file in table["files"]:
            actual = (input_root / file["source_file"]).resolve()
            roots = [r for r in [original, source.project] if actual.is_relative_to(r)]
            if not roots:
                raise ValueError("Java 成员表来源不在本次项目内，请重新提取: " + file["source_file"])
            relative = actual.relative_to(max(roots, key=lambda r: len(r.parts))).as_posix()
            record = source.files.get(relative)
            if not record or record["sha256"] != file["source_sha256"]:
                raise ValueError("Java 成员表与本轮源码摘要不符: " + relative)
            if file.get("status") != "extracted":
                raise ValueError("Java 提取包含未成功文件: " + relative)
            file_map[file["original_file"]] = relative
        target = Path(output) / "artifacts/java-members" / (str(number) + "-members.json")
        target.parent.mkdir(parents=True, exist_ok=True)
        shutil.copyfile(path, target)
        if sha(target) != sha(path):
            raise ValueError("Java 成员表复制期间发生变化")
        table_record = {"file": target.relative_to(output).as_posix(), "sha256": sha(target)}
        result["tables"].append(table_record)
        links = {}
        for raw in table["members"]:
            loc = raw["source_location"]
            relative = file_map[loc["file"]]
            start, end = loc["start_offset_utf16"], loc["end_offset_utf16_exclusive"]
            candidates = [(key, m) for key, m in members.items() if m["file"] == relative and m["kind"] == raw["kind"]
                          and canonical(m["owner"]) == canonical(raw["owner"]) and m["name"] == raw["name"]
                          and (m["start"] == start and m["end"] == end or raw["kind"] == "field" and
                               m.get("read_start") == start and m.get("read_end") == end and m.get("field_type") == raw.get("type"))]
            if len(candidates) != 1:
                raise ValueError("Java 成员不能唯一对应上下文声明: " + raw["id"])
            key, member = candidates[0]
            if raw.get("original_body") is not None:
                encoded = (source.project / relative).read_bytes().decode("utf-8").encode("utf-16-le")
                body = encoded[2 * member["body_start"]:2 * member["body_end"]].decode("utf-16-le")
                if body != raw["original_body"]:
                    raise ValueError("Java 原方法体与本轮源码不符: " + raw["id"])
            links[raw["id"]] = key
            identity = (raw["id"], table_record["sha256"])
            if identity in all_links:
                raise ValueError("重复提供 Java 成员表")
            all_links[identity] = key
            basis = {"table": table_record["file"], "source_member_id": raw["id"], "extracted_role": raw["role"],
                     "test_framework": raw.get("test_framework"), "basis": "HASH_AND_DECLARATION_SPAN"}
            member.setdefault("java_member_evidence", []).append(basis)
            framework = raw.get("test_framework")
            role = ROLE_MAP.get(raw["role"])
            junit3 = framework == "junit3" and JUNIT3 in lineage(member["owner_type_key"])
            if role and (framework != "junit3" and member["roles"] or junit3):
                member["roles"] = sorted(set(member["roles"]) | {"test_junit3" if junit3 and role == "test" else role})
            elif role and framework == "junit3":
                raise ValueError("JUnit3 源继承链无法确认: " + raw["id"])
            for annotation in raw.get("annotations", []):
                if annotation.get("resolved_candidate") == "org.junit.Test" and annotation.get("arguments"):
                    member.setdefault("test_execution_semantics", []).append({"framework": "junit4",
                        "annotation_arguments": annotation["arguments"], "basis": "SOURCE_ANNOTATION_NOT_EXECUTION"})
            result["member_links"].append({**basis, "context_member_key": key, "source_file": relative,
                                          "source_sha256": source.files[relative]["sha256"]})
        for invocation in table.get("test_invocations", []):
            key = links.get(invocation["source_member_id"])
            execution = by_type.get(canonical(invocation["execution_class"]), [])
            if key is None or len(execution) != 1:
                raise ValueError("测试执行类或源成员不唯一: " + invocation["selector"])
            owner = members[key]["owner_type_key"]
            chain = lineage(execution[0])
            if owner not in chain or canonical(invocation["declaring_class"]) != canonical(types[owner]["id"]):
                raise ValueError("执行类与声明类不在已确认源继承链上: " + invocation["selector"])
            for child, parent in zip(chain, chain[1:]):
                if parent != JUNIT3:
                    result["test_parent_edges"][child] = parent
            expected_selector = invocation["execution_class"] + "#" + invocation["source_member_id"].rsplit("#", 1)[1]
            if invocation["selector"] != expected_selector:
                raise ValueError("测试选择器与成员不一致")
            result["test_invocations"].append({**invocation, "source_member_key": key,
                "execution_type_key": execution[0], "declaring_type_key": owner, "table": table_record["file"],
                "context_selector": types[execution[0]]["id"] + "#" + members[key]["id"].split("#", 1)[1],
                "basis": "HASH_CHECKED_SOURCE_NOT_RUNTIME_DISCOVERY"})
    return result
