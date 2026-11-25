"""回放三部分整合：源码提取/上下文、最终译文静态审阅及受控错误。

标注与结论是本次 Agent 对 Interval 的固定审阅，不是通用语义判定器。
此脚本没有创建独立盲审会话；它验证材料交接、证据约束和程序流程。
"""
import argparse
import hashlib
import json
import os
from pathlib import Path
import re
import shutil
import subprocess
import sys

ROOT = Path(__file__).resolve().parents[3]
VERIFY = ROOT / '主体/静态验证/src/verify_tool.py'

# 本次 Agent 已逐项对照两侧源码的行为；代码生成回归材料，不据名称推断新项目语义。
REVIEWS = {
    'test_construct': '构造区间(1,3)，依次检查起点1、终点3；仓颉显式Int32匹配业务签名。',
    'test_size': '构造区间(0,2)，调用真实size并要求3，保留端点包含的长度语义。',
    'test_intervaloverlaps': '区间(1,3)与(2,4)调用区间重载，要求重叠为真。',
    'test_intervalDoesNotOverlap': '区间(1,13)与(27,42)调用区间重载，要求重叠为假。',
    'test_pointOverlaps': '区间(1,3)对点2调用点重载，要求重叠为真。',
    'test_pointDoesNotOverlap': '区间(1,13)对点42调用点重载，要求重叠为假。',
    'test_comparable': '按(4,6)、(2,7)、(3,4)顺序放入同一有序集合，推进同一迭代器并依次断言起点2、3、4；IntervalBridge委托真实compareTo并转换Ordering。',
    'test_checkToString': '构造区间(4,6)，要求真实toString返回4:6。',
    'test_compareToNegativeTest': '构造区间(4,6)，传入不属于Intervalable的普通对象，要求真实compareTo返回-1；UnrelatedValue承担原new Object()的角色。',
}


def load(path):
    return json.loads(path.read_text(encoding='utf-8-sig'))


