"""成员内部的只读分析：记录源码顺序、控制包围和断言依据，不重写或执行 Java。"""
from collections import defaultdict

from common import identity

ASSERT_OWNERS = {"org.junit.Assert", "org.junit.jupiter.api.Assertions", "junit.framework.Assert", "junit.framework.TestCase"}
ASSERT_NAMES = {"assertEquals", "assertNotEquals", "assertTrue", "assertFalse", "assertNull", "assertNotNull",
                "assertSame", "assertNotSame", "assertArrayEquals", "assertThrows", "assertDoesNotThrow",
                "assertAll", "assertTimeout", "assertTimeoutPreemptively", "assertInstanceOf", "assertIterableEquals",
                "assertLinesMatch", "fail"}
CAPABILITIES = {"statement_structure": True, "assertion_evidence": True, "compatibility_feature_detection": True,
                "source_transformation": "UNSUPPORTED", "executable_test_prefix_generation": "UNSUPPORTED",
                "runtime_control_flow": "NOT_ESTABLISHED", "operation_assertion_causality": "NOT_ESTABLISHED"}


def assertion_basis(reference, file, members, types):
    """区分静态确认、import 支持和仅同名候选；名称包含 assert 本身不是证据。"""
    name = reference["name"]
    if name not in ASSERT_NAMES or reference["kind"] != "call":
        return None
    if reference.get("target_owner") in ASSERT_OWNERS and reference["resolution"] not in {"ambiguous", "unresolved"}:
        return "CONFIRMED_STATIC", "BOUND_FRAMEWORK_DECLARATION"
    if reference["resolution"] in {"resolved_static", "ambiguous", "project_declaration_unmapped"}:
        return "CANDIDATE", "PROJECT_OR_AMBIGUOUS_DECLARATION"
    owner = reference.get("owner_type_key")
    owners, pending = set(), [owner] if owner else []
    while pending:
        current = pending.pop()
        if current in owners:
            continue
        owners.add(current)
        pending.extend(types.get(current, {}).get("parents", []))
    if any(m["owner_type_key"] in owners and m["name"] == name and m["kind"] == "method" for m in members.values()):
        return "CANDIDATE", "PROJECT_MEMBER_MAY_SHADOW_IMPORT"
    scope = reference.get("scope_as_written")
    if scope in ASSERT_OWNERS:
        # 首段若是项目类型名，就可能是表达式而非全限定类型名。
        if any(t["file"] == file["file"] and t["name"] == scope.split(".")[0] for t in types.values()):
            return "CANDIDATE", "PROJECT_TYPE_MAY_SHADOW_QUALIFIER"
        return "SOURCE_IMPORT_SUPPORTED", "EXPLICIT_QUALIFIED_FRAMEWORK_NAME"
    imports = file["imports"]
    if scope is None:
        explicit = [i["name"] for i in imports if i["static"] and i["name"].endswith("." + name)]
        candidates = explicit or [i["name"][:-2] + "." + name for i in imports if i["static"] and i["name"].endswith(".*")]
        if len(candidates) == 1 and candidates[0].rsplit(".", 1)[0] in ASSERT_OWNERS:
            return "SOURCE_IMPORT_SUPPORTED", "UNIQUE_STATIC_IMPORT"
    else:
        # Assertions.assertEquals 需要实际 import；相同简单名的项目类型会阻止推定。
        package = file["package"]
        shadowed = any(t["name"] == scope and (t["file"] == file["file"] or t["id"] == (package + "." + scope).lstrip("."))
                       for t in types.values())
        explicit = [i["name"] for i in imports if not i["static"] and i["name"].endswith("." + scope)]
        candidates = explicit or [i["name"][:-1] + scope for i in imports if not i["static"] and i["name"].endswith(".*")]
        if not shadowed and len(candidates) == 1 and candidates[0] in ASSERT_OWNERS:
            return "SOURCE_IMPORT_SUPPORTED", "UNIQUE_TYPE_IMPORT"
    return "CANDIDATE", "NAME_ONLY_NOT_FRAMEWORK_EVIDENCE"


