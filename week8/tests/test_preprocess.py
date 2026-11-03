from pathlib import Path
import json
import sys
import tempfile
import unittest
sys.path.insert(0,str(Path(__file__).resolve().parents[1]/'tools'))
import preprocess
import project_materials as facts


class PreprocessStepTests(unittest.TestCase):
    def setUp(self):
        self.tmp=tempfile.TemporaryDirectory();self.addCleanup(self.tmp.cleanup)
        self.root=Path(self.tmp.name);self.src=self.root/'repo';self.src.mkdir()
        (self.src/'README.md').write_text('Example repository')
        (self.src/'pom.xml').write_text('<project/>')
        (self.src/'settings.json').write_text('{"x":1}')
        self.out=self.root/'out';preprocess.prepare(self.src,self.out,javac='missing-javac-for-test')

    def proposal(self):
        p=facts.load(self.out/'agent-output-template.json')
        p.update(repository_summary='示例工程',observations=[{'description':'根目录存在Maven入口','evidence':['file:pom.xml']}],uncertainties=['未执行构建'],read_parts=[])
        file=self.root/'agent.json';facts.save(file,p);return file

    def test_handoff_is_preclassification(self):
        h=facts.load(self.out/'handoff.json')
        self.assertEqual(h['next_step'],'material_classification')
        self.assertEqual(h['agent_status'],'NOT_PROVIDED')
        self.assertTrue((self.out/'facts/snapshots/settings.json').exists())
        self.assertFalse((self.out/'materials.json').exists())

    def test_notes_optional_and_unread_visible(self):
        result=preprocess.attach(self.out,self.proposal())
        self.assertEqual(result['unread_parts'],3)
        self.assertEqual(facts.load(self.out/'handoff.json')['agent_status'],'REFERENCES_CHECKED')

    def test_wrong_evidence_rejected_without_notes(self):
        file=self.proposal();p=facts.load(file);p['observations'][0]['evidence']=['file:invented'];facts.save(file,p)
        with self.assertRaises(ValueError):preprocess.attach(self.out,file)
        self.assertFalse((self.out/'agent-notes.json').exists())

    def test_wrong_snapshot_rejected(self):
        file=self.proposal();p=facts.load(file);p['snapshot_id']='old';facts.save(file,p)
        with self.assertRaises(ValueError):preprocess.attach(self.out,file)

    def test_part_change_rejected(self):
        part=next((self.out/'agent-input').glob('part-*.json'));part.write_text('{}')
        with self.assertRaises(ValueError):preprocess.attach(self.out,self.proposal())

    def test_existing_notes_not_overwritten(self):
        file=self.proposal();preprocess.attach(self.out,file)
        with self.assertRaises(ValueError):preprocess.attach(self.out,file)


if __name__=='__main__':unittest.main()