def save(path, value):
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(value, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')


def annotations(run, side):
    """按原行建立可核对标注，原文引文不被重排；保留全部断言和辅助委托。"""
    aligned = load(run / 'process/01-alignment/alignment.json')
    source = run / 'process/01-alignment' / aligned['files'][side]
    lines = source.read_text(encoding='utf-8-sig').splitlines()
    notes = []
    for number, line in enumerate(lines, 1):
        stripped = line.strip()
        if not stripped or stripped in {'}', '};'} or stripped.startswith(('//', '/*', '*')):
            continue
        containing = next((u for u in aligned['units'] if u[side] and u[side][0] <= number <= u[side][1]), None)
        name = containing['name'] if containing else None
        check = 'assert' in stripped or '@Assert' in stripped
        phase = '被测操作（结果检查）' if check else '初始化与准备'
        description = ('保留本次调用及断言：' if check else '保留声明、对象或操作：') + stripped
        if 'ordered.add' in stripped or 'intervals.add' in stripped:
            phase, description = '被测操作', '按源码顺序向同一有序集合加入区间：' + stripped
        if 'return interval.compareTo' in stripped:
            phase, description = '被测操作', '委托真实业务compareTo，再把比较结果转换为Ordering。'
        notes.append({'start': number, 'end': number, 'quote': line,
            '片段编号': ('J' if side == 'java' else 'C') + str(len(notes) + 1).zfill(3),
            '环节': phase, '维度': '断言与操作' if check else '声明与准备', '内容': description,
            '关联': (name + '本侧的对象、调用或检查；结合本侧相邻语句阅读。') if name else '供本类测试使用的包、框架、声明或辅助结构。',
            '依据': source.name + '原文第' + str(number) + '行', '待确认': '无；完整接口前提见联合比较约定'})
    directory = run / 'process/02-annotations' / ('Java' if side == 'java' else 'Cangjie')
    save(directory / ('annotations_' + side + '.json'), notes)
    materials = load(directory / ('materials_' + side + '.json'))
    used = [m for m in materials if m['file'].endswith(('/' + source.name, '/interval.cj', '/Interval.java', '/intervalable.cj', '/Intervalable.java', '/agent_context.json'))]
    save(directory / ('context_' + side + '.json'), {'sources': [
        {'file': m['file'], 'reason': '固定回归读取本侧测试、相关业务定义或同版上下文'} for m in used],
        'unknowns': [], 'analysis_mode': 'CURRENT_AGENT_FIXED_REVIEW_NO_INDEPENDENT_BLIND_SESSIONS'})
    return notes


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output', type=Path, required=True)
    args = parser.parse_args()
    output = args.output.resolve()
    output.mkdir(parents=True, exist_ok=False)
    env = {**os.environ, 'PYTHONIOENCODING': 'utf-8', 'PYTHONDONTWRITEBYTECODE': '1'}
    commands, checks = [], []

    def check(name, condition):
        if not condition:
            raise AssertionError(name)
        checks.append({'name': name, 'status': 'PASSED'})
        save(output / 'checks.json', checks)

    def call(name, command, expected=0):
        result = subprocess.run(list(map(str, command)), cwd=ROOT, env=env, capture_output=True, timeout=300)
        (output / (name + '.stdout.log')).write_bytes(result.stdout)
        (output / (name + '.stderr.log')).write_bytes(result.stderr)
        commands.append({'name': name, 'command': list(map(str, command)), 'returncode': result.returncode, 'expected': expected})
        save(output / 'commands.json', commands)
        if result.returncode != expected:
            raise RuntimeError(name + ': ' + (result.stdout + result.stderr).decode('utf-8', errors='replace')[-3000:])
        return result.stdout.decode('utf-8', errors='replace')

    def verify(name, run, action, *options, expected=0):
        return call(name, [sys.executable, VERIFY, action, '--run', run, *options], expected)

    call('01-context-regression', [sys.executable, '-m', 'unittest', 'discover', '-s', '主体/上下文工具/tests', '-v'])
    call('02-static-regression', [sys.executable, '-m', 'unittest', 'discover', '-s', '主体/静态验证/src/tests', '-v'])
    call('03-week12-flow', [sys.executable, ROOT / '主体/集成适配/tests/run_integration.py', '--output', output / 'base'])
    base = output / 'base'
    task = load(base / 'whole_task.json')
    task.update(is_template=False, task_id='interval-static-integration')
    task['constraints']['compile_or_run_projects'] = True
    task['context']['index'] = str(base / 'context-index/project_schema.json')
    task['context']['java_members'] = [str(base / 'java-extraction/members.json')]
    task['context']['suites'][0].update(output_dir=str(base / 'context-suite'),
        agent_context=str(base / 'context-suite/agent_context.json'), tasks_file=str(base / 'context-suite/tasks.json'))
    save(output / 'whole_task.json', task)
    prepared = output / 'static-input'
    call('04-adapt-static', [sys.executable, ROOT / '主体/集成适配/prepare_static_validation.py', '--task', output / 'whole_task.json',
                            '--translated', base / 'translation/translated', '--output', prepared])
    config = load(prepared / 'translation_config.json')
    check('新上下文交付包含整类共享逐条文件', len(config['context_files']) >= 13)
    check('成员表路径可接收week12嵌套交付', config['java_members_file'] == '02-java-skeleton/0/members.json')
    contract = output / 'target_contract.md'
    business = ROOT / '样例材料/Interval双语项目/cangjie/src/interval.cj'
    clauses = {name: '本轮接口前提（' + name + '）：' + review for name, review in REVIEWS.items()}
    contract.write_text('# 本轮目标接口依据\n\n来源：样例材料/Interval双语项目/cangjie/src/interval.cj\n'
        + 'SHA-256：' + hashlib.sha256(business.read_bytes()).hexdigest() + '\n\n'
        + '\n\n'.join(clauses.values()) + '\n\n原业务定义：\n```cangjie\n' + business.read_text(encoding='utf-8')
        + '\n```\n\n上述前提限定于本轮输入与已执行测试，不构成任意输入上的等价证明。\n', encoding='utf-8')
    run = output / 'interval-review'
    verify('05-init', run, 'init', '--translation', prepared, '--route', 'whole', '--contract', contract)
    aligned = load(run / 'process/01-alignment/alignment.json')
    check('九个测试由源清单和执行类正确定位', len(aligned['units']) == 9 and all(u['java'] and u['cangjie'] and u['test_invocations'] for u in aligned['units']))
    check('第二版上下文实际进入取材清单', any(p.endswith('agent_context.json') for p in aligned['materials']))
    notes = {side: annotations(run, side) for side in ['java', 'cangjie']}
    for side in notes:
        verify('06-annotate-' + side, run, 'annotate', '--side', side)
        edit = load(run / 'process/02-annotations' / ('Java' if side == 'java' else 'Cangjie') / 'edit_check.json')
        check(side + '插注释后可还原原文', edit['restored_original'])
    verify('07-compare', run, 'compare')
    verify('08-audit-missing', run, 'audit', expected=2)
    for unit in aligned['units']:
        uid, name = unit['id'], unit['name']
        packet = load(run / 'process/03-comparison' / ('compare_' + uid + '.json'))
        refs = {side: [n['片段编号'] for n in notes[side] if unit[side][0] <= n['start'] <= n['end'] <= unit[side][1]] for side in notes}
        # 只给需要排序委托的用例附加对应辅助声明，避免把整类依据机械复用。
        if name == 'test_comparable':
            refs['cangjie'] += [n['片段编号'] for n in notes['cangjie'] if n['start'] < unit['cangjie'][0] and ('IntervalBridge' in n['quote'] or 'return interval.compareTo' in n['quote'])]
        if name == 'test_compareToNegativeTest':
            refs['cangjie'] += [n['片段编号'] for n in notes['cangjie'] if 'private class UnrelatedValue' in n['quote']]
        draft = {'id': uid, 'packet_hash': packet['packet_hash'], 'checks': [
            {'kind': 'source', 'topic': '准备、操作和全部断言', 'status': '在所列前提和范围内一致',
             **refs, 'reason': REVIEWS[name]},
            {'kind': 'interface', 'topic': '真实业务接口与必要结构适配', 'status': '在所列前提和范围内一致',
             **refs, 'reason': REVIEWS[name], 'contract_reference': {'quote': clauses[name],
                 'assumption': '使用本轮快照中的Interval业务及测试辅助委托，范围限定于原用例。'}}]}
        path = run / 'process/03-comparison' / ('submission_' + uid + '.json')
        save(path, draft)
        verify('09-submit-' + uid, run, 'submit', '--input', path)
    verify('10-audit-complete', run, 'audit')
    decision = run / 'process/04-audit/class_review.json'
    save(decision, {'action': '复用已有依据', 'affected': [],
        'reason': '原测试没有共享字段、生命周期或资源；每条创建自身对象。有序集合适配仅用于comparable测试，已单独核对。'})
    narrative = run / 'process/05-report/narrative.md'
    narrative.parent.mkdir(parents=True, exist_ok=True)
    narrative.write_text('本轮对 IntervalTest 的九条最终译文作静态审阅，保留十二条源断言。\n\n'
        + '\n\n'.join(name + '：' + reason for name, reason in REVIEWS.items())
        + '\n\n结论是在所列接口前提和当前范围内一致。标注与判断由当前Agent对照两侧源码整理，脚本固定回放；本轮没有执行两个独立盲审会话，未评估语义错误检出率。Java和仓颉各9条测试的真实运行日志另存于base。\n', encoding='utf-8')
    verify('11-summary', run, 'summary', '--decision', decision)
    verify('12-deliver', run, 'deliver', '--decision', decision, '--narrative', narrative)
    report = load(run / 'deliverables/report.json')
    check('九个单元均完成静态比较', report['scope']['selected'] == report['scope']['compared'] == 9)
    check('结论有明确接口前提', report['contract']['status'] == 'assumed' and all(r['status'] == '在所列前提和范围内一致' for r in report['results']))
    for evidence in report['evidence'].values():
        lines = (run / 'deliverables' / evidence['file']).read_text(encoding='utf-8').splitlines()
        first, last = evidence['annotated']
        if '\n'.join(lines[first - 1:last]) != evidence['quote']:
            raise AssertionError('交付报告引文错位')
    check('交付引用全部回到真实标注源码', True)

    # 受控错误验证的是提交/复查路径，不冒充模型自动发现错误。
    mutant = output / 'mutant-input'
    shutil.copytree(prepared, mutant)
    final = mutant / '06-whole-translation/test/interval_test.cj'
    code = final.read_text(encoding='utf-8')
    old = '@Assert(Int32(3), Interval(0, 2).size())'
    if code.count(old) != 1:
        raise AssertionError('受控改动锚点不唯一')
    final.write_text(code.replace(old, '@Assert(Int32(4), Interval(0, 2).size())'), encoding='utf-8')
    badrun = output / 'mutant-review'
    verify('13-init-mutant', badrun, 'init', '--translation', mutant, '--route', 'whole', '--test', 'test_size', '--contract', contract)
    badnotes = {side: annotations(badrun, side) for side in ['java', 'cangjie']}
    for side in badnotes:
        verify('14-mutant-annotate-' + side, badrun, 'annotate', '--side', side)
    verify('15-mutant-compare', badrun, 'compare')
    stale = load(run / 'process/03-comparison/submission_U02.json')
    stale['id'] = 'U01'
    save(output / 'stale-submission.json', stale)
    verify('16-reject-old-verdict', badrun, 'submit', '--input', output / 'stale-submission.json', expected=1)
    check('最终译文变化后拒绝旧比较材料', True)
    badunit = load(badrun / 'process/01-alignment/alignment.json')['units'][0]
    badpacket = load(badrun / 'process/03-comparison/compare_U01.json')
    refs = {side: [n['片段编号'] for n in badnotes[side] if badunit[side][0] <= n['start'] <= n['end'] <= badunit[side][1]] for side in badnotes}
    draft = {'id': 'U01', 'packet_hash': badpacket['packet_hash'], 'checks': [
        {'kind': 'source', 'topic': '长度断言的期望值', 'status': '发现差异', **refs,
         'reason': 'Java要求区间(0,2)长度等于3，受控错误译文改成4。', 'recheck': '已重新读取两侧test_size原文，定位3与4的实际字面量。'},
        {'kind': 'interface', 'topic': '真实size定义', 'status': '在所列前提和范围内一致', **refs,
         'reason': '业务size实现仍为end-start+1，未随错误译文改动。',
         'contract_reference': {'quote': clauses['test_size'], 'assumption': '使用本轮未修改的业务源码。'}}]}
    save(output / 'mutant-submission.json', draft)
    verify('17-submit-difference', badrun, 'submit', '--input', output / 'mutant-submission.json')
    check('确认差异不会被接口一致项覆盖', load(badrun / 'process/03-comparison/result_U01.json')['status'] == '发现差异')

    # 修改上下文后，适配与验证都必须拒绝，不能把半成品作为正常输入。
    badsuite = output / 'corrupt-suite'
    shutil.copytree(base / 'context-suite', badsuite)
    first_test = badsuite / load(badsuite / 'tasks.json')['tests'][0]['file']
    first_test.write_bytes(first_test.read_bytes() + b'\n')
    badtask = json.loads(json.dumps(task))
    badtask['context']['suites'][0]['output_dir'] = str(badsuite)
    save(output / 'bad-context-task.json', badtask)
    badinput = output / 'rejected-input'
    call('17a-reject-context-change', [sys.executable, ROOT / '主体/集成适配/prepare_static_validation.py',
        '--task', output / 'bad-context-task.json', '--translated', base / 'translation/translated', '--output', badinput], expected=1)
    verify('17b-reject-failed-input', output / 'rejected-review', 'init', '--translation', badinput, '--route', 'whole', expected=1)
    check('上下文摘要变化和失败交付均被拒绝', (badinput / 'FAILED.json').is_file())

    # 基类测试进入清单但不套用子类文件行号；单文件限制必须表现为受阻。
    inherited = json.loads(json.dumps(task))
    inherited['project_root'] = str(base / 'fixture-project')
    inherited['context']['index'] = str(base / 'fixture-index/project_schema.json')
    inherited['context']['suites'][0].update(output_dir=str(base / 'fixture-suite'), source_type='p.ChildCase')
    inherited['java_extractions'][0].update(extraction_root=str(base / 'fixture-extraction'), members_file=str(base / 'fixture-extraction/members.json'))
    inherited['targets'][0].update(source_type='p.ChildCase', source_file='src/test/java/p/ChildCase.java')
    inherited_skeleton = output / 'inherited-skeleton'
    inherited_skeleton.mkdir()
    inherited_code = 'package probe\nimport std.unittest.*\nimport std.unittest.testmacro.*\n@Test\nclass ChildCase {\n'
    inherited_mapping = []
    inherited_table = load(base / 'fixture-extraction/members.json')
    ids = {i['source_member_id'] for i in inherited_table['test_invocations'] if i['execution_class'] == 'p.ChildCase'}
    for member in inherited_table['members']:
        if member['id'] in ids:
            inherited_code += '@TestCase\nfunc ' + member['name'] + '(): Unit {\nthrow Exception("INTERFACE_SCOPE_ONLY")\n}\n'
            inherited_mapping.append({'source_member_id': member['id'], 'source_members_file': 'members.json',
                'target_file': 'inherited.cj', 'target_member': member['name'], 'status': 'mapped'})
    inherited_code += '}\n'
    (inherited_skeleton / 'inherited.cj').write_text(inherited_code, encoding='utf-8')
    save(inherited_skeleton / 'member_mapping.json', inherited_mapping)
    inherited['skeleton_bundles'][0].update(skeleton_root=str(inherited_skeleton), mapping_file=str(inherited_skeleton / 'member_mapping.json'),
        source_members_base=str(base / 'fixture-extraction'), target_files_base=str(inherited_skeleton))
    save(output / 'inherited-task.json', inherited)
    inherited_input = output / 'inherited-input'
    call('17c-inherited-adapter', [sys.executable, ROOT / '主体/集成适配/prepare_static_validation.py',
        '--task', output / 'inherited-task.json', '--translated', inherited_skeleton, '--output', inherited_input])
    inherited_run = output / 'inherited-review'
    verify('17d-inherited-scope', inherited_run, 'init', '--translation', inherited_input, '--route', 'whole')
    units = load(inherited_run / 'process/01-alignment/alignment.json')['units']
    check('继承测试不漏算且跨文件声明明确受阻', len(units) == 2 and
        any(u['name'] == 'testFromBase' and u['java'] is None and '跨文件' in u['reason'] for u in units)
        and any(u['name'] == 'testOwn' and u['java'] for u in units))

    # 实际运行带注释的交付源码；两侧原文还原校验之外再检查编译/测试行为。
    sources = output / 'annotated-cangjie/src'
    shutil.copytree(ROOT / '样例材料/Interval双语项目/cangjie/src', sources)
    shutil.copyfile(run / 'deliverables/interval_test.cj', sources / 'interval_test.cj')
    cjc = os.environ.get('CJ_TEST_CJC', 'cjc')
    binary = sources.parent / ('tests.exe' if os.name == 'nt' else 'tests')
    call('18-compile-annotated', [cjc, '--test', '-p', sources, '-o', binary, '--diagnostic-format', 'noColor'])
    executed = call('19-run-annotated', [binary])
    clean = re.sub(r'\x1b\[[0-?]*[ -/]*[@-~]', '', executed)
    (output / 'annotated-cangjie.clean.log').write_text(clean, encoding='utf-8')
    check('标注后的仓颉交付仍九条通过', re.search(r'PASSED:\s*9', clean) is not None and re.search(r'FAILED:\s*0', clean) is not None)
    counts = {}
    for group, label in [('context', '01-context-regression'), ('static', '02-static-regression')]:
        text = (output / (label + '.stderr.log')).read_text(encoding='utf-8')
        counts[group] = int(re.search(r'Ran (\d+) tests', text)[1])
    save(output / 'summary.json', {'status': 'PASSED', 'context_regressions': counts['context'], 'static_regressions': counts['static'],
        'week12_checks': load(base / 'integration_summary.json')['checks_passed'], 'static_flow_checks': len(checks),
        'source_tests': 9, 'source_assertions': 12, 'compared': report['scope']['compared'],
        'java_tests_passed': 9, 'cangjie_tests_passed': 9, 'annotated_cangjie_tests_passed': 9,
        'semantic_verdict': '在所列前提和范围内一致', 'model_analysis_mode': 'CURRENT_AGENT_FIXED_REVIEW',
        'independent_blind_sessions': 'NOT_RUN', 'semantic_accuracy_benchmark': 'NOT_RUN',
        'business_modified': False, 'model_api_used': False})
    print(json.dumps(load(output / 'summary.json'), ensure_ascii=True, indent=2))


if __name__ == '__main__':
    main()
