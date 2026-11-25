"""Apply an evidence-backed target location before either annotation starts."""
from pathlib import Path
import re

from alignment import declarations
from workflow import SIDES, alignment, folder, read, require, save, sha, stage


def resolve(run: Path, draft: Path):
    for side in SIDES:
        directory = folder(run, side)
        allowed = {"inputs", f"materials_{side}.json", f"task_{side}.json"}
        require(all(p.name in allowed for p in directory.iterdir()),
                "两侧标注已开始，不能修改定位")
    for directory in [stage(run, i) for i in (3, 4, 5)] + [run / "deliverables"]:
        require(not any(p.is_file() for p in directory.rglob("*")), "比较或交付已开始")

    data = alignment(run)
    form = read(draft)
    units = {unit["id"]: unit for unit in data["units"]}
    require(isinstance(form, dict) and isinstance(form.get("id"), str)
            and form["id"] in units, "需要有效的复核单元编号")
    unit = units[form["id"]]
    require(not unit["cangjie"] or unit.get("location_review"), "此单元已有唯一定位")
    reason = form.get("reason")
    segments = form.get("cangjie")
    require(isinstance(reason, str) and reason.strip() and isinstance(segments, list)
            and segments, "需要复核原因和至少一个完整声明")
    directory = folder(run, "cangjie")
    task_path = directory / "task_cangjie.json"
    task = read(task_path)
    task_units = [item for item in task["units"] if item["id"] == form["id"]]
    require(len(task_units) == 1, "仓颉任务包单元不唯一")
    raw = (stage(run, 1) / data["files"]["cangjie"]).read_bytes()
    manifest = read(directory / "materials_cangjie.json")
    require(sha(raw) == manifest[0]["sha256"] and raw == (directory / task["source"]).read_bytes(),
            "仓颉原文与独立任务包版本不符")
    text = raw.decode("utf-8-sig")
    lines = text.splitlines()
    occupied = [span for other in units.values() if other is not unit
                for span in other.get("cangjie_ranges", [other["cangjie"]]) if span]
    ranges, evidence = [], []
    for item in segments:
        require(isinstance(item, dict), "范围必须包含行号及原文")
        start, end = item.get("start"), item.get("end")
        require(type(start) is int and type(end) is int and 1 <= start <= end <= len(lines),
                "仓颉范围越界")
        span = [start, end]
        quote = "\n".join(lines[start - 1:end])
        require(item.get("quote") == quote, "引文与原文不符")
        names = {name for name in re.findall(r"\bfunc\s+(\w+)\s*\(", quote)
                 if span in declarations(text, name, "cangjie")}
        require(len(names) == 1, "范围必须恰好覆盖含注解的完整方法声明")
        name = names.pop()
        mapped = span in unit["candidates"]
        if not mapped:
            require(unit["name"] in reason and name in reason
                    and re.search(r"(?m)^\s*@TestCase\b", quote),
                    "映射外声明须有测试注解，并在原因中指名源、目标方法并说明对应依据")
        require(all(end < left or start > right for left, right in occupied + ranges),
                "复核范围与已有目标或本次其他片段重叠")
        ranges.append(span)
        evidence.append(dict(start=start, end=end, quote=quote, member=name,
                             basis="同成员映射候选" if mapped else "模型提供对应依据：" + reason))
    ranges.sort()
    unit.update(cangjie=ranges[0], cangjie_ranges=ranges,
                location_review={"reason": reason, "evidence": evidence})
    task_units[0].update(lines=ranges[0], ranges=ranges)
    save(stage(run, 1) / "alignment.json", data)
    save(task_path, task)
    return unit
