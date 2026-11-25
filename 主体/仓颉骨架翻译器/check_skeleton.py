"""Check generated Cangjie declarations and their Java member mappings before filling."""

import argparse
import json
from pathlib import Path
import re
import sys
from typing import NamedTuple

# Slot helpers from the integrated fragment_tool.py.


def inside(root, name):
    path = (root / name).resolve()
    if not path.is_relative_to(root):
        raise ValueError(f"路径超出允许目录: {name}")
    return path


def markers(slot):
    return f"/* FRAGMENT_BEGIN:{slot} */", f"/* FRAGMENT_END:{slot} */"


def region(source, slot):
    start, end = markers(slot)
    if source.count(start) != 1 or source.count(end) != 1:
        raise ValueError(f"{slot}: 起止标记必须各出现一次")
    a, b = source.index(start), source.index(end) + len(end)
    if a + len(start) >= b - len(end) or "/* FRAGMENT_" in source[a + len(start):b - len(end)]:
        raise ValueError(f"{slot}: 标记顺序错误、空槽或嵌套")
    return a, b


class Token(NamedTuple):
    value: str
    start: int
    end: int


TOKEN = re.compile(
    r"(?P<comment>//[^\r\n]*|/\*.*?\*/)"
    r'''|""".*?"""|"(?:\\.|[^"\\])*"|'(?:\\.|[^'\\])*'|[^\W\d]\w*|::|[^\s]''',
    re.DOTALL,
)
MARKER = re.compile(r"/\* FRAGMENT_(?:BEGIN|END):([A-Za-z0-9_-]+) \*/")
TYPE_DECLARATIONS = {"class", "struct", "interface", "enum"}
MEMBER_DECLARATIONS = TYPE_DECLARATIONS | {"func", "init", "let", "var", "prop"}
MEMBER_MODIFIERS = {
    "public", "protected", "internal", "private", "static", "abstract", "open",
    "override", "redef", "operator", "const", "sealed", "mut",
}


def load(path):
    return json.loads(path.read_text(encoding="utf-8-sig"))


def tokens(source):
    return [Token(match[0], match.start(), match.end())
            for match in TOKEN.finditer(source) if match.lastgroup != "comment"]


def selector_key(selector):
    if "(" not in selector:
        return selector + "()"
    return re.sub(r"\s+", "", selector)


def source_members(run, config, required):
    project = Path(config["project_root"]).resolve()
    selected_files = {inside(project, name) for name in config["test_files"]}
    permitted_files = selected_files | {inside(project, name) for name in config.get("test_support_files", [])}
    tables = {}
    selectors = {}
    default_required = set()
    for table_path in sorted((run / "02-java-skeleton").rglob("members.json")):
        table = load(table_path)
        table_id = table_path.relative_to(run).as_posix()
        indexed = {}
        records = {item["original_file"]: item["source_file"] for item in table["files"]}
        for member in table["members"]:
            original = records[member["source_location"]["file"]]
            source_path = inside(project, Path(table["input_root"]) / original)
            if source_path not in permitted_files:
                continue
            key = member["id"]
            indexed[key] = member
            if member["role"] == "test" or member["role"].startswith("test_"):
                if source_path in selected_files:
                    default_required.add(key)
                # Declaring-class selectors continue to work for older member tables.
                selectors.setdefault(selector_key(key.split("::", 1)[1]), set()).add(key)
        for invocation in table.get("test_invocations", []):
            key = invocation["source_member_id"]
            if key in indexed:
                selectors.setdefault(selector_key(invocation["selector"]), set()).add(key)
        tables[table_id] = indexed
    if not tables:
        raise ValueError("未找到 Java 成员表")
    if required:
        expected = set(required)
    elif config.get("selected_test_methods"):
        expected = set()
        for selector in config["selected_test_methods"]:
            matches = selectors.get(selector_key(selector), set())
            if len(matches) != 1:
                raise ValueError(f"测试选择器无法唯一定位源成员：{selector}")
            expected.update(matches)
    else:
        expected = default_required
    all_ids = {member_id for table in tables.values() for member_id in table}
    if not expected:
        raise ValueError("没有找到要核对的测试；请检查本轮选中的文件或成员")
    if expected - all_ids:
        raise ValueError(f"选中的源成员不存在：{sorted(expected - all_ids)}")
    return tables, expected