def build_internal_analysis(facts, files, types, members, references):
    """把 Java 返回的成员内部节点和现有成员/引用身份接起来，生成可查询分析表。"""
    member_at = defaultdict(list)
    for key, member in members.items():
        member_at[(member["file"], member["start"], member["kind"])].append(key)
    nodes, at, by_member = {}, {}, defaultdict(list)
    for file in facts["files"]:
        for raw in file.get("body_nodes", []):
            candidates = member_at[(file["file"], raw["member_start"], raw["member_kind"])]
            if len(candidates) != 1:
                raise ValueError("内部语句不能唯一对应成员: " + file["file"])
            member = candidates[0]
            key = identity([member, "body", raw["ast_kind"], raw["start"], raw["end"]])
            node = {k: v for k, v in raw.items() if k not in {"member_start", "member_kind"}}
            node.update(key=key, member_key=member, file=file["file"], parent_key=None, reference_keys=[])
            nodes[key] = node
            at[(member, raw["start"], raw["end"])] = key
            by_member[member].append(key)
    for node in nodes.values():
        span = node.pop("parent_span")
        if span is not None:
            node["parent_key"] = at.get((node["member_key"], *span))
        parent = nodes.get(node["parent_key"], {})
        node["top_level"] = parent.get("node_kind") == "block" and parent.get("parent_key") is None
    for keys in by_member.values():
        keys.sort(key=lambda key: (nodes[key]["start"], -nodes[key]["end"], key))
        siblings = defaultdict(int)
        for key in keys:
            node = nodes[key]
            siblings[node["parent_key"]] += 1
            node["source_order_in_parent"] = siblings[node["parent_key"]]

    def contexts(key):
        """从外到内保存控制/延迟执行包围，不将源码顺序当运行轨迹。"""
        result = []
        while key is not None:
            node = nodes[key]
            if node["node_kind"] in {"control", "container"} or node["role_in_parent"] in {
                    "THEN", "ELSE", "TRY_BODY", "FINALLY_BODY", "CATCH_BODY", "LAMBDA_BODY", "LOOP_BODY"}:
                result.append(key)
            key = node["parent_key"]
        return list(reversed(result))

    checks = {}
    for key, node in nodes.items():
        if "native_assert" not in node:
            continue
        check_key = identity([key, "java_assert"])
        checks[check_key] = {"key": check_key, "node_key": key, "member_key": node["member_key"],
                             "file": node["file"], "start": node["start"], "end": node["end"],
                             "name": "assert", "recognition": "JAVA_ASSERT_SYNTAX", "basis": "AssertStmt",
                             "control_node_keys": contexts(key), "reference_key": None,
                             "execution_condition": "JAVA_ASSERTIONS_ENABLED_REQUIRED",
                             "deferred_context": any(nodes[n]["deferred"] for n in contexts(key))}
    for key, reference in references.items():
        member = reference.get("caller_source_member_key")
        candidates = [nodes[n] for n in by_member[member]
                      if nodes[n]["start"] <= reference["start"] and reference["end"] <= nodes[n]["end"]]
        node = min(candidates, key=lambda n: n["end"] - n["start"]) if candidates else None
        controls = contexts(node["key"]) if node else []
        reference.update(analysis_node_key=node["key"] if node else None, control_node_keys=controls)
        if node:
            node["reference_keys"].append(key)
        evidence = assertion_basis(reference, files[reference["file"]], members, types)
        if evidence is not None:
            check_key = identity([key, "assertion"])
            checks[check_key] = {"key": check_key, "node_key": node["key"] if node else None, "member_key": member,
                                 "file": reference["file"], "start": reference["start"], "end": reference["end"],
                                 "name": reference["name"], "recognition": evidence[0], "basis": evidence[1],
                                 "control_node_keys": controls, "reference_key": key,
                                 "deferred_context": any(nodes[n]["deferred"] for n in controls),
                                 "execution_condition": "DEFERRED_CONTEXT" if any(nodes[n]["deferred"] for n in controls) else "SEE_CONTROL_CONTEXT"}
    # 这些特征仅提示由哪部分复核，不断言一定需要改写，更不会修改源程序。
    features = {}

    def feature(kind, member_keys=(), type_keys=(), reference_keys=(), node_keys=(), **detail):
        value = {"kind": kind, "member_keys": sorted(set(member_keys)), "type_keys": sorted(set(type_keys)),
                 "reference_keys": sorted(set(reference_keys)), "node_keys": sorted(set(node_keys)), **detail}
        value.update(status="REVIEW_REQUIRED", source_transformation="UNSUPPORTED")
        value["key"] = identity(value)
        features[value["key"]] = value

    groups = defaultdict(list)
    for key, member in members.items():
        if member["kind"] in {"method", "constructor"}:
            groups[(member["owner_type_key"], member["kind"], member["name"])].append(key)
        if member["kind"] == "initializer":
            feature("INITIALIZER_BLOCK", [key], [member["owner_type_key"]], static="static" in member.get("modifiers", []))
        special = set(member["roles"]) & {"parameterized_test", "dynamic_test", "template_test", "repeated_test", "disabled"}
        if special:
            feature("SPECIAL_TEST_EXECUTION", [key], roles=sorted(special))
    for (owner, kind, name), keys in groups.items():
        if len(keys) > 1:
            feature("OVERLOAD_GROUP", keys, [owner], member_kind=kind, name=name)
    for key, type_node in types.items():
        if type_node.get("structure_boundary"):
            feature(type_node["structure_boundary"], type_keys=[key])
    for key, node in nodes.items():
        if node["deferred"] or node["try_with_resources"]:
            feature("LAMBDA" if node["deferred"] else "TRY_WITH_RESOURCES", [node["member_key"]], node_keys=[key])
    for key, reference in references.items():
        if reference["kind"] != "call":
            continue
        member = [reference["caller_source_member_key"]] if reference.get("caller_source_member_key") else []
        if reference["name"] in {"this", "super"}:
            feature("CONSTRUCTOR_DELEGATION", member, reference_keys=[key], call_form=reference["name"])
        if reference.get("call_kind") == "method_reference":
            feature("METHOD_REFERENCE", member, reference_keys=[key])
    return {"schema_version": "member-internal-analysis-1.0", "capabilities": CAPABILITIES,
            "nodes": nodes, "checks": checks, "features": features,
            "ordering": "SOURCE_ORDER_ONLY_NOT_RUNTIME_TRACE",
            "limitations": ["No source rewriting or executable test prefix generation.",
                            "Control contexts are syntax containment, not reachability or execution counts.",
                            "Import-supported assertions require review when external dependencies are missing.",
                            "Custom assertion APIs and operation-to-check causality require Agent review."]}


