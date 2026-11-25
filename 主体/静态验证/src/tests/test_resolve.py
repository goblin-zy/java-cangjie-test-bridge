from pathlib import Path
import sys
import tempfile
import unittest

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from locating import resolve
from workflow import alignment, folder, put, read, save, sha, stage


class ResolveTests(unittest.TestCase):
    def setUp(self):
        temporary = tempfile.TemporaryDirectory()
        self.addCleanup(temporary.cleanup)
        self.run_dir = Path(temporary.name)
        self.source = "\n".join(
            f"@TestCase\nfunc {name}(): Unit {{\n}}" for name in ("first", "other", "last"))
        raw = self.source.encode()
        self.path = stage(self.run_dir, 1) / "alignment.json"
        put(self.path.parent / "example.cj", raw)
        save(self.path, {"files": {"cangjie": "example.cj"}, "units": [
            {"id": "U1", "name": "split", "cangjie": None, "candidates": [[1, 3], [7, 9]]},
            {"id": "U2", "name": "other", "cangjie": [4, 6]},
        ]})
        folder(self.run_dir, "java").mkdir(parents=True)
        target = folder(self.run_dir, "cangjie")
        put(target / "inputs/example.cj", raw)
        save(target / "materials_cangjie.json", [{"sha256": sha(raw)}])
        self.task = target / "task_cangjie.json"
        save(self.task, {"source": "inputs/example.cj", "units": [{"id": "U1", "lines": None}]})

    def submit(self, *spans):
        draft = self.run_dir / "draft.json"
        lines = self.source.splitlines()
        save(draft, {"id": "U1", "reason": "split 分解为多个声明；other 已由另一个单元占用",
                     "cangjie": [{"start": a, "end": b, "quote": "\n".join(lines[a-1:b])}
                                 for a, b in spans]})
        return resolve(self.run_dir, draft)

    def test_nonadjacent_methods_keep_gap_for_other_unit(self):
        self.submit((1, 3), (7, 9))
        first, other = alignment(self.run_dir)["units"]
        self.assertEqual(first["cangjie_ranges"], [[1, 3], [7, 9]])
        self.assertEqual(first["cangjie"], [1, 3])
        self.assertEqual(other["cangjie"], [4, 6])
        self.assertEqual(read(self.task)["units"][0],
                         {"id": "U1", "lines": [1, 3], "ranges": [[1, 3], [7, 9]]})

    def test_rejects_partial_methods_and_overlaps_without_writing(self):
        for spans, error in [([(1, 2)], "完整方法"), ([(1, 3), (1, 3)], "重叠"),
                             ([(1, 3), (4, 6)], "重叠")]:
            with self.subTest(spans=spans):
                before = (self.path.read_bytes(), self.task.read_bytes())
                with self.assertRaisesRegex(ValueError, error):
                    self.submit(*spans)
                self.assertEqual((self.path.read_bytes(), self.task.read_bytes()), before)

    def test_rejects_changes_after_either_side_starts(self):
        for side in ("java", "cangjie"):
            with self.subTest(side=side):
                notes = folder(self.run_dir, side) / f"annotations_{side}.json"
                save(notes, [])
                with self.assertRaisesRegex(ValueError, "标注已开始"):
                    self.submit((1, 3))
                notes.unlink()


if __name__ == "__main__":
    unittest.main()
