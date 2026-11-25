from pathlib import Path
import hashlib
import json

VERSION = "java-test-context-second-edition"
SCHEMA = "java-test-context-2.1"


def load(path):
    return json.loads(Path(path).read_text(encoding="utf-8-sig"))


def save(path, value):
    path = Path(path)
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(value, ensure_ascii=True, indent=2) + "\n", encoding="utf-8")


def sha(path):
    result = hashlib.sha256()
    with Path(path).open("rb") as stream:
        for chunk in iter(lambda: stream.read(1024 * 1024), b""):
            result.update(chunk)
    return result.hexdigest()


def identity(value):
    return hashlib.sha256(json.dumps(value, sort_keys=True, ensure_ascii=False).encode()).hexdigest()


def write_new(path, value):
    if Path(path).exists():
        raise ValueError("输出已存在，请换新目录/文件: " + str(path))
    save(path, value)


def safe_path(root, relative, *, allow_root=False):
    """把交付包内相对路径变成绝对路径；拒绝越界、软链接及 Windows 联接。"""
    root = Path(root).resolve()
    if not isinstance(relative, str) or not relative:
        raise ValueError("路径必须是非空字符串")
    part = Path(relative)
    if part.is_absolute() or part.drive or ".." in part.parts:
        raise ValueError("必须使用包内相对路径: " + relative)
    path = root / part
    for component in [path, *path.parents]:
        if component == root:
            break
        if component.is_symlink() or component.is_junction():
            raise ValueError("不能读取链接路径: " + relative)
    path = path.resolve()
    if not path.is_relative_to(root) or (path == root and not allow_root):
        raise ValueError("路径越界: " + relative)
    return path


def issue(kind, message, *, file=None, severity="warning", **details):
    """统一记录缺项；发现问题不代表已经解决问题。"""
    value = {"kind": kind, "message": message, "severity": severity, **details}
    if file is not None:
        value["file"] = file
    return value