def query_member(project, member, offset=0, limit=100, max_chars=12000, include_source=False):
    """并行分页节点/检查/特征；可选正文共用字符预算，超限保留位置与原因。"""
    if offset < 0 or not 1 <= limit <= 500 or max_chars < 0:
        raise ValueError("无效内部分析分页或预算")
    key = project.key(member, include_types=False)
    data = project.data["internal_analysis"]
    nodes = sorted((n for n in data["nodes"].values() if n["member_key"] == key), key=lambda n: (n["start"], -n["end"], n["key"]))
    checks = sorted((c for c in data["checks"].values() if c["member_key"] == key), key=lambda c: (c["start"], c["end"]))
    features = [f for f in data["features"].values() if key in f["member_keys"] or project.members[key]["owner_type_key"] in f["type_keys"]]
    used, omitted = 0, []
    result_nodes = []
    for node in nodes[offset:offset + limit]:
        row = dict(node)
        if include_source:
            content = project.span(row["file"], row["start"], row["end"])
            included = used + len(content) <= max_chars
            row.update(content=content if included else None, content_status="CONTENT_INCLUDED" if included else "CONTENT_NOT_INCLUDED_BUDGET")
            if included:
                used += len(content)
            else:
                omitted.append(row["key"])
        result_nodes.append(row)
    total = max(len(nodes), len(checks), len(features))
    return {"status": "INTERNAL_ANALYSIS_READ", "index_id": project.data["index_id"], "snapshot_id": project.data["snapshot_id"],
            "member_key": key, "display_id": project.members[key]["id"], "capabilities": data["capabilities"],
            "source": {"file": project.members[key]["file"], "sha256": project.input.files[project.members[key]["file"]]["sha256"]},
            "counts": {"nodes": len(nodes), "recognized_checks": sum(c["recognition"] != "CANDIDATE" for c in checks),
                       "assertion_candidates": sum(c["recognition"] == "CANDIDATE" for c in checks), "features": len(features)},
            "nodes": result_nodes, "checks": checks[offset:offset + limit], "features": features[offset:offset + limit],
            "next_offset": offset + limit if offset + limit < total else None,
            "required_not_included": omitted, "included_chars": used, "ordering": data["ordering"], "limitations": data["limitations"]}


