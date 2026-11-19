"""SQLite stores full, read-only input snapshots; all evidence queries use that snapshot."""
from __future__ import annotations
import json
import sqlite3
from pathlib import Path
from contextlib import contextmanager

TABLES = ("files", "members", "references", "facts", "candidates", "issues")

@contextmanager
def connect(path: Path, *, readonly: bool = False):
    if readonly:
        db = sqlite3.connect(path.resolve().as_uri() + "?mode=ro", uri=True)
    else:
        path.parent.mkdir(parents=True, exist_ok=True)
        db = sqlite3.connect(path)
    db.row_factory = sqlite3.Row
    try:
        yield db
    finally:
        db.close()

def create(path: Path):
    with connect(path) as db:
        db.execute("CREATE TABLE metadata (key TEXT PRIMARY KEY, value TEXT NOT NULL)")
        for table in TABLES:
            db.execute(f'CREATE TABLE "{table}" (id TEXT PRIMARY KEY, file_id TEXT, module TEXT, name TEXT, data TEXT NOT NULL)')
            db.execute(f'CREATE INDEX "{table}_file" ON "{table}"(file_id)')
            db.execute(f'CREATE INDEX "{table}_module" ON "{table}"(module)')
        db.commit()

def save(path: Path, metadata: dict, records: dict):
    with connect(path) as db:
        for key, value in metadata.items():
            db.execute("INSERT OR REPLACE INTO metadata VALUES (?,?)", (key, json.dumps(value, ensure_ascii=False)))
        for table, rows in records.items():
            if table not in TABLES:
                raise ValueError(table)
            for row in rows:
                db.execute(f'INSERT INTO "{table}" VALUES (?,?,?,?,?)', (
                    row["id"], row.get("file_id"), row.get("module"),
                    row.get("name"), json.dumps(row, ensure_ascii=False)))
        db.commit()

def metadata(path: Path):
    with connect(path, readonly=True) as db:
        return {r["key"]: json.loads(r["value"]) for r in db.execute("SELECT * FROM metadata")}

def records(path: Path, table: str, *, module: str | None = None, file_id: str | None = None):
    if table not in TABLES:
        raise ValueError(table)
    clauses, args = [], []
    if module is not None:
        clauses.append("module=?"); args.append(module)
    if file_id is not None:
        clauses.append("file_id=?"); args.append(file_id)
    query = f'SELECT data FROM "{table}"'
    if clauses:
        query += " WHERE " + " AND ".join(clauses)
    query += " ORDER BY id"
    with connect(path, readonly=True) as db:
        return [json.loads(r[0]) for r in db.execute(query, args)]

def record(path: Path, table: str, identifier: str):
    if table not in TABLES:
        raise ValueError(table)
    with connect(path, readonly=True) as db:
        row = db.execute(f'SELECT data FROM "{table}" WHERE id=?', (identifier,)).fetchone()
    if not row:
        raise KeyError(f"没有找到 {table}: {identifier}")
    return json.loads(row[0])

