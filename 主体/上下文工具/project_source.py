"""直接接收 Java 项目，冻结原文；不再读取预处理配置或调用预处理程序。"""
import base64
from collections import Counter
from pathlib import Path
import shutil

from common import identity, issue, load, safe_path, save, sha
from layout import discover, file_role, inventory_paths, matched


def scan_project(project_root, output, *, business_roots=None, test_roots=None,
                 support_roots=None, resource_roots=None, test_scope=(), exclude=()):
    """发现目录→判定角色→原字节复制→摘要核对，返回可供解析的本轮源码快照。

    root 参数是相对项目的目录；test_scope 是相对项目路径的 glob，可重复。
    自动发现只理解常规目录与字面 Maven 声明，不执行 Maven/Gradle。
    """
    source = Path(project_root).resolve()
    out = Path(output).resolve()
    if not source.is_dir():
        raise ValueError("项目目录不存在")
    if out.exists() or out.is_relative_to(source) or source.is_relative_to(out):
        raise ValueError("输出必须是项目之外的新目录，二者不能相互包含")
    names, omissions = inventory_paths(source, exclude, resource_roots or ())
    explicit = {"business": business_roots, "test": test_roots,
                "support": support_roots, "resource": resource_roots}
    layout, problems = discover(source, names, explicit)
    # 声明的资源中可能有名为 build/target 的测试数据，不能误当构建产物删除。
    names, omissions = inventory_paths(source, exclude, layout["roots"]["resource"])
    out.mkdir(parents=True)
    try:
        (out / "source").mkdir()
        records = []
        for name in names:
            original = safe_path(source, name)
            target = safe_path(out / "source", name)
            target.parent.mkdir(parents=True, exist_ok=True)
            before = sha(original)
            shutil.copyfile(original, target)
            if sha(target) != before or sha(original) != before:
                raise ValueError("复制期间项目文件发生变化: " + name)
            role = file_role(name, layout)
            if role == "unclassified_java":
                role = "support_source"
                problems.append(issue("SOURCE_ROLE_NOT_DECLARED", "按辅助源码分析；请按需显式声明源码根", file=name))
            records.append({"file": name, "source_role": role,
                            "parse_input": role in {"business_source", "test_source", "support_source"},
                            "sha256": before, "size": target.stat().st_size})
        # 复制后再枚举，至少阻止复制期间新增/移除文件造成静默缺项。
        after, _ = inventory_paths(source, exclude, layout["roots"]["resource"])
        if after != names or any(sha(safe_path(source, r["file"])) != r["sha256"] for r in records):
            raise ValueError("扫描期间项目发生变化，请在源码稳定后重试")
        selected = [r["file"] for r in records if r["source_role"] == "test_source" and r["parse_input"]
                    and (not test_scope or matched(r["file"], test_scope))]
        if test_scope and not selected:
            raise ValueError("test_scope 没有匹配到测试源码")
        if not selected:
            problems.append(issue("NO_SELECTED_TEST_FILES", "未识别测试文件，请用 --test-root 指定目录"))
        scope = {"source_roots": {k: layout["roots"][k] for k in ("business", "test", "support")},
                 "filtered_resources": layout.get("filtered_resources", []),
                 "resource_roots": layout["roots"]["resource"], "selected_test_files": selected,
                 "test_scope": list(test_scope), "build_declarations": layout["build_declarations"]}
        snapshot = identity([{k: r[k] for k in ("file", "sha256", "size")} for r in records])
        value = {"schema_version": "context-source-2.0", "project_root": "source", "snapshot_id": snapshot,
                 "inventory": records, "scope": scope, "issues": omissions + problems,
                 "origin": str(source), "transformation": "IDENTITY_ONLY"}
        save(out / "source_manifest.json", value)
        return ProjectSource(out / "source_manifest.json")
    except Exception as exc:
        save(out / "FAILED.json", {"error": str(exc)})
        raise


class ProjectSource:
    """统一源码读取接口：构建时和查询时都只读取本轮 source/ 副本。"""

    def __init__(self, manifest):
        self.manifest_path = Path(manifest).resolve()
        self.root = self.manifest_path.parent
        value = load(self.manifest_path)
        if value["schema_version"] != "context-source-2.0" or value["transformation"] != "IDENTITY_ONLY":
            raise ValueError("不支持的源码快照格式")
        self.project = safe_path(self.root, value["project_root"])
        self.scope = value["scope"]
        self.snapshot_id = value["snapshot_id"]
        self.files = {r["file"]: r for r in value["inventory"]}
        self.issues = value["issues"]
        if len(self.files) != len(value["inventory"]):
            raise ValueError("源码清单包含重复路径")
        expected = identity([{k: r[k] for k in ("file", "sha256", "size")} for r in value["inventory"]])
        if expected != self.snapshot_id:
            raise ValueError("源码快照身份不一致")
        # 每次打开索引核对整个快照；read 再核对具体文件，避免会话期间变化。
        names, links = inventory_paths(self.project, (), self.scope["resource_roots"])
        if set(names) != set(self.files) or links:
            raise ValueError("源码文件集合或链接状态发生变化")
        for name, record in self.files.items():
            path = safe_path(self.project, name)
            if not path.is_file() or path.stat().st_size != record["size"] or sha(path) != record["sha256"]:
                raise ValueError("冻结原件变化: " + name)

    def summary(self):
        """兼容上下文组装需要的缺项统计，不暴露旧预处理协议。"""
        return {"snapshot_id": self.snapshot_id, "issue_counts": dict(Counter(r["kind"] for r in self.issues))}

    def read_file(self, relative, max_bytes=262144):
        """返回 UTF-8 文本或二进制 base64；预算为 0 时返回缺项，不抛异常。"""
        if max_bytes < 0:
            raise ValueError("max_bytes 不能为负数")
        if relative not in self.files:
            raise ValueError("文件不在源码快照内: " + relative)
        record = self.files[relative]
        data = safe_path(self.project, relative).read_bytes()
        import hashlib
        if hashlib.sha256(data).hexdigest() != record["sha256"]:
            raise ValueError("冻结原件变化: " + relative)
        value = {**record, "snapshot_id": self.snapshot_id}
        if len(data) > max_bytes:
            return {**value, "status": "CONTENT_NOT_INCLUDED_SIZE_LIMIT", "content": None, "max_bytes": max_bytes}
        try:
            content, encoding = data.decode("utf-8"), "utf-8"
        except UnicodeDecodeError:
            content, encoding = base64.b64encode(data).decode("ascii"), "base64"
        return {**value, "status": "CONTENT_INCLUDED", "content": content, "encoding": encoding}
