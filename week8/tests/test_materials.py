from pathlib import Path
import json
import sys
import tempfile
import unittest

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "tools"))
import project_materials as tool


class PipelineTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.temp = tempfile.TemporaryDirectory()
        cls.root = Path(cls.temp.name)
        src = cls.root / "source"
        (src / "a/src/main/java").mkdir(parents=True)
        (src / "a/src/test/java").mkdir(parents=True)
        (src / "b").mkdir()
        (src / "pom.xml").write_text('<project><modules><module>a</module><module>b</module></modules></project>')
        (src / "a/pom.xml").write_text('<project><dependencies><dependency><groupId>x</groupId><artifactId>y</artifactId></dependency></dependencies></project>')
        (src / "a/src/main/java/Box.java").write_text('class Box { int n; int get(){return n;} }')
        (src / "a/src/test/java/BoxTest.java").write_text('class BoxTest { @Test void check(){} }')
        (src / "b/build.gradle").write_text('// dynamic configuration')
        (src / ".env").write_text('SECRET=not-an-input')
        (src / "target").mkdir(); (src / "target/ignored.txt").write_text('generated')
        cls.scan = cls.root / "scan"
        tool.scan(src, cls.scan)

    @classmethod
    def tearDownClass(cls): cls.temp.cleanup()

    def out(self, name):
        return self.root / (self.id().split('.')[-1] + '-' + name)


    def test_modules_ast_and_exclusions(self):
        self.assertEqual(tool.verify(self.scan)['parser']['status'], 'AVAILABLE')
        self.assertEqual(len(tool.load(self.scan / 'project.json')['modules']), 3)
        self.assertTrue(any(s['name'] == 'check()' for s in tool.load(self.scan / 'symbols.json')))
        self.assertFalse((self.scan / 'snapshots/.env').exists())
        self.assertFalse((self.scan / 'snapshots/target/ignored.txt').exists())
        self.assertTrue(any(i['code'] == 'GRADLE_STATIC_ONLY' for i in tool.load(self.scan / 'issues.json')))

    def test_packet_complete_text(self):
        out = self.out('pack'); tool.packet(self.scan, out, 256)
        parts = tool.load(out / 'packet_manifest.json')['parts']
        target = 'file:a/src/main/java/Box.java'
        text = ''.join(tool.load(out / p['path'])['text'] for p in parts if p['file'] == target)
        self.assertEqual(text, (self.scan / 'snapshots/a/src/main/java/Box.java').read_text())





    def test_missing_jdk_preserves_inventory(self):
        out = self.out('no-jdk')
        tool.scan(self.root / 'source', out, javac=str(self.root / 'absent-javac'))
        self.assertEqual(tool.verify(out)['parser']['status'], 'INCOMPLETE')
        self.assertTrue(any(f.get('parse_status') == 'not_parsed' for f in tool.load(out / 'files.json')))

    def test_syntax_error_preserves_original(self):
        src = self.out('broken'); src.mkdir()
        raw = 'class Broken { void x( { }'.encode()
        (src / 'Broken.java').write_bytes(raw)
        out = self.out('syntax'); tool.scan(src, out)
        self.assertEqual((out / 'snapshots/Broken.java').read_bytes(), raw)
        self.assertEqual(tool.load(out / 'files.json')[0]['parse_status'], 'partial')
        self.assertTrue(any(i['code'] == 'JAVA_SYNTAX_ERROR' for i in tool.load(out / 'issues.json')))


    def test_tampered_snapshot_rejected(self):
        import shutil
        changed = self.out('copy'); shutil.copytree(self.scan, changed)
        (changed / 'snapshots/a/src/main/java/Box.java').write_text('changed')
        with self.assertRaisesRegex(ValueError, '已变化'): tool.packet(changed, self.out('pack'))

    def test_output_inside_input_and_overwrite_rejected(self):
        with self.assertRaises(ValueError): tool.scan(self.root / 'source', self.root / 'source/new')
        with self.assertRaises(ValueError): tool.packet(self.scan, self.scan)


if __name__ == '__main__': unittest.main()
