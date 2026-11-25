"""原项目 → 源码快照 → 一次结构/引用分析 → 四张索引表；不再接受预处理包。"""
from collections import Counter, defaultdict
from pathlib import Path
import os
import shutil

from backend import analyze
from common import SCHEMA, VERSION, identity, load, save, sha
from project_source import scan_project
from facts import normalize_facts
from internal_analysis import build_internal_analysis
from java_members import import_members

TESTS = {"Test": "test", "ParameterizedTest": "parameterized_test", "RepeatedTest": "repeated_test",
         "TestFactory": "dynamic_test", "TestTemplate": "template_test"}
LIFECYCLE = {"BeforeEach": "setup", "Before": "setup", "AfterEach": "cleanup", "After": "cleanup",
             "BeforeAll": "class_setup", "BeforeClass": "class_setup", "AfterAll": "class_cleanup", "AfterClass": "class_cleanup"}


def annotation_name(name, file, types):
    """以显式全名/import 判断 JUnit 注解；项目同名注解不能冒充框架注解。"""
    if "." in name:
        return name, "EXPLICIT_NAME"
    if any(t["name"] == name and t["file"] == file["file"] for t in types.values()):
        return None, "PROJECT_TYPE_SHADOWS_ANNOTATION"
    explicit = [i["name"] for i in file["imports"] if not i["static"] and i["name"].rsplit(".", 1)[-1] == name]
    if len(explicit) == 1:
        return explicit[0], "EXPLICIT_IMPORT"
    if len(explicit) > 1:
        return None, "AMBIGUOUS_IMPORT"
    same_package = file["package"] + "." + name if file["package"] else name
    if any(t["id"] == same_package for t in types.values()):
        return None, "PROJECT_PACKAGE_TYPE"
    candidates = [i["name"][:-1] + name for i in file["imports"] if not i["static"] and i["name"].endswith(".*")]
    junit = [x for x in candidates if x.rsplit(".", 1)[0] in {"org.junit", "org.junit.jupiter.api", "org.junit.jupiter.params"}]
    if len(junit) == 1 and len(candidates) == 1:
        return junit[0], "SINGLE_WILDCARD_IMPORT"
    return None, "NOT_BOUND"


