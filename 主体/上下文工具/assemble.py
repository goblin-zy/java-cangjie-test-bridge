"""Stage-aware initial evidence, with explicit omissions and local follow-up keys."""
from collections import deque
from pathlib import Path
import json

from common import save, sha
from agent_view import compact_context
from internal_analysis import context_summary

PROFILES = {
    "materials": "归纳项目公共材料：测试原文、项目类型和被用到的业务接口；语义判断由Agent完成。",
    "skeleton": "辅助理解测试结构：类型、字段、初始化、构造器、生命周期和方法签名。",
    "whole": "翻译整个测试类：测试原文、辅助实现、初始化和相关业务接口。",
    "fragment": "翻译指定测试方法：保留所在类及生命周期，展开该方法的辅助依赖。",
}


def assemble(project, target, profile="whole", max_depth=6, max_members=200, max_chars=30000,
             *, scope="combined", provided=()):
    """按已绑定依赖做广度优先展开；业务方法止于签名，正文留给 read。

    scope=shared 只放类初始化和生命周期；scope=test 只从一条测试出发。
    provided 只接受已实际包含的共享源码，预算不足的共享记录不能抵扣。
    """
    if profile not in PROFILES or min(max_depth, max_members, max_chars) < 0:
        raise ValueError("无效阶段或预算")
    if scope not in {"combined", "shared", "test"}:
        raise ValueError("无效组装范围")
    type_key, tests, lifecycle, hierarchy, hierarchy_issues = project.test_target(target)
    if profile == "fragment" and len(tests) != 1:
        raise ValueError("fragment需要唯一测试方法，请使用类型#方法签名或方法key")
    records, omitted, boundaries, unresolved, resources, graph = [], [], list(hierarchy_issues), [], [], []
    budget = {"max_depth": max_depth, "max_members": max_members, "max_chars": max_chars,
              "included_chars": 0, "visited_members": 0}
    covered = []

    def provided_by(row):
        """只在真实源码区间包含时复用；同名、同 id 的签名不能冒充完整正文。"""
        source = row["source"]
        for shared in provided:
            span = shared["source"]
            if shared.get("content") is not None and source["file"] == span["file"] and \
                    span["start_offset_utf16"] <= source["start_offset_utf16"] and \
                    source["end_offset_utf16_exclusive"] <= span["end_offset_utf16_exclusive"]:
                return shared["id"]
        return None

    def add(key, mode, reason):
        row = project.read(key, mode, max_chars=10**12)
        source = row["source"]
        row["reason"] = reason
        shared_id = provided_by(row)
        if shared_id is not None:
            row.update(content=None, status="PROVIDED_BY_SHARED_CONTEXT", shared_record=shared_id)
            records.append(row)
            return
        for parent in covered:
            span = parent["source"]
            if source["file"] == span["file"] and source["start_offset_utf16"] >= span["start_offset_utf16"] and source["end_offset_utf16_exclusive"] <= span["end_offset_utf16_exclusive"]:
                row.update(content=None, status="COVERED_BY_INCLUDED_SOURCE", covered_by=parent["id"])
                records.append(row)
                return
        if budget["included_chars"] + row["content_chars"] > max_chars:
            row.update(content=None, status="CONTENT_NOT_INCLUDED_BUDGET")
            omitted.append({"id": key, "mode": mode, "reason": "CHAR_BUDGET", "required_chars": row["content_chars"]})
        else:
            budget["included_chars"] += row["content_chars"]
            if mode == "full":
                covered.append(row)
        records.append(row)

    # Full source is useful for translation; skeleton keeps structure and signatures.
    add(type_key, "full" if profile == "whole" and scope == "combined" else "signature", "SELECTED_TEST_TYPE")
    type_files = {project.types[k]["file"] for k in hierarchy}
    imports = [{"file": file, "package": project.data["files"][file]["package"],
                "imports": project.data["files"][file]["imports"]} for file in sorted(type_files)]
    roots = []
    initialization = []
    for t in hierarchy:
        if t != type_key:
            add(t, "signature", "INHERITED_TYPE_HEADER")
        for key in project.by_type[t]:
            m = project.members[key]
            if m["kind"] in {"field", "initializer", "constructor"}:
                if scope != "test":
                    roots.append((key, 0, "TEST_INITIALIZATION"))
                initialization.append({"key": key, "owner_type_key": t, "kind": m["kind"],
                                       "start": m["start"], "modifiers": m.get("modifiers", [])})
    if scope != "test":
        roots += [(k, 0, "LIFECYCLE") for k in lifecycle]
    if scope != "shared":
        roots += [(k, 0, "SELECTED_TEST") for k in tests]
    if profile == "skeleton":
        roots += [(k, 0, "TEST_METHOD_SIGNATURE") for t in hierarchy for k in project.by_type[t]
                  if project.members[k]["kind"] == "method"]
    pending, visited, type_seen, resource_seen = deque(roots), set(), set(hierarchy), set()
    initialized_business_types = set()

    def business_initializers(owner, depth):
        if owner in initialized_business_types or project.types[owner]["source_role"] != "business_source":
            return
        initialized_business_types.add(owner)
        for mkey in project.by_type[owner]:
            m = project.members[mkey]
            if m["kind"] in {"field", "initializer"}:
                pending.append((mkey, depth, "BUSINESS_INITIALIZATION_EVIDENCE"))

    while pending:
        key, depth, reason = pending.popleft()
        if key in visited:
            continue
        if depth > max_depth or len(visited) >= max_members:
            omitted.append({"id": key, "mode": "full", "reason": "DEPTH_BUDGET" if depth > max_depth else "MEMBER_BUDGET"})
            continue
        visited.add(key)
        member = project.members[key]
        owner = member.get("owner_type_key")
        if owner and member["kind"] == "constructor":
            business_initializers(owner, depth + 1)
        if owner and owner not in type_seen:
            type_seen.add(owner)
            add(owner, "signature", "DEPENDENCY_TYPE_HEADER")
            f = project.data["files"][member["file"]]
            if member["file"] not in type_files:
                imports.append({"file": member["file"], "package": f["package"], "imports": f["imports"]})
                type_files.add(member["file"])
        business = member["source_role"] == "business_source"
        signature_only = member["kind"] in {"method", "constructor"} and (business or profile == "skeleton")
        add(key, "signature" if signature_only else "full", reason)
        roles = set(member["roles"])
        if member.get("test_execution_semantics"):
            boundaries.append({"kind": "TEST_EXECUTION_SEMANTICS_REQUIRE_REVIEW", "member": key,
                               "semantics": member["test_execution_semantics"]})
        if roles.intersection({"parameterized_test", "template_test", "dynamic_test", "repeated_test", "disabled"}):
            boundaries.append({"kind": "TEST_EXECUTION_SEMANTICS_REQUIRE_REVIEW", "member": key,
                               "roles": sorted(roles), "annotation_details": member.get("annotation_details", [])})
        # A signature is an explicit boundary. On-demand read can retrieve business bodies.
        if signature_only:
            boundaries.append({"kind": "BODY_AVAILABLE_ON_DEMAND", "member": key})
            continue
        if provided_by(project.read(key, "full", max_chars=10**12)) is not None:
            # 共享闭包已包含这些边和缺项，测试文件通过 shared_ref 读取，不重复展开。
            continue
        for reference in project.by_caller[key]:
            r = project.references[reference]
            graph.append({"reference": reference, "caller": key, "resolution": r["resolution"],
                          "targets": r["target_keys"], "dispatch": r.get("dispatch")})
            if r["resolution"] in {"unresolved", "ambiguous", "project_declaration_unmapped"}:
                unresolved.append(project.resolve(reference))
            elif r["resolution"] == "external":
                boundaries.append({"kind": "EXTERNAL_DECLARATION", "reference": reference,
                                   "signature": r.get("target_signature")})
            for callee in r["target_keys"]:
                pending.append((callee, depth + 1, "RESOLVED_DEPENDENCY"))
            for target_type in r.get("target_type_keys", []):
                business_initializers(target_type, depth + 1)
                if target_type not in type_seen:
                    type_seen.add(target_type)
                    add(target_type, "signature", "IMPLICIT_CONSTRUCTOR_TYPE")
                boundaries.append({"kind": "IMPLICIT_CONSTRUCTOR", "reference": reference, "type": target_type})
            resource = project.resources(reference, type_key, max_bytes=max(0, max_chars - budget["included_chars"]))
            if resource is not None and reference not in resource_seen:
                resource_seen.add(reference)
                payload = resource.get("resource", {})
                content = payload.get("content")
                if isinstance(content, str) and len(content) > max_chars - budget['included_chars']:
                    payload.update(content=None, status="CONTENT_NOT_INCLUDED_SIZE_LIMIT")
                    content = None
                if isinstance(content, str):
                    budget["included_chars"] += len(content)
                if payload.get("status") == "CONTENT_NOT_INCLUDED_SIZE_LIMIT":
                    omitted.append({"reference": reference, "reason": "RESOURCE_BUDGET"})
                resources.append(resource)
    budget["visited_members"] = len(visited)
    lifecycle_groups = {}
    for role in ["class_setup", "setup", "cleanup", "class_cleanup"]:
        ordered_types = list(reversed(hierarchy)) if role in {"cleanup", "class_cleanup"} else hierarchy
        lifecycle_groups[role] = [{"type": t, "members": [k for k in lifecycle if project.members[k]["owner_type_key"] == t and role in project.members[k]["roles"]],
                                  "within_type_order": "NOT_ESTABLISHED"} for t in ordered_types]
    return {"schema_version": "initial-context-1.0", "status": "ASSEMBLED_WITH_LIMITATIONS",
            "index_id": project.data["index_id"], "snapshot_id": project.data["snapshot_id"],
            "input_issues": project.input.summary()["issue_counts"], "semantic_problems": project.data['problems'],
            "profile": profile, "scope": scope, "purpose": PROFILES[profile], "target_type": type_key,
            "selected_tests": [] if scope == "shared" else tests,
            # 执行类可以是子类，源成员仍属于基类；两种身份都交给 Agent。
            "test_invocations": [r for r in project.data.get("java_members", {}).get("test_invocations", [])
                                 if r["execution_type_key"] == type_key and r["source_member_key"] in tests
                                 and scope != "shared"],
            "imports": imports, "records": records, "dependency_edges": graph, "lifecycle": lifecycle_groups,
            "initialization": sorted(initialization, key=lambda r: (hierarchy.index(r["owner_type_key"]), r["start"])),
            "resources": resources, "unresolved": unresolved, "boundaries": boundaries,
            "required_not_included": omitted, "budget": budget, "test_structure": context_summary(project, records),
            "artifacts": project.data["artifacts"], "semantic_completeness": "NOT_ESTABLISHED",
            "limitations": project.data["limitations"] + ["Initialization is source order evidence, not a runtime execution trace.",
                "Lifecycle ordering assumes ordinary JUnit inheritance; extensions, nested/enclosing instances and providers need review.",
                "Only resolved call/field edges are expanded; type-use and reflection dependencies may require queries."],
            "next_actions": ["read: omitted or business bodies by id", "references/resolve: inspect unresolved references and candidates",
                             "file: inspect annotations, imports or resource/config files", "lookup: inspect supplied artifact items and their statuses",
                             "analyze: inspect source steps/checks/control contexts; features: inspect compatibility review items"]}


