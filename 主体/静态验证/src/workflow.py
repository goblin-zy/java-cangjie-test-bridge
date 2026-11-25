"""File operations for the agent-driven review. All source locations are 1-based."""
from pathlib import Path
import hashlib
import json
import os
import re
import tempfile

STAGES = ("01-alignment", "02-annotations", "03-comparison",
          "04-audit", "05-report")
SIDES = {"java": "Java", "cangjie": "Cangjie"}
FIELDS = ("片段编号", "环节", "维度", "内容", "关联", "依据", "待确认")
PHASE = r"(?:初始化与准备|被测操作|结果检查|清理)"
RESULTS = ("在所列前提和范围内一致", "发现差异", "信息不足")


def require(ok, message):
    if not ok:
        raise ValueError(message)


def stage(run, index):
    return run / "process" / STAGES[index - 1]


def read(path):
    return json.loads(path.read_text(encoding="utf-8-sig"))


def put(path, data):
    path.parent.mkdir(parents=True, exist_ok=True)
    with tempfile.NamedTemporaryFile(dir=path.parent, delete=False) as stream:
        temp = Path(stream.name)
        try:
            stream.write(data)
        except BaseException:
            stream.close()
            temp.unlink(missing_ok=True)
            raise
    try:
        os.replace(temp, path)
    finally:
        temp.unlink(missing_ok=True)


def save(path, data):
    put(path, (json.dumps(data, ensure_ascii=False, indent=2) + "\n").encode())


def sha(data):
    return hashlib.sha256(data).hexdigest()


def alignment(run):
    return read(stage(run, 1) / "alignment.json")


def folder(run, side):
    return stage(run, 2) / SIDES[side]


def ranges(unit, side):
    if side == "cangjie" and unit.get("cangjie_ranges"):
        return unit["cangjie_ranges"]
    return [unit[side]] if unit[side] else []

def packets(run):
    a = alignment(run)
    for side in SIDES:
        out = folder(run, side)
        name = a["files"][side]
        paths = [stage(run, 1) / name, *map(Path, a["side_inputs"][side])]
        materials = []
        for ix, path in enumerate(dict.fromkeys(paths)):
            relative = Path("inputs") / str(ix) / path.name
            data = path.read_bytes()
            put(out / relative, data)
            materials.append({"file": relative.as_posix(), "sha256": sha(data)})
        save(out / f"materials_{side}.json", materials)
        save(out / f"task_{side}.json", {
            "side": side, "source": materials[0]["file"],
            "units": [{"id": u["id"], "lines": u[side]} for u in a["units"]],
            "instruction": "仅使用本任务列出的输入材料。按源码顺序提交带原文行号的注释与实际查阅记录。"})


def safe_starts(lines, side):
    # Conservative handling of multi-line lexical constructs. Raw literals and
    # Java Unicode escapes can change the lexical meaning of whole lines.
    block = 0
    literal = ""
    allowed = set()
    for n, line in enumerate(lines, 1):
        require(not re.search(r'\\u+[0-9a-fA-F]{4}', line),
                "包含当前版本不能安全插注释的转义或原始字符串，请缩小文件范围")
        if not block and not literal:
            allowed.add(n)
        i = 0
        while i < len(line):
            if block:
                if line.startswith("*/", i):
                    block -= 1
                    i += 2
                elif side == "cangjie" and line.startswith("/*", i):
                    block += 1
                    i += 2
                else:
                    i += 1
            elif literal:
                if line[i] == "\\":
                    i += 2
                elif line.startswith(literal, i):
                    i += len(literal)
                    literal = ""
                else:
                    i += 1
            elif line.startswith("//", i):
                break
            elif line.startswith("/*", i):
                block = 1
                i += 2
            elif side == 'cangjie' and re.match(r'#+["\']', line[i:]):
                # 原始字面量只在字符串/注释外识别；普通 "#id" 是合法 CSS 字符串。
                raise ValueError('包含当前版本不能安全插注释的原始字符串，请缩小文件范围')
            elif line[i] in ('"', "'"):
                literal = line[i] * 3 if line.startswith(line[i] * 3, i) else line[i]
                i += len(literal)
            else:
                i += 1
    return allowed


def render(run, side):
    a = alignment(run)
    out = folder(run, side)
    name = a["files"][side]
    raw = (stage(run, 1) / name).read_bytes()
    materials = read(out / f"materials_{side}.json")
    for item in materials:
        require(sha((out / item["file"]).read_bytes()) == item["sha256"], "取材副本已变更")
    require(sha(raw) == materials[0]["sha256"], "标注依据与原文版本不同")
    lines = raw.decode("utf-8-sig").splitlines(keepends=True)
    anchor = lambda n: lines[n-1].rstrip("\r\n")
    starts = safe_starts(lines, side)
    annotations = read(out / f"annotations_{side}.json")
    context = read(out / f"context_{side}.json")
    require(isinstance(context["sources"], list) and context["sources"]
            and isinstance(context["unknowns"], list), "需要实际补读来源及未知项")
    inserts, ids, previous = {}, set(), 0
    for note in annotations:
        lo, hi = note["start"], note["end"]
        require(previous < lo <= hi <= len(lines) and lo in starts, "注释范围重叠、越界或起点不安全")
        previous = hi
        require(note["quote"] == "\n".join(anchor(n) for n in range(lo,hi+1)), "原文引文不吻合")
        for k in FIELDS:
            v = note[k]
            require(isinstance(v,str) and v.strip() and len(v.splitlines()) == 1
                    and not re.search(r'[\x00-\x1f\x7f]|\\u+|\\$',v), f"注释字段无效 {k}")
        require(re.fullmatch(PHASE + "(?:（" + PHASE + "）)?", note["环节"]), "环节格式错误")
        ident = note["片段编号"]
        require(ident not in ids, "片段编号重复")
        ids.add(ident)
        inserts[lo] = note
    for u in a["units"]:
        for span in ranges(u, side):
            require(any(span[0] <= n["start"] <= n["end"] <= span[1] for n in annotations),
                    f'{side} 缺少 {u["id"]} 的注释')
    output, locations = [], []
    for n,line in enumerate(lines,1):
        if n in inserts:
            indent = re.match(r"[ \t]*",line).group()
            ending = "\r\n" if line.endswith("\r\n") else "\n"
            output.extend(f"{indent}// {k}：{inserts[n][k]}{ending}" for k in FIELDS)
        output.append(line)
        locations.append(len(output))
    require("".join(output[i-1] for i in locations) == "".join(lines), "原文还原校验失败")
    encoded = "".join(output).encode("utf-8-sig" if raw.startswith(b"\xef\xbb\xbf") else "utf-8")
    put(out / name, encoded)
    save(out / "source_locations.json", {"original_to_annotated":locations})
    save(out / "edit_check.json", {"original_sha256":sha(raw),"annotated_sha256":sha(encoded),
        "restored_original":True, "segments":len(annotations)})
    return annotations

