"""历史证据源码位置读取兼容模块；当前查找工具位于week7/context-lookup。"""
from pathlib import Path

def source_text(path, location):
    # Upstream offsets are Java UTF-16 units, not Python character offsets.
    text = Path(path).read_bytes().decode("utf-8")
    raw = text.encode("utf-16-le")
    start = location["start_offset_utf16"] * 2
    end = location["end_offset_utf16_exclusive"] * 2
    if not 0 <= start <= end <= len(raw):
        raise ValueError("Invalid upstream UTF-16 source range")
    return raw[start:end].decode("utf-16-le")