def write_context(project, value, output, view="compact"):
    if view not in {"compact", "full"}:
        raise ValueError("无效阅读视图")
    folder = Path(output).resolve()
    # 索引自身的 contexts/ 可保存输出，但不能写入冻结源码；拒绝覆盖已有目录。
    if folder.exists() or folder.is_relative_to(project.input.project) or project.input.root.is_relative_to(folder):
        raise ValueError("上下文输出须为新目录，且不能覆盖或包含源码快照")
    folder.mkdir(parents=True)
    save(folder / "initial_context.json", value)
    compact = compact_context(value)
    compact["full_context_sha256"] = sha(folder / "initial_context.json")
    save(folder / "agent_context.json", compact)
    reading = compact if view == "compact" else value
    paragraphs = ["# 初始上下文", value["purpose"],
                  "索引：" + value["index_id"], "源码快照：" + value["snapshot_id"],
                  "默认先读 agent_context.json；完整证据见同目录 initial_context.json。当前Markdown视图：" + view]
    for r in reading["records"]:
        paragraphs += ["## " + r["display_id"], json.dumps({k: r[k] for k in ["id", "status", "source"]}, ensure_ascii=False),
                       "```java\n" + r["content"] + "\n```" if r["content"] is not None else r["status"] + ("：" + r["covered_by"] if r.get("covered_by") else "")]
    fields = ["selected_tests", "test_invocations", "imports", "lifecycle", "initialization", "resources", "test_structure", "unresolved", "required_not_included", "boundaries", "budget", "input_issues", "semantic_problems", "semantic_completeness", "artifacts", "limitations"]
    if view == "compact":
        fields += ["covered_by_source", "boundary_counts", "external_interfaces", "bodies_available_on_demand", "dependency_counts"]
    for field in fields:
        paragraphs += ["## " + field, "```json\n" + json.dumps(reading[field], ensure_ascii=True, indent=2) + "\n```"]
    (folder / "initial_context.md").write_text("\n\n".join(paragraphs) + "\n", encoding="utf-8")
    return {"status": value["status"], "json": str(folder / "initial_context.json"), "markdown": str(folder / "initial_context.md"),
            "agent_json": str(folder / "agent_context.json"), "view": view,
            "recommended_input": str(folder / ("agent_context.json" if view == "compact" else "initial_context.json")),
            "full_json_bytes": (folder / "initial_context.json").stat().st_size,
            "agent_json_bytes": (folder / "agent_context.json").stat().st_size,
            "records": len(value["records"]), "unresolved": len(value["unresolved"]),
            "required_not_included": len(value["required_not_included"]), "budget": value["budget"]}


