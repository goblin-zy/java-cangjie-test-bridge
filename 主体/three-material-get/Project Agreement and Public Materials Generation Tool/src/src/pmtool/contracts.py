"""Collect indexed test-to-business usages for the contract review."""
from . import db


def contract_scope(index, files, members):
    target_files = [f for f in files.values()
                    if f["language"] == "cangjie" and f["relative_path"].lower().endswith(".cj")
                    and f.get("effective_role", f.get("role")) != "test" and f["status"] != "excluded"]
    mode = "propose_from_source"
    if target_files:
        mode = "inspect_target" if all(f["status"] == "parsed" for f in target_files) else "inspect_partial_target"
    uses = {}
    for ref in db.records(index, "references"):
        file = files[ref["file_id"]]
        if file["language"] != "java" or (file.get("effective_role") or file["role"]) != "test":
            continue
        for member_id in ref.get("target_member_ids", []):
            member = members[member_id]
            if member["language"] == "java" and member["file_role"] != "test":
                uses.setdefault(member_id, []).append(ref["id"])
    return {"mode": mode, "test_references_by_source_member": uses,
            "review_note": "索引仅列已绑定的测试侧引用。沿测试准备、辅助和清理核对可达调用，补查未绑定、继承和异常类型。"}
