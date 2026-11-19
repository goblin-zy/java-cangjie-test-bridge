import json
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest

TOOL = Path(__file__).with_name("fragment_tool.py")


class WorkflowTest(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory(dir=Path.cwd())
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)
        self.project = self.root / "project"
        self.project.mkdir()
        source = self.project / "T.java"
        source.write_text("class T {}", encoding="utf-8")
        self.run_dir = self.root / "output"
        self.put("translation_config.json", {"project_root": str(self.project),
                 "output_dir": str(self.run_dir), "test_files": ["T.java"]})
        self.put("02-java-skeleton/members.json", {
            "input_root": str(self.project), "files": [{"source_file": "T.java"}],
            "members": [{"id": "T.java::T#test()", "kind": "method", "role": "test",
                         "source_location": {"file": "original/T.java"},
                         "original_body": "{ assertTrue(true); }"}]})
        self.put("05-cangjie-skeleton/member_mapping.json", [{
            "source_members_file": "02-java-skeleton/members.json", "source_member_id": "T.java::T#test()",
            "target_file": "T.cj", "target_member": "test", "target_signature": "func test(): Unit",
            "status": "mapped", "fill_slot": "body", "slot_id": "T_test"}])
        self.skeleton = self.run_dir / "05-cangjie-skeleton/T.cj"
        self.skeleton.write_text('package t\n\nfunc test(): Unit {\n    /* FRAGMENT_BEGIN:T_test */\n    throw Exception("SKELETON_PLACEHOLDER")\n    /* FRAGMENT_END:T_test */\n}\n', encoding="utf-8")

    def put(self, relative, value):
        path = self.run_dir / relative
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(json.dumps(value), encoding="utf-8")
        return path

    def invoke(self, command, *args, ok=True):
        result = subprocess.run([sys.executable, str(TOOL), "--run", str(self.run_dir),
                                 command, *map(str, args)], capture_output=True, encoding="utf-8")
        self.assertEqual(result.returncode == 0, ok, result.stderr)
        return json.loads(result.stdout) if ok else result.stderr

    def prepare_task(self):
        self.invoke("plan")
        review = self.put("review.json", {"T_test": {"refs": [
            {"file": "review-data.json", "pointer": "/records/0", "purpose": "样例上下文"}]}})
        self.put("review-data.json", {"records": [{"content": "fixture"}]})
        self.invoke("review", review)
        return self.invoke("next")

    def test_complete_and_repeat(self):
        packet = self.prepare_task()
        self.assertIn("fixture", Path(packet["packet"]).read_text(encoding="utf-8"))
        result = self.put("result.json", {"task_id": "T_test", "packet_sha256": packet["packet_sha256"],
                          "code": "@Assert(true)", "imports": ["std.unittest.*"]})
        self.invoke("apply", result)
        self.invoke("apply", result)
        self.assertEqual(self.invoke("next")["status"], "complete")
        self.assertEqual(self.invoke("finalize")["status"], "complete")
        output = (self.run_dir / "07-fragment-translation/test/T.cj").read_text(encoding="utf-8")
        self.assertIn("import std.unittest.*", output)
        self.assertIn("@Assert(true)", output)
        self.assertNotIn("PLACEHOLDER", output)
        self.assertIn("PLACEHOLDER", self.skeleton.read_text(encoding="utf-8"))

    def test_stale_result_and_partial_finalization(self):
        self.prepare_task()
        bad = self.put("bad.json", {"task_id": "T_test", "packet_sha256": "stale", "code": "test"})
        self.invoke("apply", bad, ok=False)
        self.invoke("block", "T_test", "missing dependency")
        self.assertEqual(self.invoke("next")["status"], "blocked")
        self.assertEqual(self.invoke("finalize")["status"], "partial")
        self.assertFalse((self.run_dir / "07-fragment-translation/test/T.cj").exists())

    def test_reject_duplicate_slots(self):
        self.skeleton.write_text(self.skeleton.read_text(encoding="utf-8") * 2, encoding="utf-8")
        self.assertIn("T_test", self.invoke("plan", ok=False))


if __name__ == "__main__":
    unittest.main()