def qualified_names(code, keyword):
    sequence = tokens(code)
    for start, token in enumerate(sequence[:-1]):
        if token.value != keyword:
            continue
        i = start + 1
        name = sequence[i].value
        while i + 2 < len(sequence) and sequence[i + 1].value in {".", "::"}:
            name += sequence[i + 1].value + sequence[i + 2].value
            i += 2
        yield name


class TargetSource:
    def __init__(self, path):
        self.code = path.read_text(encoding="utf-8-sig")
        self.tokens = tokens(self.code)
        self.values = [token.value for token in self.tokens]
        self.owners = []
        self.closing = {}
        scopes = []
        declared_type = None
        for i, value in enumerate(self.values):
            self.owners.append(tuple(owner for _, owner in scopes))
            if value in TYPE_DECLARATIONS and i + 1 < len(self.values) and self.values[i + 1].isidentifier():
                declared_type = self.values[i + 1]
            elif value == "{":
                scopes.append((i, declared_type))
                declared_type = None
            elif value == "}":
                if not scopes:
                    raise ValueError("目标源码有未配对的右花括号")
                start, _ = scopes.pop()
                self.closing[start] = i
        if scopes:
            raise ValueError("目标源码有未配对的左花括号")

    def declaration(self, row):
        signature = [token.value for token in tokens(row["target_signature"])]
        keywords = {"func", "init", "let", "var", "prop"}
        pivot = next((i for i, value in enumerate(signature) if value in keywords), -1)
        if pivot < 0 or pivot + 1 >= len(signature):
            raise ValueError("target_signature 缺少可识别的声明")
        name = "init" if signature[pivot] == "init" else signature[pivot + 1]
        if name != row["target_member"]:
            raise ValueError(f"target_member 与签名不一致：{row['target_member']} / {name}")
        target_class = row.get("target_class")
        expected_scope = tuple(target_class.rsplit(".", 1)[-1].split("$")) if target_class else ()
        candidates = []
        for i, item in enumerate(self.values):
            end = i + len(signature)
            if (item == signature[0] and self.values[i:end] == signature
                    and self.owners[i] == expected_scope
                    and self.signature_ends_at(end, signature[pivot])):
                candidates.append((i, end))
        if len(candidates) != 1:
            raise ValueError(f"目标声明匹配 {len(candidates)} 处：{target_class or '<package>'}.{row['target_signature']}")
        return candidates[0]

    def signature_ends_at(self, end, kind):
        if end == len(self.values) or self.values[end] in {"{", "=", ";", "let", "var", "func", "}", "@"}:
            return True
        if kind not in {"let", "var"}:
            return False
        gap = self.code[self.tokens[end - 1].end:self.tokens[end].start]
        if "\n" not in gap:
            return False
        while end < len(self.values) and self.values[end] in MEMBER_MODIFIERS:
            end += 1
        return end < len(self.values) and self.values[end] in MEMBER_DECLARATIONS

    def slot(self, row, end):
        slot = row["slot_id"]
        start, stop = region(self.code, slot)
        begin_marker, end_marker = markers(slot)
        if not tokens(self.code[start + len(begin_marker):stop - len(end_marker)]):
            raise ValueError(f"槽位 {slot} 缺少占位内容")
        if row["fill_slot"] == "body" and end in self.closing:
            opening = self.tokens[end].end
            closing = self.tokens[self.closing[end]].start
            if opening <= start < stop <= closing and not tokens(self.code[opening:start] + self.code[stop:closing]):
                return
        if row["fill_slot"] == "initializer" and end < len(self.tokens) and self.values[end] == "=":
            opening = self.tokens[end].end
            if opening <= start and not tokens(self.code[opening:start]):
                return
        raise ValueError(f"槽位 {slot} 未包住目标声明的 {row['fill_slot']} 占位")


def target_packages(roots):
    paths = {path for root in roots for path in (root.rglob("*.cj") if root.is_dir() else [root])}
    return {pkg for path in paths
            for pkg in qualified_names(path.read_text(encoding="utf-8-sig"), "package")}


def wrong_namespace(import_name, packages):
    if any(import_name == package or import_name.startswith(package + ".") for package in packages):
        return []
    short = import_name.split("::")[-1]
    return sorted(package for package in packages if "::" in package
                  and (short == package.split("::")[-1] or short.startswith(package.split("::")[-1] + ".")))