def assemble_class(project, target, **budgets):
    """共享上下文：类型头、字段、初始化、构造器、继承生命周期及其依赖。"""
    return assemble(project, target, profile="fragment" if "#" in target else "whole", scope="shared", **budgets)


def assemble_test(project, test, shared, **budgets):
    """单测上下文：测试正文、测试辅助实现、相关业务接口，以及共享记录引用。"""
    if shared["index_id"] != project.data["index_id"]:
        raise ValueError("共享上下文与当前索引不一致")
    type_key, _, _, hierarchy, _ = project.test_target(test)
    if shared["target_type"] != type_key:
        raise ValueError("测试与共享上下文不属于同一类型")
    return assemble(project, test, profile="fragment", scope="test", provided=shared["records"], **budgets)


def write_suite(project, target, output, max_depth=6, max_members=200, max_chars=30000):
    """一次输出类共享材料、逐条测试材料、完整类翻译的 Agent 阅读入口。

    逐条文件通过带 SHA-256 的 shared_ref 对接，Agent 必须同时阅读共享部分。
    agent_context.json 仍提供整类视图，避免把“按测试组织证据”误当逐片段翻译。
    """
    folder = Path(output).resolve()
    if folder.exists() or folder.is_relative_to(project.input.project) or project.input.root.is_relative_to(folder):
        raise ValueError("suite 输出须为源码之外的新目录")
    type_key, tests, _, _, _ = project.test_target(target)
    budgets = dict(max_depth=max_depth, max_members=max_members, max_chars=max_chars)
    # 继承测试的声明 owner 是基类；用所选派生类型#签名保持本轮实例的生命周期。
    type_name = project.types[type_key]["id"]
    shared = assemble_class(project, type_key, **budgets)
    whole = assemble(project, target, profile="whole", **budgets)
    result = write_context(project, whole, folder, "compact")
    save(folder / "shared.json", shared)
    entries = []
    for key in tests:
        method_target = type_name + "#" + project.members[key]["id"].split("#", 1)[1]
        value = assemble_test(project, method_target, shared, **budgets)
        value["shared_ref"] = {"file": "../shared.json", "sha256": sha(folder / "shared.json"),
                               "index_id": shared["index_id"], "required": True}
        # 名称中不使用参数类型，避免 <>[] 等字符成为 Windows 非法路径。
        filename = "tests/" + project.members[key]["name"] + "-" + key[:12] + ".json"
        save(folder / filename, value)
        entries.append({"test_key": key, "display_id": project.members[key]["id"], "file": filename,
                        "test_invocations": value["test_invocations"],
                        "sha256": sha(folder / filename), "unresolved": len(value["unresolved"]),
                        "required_not_included": len(value["required_not_included"])})
    manifest = {"schema_version": "test-context-suite-2.0", "index_id": project.data["index_id"],
                "snapshot_id": project.data["snapshot_id"], "target_type": type_key,
                "shared": {"file": "shared.json", "sha256": sha(folder / "shared.json")},
                "tests": entries, "agent_entry": "agent_context.json",
                "reading_order": ["agent_context.json for whole-class translation",
                                  "shared.json + tests/<selected>.json for one-test evidence", "local CLI queries as needed"]}
    save(folder / "tasks.json", manifest)
    return {**result, "status": "SUITE_CREATED_WITH_LIMITATIONS", "tests": len(tests),
            "tasks": str(folder / "tasks.json"), "shared": str(folder / "shared.json")}
