"""把一次 JavaParser 分析的结果规范化；这里只整理位置与身份，不猜测引用目标。"""
from collections import defaultdict
from pathlib import Path

from common import identity


def source_identity(snapshot, file, node):
    """显示名允许重复，机器 key 同时包含快照、路径、节点种类和精确区间。"""
    return identity([snapshot, file, node["kind"], node["id"], node["start"], node["end"]])


def normalize_facts(source, analysis):
    """将语法类型/成员与语义引用放到同一坐标体系，供 indexer 建立关系。

    Java String 的下标按 UTF-16 码元计数，Python 字符串不一定相同。
    因此切片前先编码为 UTF-16，保留 emoji、制表符和 CRLF 的位置。
    """
    result = []
    for raw in analysis["files"]:
        relative = Path(raw["file"]).resolve().relative_to(source.project).as_posix()
        record = source.files[relative]
        if "facts" not in raw:
            # 没有可恢复 AST（包括非 UTF-8 输入）时仍登记文件及解析失败原因。
            result.append({"file": relative, "source_role": record["source_role"],
                           "source_sha256": record["sha256"], "parse_status": raw["status"].upper(),
                           "package": "", "imports": [], "types": [], "members": [],
                           "calls": [], "references": [], "body_nodes": [], "boundaries": []})
            continue
        encoded = (source.project / relative).read_bytes().decode("utf-8").encode("utf-16-le")

        def text(start, end):
            if not 0 <= start <= end <= len(encoded) // 2:
                raise ValueError("解析位置越界: " + relative)
            return encoded[start * 2:end * 2].decode("utf-16-le")

        syntax = raw.get("facts", {"package": "", "imports": [], "types": [], "members": []})
        file = {**syntax, "file": relative, "source_role": record["source_role"],
                "source_sha256": record["sha256"], "parse_status": raw["status"].upper(),
                "calls": [], "references": [], "boundaries": []}
        type_at = defaultdict(list)
        for node in file["types"]:
            node["source_key"] = source_identity(source.snapshot_id, relative, node)
            node["header_source"] = text(node["start"], node["header_end"])
            for annotation in node["annotation_details"]:
                annotation["source"] = text(annotation["start"], annotation["end"])
            type_at[node["start"]].append(node["source_key"])
            if node.get("structure_boundary"):
                file["boundaries"].append({"kind": node["structure_boundary"], "type": node["source_key"]})
        for node in file["members"]:
            node["source_member_key"] = source_identity(source.snapshot_id, relative, node)
            owners = type_at[node.pop("owner_start")]
            if len(owners) != 1:
                raise ValueError("无法唯一定位成员所属类型: " + node["id"])
            node["owner_type_key"] = owners[0]
            node["original_source"] = text(node["start"], node["end"])
            if node.get("initializer_start") is not None:
                node["initializer"] = text(node["initializer_start"], node["initializer_end"])
            for annotation in node["annotation_details"]:
                annotation["source"] = text(annotation["start"], annotation["end"])
        # Java 原始位置统一为包内路径；节点仍保留结构元数据，不复制所有语句正文。
        for node in file.get("body_nodes", []):
            loc = node.pop("location")
            node.update(start=loc["start"], end=loc["end"])
            text(node["start"], node["end"])  # 验证 UTF-16 区间可回读。
            parent = node.pop("parent_location", None)
            node["parent_span"] = [parent["start"], parent["end"]] if parent else None
        # 通过最小包含区间定位调用者；匿名类方法不会归到包住它的外层测试方法。
        for raw_ref in raw["references"]:
            loc = raw_ref.get("location")
            if not loc:
                continue
            start, end = loc["start"], loc["end"]
            callers = [m for m in file["members"] if m["start"] <= start and end <= m["end"]]
            caller = min(callers, key=lambda m: m["end"] - m["start"]) if callers else None
            owner = next((t for t in file["types"] if caller and t["source_key"] == caller["owner_type_key"]), None)
            is_call = raw_ref["kind"] in {"method", "constructor", "method_reference"}
            node = {"kind": "call" if is_call else "reference", "name": raw_ref["name"],
                    "id": (caller["id"] if caller else relative) + "@" + str(start) + ":" + raw_ref["name"],
                    "start": start, "end": end, "start_line": text(0, start).count("\n") + 1,
                    "owner": owner["id"] if owner else None, "owner_type_key": owner["source_key"] if owner else None,
                    "caller": caller["id"] if caller else None,
                    "caller_start": caller["start"] if caller else None,
                    "caller_source_member_key": caller["source_member_key"] if caller else None,
                    "original_source": text(start, end), "resolution": "NOT_ATTEMPTED"}
            node["end_line"] = node["start_line"] + node["original_source"].count("\n")
            node["call_kind" if is_call else "reference_kind"] = raw_ref["kind"]
            node["reference_key"] = source_identity(source.snapshot_id, relative, node)
            file["calls" if is_call else "references"].append(node)
        result.append(file)
    return {"files": result}