def verify(run, roots=(), required=()):
    roots = tuple(root.resolve(strict=True) for root in roots)
    config = load(run / "translation_config.json")
    tables, expected = source_members(run, config, required)
    skeleton = run / "05-cangjie-skeleton"
    mapping = load(skeleton / "member_mapping.json")
    if not isinstance(mapping, list) or any(not isinstance(row, dict) for row in mapping):
        raise ValueError("member_mapping.json 应为映射对象数组")
    packages = target_packages(roots)
    errors, blocked = [], []
    seen, declarations = set(), set()
    assigned_slots = {}
    files = {}
    for row in mapping:
        member_id = row.get("source_member_id")
        try:
            member = None
            if member_id is not None:
                table = inside(run, row["source_members_file"]).relative_to(run).as_posix()
                member = tables.get(table, {}).get(member_id)
                if member is None:
                    raise ValueError("源成员在指定成员表或本轮范围中不存在")
            elif not row.get("adaptation"):
                raise ValueError("新增目标成员应说明来源和作用")
            status = row["status"]
            if status == "blocked":
                if not member_id or not row.get("adaptation"):
                    raise ValueError("blocked 必须给出源成员和原因")
                blocked.append(member_id)
                seen.add(member_id)
                continue
            if status not in {"mapped", "reused"}:
                raise ValueError(f"未知的映射状态 {status}")
            if status == "reused":
                path = (skeleton / row["target_file"]).resolve()
                if not path.is_relative_to(skeleton) and not any(path == root or path.is_relative_to(root) for root in roots):
                    raise ValueError("复用的目标文件不在骨架或已给出的目标源码范围内")
            else:
                path = inside(skeleton, row["target_file"])
            if path not in files:
                files[path] = TargetSource(path)
            target = files[path]
            start, end = target.declaration(row)
            if (path, start) in declarations:
                raise ValueError("目标声明被重复映射")
            declarations.add((path, start))
            fill, slot = row.get("fill_slot"), row.get("slot_id")
            if fill is not None:
                if (status != "mapped" or fill not in {"body", "initializer"}
                        or not re.fullmatch(r"[A-Za-z0-9_-]+", slot or "") or slot in assigned_slots):
                    raise ValueError(f"无效或重复的槽位 {slot}")
                original_field = "original_body" if fill == "body" else "initializer"
                if member is None or not member.get(original_field):
                    raise ValueError(f"槽位 {slot} 缺少对应的 Java 原文 {original_field}")
                target.slot(row, end)
                assigned_slots[slot] = path
            elif slot is not None:
                raise ValueError(f"槽位 {slot} 缺少填充类型")
            seen.add(member_id)
        except (KeyError, OSError, TypeError, ValueError) as error:
            errors.append(f"{member_id}: {error}")
    for path in sorted(skeleton.rglob("*.cj")):
        source = path.read_text(encoding="utf-8-sig")
        for name in qualified_names(source, "import"):
            namespaced = wrong_namespace(name, packages)
            if namespaced:
                errors.append(f"{path.name}: import {name} 缺少正确的包命名空间，可用声明 {namespaced}")
        for marker in sorted(set(MARKER.findall(source))):
            if assigned_slots.get(marker) != path:
                errors.append(f"{path.name}: 槽位 {marker} 没有关联到本文件的成员映射")
    errors.extend(f"{member_id}: 缺少有效的成员映射" for member_id in sorted(expected - seen))
    return {"status": "failed" if errors else ("partial" if blocked else "passed"),
            "checked_members": len(seen - {None}), "required_members": len(expected),
            "slots": len(assigned_slots), "blocked": blocked, "errors": errors}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--run", required=True, type=Path, help="包含 Java 成员、生成骨架和本轮配置的目录")
    parser.add_argument("--target-source", action="append", type=Path, default=[], help="可重复，校对包命名空间的目标源码")
    parser.add_argument("--required-member", action="append", default=[], help="可重复，覆盖默认要求核对的成员 ID")
    parser.add_argument("--report", type=Path, help="结构检查 JSON 输出路径")
    args = parser.parse_args()
    try:
        report = verify(args.run.resolve(), args.target_source, args.required_member)
    except (KeyError, OSError, TypeError, ValueError) as error:
        report = {"status": "failed", "errors": [str(error)]}
    output = json.dumps(report, ensure_ascii=False, indent=2) + "\n"
    if args.report:
        args.report.write_text(output, encoding="utf-8")
    sys.stdout.reconfigure(encoding="utf-8")
    print(output, end="")
    return {"passed": 0, "failed": 1, "partial": 2}[report["status"]]


if __name__ == "__main__":
    raise SystemExit(main())
