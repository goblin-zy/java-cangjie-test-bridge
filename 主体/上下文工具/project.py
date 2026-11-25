"""Local read/query operations over one immutable project schema and frozen input."""
from collections import defaultdict
from datetime import datetime, timezone
from pathlib import Path, PurePosixPath
import json
import posixpath

from common import SCHEMA, load, sha
from project_source import ProjectSource
from common import safe_path


class Project:
    def __init__(self, index):
        """核对索引、快照和依赖摘要，再建立调用者/被调用者的内存反向表。"""
        self.path = Path(index).resolve()
        self.root = self.path.parent
        if (self.root / "FAILED.json").exists():
            raise ValueError("索引有FAILED.json，不能继续使用")
        manifest = load(self.root / "context_manifest.json")
        if manifest["schema_version"] != SCHEMA or manifest["schema_sha256"] != sha(self.path):
            raise ValueError("索引格式或摘要不符")
        self.data = load(self.path)
        if self.data["index_id"] != manifest["index_id"]:
            raise ValueError("索引版本不一致")
        source_manifest = safe_path(self.root, self.data["source_manifest"])
        if sha(source_manifest) != self.data["source_manifest_sha256"]:
            raise ValueError("源码清单已经变化")
        self.input = ProjectSource(source_manifest)
        if self.input.snapshot_id != self.data["snapshot_id"]:
            raise ValueError("索引与源码快照版本不一致")
        self.members = self.data["members"]
        self.types = self.data["types"]
        self.references = self.data["references"]
        self.by_type = defaultdict(list)
        self.by_caller = defaultdict(list)
        self.incoming = defaultdict(list)
        for key, m in self.members.items():
            self.by_type[m.get("owner_type_key")].append(key)
        for key, r in self.references.items():
            self.by_caller[r.get("caller_source_member_key")].append(key)
            for target in r["target_keys"]:
                self.incoming[target].append(key)
        self.artifacts = {}
        for record in self.data.get("java_members", {}).get("tables", []):
            if sha(safe_path(self.root, record["file"])) != record["sha256"]:
                raise ValueError("Java 成员表副本已经变化")
        for record in self.data["backend"].get("project_classpath", []):
            if sha(safe_path(self.root, record["file"])) != record["sha256"]:
                raise ValueError("索引所用外部JAR已经变化")
        for name, record in self.data["artifacts"].items():
            path = safe_path(self.root, record["file"])
            if sha(path) != record["sha256"]:
                raise ValueError("附加资料变化: " + name)
            self.artifacts[name] = load(path)
        self._text = {}

    def log(self, operation, request, result):
        """查询日志只记操作与数量，不把读取到的所有代码重复写进日志。"""
        def count(value):
            return value if isinstance(value, int) else len(value)
        record = {"at": datetime.now(timezone.utc).isoformat(), "index_id": self.data["index_id"],
                  "snapshot_id": self.data["snapshot_id"], "operation": operation, "request": request,
                  "status": result.get("status"), "records": count(result.get("records", [])),
                  "unresolved_count": count(result.get("unresolved", []))}
        with (self.root / "query_log.jsonl").open("a", encoding="utf-8") as stream:
            stream.write(json.dumps(record, ensure_ascii=False) + "\n")

    def overview(self):
        """让 Agent 首先确认任务范围、索引规模、缺项和可用附加材料。"""
        return {"status": "INDEX_READABLE", "index_id": self.data["index_id"],
                "snapshot_id": self.data["snapshot_id"], "summary": self.data["summary"],
                "selected_test_files": self.data["selected_test_files"], "resource_roots": self.data["resource_roots"],
                "input_issues": self.input.summary()["issue_counts"], "semantic_problems": self.data["problems"],
                "artifacts": list(self.artifacts), "limitations": self.data["limitations"],
                "internal_analysis_capabilities": self.data["internal_analysis"]["capabilities"]}

    def search(self, name="", kind="all", offset=0, limit=50):
        """按显示名子串或路径找候选，返回机器 key；同名结果不会强行合并。"""
        if offset < 0 or not 1 <= limit <= 500:
            raise ValueError("offset须非负，limit须为1到500")
        rows = []
        if kind in {"file", "resource", "config"}:
            for file, record in self.input.files.items():
                role = record['source_role']
                if name.casefold() in file.casefold() and (kind == 'file' or kind == 'resource' and role == 'resource' or kind == 'config' and role in {'build_config', 'config'}):
                    rows.append({"file": file, "kind": "file", "source_role": role, "size": record['size'], "sha256": record['sha256']})
        for key, m in [*self.types.items(), *self.members.items()]:
            if name.casefold() not in m["id"].casefold() or (kind != "all" and m["kind"] != kind):
                continue
            rows.append({"key": key, "id": m["id"], "kind": m["kind"], "file": m["file"],
                         "start_line": m["start_line"], "roles": m.get("roles", [])})
        return {"status": "SEARCHED", "total": len(rows), "records": rows[offset:offset + limit],
                "next_offset": offset + limit if offset + limit < len(rows) else None}

    def key(self, value, include_types=True):
        """接受机器 key 或唯一完整显示名；歧义时要求先 search。"""
        available = {**self.members, **(self.types if include_types else {})}
        if value in available:
            return value
        matches = [k for k, node in available.items() if node["id"] == value]
        if len(matches) != 1:
            raise ValueError("标识不存在或不唯一，请先search并使用key: " + json.dumps(matches))
        return matches[0]

    def span(self, file, start, end):
        """校验冻结原件后，按 Java 使用的 UTF-16 下标读取真实源码区间。"""
        path = safe_path(self.input.project, file)
        if sha(path) != self.input.files[file]["sha256"]:
            raise ValueError("冻结原件变化: " + file)
        if file not in self._text:
            self._text[file] = path.read_bytes().decode("utf-8").encode("utf-16-le")
        return self._text[file][start * 2:end * 2].decode("utf-16-le")

    def read(self, value, mode="full", max_chars=30000):
        """读取类型/成员完整原文或签名；超过预算时整段留空并说明原因。"""
        if mode not in {"full", "signature"} or max_chars < 0:
            raise ValueError("无效的读取模式或预算")
        key = self.key(value)
        node = self.members.get(key) or self.types[key]
        # 字段绑定用 VariableDeclarator 的精确位置；阅读时返回完整字段声明，保留类型。
        start = node.get("read_start", node["start"])
        end = node.get("read_end", node["end"])
        if mode == "signature":
            end = node.get("signature_end", node.get("header_end", end))
        content = self.span(node["file"], start, end)
        included = len(content) <= max_chars
        return {"status": "CONTENT_INCLUDED" if included else "CONTENT_NOT_INCLUDED_BUDGET", "id": key,
                "display_id": node["id"], "content_kind": mode, "content": content if included else None,
                "content_chars": len(content), "source": {"file": node["file"], "sha256": self.input.files[node["file"]]["sha256"],
                    "start_line": self.span(node["file"], 0, start).count("\n") + 1,
                    "end_line": self.span(node["file"], 0, end).count("\n") + 1,
                    "start_offset_utf16": start, "end_offset_utf16_exclusive": end},
                "index_id": self.data["index_id"], "snapshot_id": self.data["snapshot_id"]}

    def read_file(self, file, first=None, last=None, max_chars=30000):
        """补查完整配置/资源文件，或按行查看源码；不会执行文件内容。"""
        if max_chars < 0:
            raise ValueError("读取预算不能为负数")
        record = self.input.files.get(file)
        if not record:
            raise ValueError("文件不在源码快照内")
        if first is None and last is None:
            result = self.input.read_file(file, max_bytes=max_chars)
            return {**result, "index_id": self.data["index_id"]}
        if first is None or last is None or first < 1 or last < first:
            raise ValueError("必须提供有效的起止行号")
        raw = safe_path(self.input.project, file).read_bytes()
        if sha(safe_path(self.input.project, file)) != record["sha256"]:
            raise ValueError("冻结原件变化")
        lines = raw.decode("utf-8").splitlines(keepends=True)
        if last > len(lines):
            raise ValueError("行号超过文件范围")
        content = "".join(lines[first - 1:last])
        return {"status": "CONTENT_INCLUDED" if len(content) <= max_chars else "CONTENT_NOT_INCLUDED_BUDGET",
                "content": content if len(content) <= max_chars else None, "content_chars": len(content),
                "source": {"file": file, "sha256": record["sha256"], "start_line": first, "end_line": last},
                "index_id": self.data["index_id"], "snapshot_id": self.data["snapshot_id"]}

    def resolve(self, reference):
        """返回构建时保存的绑定和原始表达式；查询阶段不重复调用 resolve()。"""
        if reference not in self.references:
            raise ValueError("引用不存在，请通过calls或references查询取得reference_key")
        node = self.references[reference]
        return {"status": node["resolution"], "reference": node,
                "expression": self.span(node["file"], node["start"], node["end"]),
                "targets": [{"key": k, "id": self.members[k]["id"], "file": self.members[k]["file"]} for k in node["target_keys"]],
                "index_id": self.data["index_id"], "snapshot_id": self.data["snapshot_id"]}

    def related(self, member, direction="outgoing", offset=0, limit=50):
        """从 by_caller 或 incoming 表取边，分页返回调用/字段引用的证据。"""
        if direction not in {"outgoing", "incoming"} or offset < 0 or not 1 <= limit <= 500:
            raise ValueError("无效方向或分页参数")
        key = self.key(member, include_types=False)
        keys = self.by_caller[key] if direction == "outgoing" else self.incoming[key]
        return {"status": "QUERIED", "member_key": key, "total": len(keys),
                "records": [self.resolve(k) for k in keys[offset:offset + limit]],
                "next_offset": offset + limit if offset + limit < len(keys) else None}

    def hierarchy(self, key):
        """按父类在前的顺序遍历已绑定继承关系；循环及未绑定父类单独记录。"""
        result, issues, active, seen = [], [], set(), set()
        def visit(current):
            if current in active:
                issues.append({"kind": "INHERITANCE_CYCLE", "type": current})
                return
            if current in seen:
                return
            seen.add(current); active.add(current)
            node = self.types[current]
            for ambiguity in node.get("parent_ambiguities", []):
                issues.append({"kind": "PARENT_AMBIGUOUS", "type": current, **ambiguity})
            source_parent = self.data.get("java_members", {}).get("test_parent_edges", {}).get(current)
            parents = node["parents"] or ([source_parent] if source_parent else [])
            for parent in parents:
                visit(parent)
            if source_parent and not node["parents"]:
                issues.append({"kind": "SOURCE_TEST_INHERITANCE", "type": current,
                               "basis": "HASH_CHECKED_SOURCE_NOT_RUNTIME_DISCOVERY"})
            if node.get("extends") and node["parent_resolution"] != "SYMBOL_SOLVER":
                issues.append({"kind": "PARENT_NOT_BOUND", "type": current, "candidates": node.get("parent_candidates", [])})
            result.append(current); active.remove(current)
        visit(key)
        return result, issues

    def test_target(self, target):
        """确定所选测试、有效覆盖方法和生命周期；参数不同的方法不互相遮蔽。"""
        tests = {"test", "parameterized_test", "repeated_test", "dynamic_test", "template_test", "test_junit3"}
        method = None
        if target in self.members:
            method = target
            type_key = self.members[method]["owner_type_key"]
        else:
            type_name, separator, signature = target.partition("#")
            if separator:
                matches = [k for k, n in self.types.items() if n["id"] == type_name]
            elif target in self.types:
                matches = [target]
            else:
                normalized = target.replace("\\", "/")
                matches = [k for k, n in self.types.items() if n["id"] == target or n["file"] == normalized]
                if len(matches) > 1:
                    matches = [k for k in matches if any(tests.intersection(self.members[m]["roles"]) for m in self.by_type[k])]
            if len(matches) != 1:
                raise ValueError("测试类型不存在或不唯一: " + json.dumps(matches))
            type_key = matches[0]
            if separator:
                hierarchy, _ = self.hierarchy(type_key)
                found = [k for t in reversed(hierarchy) for k in self.by_type[t] if self.members[k]["id"].split("#", 1)[-1] == signature]
                if not found:
                    raise ValueError("测试方法不存在")
                method = found[0]
        if self.types[type_key]["file"] not in self.data["selected_test_files"]:
            raise ValueError("测试类不在本轮明确的任务范围内")
        hierarchy, issues = self.hierarchy(type_key)
        effective = {}
        for t in hierarchy:
            for k in self.by_type[t]:
                m = self.members[k]
                if m["kind"] != "method":
                    continue
                # Include parameter types, so setup(int) never hides setup().
                signature = (m.get("resolved_signature") or m["id"].replace("#", ".")).split("(", 1)
                override = (m["name"], signature[1] if len(signature) > 1 else "")
                if "private" in m.get("modifiers", []):
                    override = (k, "private")
                effective[override] = k
        selected = [k for k in effective.values() if tests.intersection(self.members[k]["roles"])]
        invocation_rows = [r for r in self.data.get("java_members", {}).get("test_invocations", []) if r["execution_type_key"] == type_key]
        if invocation_rows:
            selected = list(dict.fromkeys(r["source_member_key"] for r in invocation_rows))
        if method is not None:
            selected = [method] if method in selected else []
        if not selected:
            raise ValueError("未识别到所选JUnit测试；注解/继承存在缺项时请先补充材料")
        lifecycle = [k for k in effective.values() if set(self.members[k]["roles"]).intersection({"setup", "cleanup", "class_setup", "class_cleanup"})]
        return type_key, selected, lifecycle, hierarchy, issues

    def resources(self, reference, target_type=None, max_bytes=262144):
        """根据已确认的资源 API、字面量/常量字段和包锚点定位资源，不猜工作目录。"""
        r = self.references[reference]
        owner, name = r.get("target_owner"), r["name"]
        loader = owner == "java.lang.ClassLoader"
        class_api = owner == "java.lang.Class"
        filesystem = owner in {"java.nio.file.Path", "java.nio.file.Paths", "java.io.File", "java.io.FileInputStream", "java.io.FileReader"}
        if not ((loader or class_api) and name in {"getResource", "getResourceAsStream"}) and not filesystem:
            return None
        value, basis = r.get("literal_path"), "DIRECT_STRING_LITERAL"
        if value is None and r.get("arguments"):
            argument = r["arguments"][0]
            matches = []
            for ref in self.by_caller.get(r["caller_source_member_key"], []):
                field = self.references[ref]
                if field["kind"] != "call" and self.span(field["file"], field["start"], field["end"]) == argument:
                    matches.extend(field["target_keys"])
            constants = [self.members[k] for k in set(matches) if self.members[k]["kind"] == "field" and "final" in self.members[k]["modifiers"]]
            if len(constants) == 1:
                try:
                    value = json.loads(constants[0]["initializer"])
                    basis = "FINAL_FIELD_STRING_LITERAL"
                except (ValueError, TypeError):
                    pass
        if not isinstance(value, str):
            return {"status": "unresolved", "kind": "RESOURCE_PATH_NOT_LITERAL", "reference": reference}
        if "\x00" in value or ":" in value or "\\" in value:
            return {"status": "unresolved", "kind": "RESOURCE_PATH_NOT_SUPPORTED", "reference": reference, "path": value}
        if filesystem:
            return {"status": "unresolved", "kind": "FILESYSTEM_WORKING_DIRECTORY_NOT_SPECIFIED", "reference": reference, "path": value}
        anchored = value.lstrip("/")
        if loader and value.startswith("/"):
            return {"status": "unresolved", "kind": "CLASSLOADER_PATH_MUST_BE_ROOT_RELATIVE_WITHOUT_SLASH", "reference": reference, "path": value}
        if class_api and not value.startswith("/"):
            caller = self.members.get(r["caller_source_member_key"], {})
            anchor = r.get("class_resource_package")
            if anchor is None and r.get("self_get_class"):
                cls = self.types[target_type] if target_type else self.types.get(caller.get("owner_type_key"), {})
                anchor = self.data["files"].get(cls.get("file"), {}).get("package")
            if anchor is None:
                return {"status": "unresolved", "kind": "CLASS_RESOURCE_ANCHOR_NOT_ESTABLISHED", "reference": reference, "path": value}
            package = anchor
            anchored = package.replace(".", "/") + "/" + value if package else value
        anchored = posixpath.normpath(anchored)
        if anchored == ".." or anchored.startswith("../") or anchored.startswith("/"):
            return {"status": "unresolved", "kind": "RESOURCE_OUTSIDE_ROOT", "reference": reference}
        candidates = [str(PurePosixPath(root) / anchored) for root in self.data["resource_roots"]
                      if str(PurePosixPath(root) / anchored) in self.input.files]
        candidates.extend(entry['file'] for entry in self.input.scope.get('filtered_resources', [])
                          if entry['classpath_path'] == anchored)
        candidates = list(dict.fromkeys(candidates))
        if len(candidates) != 1:
            return {"status": "ambiguous" if candidates else "unresolved", "kind": "RESOURCE_NOT_UNIQUE",
                    "reference": reference, "path": value, "candidates": candidates}
        content = self.input.read_file(candidates[0], max_bytes)
        return {"status": "located", "reference": reference, "path_basis": basis,
                "api_owner": owner, "resource": content}

    def materials(self, query="", kind="materials", limit=20):
        """查询其他模块已提供的 JSON 条目，原样保留 pending 等状态，不代替材料生成。"""
        if not 1 <= limit <= 200:
            raise ValueError("limit须为1到200")
        data = self.artifacts.get(kind)
        if data is None:
            return {"status": "NOT_PROVIDED", "artifact": kind, "records": []}
        rows = data if isinstance(data, list) else data.get("items", data.get("rules")) if isinstance(data, dict) else None
        if not isinstance(rows, list):
            raise ValueError("附加JSON缺少可查询的条目数组")
        hits = [(i, r) for i, r in enumerate(rows) if query.casefold() in json.dumps(r, ensure_ascii=False).casefold()]
        artifact = self.data["artifacts"][kind]
        return {"status": "QUERIED", "artifact": kind, "total": len(hits), "records": [
            {"item": r, "source": {**artifact, "item_index": i},
             "schema_version": data.get("schema_version") if isinstance(data, dict) else None} for i, r in hits[:limit]],
            "remaining": max(0, len(hits) - limit)}
