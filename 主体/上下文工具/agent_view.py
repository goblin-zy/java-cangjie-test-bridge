"""Compact reading projection; full evidence and every omission remain accessible."""
from collections import Counter, defaultdict


def compact_context(value):
    """压缩重复元数据，保留已纳入源码、每条未解析引用和全部预算缺项。

    这里只改变展示方式；不推断依赖，也不通过摘要替代辅助方法中的断言。
    """
    records, covered, files = [], defaultdict(list), {}
    for i, row in enumerate(value["records"]):
        source = row["source"]
        files[source["file"]] = source["sha256"]
        if row["status"] == "COVERED_BY_INCLUDED_SOURCE":
            covered[row["covered_by"]].append({"id": row["id"], "display_id": row["display_id"]})
            continue
        records.append({"id": row["id"], "display_id": row["display_id"], "status": row["status"],
                        "content_kind": row["content_kind"], "content": row["content"],
                        "source": {"file": source["file"], "lines": [source["start_line"], source["end_line"]]},
                        "full_evidence_pointer": "/records/" + str(i)})
    unresolved = []
    for i, row in enumerate(value["unresolved"]):
        ref = row["reference"]
        reason = ref.get("reason", "")
        unresolved.append({"reference_key": ref["reference_key"], "resolution": ref["resolution"],
                           "file": ref["file"], "line": ref["start_line"], "name": ref["name"],
                           "candidate_count": len(ref.get("candidates", [])),
                           "reason_summary": reason[:160], "reason_abbreviated": len(reason) > 160,
                           "full_evidence_pointer": "/unresolved/" + str(i)})
    boundaries, external, bodies = [], set(), set()
    for row in value["boundaries"]:
        if row["kind"] == "EXTERNAL_DECLARATION":
            external.add(row.get("signature"))
        elif row["kind"] == "BODY_AVAILABLE_ON_DEMAND":
            bodies.add(row["member"])
        else:
            boundaries.append(row)
    return {"schema_version": "agent-context-1.0", "status": value["status"],
            "index_id": value["index_id"], "snapshot_id": value["snapshot_id"],
            "profile": value["profile"], "purpose": value["purpose"], "target_type": value["target_type"],
            "selected_tests": value["selected_tests"], "full_context_file": "initial_context.json",
            "test_invocations": value.get("test_invocations", []),
            "files": files,
            "imports": [{"file": r["file"], "package": r["package"],
                         "imports": [{"name": imp["name"], "static": imp["static"]} for imp in r["imports"]]}
                        for r in value["imports"]],
            "records": records,
            "covered_by_source": [{"source": source, "members": members} for source, members in covered.items()],
            "lifecycle": value["lifecycle"], "initialization": value["initialization"], "resources": value["resources"],
            "test_structure": value["test_structure"],
            "unresolved_count": len(value["unresolved"]), "unresolved": unresolved,
            "boundaries": boundaries, "boundary_counts": dict(Counter(r["kind"] for r in value["boundaries"])),
            "external_interfaces": sorted(x for x in external if x is not None),
            "bodies_available_on_demand": sorted(bodies),
            "dependency_counts": dict(Counter(r["resolution"] for r in value["dependency_edges"])),
            "full_dependency_evidence_pointer": "/dependency_edges",
            "full_boundary_evidence_pointer": "/boundaries",
            "required_not_included": value["required_not_included"], "budget": value["budget"],
            "input_issues": value["input_issues"],
            "semantic_problems": [{"kind": r["kind"], "file": r.get("file"),
                                    "full_evidence_pointer": "/semantic_problems/" + str(i)}
                                   for i, r in enumerate(value["semantic_problems"])],
            "artifacts": value["artifacts"], "semantic_completeness": value["semantic_completeness"],
            "limitations": value["limitations"], "next_actions": value["next_actions"],
            "projection_note": "All included source/resource content, unresolved identities and omissions are retained. "
                               "Verbose diagnostics, exact spans and graph rows are in full_context_file or local queries."}
