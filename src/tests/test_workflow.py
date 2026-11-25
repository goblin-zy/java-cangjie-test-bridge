"""Integration fixtures: the delivered points-wallet-whole run and Translation-all wallet output.

Run from src with: python -B -m unittest discover -s tests
Only temporary copies of evidence are modified.
"""
import shutil
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path

SRC = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(SRC))
from alignment import prepare
from comparison import audit, bundles, checked, summarize
from workflow import RESULTS, alignment, folder, read, render, save, sha, stage

FIXTURE = SRC.parent / 'runs/points-wallet-whole'
TRANSLATIONS = SRC.parents[1] / 'Translation-all'


class WalletWorkflowTests(unittest.TestCase):
    def setUp(self):
        temp = tempfile.TemporaryDirectory()
        self.addCleanup(temp.cleanup)
        self.run_dir = Path(temp.name) / 'run'
        shutil.copytree(FIXTURE / 'process', self.run_dir / 'process')
        self.packet = bundles(self.run_dir)['U01']
        self.result = read(stage(self.run_dir, 3) / 'result_U01.json')
        self.interface = next(c for c in self.result['checks'] if c['kind'] == 'interface')

    def test_missing_contract_only_allows_unknown_interface(self):
        self.assertEqual(self.packet['contract']['status'], 'missing')
        self.assertEqual(checked(self.packet, self.result)['status'], RESULTS[2])
        self.interface['status'] = RESULTS[0]
        with self.assertRaisesRegex(ValueError, '缺约定'):
            checked(self.packet, self.result)

    def test_contract_quote_and_snapshot_version_are_verified(self):
        contract = self.run_dir / 'contract.txt'
        clause = 'spend(n) consumes n points.'
        contract.write_text(clause, encoding='utf-8')
        aligned = alignment(self.run_dir)
        aligned['contract'] = {'status':'assumed', 'path':str(contract),
                               'sha256':sha(contract.read_bytes())}
        save(stage(self.run_dir, 1) / 'alignment.json', aligned)
        packet = bundles(self.run_dir)['U01']
        self.result['packet_hash'] = packet['packet_hash']
        self.interface['status'] = RESULTS[0]
        with self.assertRaises((KeyError, ValueError)):
            checked(packet, self.result)
        ref = {'quote':'spend(n) adds n points.', 'assumption':'本轮业务遵循此约定'}
        self.interface['contract_reference'] = ref
        with self.assertRaisesRegex(ValueError, '原文'):
            checked(packet, self.result)
        ref['quote'] = clause
        self.assertEqual(checked(packet, self.result)['status'], RESULTS[0])
        contract.write_text(clause + ' Revised.', encoding='utf-8')
        with self.assertRaisesRegex(ValueError, '快照已变更'):
            checked(packet, self.result)

    def test_audit_detects_one_missing_comparison(self):
        (stage(self.run_dir, 3) / 'result_U02.json').unlink()
        state = audit(self.run_dir)
        self.assertEqual((state['selected'], state['compared']), (2, 1))
        self.assertEqual([(u['id'], u['state']) for u in state['units']],
                         [('U01', '已比较'), ('U02', '漏做')])

    def test_uncovered_segment_is_rejected(self):
        lo, hi = self.packet['unit']['java']
        segments = self.packet['sides']['java']['segments']
        ident = next(k for k,n in segments.items() if lo <= n['start'] <= n['end'] <= hi)
        for check in self.result['checks']:
            if ident in check['java']:
                # Supply another existing segment so that only coverage is invalid.
                check['java'] = [value for value in segments if value != ident]
        with self.assertRaisesRegex(ValueError, '片段未交代'):
            checked(self.packet, self.result)

    def test_note_edit_invalidates_old_submission(self):
        path = folder(self.run_dir, 'java') / 'annotations_java.json'
        notes = read(path)
        notes[0]['内容'] += '（重新查阅原文）'
        save(path, notes)
        with self.assertRaisesRegex(ValueError, '旧版本'):
            checked(bundles(self.run_dir)['U01'], self.result)

    def test_source_difference_survives_unknown_interface(self):
        item = next(c for c in self.result['checks'] if c['kind'] == 'source')
        item.update(status=RESULTS[1], recheck='已回查原始表达式')
        self.assertEqual(checked(self.packet, self.result)['status'], RESULTS[1])
        self.assertEqual(self.interface['status'], RESULTS[2])

    def test_unresolved_class_question_must_reach_affected_result(self):
        decision = self.run_dir / 'review.json'
        save(decision, {'action':'待确认', 'affected':['U01'], 'reason':'准备方法调用时机不明'})
        with self.assertRaisesRegex(ValueError, '跨测试未知项'):
            summarize(self.run_dir, decision)

    def test_changed_source_cannot_claim_full_scope(self):
        workspace = self.run_dir.parent / 'project'
        shutil.copytree(TRANSLATIONS / '01-projects/points-wallet', workspace)
        test = next(workspace.rglob('PointsWalletTest.java'))
        test.write_bytes(test.read_bytes() + b'\n')
        with self.assertRaisesRegex(ValueError, '重新提取'):
            prepare(TRANSLATIONS / 'output/points-wallet-coverage', 'whole',
                    self.run_dir.parent / 'changed', None, [], workspace)

    def test_misquoted_source_anchor_is_rejected(self):
        path = folder(self.run_dir, 'java') / 'annotations_java.json'
        notes = read(path)
        notes[0]['quote'] += ' '
        save(path, notes)
        with self.assertRaisesRegex(ValueError, '原文引文'):
            render(self.run_dir, 'java')

    def test_fragment_route_selection_locates_only_requested_method(self):
        run = self.run_dir.parent / 'fragment'
        aligned = prepare(TRANSLATIONS / 'output/points-wallet-coverage', 'fragment',
                          run, None, ['rejectsOverspending'])
        unit, = aligned['units']
        self.assertEqual(unit['name'], 'rejectsOverspending')
        target = TRANSLATIONS / 'output/points-wallet-coverage/07-fragment-translation/test/wallet/points_wallet_test.cj'
        self.assertIn(str(target), aligned['versions'])
        self.assertEqual((stage(run, 1) / aligned['files']['cangjie']).read_bytes(), target.read_bytes())
        for side in ('java','cangjie'):
            lo,hi = unit[side]
            lines = (stage(run, 1) / aligned['files'][side]).read_text(encoding='utf-8-sig').splitlines()
            self.assertIn(unit['name'], '\n'.join(lines[lo-1:hi]))

    def test_replay_through_public_commands(self):
        new_run = self.run_dir.parent / 'replay'

        def call(command, *args, expected=0):
            result = subprocess.run([sys.executable, '-B', str(SRC / 'verify_tool.py'),
                                     command, '--run', str(new_run), *map(str,args)],
                                    capture_output=True)
            self.assertEqual(result.returncode, expected, result.stderr)
            return result.stdout

        call('init', '--translation', TRANSLATIONS / 'output/points-wallet-coverage', '--route', 'whole')
        for side in ('java', 'cangjie'):
            for prefix in ('context', 'annotations'):
                name = f'{prefix}_{side}.json'
                shutil.copyfile(folder(FIXTURE,side) / name, folder(new_run,side) / name)
            call('annotate', '--side', side)
        call('compare')
        call('audit', expected=2)
        for uid in ('U01','U02'):
            call('unit-input', '--id', uid)
            submission = read(stage(FIXTURE,3) / f'submission_{uid}.json')
            # Input paths can change when the repository is moved.
            submission['packet_hash'] = read(stage(new_run,3) / f'compare_{uid}.json')['packet_hash']
            draft = stage(new_run,3) / f'submission_{uid}.json'
            save(draft, submission)
            call('submit', '--input', draft)
        call('audit')
        decision = stage(FIXTURE,4) / 'class_review.json'
        call('summary','--decision',decision)
        call('deliver','--decision',decision,'--narrative',stage(FIXTURE,5) / 'narrative.md')
        dest = new_run / 'deliverables'
        report = read(dest / 'report.json')
        self.assertEqual(report['scope']['compared'], 2)
        self.assertEqual([r['status'] for r in report['results']], [RESULTS[2]] * 2)
        for ref in report['evidence'].values():
            lines = (dest/ref['file']).read_text(encoding='utf-8-sig').splitlines()
            lo,hi = ref['annotated']
            self.assertEqual('\n'.join(lines[lo-1:hi]), ref['quote'])
        call('deliver','--decision',decision,'--narrative',stage(FIXTURE,5) / 'narrative.md',expected=1)


if __name__ == '__main__':
    unittest.main()
