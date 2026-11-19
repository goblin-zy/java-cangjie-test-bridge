"""Read declarations, never execute Maven/Gradle/CJPM/shell scripts."""
from __future__ import annotations
import json
import re
import tomllib
import xml.etree.ElementTree as ET
from xml.parsers import expat
from pathlib import Path

def extract_config(path: str, text: str):
    facts, problems = [], []
    name = Path(path).name.lower()
    def add(key, value, line=1, note="", end_line=None):
        facts.append({"name": key, "value": value, "start_line": line,
                      "end_line": end_line or line, "note": note})
    def line_for(needle):
        return next((i for i, s in enumerate(text.splitlines(), 1) if needle in s), 1)
    if name == "pom.xml":
        if "<!DOCTYPE" in text.upper() or "<!ENTITY" in text.upper():
            return [], ["POM 含 DOCTYPE/ENTITY，不解析；请人工核对"]
        doc = ET.fromstring(text)
        # Pair the structural XML tree with Expat element ranges; no regex over XML.
        xml_parser=expat.ParserCreate(namespace_separator="|")
        located, stack=[],[]
        def begin_element(name, attrs):
            location={"name":name.rsplit("|",1)[-1],"start":xml_parser.CurrentLineNumber}
            located.append(location);stack.append(location)
        def end_element(name):
            stack.pop()["end"]=xml_parser.CurrentLineNumber
        xml_parser.StartElementHandler=begin_element
        xml_parser.EndElementHandler=end_element
        xml_parser.Parse(text, True)
        elements=list(doc.iter())
        if len(elements)!=len(located):
            raise ValueError("XML节点与位置映射不一致")
        locations={id(node):position for node,position in zip(elements,located)}
        def element_fact(key, value, node, note=""):
            location=locations[id(node)]
            add(key,value,location["start"],note,location["end"])
        def tag(el):
            return el.tag.rsplit("}", 1)[-1]
        def child(el, key):
            return next((c for c in el if tag(c) == key), None)
        def val(el, key):
            n = child(el, key)
            return (n.text or "").strip() if n is not None else ""
        props_node = child(doc, "properties")
        props = {tag(c): (c.text or "").strip() for c in props_node} if props_node is not None else {}
        for key in ("groupId", "artifactId", "version", "packaging"):
            value = val(doc, key)
            if value:
                element_fact("maven." + key, value, child(doc,key))
        for key, value in props.items():
            element_fact("maven.properties." + key, value, child(props_node,key))
        def expand(s):
            for _ in range(10):
                new = re.sub(r"\$\{([^}]+)\}", lambda m: props.get(m[1], m[0]), s)
                if new == s: break
                s = new
            return s
        for deps in doc.iter():
            if tag(deps) != "dependencies": continue
            for dep in deps:
                if tag(dep) != "dependency": continue
                value = {key: val(dep, key) for key in ("groupId","artifactId","version","scope","type","classifier")}
                value["resolved_local_version"] = expand(value["version"])
                artifact = value["artifactId"]
                element_fact("maven.dependency", value, dep,
                    "声明位置；dependencyManagement/父POM/profile等生效条件需额外核对，不是有效依赖树。")
        for plugin in doc.iter():
            if tag(plugin) == "plugin":
                element_fact("maven.plugin", {k:val(plugin,k) for k in ("groupId","artifactId","version")}, plugin,
                    "仅配置声明，未执行插件")
        problems.append("POM 仅提取声明和当前文件属性替换，未计算继承、profiles或有效classpath；请配置 Java source_roots/classpath。")
    elif name in {"cjpm.toml", "pyproject.toml"} or name.endswith(".toml"):
        data = tomllib.loads(text)
        def flatten(prefix, value):
            if isinstance(value, dict):
                for key, v in value.items(): flatten(prefix+[str(key)],v)
            else:
                key = ".".join(prefix)
                add("toml."+key, value, line_for(prefix[-1]) if prefix else 1, "键名定位为上下文行，精确表路径见name")
        flatten([], data)
    elif name.endswith(".json"):
        data = json.loads(text)
        if name in {"package.json", "config.json"}:
            for key in ("name", "version", "engines", "dependencies", "devDependencies", "scripts"):
                if key in data: add("json."+key, data[key], line_for('"'+key+'"'), "只读取，不执行 scripts")
    elif name in {"build.gradle", "build.gradle.kts", "settings.gradle", "settings.gradle.kts"}:
        problems.append("Gradle 为可执行构建脚本，本工具不运行；保留内容，由Codex整理声明，不能视为有效构建模型。")
    return facts, problems

