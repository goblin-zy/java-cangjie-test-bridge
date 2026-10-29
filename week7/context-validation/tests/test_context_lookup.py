"""Negative-path tests for the source/selection boundary, not translation quality."""
from pathlib import Path
import hashlib
import json
import sys
import tempfile
import unittest

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "tools"))
import context_lookup as tool


class SourceBoundaryTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name).resolve()
        self.repo = self.root / "repo"
        self.index = self.root / "index"
        self.repo.mkdir()
        self.index.mkdir()
        self.text = '// 中文 😀\r\nclass T {\r\n    void check() {}\r\n}\r\n'
        raw = self.text.encode("utf-8")
        (self.repo / "T.java").write_bytes(raw)
        (self.index / "T.java").write_bytes(raw)
        digest = hashlib.sha256(raw).hexdigest()
        source = {"snapshot": "T.java", "repository_path": "T.java", "sha256": digest, "imports": []}
        def entry(symbol, substring, role):
            start = self.text.index(substring)
            location = {"start_offset_utf16": len(self.text[:start].encode("utf-16-le")) // 2, "end_offset_utf16_exclusive": len(self.text[:start + len(substring)].encode("utf-16-le")) // 2, "start_line": 2, "end_line": 2}
            return {"group": "test", "symbol": symbol, "upstream_id": "T.java::" + symbol, "source": source, "content": substring, "upstream": {"role": role, "source_location": location}}
        self.catalog = {"schema_version": "context-catalog-1.0", "files": [source], "members": [entry("T#check()", "void check() {}", "test")], "classes": [entry("T", "class T {\r\n    void check() {}\r\n}", "class")], "limitations": []}
        self.selection = {"schema_version": "context-selection-1.0", "units": [{"target": {"group": "test", "symbol": "T#check()"}, "evidence": []}]}
        self.save()

    def save(self):
        tool.write_json(self.index / "catalog.json", self.catalog)
        tool.write_json(self.root / "selection.json", self.selection)

    def export(self):
        return tool.export_context(self.index / "catalog.json", self.root / "selection.json", self.repo, self.root / "output")

    def test_utf16_offsets_after_chinese_emoji_and_crlf(self):
        self.export()
        result = tool.read_json(self.root / "output/context_01.json")
        self.assertEqual(result["target"]["content"], "void check() {}")
        self.assertEqual((self.root / "output/inputs/T.java").read_bytes(), (self.repo / "T.java").read_bytes())
        markdown = (self.root / "output/context_01.md").read_text(encoding="utf-8")
        self.assertIn(result["original_test_class"]["content"].replace("\r\n", "\n"), markdown)

    def test_changed_live_source_rejected(self):
        (self.repo / "T.java").write_text("class T {}", encoding="utf-8")
        with self.assertRaisesRegex(ValueError, "Stale"):
            self.export()
        self.assertFalse((self.root / "output").exists())

    def test_modified_snapshot_rejected(self):
        (self.index / "T.java").write_text("class T {}", encoding="utf-8")
        with self.assertRaisesRegex(ValueError, "Stale"):
            self.export()

    def test_duplicate_symbol_not_silently_overwritten(self):
        self.catalog["members"].append(self.catalog["members"][0])
        self.save()
        with self.assertRaisesRegex(ValueError, "Ambiguous"):
            self.export()

    def test_unknown_dependency_not_invented(self):
        self.selection["units"][0]["evidence"] = [{"group": "main", "symbol": "Missing#run()", "reason": "need this"}]
        self.save()
        with self.assertRaisesRegex(ValueError, "not found"):
            self.export()

    def test_existing_delivery_not_overwritten(self):
        self.export()
        before = (self.root / "output/context_01.json").read_bytes()
        with self.assertRaisesRegex(ValueError, "new or empty"):
            self.export()
        self.assertEqual((self.root / "output/context_01.json").read_bytes(), before)

    def test_path_escape_rejected(self):
        with self.assertRaisesRegex(ValueError, "escapes"):
            tool.inside(self.repo, "../outside.txt")


if __name__ == "__main__":
    unittest.main()