def query_features(project, value=None, offset=0, limit=100):
    """按成员/类型筛选特征；不把 REVIEW_REQUIRED 当作已生成转换方案。"""
    if offset < 0 or not 1 <= limit <= 500:
        raise ValueError("无效特征分页")
    rows = list(project.data["internal_analysis"]["features"].values())
    if value:
        key = project.key(value)
        owner = project.members[key]["owner_type_key"] if key in project.members else key
        rows = [r for r in rows if key in r["member_keys"] or owner in r["type_keys"] or
                any(project.members[k]["owner_type_key"] == owner for k in r["member_keys"]) and key in project.types]
    return {"status": "COMPATIBILITY_FEATURES_READ", "index_id": project.data["index_id"],
            "source_transformation": "UNSUPPORTED", "total": len(rows), "records": rows[offset:offset + limit],
            "next_offset": offset + limit if offset + limit < len(rows) else None}


def context_summary(project, records):
    """初始上下文只增加结构摘要；完整节点按需 analyze，不把全部语句重复塞入。"""
    keys = {r["id"] for r in records if r["id"] in project.members and r["content_kind"] == "full"
            and r["status"] != "PROVIDED_BY_SHARED_CONTEXT"}
    data = project.data["internal_analysis"]
    rows = []
    for key in sorted(keys):
        nodes = sorted((n for n in data["nodes"].values() if n["member_key"] == key and n["top_level"]), key=lambda n: n["start"])
        checks = [c for c in data["checks"].values() if c["member_key"] == key]
        rows.append({"member_key": key, "display_id": project.members[key]["id"],
                     "top_level_steps": [{"key": n["key"], "ast_kind": n["ast_kind"], "lines": [n["start_line"], n["end_line"]]} for n in nodes[:20]],
                     "remaining_steps": max(0, len(nodes) - 20),
                     "recognized_checks": sum(c["recognition"] != "CANDIDATE" for c in checks),
                     "assertion_candidates": sum(c["recognition"] == "CANDIDATE" for c in checks),
                     "deferred_checks": sum(c["deferred_context"] for c in checks),
                     "details_command": "analyze --id " + key})
    return {"schema_version": data["schema_version"], "capabilities": data["capabilities"], "members": rows,
            "ordering": data["ordering"], "cross_member_behavior": "FOLLOW_REFERENCES_NOT_INLINE_EXECUTION_TRACE",
            "details": "Use analyze for checks/guards and references for helper targets; shared records remain in shared_ref."}
