"""Decode the official std.ast 1.2 dump, NOT Cangjie source text.
The format is version-bound. Unknown nodes stay in raw evidence and produce coverage issues.
"""
from __future__ import annotations
import json
import re
from dataclasses import dataclass, field

@dataclass
class DumpNode:
    kind: str
    field_name: str = ""
    attributes: dict[str, str] = field(default_factory=dict)
    children: list["DumpNode"] = field(default_factory=list)

    def children_named(self, name):
        return [c for c in self.children if c.field_name == name]

    def first(self, name):
        return next(iter(self.children_named(name)), None)

    def tokens(self):
        if self.kind == "Token":
            yield self
        for child in self.children:
            yield from child.tokens()

def decode_dump(text: str) -> DumpNode:
    marker = "PMTOOL_CJ_AST_1_2"
    if marker not in text:
        raise ValueError("缺少仓颉桥接协议标记，不能按 std.ast 1.2 解码")
    lines = text.split(marker, 1)[1].strip().splitlines()
    stack, root = [], None
    # These expressions parse dump labels, not source-language method boundaries.
    opening = re.compile(r"^(?:(-?[\w]+)(?:\s*:\s*\d+[, :]*)?\s*:\s*|(-?[\w]+):\s*\d+,\s*)?([\w]+)\s*\{$")
    for raw in lines:
        line = raw.strip()
        if not line:
            continue
        if line == "}":
            if not stack:
                raise ValueError("AST dump 大括号不匹配")
            stack.pop()
            continue
        match = opening.match(line)
        if match:
            field_name = (match.group(1) or match.group(2) or "").lstrip("-")
            node = DumpNode(match.group(3), field_name)
            if stack:
                stack[-1].children.append(node)
            elif root is None:
                root = node
            else:
                raise ValueError("AST dump 含多个根节点")
            stack.append(node)
        elif stack and ":" in line:
            key, value = line.split(":", 1)
            stack[-1].attributes[key.strip().lstrip("-")] = value.strip()
        else:
            raise ValueError(f"不支持的 AST dump 行：{line[:160]}")
    if stack or root is None or root.kind != "Program":
        raise ValueError("AST dump 不完整或根节点不是 Program")
    return root

def token_value(node: DumpNode | None) -> str:
    if not node:
        return ""
    raw = node.attributes.get("value", "")
    try:
        return json.loads(raw)
    except (ValueError, TypeError):
        return raw.strip('"')

def spelling(node: DumpNode | None) -> str:
    return " ".join(token_value(t) for t in node.tokens()) if node else ""

def span(node: DumpNode):
    positions = []
    for t in node.tokens():
        match = re.search(r"(\d+)\s*:\s*(\d+)\s*$", t.attributes.get("pos", ""))
        if match and int(match.group(1)) > 0:
            positions.append((int(match.group(1)), int(match.group(2))))
    if not positions:
        raise ValueError(f"{node.kind} 缺少可用的原始行列；不能编造源码位置")
    return min(p[0] for p in positions), max(p[0] for p in positions)