def build(project_root, output, *, java="java", javac="javac", classpath=(), timeout=300,
          syntax_only=False, materials=None, rules=None, member_map=None,
          business_roots=None, test_roots=None, support_roots=None, resource_roots=None,
          test_scope=(), exclude=(), java_members=()):
    """完整构建入口；源码与依赖身份变化时必须构建新目录。

    scan_project 保存字节副本；analyze 调用 JavaParser.parse/findAll/resolve；
    normalize_facts 分配位置身份；下面只根据声明位置或完整签名建立绑定。
    """
    out = Path(output).resolve()
    context = scan_project(project_root, out, business_roots=business_roots, test_roots=test_roots,
                           support_roots=support_roots, resource_roots=resource_roots,
                           test_scope=test_scope, exclude=exclude)
    try:
        semantic, fingerprint = analyze(context, out / "backend", java, javac, classpath, timeout, syntax_only)
        fingerprint["mode"] = "SYNTAX_ONLY_EXPLICIT" if syntax_only else "STATIC_SYMBOL_ANALYSIS"
        context.facts = normalize_facts(context, semantic)
        files = {f["file"]: {k: v for k, v in f.items() if k not in {"types", "members", "calls", "references", "body_nodes"}}
                 for f in context.facts["files"]}
        types, members, references = {}, {}, {}
        member_at, type_at, fields_by_signature = defaultdict(list), defaultdict(list), defaultdict(list)
        methods_by_name = defaultdict(list)
        for file in context.facts["files"]:
            for t in file["types"]:
                node = {k: v for k, v in t.items() if k != "header_source"}
                node.update(file=file["file"], source_role=file["source_role"], parents=[], parent_resolution="NOT_ESTABLISHED")
                types[t["source_key"]] = node
                type_at[(file["file"], t["start"])].append(t["source_key"])
            for m in file["members"]:
                node = {k: v for k, v in m.items() if k not in {"original_source", "original_body", "variables_as_written"}}
                node.update(file=file["file"], source_role=file["source_role"], roles=[], annotation_bindings=[], resolved_signature=None)
                members[m["source_member_key"]] = node
                member_at[(file["file"], m["start"], m["kind"])].append(m["source_member_key"])
                if m["kind"] == "field":
                    fields_by_signature[m["owner"] + "." + m["name"]].append(m["source_member_key"])
                methods_by_name[m["name"]].append(m["source_member_key"])
        types_by_name = defaultdict(list)
        for key, t in types.items():
            types_by_name[t["id"]].append(key)

        def relative(location):
            if not location:
                return None
            path = Path(location["file"]).resolve()
            if not path.is_relative_to(context.project):
                return None
            return path.relative_to(context.project).as_posix()

        # 第一轮建立声明位置/完整签名索引；第二轮才给调用边绑定目标。
        # 同名/重复类型始终保留候选列表，不用 dict 覆盖旧声明。
        semantic_refs = defaultdict(list)
        problems = []
        signatures = defaultdict(list)
        for file in semantic["files"]:
            rel = Path(file["file"]).resolve().relative_to(context.project).as_posix()
            if file["issues"]:
                problems.append({"kind": "SEMANTIC_PARSE_ISSUES", "file": rel, "details": file["issues"]})
            for d in file["declarations"]:
                loc = d.get("location")
                keys = member_at.get((rel, loc["start"], d["kind"]), []) if loc else []
                if len(keys) == 1 and d.get("signature"):
                    members[keys[0]]["resolved_signature"] = d["signature"]
                    signatures[d["signature"]].append(keys[0])
            for t in file["types"]:
                loc = t.get("location")
                keys = type_at.get((rel, loc["start"]), []) if loc else []
                if len(keys) == 1:
                    node = types[keys[0]]
                    if "ancestors" in t:
                        node["parent_names"] = t["ancestors"]
                        node["parents"] = [types_by_name[name][0] for name in t["ancestors"] if len(types_by_name.get(name, [])) == 1]
                        node["parent_ambiguities"] = [{"name": name, "candidates": types_by_name[name]} for name in t["ancestors"] if len(types_by_name.get(name, [])) > 1]
                        node["parent_resolution"] = "SYMBOL_SOLVER"
                    else:
                        node["parent_reason"] = t.get("reason")
            for r in file["references"]:
                loc = r.get("location")
                if loc:
                    semantic_refs[(rel, loc["start"], r["name"], r["kind"])].append(r)
        # Fallback parent candidates are retained as such, never promoted to bindings.
        for t in types.values():
            if t["parent_resolution"] != "NOT_ESTABLISHED" or not t.get("extends"):
                continue
            name = t["extends"].split("<", 1)[0]
            f = files[t["file"]]
            candidates = [name, (f["package"] + "." + name).lstrip(".")]
            candidates += [i["name"] for i in f["imports"] if i["name"].endswith("." + name)]
            parents = sorted({key for n in candidates for key in types_by_name.get(n, [])})
            t["parent_candidates"] = parents
        for key, member in members.items():
            for name in member.get("annotations", []):
                qualified, basis = annotation_name(name, files[member["file"]], types)
                member["annotation_bindings"].append({"as_written": name, "qualified_name": qualified, "basis": basis})
                if qualified is None:
                    continue
                prefix, short = qualified.rsplit(".", 1)
                if prefix not in {"org.junit", "org.junit.jupiter.api", "org.junit.jupiter.params"}:
                    continue
                if short in TESTS and member["kind"] == "method":
                    member["roles"].append(TESTS[short])
                if short in LIFECYCLE and member["kind"] == "method":
                    member["roles"].append(LIFECYCLE[short])
                if short in {"Disabled", "Ignore"}:
                    member["roles"].append("disabled")
            # JUnit3 recognition is deliberately limited to declared TestCase inheritance.
            owner = types.get(member.get("owner_type_key"), {})
            parent_names = owner.get("parent_names", [])
            if "junit.framework.TestCase" in parent_names and member["kind"] == "method" and not member["parameters"] and "static" not in member["modifiers"]:
                if member["name"].startswith("test") and member.get("return_type") == "void" and "public" in member["modifiers"]:
                    member["roles"].append("test_junit3")
                elif member["name"] in {"setUp", "tearDown"}:
                    member["roles"].append("setup" if member["name"] == "setUp" else "cleanup")
            member["roles"] = sorted(set(member["roles"]))

        # 调用按声明位置匹配，其次完整签名；字段必须优先核对变量名及区间。
        for file in context.facts["files"]:
            rel = file["file"]
            field_names = {m["name"] for m in members.values() if m["kind"] == "field" and m["file"] == rel}
            for source in [*file["calls"], *file["references"]]:
                is_call = source["kind"] == "call"
                kind = source["call_kind"] if is_call else source["reference_kind"]
                candidates = semantic_refs.get((rel, source["start"], source["name"], kind), [])
                # Match exact spans, allowing the semicolon of explicit this/super statements.
                matching = [r for r in candidates if r["location"]["end"] in {source["end"], source["end"] + 1}]
                r = matching[0] if len(matching) == 1 else None
                if not is_call and (r is None or r["resolution"] == "local_or_parameter"):
                    continue
                if not is_call and r["resolution"] == "unresolved" and source["name"] not in field_names:
                    continue
                node = {k: v for k, v in source.items() if k != "original_source"}
                node.update(file=rel, resolution="unresolved", target_keys=[], candidates=[], dispatch="NOT_ESTABLISHED", binding_basis="NOT_ESTABLISHED")
                if r is not None:
                    node.update({k: v for k, v in r.items() if k not in {"location", "name", "kind", "target_location"}})
                    target = r.get("target_location")
                    target_rel = relative(target)
                    keys = []
                    if target_rel and is_call:
                        target_kind = "constructor" if source["name"] in {"<init>", "this", "super"} else "method"
                        keys = list(member_at.get((target_rel, target["start"], target_kind), []))
                        if keys:
                            node["binding_basis"] = "SOURCE_LOCATION"
                    elif target_rel:
                        # Anonymous-class owners reported by SymbolSolver may be the outer
                        # class. The verified field declaration span remains authoritative.
                        keys = [key for key in member_at.get((target_rel, target["start"], "field"), [])
                                if members[key]["name"] == source["name"] and members[key]["end"] == target["end"]]
                        if keys:
                            node["binding_basis"] = "SOURCE_LOCATION"
                    signature = r.get("target_signature", "")
                    if not keys and (is_call or not target_rel):
                        keys = list(signatures.get(signature, [])) if is_call else list(fields_by_signature.get(signature, []))
                        if keys:
                            node["binding_basis"] = "QUALIFIED_SIGNATURE"
                    # Never fall back to an outer same-name field when source evidence
                    # points at another declaration. Retain the original parser report.
                    if not is_call and len(keys) == 1 and node["binding_basis"] == "SOURCE_LOCATION":
                        actual = members[keys[0]]
                        node.update(reported_target_owner=r.get("target_owner"), reported_target_signature=signature,
                                    target_owner=actual["owner"], target_signature=actual["owner"] + "." + actual["name"])
                    owner_keys = types_by_name.get(node.get("target_owner"), [])
                    if len(owner_keys) > 1:
                        node.update(resolution="ambiguous", candidates=keys or owner_keys, reason="DUPLICATE_PROJECT_TYPE")
                    elif len(keys) == 1:
                        node.update(resolution="resolved_static", target_keys=keys)
                    elif len(keys) > 1:
                        node.update(resolution="ambiguous", candidates=keys, reason="MULTIPLE_DECLARATIONS")
                    elif r["resolution"] == "resolved_static":
                        node["resolution"] = "implicit_project_constructor" if is_call and source["name"] == "<init>" and owner_keys else "project_declaration_unmapped" if owner_keys or target_rel else "external"
                        node["target_type_keys"] = owner_keys
                else:
                    node["reason"] = "SEMANTIC_RESULT_NOT_AVAILABLE"
                    if is_call:
                        node["candidates"] = [k for k in methods_by_name.get(source["name"], [])
                                              if members[k]["kind"] in {"method", "constructor"}]
                references[source["reference_key"]] = node
        imported = import_members(java_members, context, project_root, files, types, members, out)
        internal = build_internal_analysis(context.facts, files, types, members, references)
        artifacts = {}
        for name, path in [("materials", materials), ("rules", rules), ("member_map", member_map)]:
            if path:
                source = Path(path).resolve()
                load(source)  # No execution; reject non-JSON input early.
                target = out / "artifacts" / (name + ".json")
                target.parent.mkdir(exist_ok=True)
                shutil.copyfile(source, target)
                artifacts[name] = {"file": target.relative_to(out).as_posix(), "sha256": sha(target)}
        summary = {"java_files": len(files), "types": len(types), "members": len(members), "references": len(references),
                   "resolution_counts": dict(Counter(r["resolution"] for r in references.values())),
                   "test_methods": sum(any(r in {"test", "parameterized_test", "repeated_test", "dynamic_test", "template_test", "test_junit3"} for r in m["roles"]) for m in members.values())}
        summary["selected_test_methods_declared"] = sum(
            m["file"] in context.scope["selected_test_files"] and
            bool(set(m["roles"]) & {"test", "parameterized_test", "repeated_test", "dynamic_test", "template_test", "test_junit3"})
            for m in members.values())
        summary.update(internal_nodes=len(internal["nodes"]),
                       recognized_assertions=sum(c["recognition"] != "CANDIDATE" for c in internal["checks"].values()),
                       assertion_candidates=sum(c["recognition"] == "CANDIDATE" for c in internal["checks"].values()),
                       compatibility_features=len(internal["features"]))
        meta = {"schema_version": SCHEMA, "tool_version": VERSION, "snapshot_id": context.snapshot_id,
                "source_manifest": "source_manifest.json", "source_manifest_sha256": sha(context.manifest_path),
                "backend": fingerprint, "artifacts": artifacts,
                "internal_analyzer_sha256": sha(Path(__file__).with_name("internal_analysis.py")),
                "java_members_adapter_sha256": sha(Path(__file__).with_name("java_members.py")),
                "java_members": imported}
        index_id = identity(meta)
        schema = {**meta, "index_id": index_id, "summary": summary, "files": files, "types": types, "members": members,
                  "references": references, "internal_analysis": internal, "selected_test_files": context.scope["selected_test_files"],
                  "resource_roots": context.scope["resource_roots"], "source_roots": context.scope["source_roots"],
                  "problems": problems, "structure_boundaries": [b for f in files.values() for b in f["boundaries"]],
                  "limitations": ["static declared targets, not runtime dispatch", "JUnit roles supported by source imports, not runtime discovery",
                                  "missing external JARs remain unresolved", "data providers and extensions require explicit review"]}
        save(out / "project_schema.json", schema)
        save(out / "context_manifest.json", {"schema_version": SCHEMA, "index_id": index_id,
                                             "schema_sha256": sha(out / "project_schema.json"), "summary": summary,
                                             "source_manifest": meta["source_manifest"], "source_snapshot_id": meta["snapshot_id"]})
        return {"status": "INDEX_CREATED", "index": str(out / "project_schema.json"), "index_id": index_id,
                "summary": summary, "semantic_problems": len(problems)}
    except Exception as exc:
        save(out / "FAILED.json", {"error": str(exc)})
        raise
