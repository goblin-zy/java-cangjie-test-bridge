from __future__ import annotations

import hashlib
import json
import os
import subprocess
from pathlib import Path

TOOL_ROOT = Path(__file__).resolve().parents[2]

def digest(value: str | bytes) -> str:
    data = value.encode("utf-8") if isinstance(value, str) else value
    return hashlib.sha256(data).hexdigest()

def stable_id(*parts: object) -> str:
    return digest(json.dumps(parts, ensure_ascii=False, sort_keys=True))[:24]

def read_json(path: Path):
    return json.loads(path.read_text(encoding="utf-8-sig"))

def write_json(path: Path, value, *, overwrite: bool = False):
    if path.exists() and not overwrite:
        raise FileExistsError(f"文件已存在，未覆盖：{path}")
    path.parent.mkdir(parents=True, exist_ok=True)
    temp = path.with_name(path.name + ".tmp")
    temp.write_text(json.dumps(value, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    os.replace(temp, path)

def run(args: list[str], *, timeout: int = 120, cwd: Path | None = None):
    result = subprocess.run(args, capture_output=True, text=True, encoding="utf-8",
                            errors="replace", timeout=timeout, cwd=cwd, shell=False)
    if result.returncode:
        raise RuntimeError(f"命令失败({result.returncode}): {args[0]}\n{result.stderr[-5000:]}\n{result.stdout[-1000:]}")
    return result

def load_config(path: Path):
    from .models import ProjectConfig
    config = ProjectConfig.model_validate(read_json(path))
    base = path.resolve().parent
    def absolute(p: str):
        pp = Path(p).expanduser()
        return str((base / pp).resolve() if not pp.is_absolute() else pp.resolve())
    for source in config.sources:
        source.path = absolute(source.path)
    config.output_dir = absolute(config.output_dir)
    p = config.parsers
    p.java_source_roots = [absolute(s) for s in p.java_source_roots]
    p.java_classpath = [absolute(s) for s in p.java_classpath]
    if p.cangjie_helper:
        p.cangjie_helper = absolute(p.cangjie_helper)
    # Executables are PATH commands or explicit paths, never shell expressions.
    return config