def normalize_dump(text: str) -> dict:
    root = decode_dump(text)
    members, references, issues = [], [], []
    contains_test_annotations = False
    package = spelling(root.first("packageHeader")).replace("package ", "").strip()
    imports = [spelling(n) for n in root.children_named("importLists")]
    supported = {"ClassDecl": "class", "StructDecl": "struct", "InterfaceDecl": "interface",
                 "EnumDecl": "enum", "ExtendDecl": "extension", "FuncDecl": "method",
                 "VarDecl": "field", "PropDecl": "property", "TypeAliasDecl": "type_alias",
                 "MacroDecl": "macro", "MainDecl": "main", "PrimaryCtorDecl": "constructor"}
    containers = {"class", "struct", "interface", "enum", "extension"}
    seen = set()

    def visit(node: DumpNode, owners: list[str], in_body: bool = False):
        nonlocal contains_test_annotations
        if node.kind.startswith("MacroExpand") or node.kind == "Annotation":
            annotation_tokens = {token_value(t) for t in node.tokens()}
            if annotation_tokens & {"Test", "TestCase"}:
                contains_test_annotations = True
        owner = ".".join([package, *owners]).strip(".")
        next_owners = owners
        executable_body = in_body or node.kind in {"Block", "LambdaExpr"}
        if node.kind in supported and (not in_body or node.kind in {"ClassDecl", "StructDecl"}):
            kind = supported[node.kind]
            name = token_value(node.first("identifier"))
            if not name and kind == "extension":
                name = spelling(node.first("extendedType") or node.first("targetType"))
            if not name and kind == "main":
                name = "main"
            if name:
                try:
                    begin, end = span(node)
                    params = [{
                        "name": token_value(p.first("identifier")),
                        "type": spelling(p.first("paramType")),
                        "named": bool(p.first("not")),
                    } for p in node.children_named("funcParams")]
                    if name == "init":
                        kind = "constructor"
                    signature = name + ("(" + ",".join(p["type"] for p in params) + ")" if kind in {"method", "constructor", "macro", "main"} else "")
                    identity = (kind, owner, signature, begin)
                    if identity not in seen:
                        seen.add(identity)
                        annotation_nodes = [c for c in node.children if c.kind in {"Annotation", "MacroExpandDecl"} or "annotation" in c.field_name.lower()]
                        annotations = [spelling(c) for c in annotation_nodes]
                        modifiers = [spelling(c) for c in node.children_named("modifiers")]
                        members.append({
                            "local_key": f"{kind}:{begin}:{signature}", "kind": kind, "name": name,
                            "owner": owner, "qualified_name": (owner+"."+signature).strip("."),
                            "signature": signature, "parameters": params,
                            "return_type": spelling(node.first("declType") or node.first("returnType")),
                            "declared_type": spelling(node.first("declType")),
                            "annotations": annotations, "modifiers": modifiers,
                            "header_structure": [
                                {"field": c.field_name, "node_kind": c.kind, "tokens": spelling(c)}
                                for c in node.children
                                if c.kind not in {"Body","Block"} and c.field_name not in {"expr","initializer"}
                            ],
                            "start_line": begin, "end_line": end,
                            "role": "test" if any("Test" in a for a in annotations) else "ordinary",
                            "resolution_note": "std.ast 仅语法结构；未实现仓颉类型/重载/动态调用绑定。",
                        })
                    if kind in containers:
                        next_owners = owners + [name]
                except ValueError as ex:
                    issues.append(str(ex))
            else:
                issues.append(f"未能提取 {node.kind} 的名称，保留原始 AST 供检查")
        if node.kind == "CallExpr":
            try:
                begin, end = span(node)
                expression = spelling(node.first("baseFunc") or node.first("callee") or node)
                references.append({"kind": "call", "name": expression, "expression": expression,
                                   "start_line": begin, "end_line": end, "resolution": "unresolved",
                                   "reason": "仓颉跨文件类型及调用绑定未实现；不可按同名强行关联。"})
            except ValueError as ex:
                issues.append(str(ex))
        if node.kind.startswith("MacroExpand"):
            issues.append("发现宏调用节点：保留语法，不展开宏，宏生成成员需要后续确认。")
        if node.kind.endswith("Decl") and node.kind not in supported:
            issues.append(f"未覆盖的声明节点：{node.kind}")
        for child in node.children:
            visit(child, next_owners, executable_body)

    visit(root, [])
    return {"protocol": "cj-stdast-dump-1.2", "status": "partial" if issues else "parsed",
            "package": package, "imports": imports, "members": members, "references": references,
            "issues": sorted(set(issues)),
            "contains_test_annotations": contains_test_annotations,
            "coverage_note": "AST dump 1.2 归一化尚未在本机 SDK 运行；缺少位置、未知声明和宏均显式报告。"}

