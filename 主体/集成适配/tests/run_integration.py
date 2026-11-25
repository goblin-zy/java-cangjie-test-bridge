"""week12 合并链路的实际检查：提取、上下文、结构检查、Java/CJ 对应测试。"""
import argparse
import hashlib
import importlib.util
import json
import os
from pathlib import Path
import re
import shutil
import subprocess
import sys
import urllib.request

ROOT = Path(__file__).resolve().parents[3]
JAVA = os.environ.get('PP_TEST_JAVA', 'java')
JAVAC = os.environ.get('PP_TEST_JAVAC', 'javac')
CJC = os.environ.get('CJ_TEST_CJC', 'cjc')


def save(path, data):
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(data, ensure_ascii=True, indent=2) + '\n', encoding='utf-8')


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


# 此脚本回放本次 Agent 已核对的固定译文，用来做接口回归，不是通用翻译器。
# 它实际运行 Java/CJ 测试，并从 Maven Central 下载固定 JUnit/Hamcrest 测试依赖。
def main():
    p = argparse.ArgumentParser()
    p.add_argument('--output', type=Path, required=True)
    args = p.parse_args()
    out = args.output.resolve()
    out.mkdir(parents=True, exist_ok=False)
    env = {**os.environ, 'PYTHONIOENCODING': 'utf-8', 'PYTHONDONTWRITEBYTECODE': '1',
           'PP_TEST_JAVA': JAVA, 'PP_TEST_JAVAC': JAVAC, 'TEMP': str(out), 'TMP': str(out)}
    commands, checks = [], []

    def check(name, condition):
        if not condition:
            raise AssertionError(name)
        checks.append({'name': name, 'status': 'PASSED'})
        save(out / 'checks.json', checks)

    def run(name, command, expected=0, json_output=False):
        process = subprocess.run(list(map(str, command)), capture_output=True, env=env, timeout=300)
        (out / (name + '.stdout.log')).write_bytes(process.stdout)
        (out / (name + '.stderr.log')).write_bytes(process.stderr)
        commands.append({'name': name, 'command': list(map(str, command)), 'returncode': process.returncode, 'expected': expected})
        save(out / 'commands.json', commands)
        if process.returncode != expected:
            raise RuntimeError(name + ': ' + process.stdout.decode('utf-8', errors='replace')[-1800:] + process.stderr.decode('utf-8', errors='replace')[-1200:])
        return json.loads(process.stdout) if json_output else process.stdout.decode('utf-8', errors='replace')

    cli = [sys.executable, ROOT / '主体/上下文工具/context_tool.py']
    extractor = ROOT / '主体/Java骨架提取器/JavaTestSkeletonExtractor.java'
    classes = out / 'extractor-classes'
    classes.mkdir()
    run('01-compile-extractor', [JAVAC, '-encoding', 'UTF-8', '-d', classes, extractor])
    project = ROOT / '样例材料/Interval双语项目/java'
    target_source = ROOT / '样例材料/Interval双语项目/cangjie/src'
    selected = 'src/test/java/org/ahocorasick/interval/IntervalTest.java'
    extraction = out / 'java-extraction'
    run('02-extract-interval', [JAVA, '-cp', classes, 'JavaTestSkeletonExtractor', '--input', project / selected, '--output', extraction])
    table = json.loads((extraction / 'members.json').read_text(encoding='utf-8'))
    check('JUnit4 九条测试角色与框架', len(table['members']) == 9 and all(m['role'] == 'test' and m['test_framework'] == 'junit4' for m in table['members']))
    built = run('03-context-build', cli + ['build', '--project', project, '--test-scope', selected, '--java-members', extraction / 'members.json',
                 '--output', out / 'context-index', '--java', JAVA, '--javac', JAVAC], json_output=True)
    index = Path(built['index'])
    suite = run('04-context-suite', cli + ['suite', '--index', index, '--target', 'org.ahocorasick.interval.IntervalTest', '--output', out / 'context-suite'], json_output=True)
    check('上下文接受新成员表并导出九条测试', suite['tests'] == 9)
    data = json.loads(index.read_text(encoding='utf-8'))
    check('九条源成员执行类关联', len(data['java_members']['test_invocations']) == 9)

    # 合成边界输入只用于测试提取/对接，不充当业务译文。
    fixture = out / 'fixture-project'
    fixtures = {
        'p/BaseCase.java': 'package p; import junit.framework.TestCase; public abstract class BaseCase extends TestCase { protected int value=1; protected void setUp() { value=2; } public void testFromBase() { assert value==2; } public static void testStatic() {} }',
        'p/ChildCase.java': 'package p; public class ChildCase extends BaseCase { public void testOwn() { assert value>0; } }',
        'p/FourCase.java': 'package p; import org.junit.Test; public class FourCase { @Test(expected=IllegalArgumentException.class, timeout=250) public void check() { throw new IllegalArgumentException(); } }',
        'fake/Test.java': 'package fake; public @interface Test {}',
        'p/FakeCase.java': 'package p; import fake.Test; public class FakeCase { @Test public void pretend() {} }'}
    for name, source in fixtures.items():
        path = fixture / 'src/test/java' / name
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(source, encoding='utf-8')
    fixture_table = out / 'fixture-extraction'
    run('05-extract-fixtures', [JAVA, '-cp', classes, 'JavaTestSkeletonExtractor', '--input', fixture / 'src/test/java', '--output', fixture_table])
    fx = json.loads((fixture_table / 'members.json').read_text(encoding='utf-8'))
    invocations = fx['test_invocations']
    check('继承执行类指向基类声明', any(i['execution_class'] == 'p.ChildCase' and i['declaring_class'] == 'p.BaseCase' and '#testFromBase()' in i['selector'] for i in invocations))
    check('静态及外来注解不作为测试', all('testStatic' not in i['selector'] and 'pretend' not in i['selector'] for i in invocations))
    fx_built = run('06-fixture-context', cli + ['build', '--project', fixture, '--java-members', fixture_table / 'members.json', '--output', out / 'fixture-index',
                   '--java', JAVA, '--javac', JAVAC], json_output=True)
    fx_suite = run('07-inherited-suite', cli + ['suite', '--index', fx_built['index'], '--target', 'p.ChildCase', '--output', out / 'fixture-suite'], json_output=True)
    check('没有 JUnit JAR 时继承测试仍可定位', fx_suite['tests'] == 2)
    fx_view = json.loads((out / 'fixture-suite/shared.json').read_text(encoding='utf-8'))
    check('继承生命周期进入共享上下文', any('setUp' in r['display_id'] for r in fx_view['records']))
    fx_agent = json.loads((out / 'fixture-suite/agent_context.json').read_text(encoding='utf-8'))
    check('初始上下文同时保留基类声明与子类执行身份', any(r['declaring_class'] == 'p.BaseCase' and r['execution_class'] == 'p.ChildCase' for r in fx_agent['test_invocations']))
    four = run('08-junit4-semantics', cli + ['initial', '--index', fx_built['index'], '--target', 'p.FourCase', '--output', out / 'four-view'], json_output=True)
    four_view = json.loads(Path(four['json']).read_text(encoding='utf-8'))
    check('expected/timeout 作为语义复核边界保留', any(r.get('semantics', [{}])[0].get('annotation_arguments', {}).get('timeout') == '250' for r in four_view['boundaries']))
    stale = json.loads((fixture_table / 'members.json').read_text(encoding='utf-8'))
    stale['files'][0]['source_sha256'] = '0' * 64
    save(out / 'stale-members.json', stale)
    run('09-reject-stale', cli + ['build', '--project', fixture, '--java-members', out / 'stale-members.json', '--output', out / 'stale-index',
                 '--java', JAVA, '--javac', JAVAC], expected=1)
    check('拒绝陈旧成员摘要', (out / 'stale-index/FAILED.json').is_file())

    skeleton = out / 'skeleton'
    skeleton.mkdir()
    methods = [m for m in table['members'] if m['role'] == 'test']
    header = '''package ahoCorasick4cj
import std.collection.*
import std.unittest.*
import std.unittest.testmacro.*

private class IntervalBridge <: Comparable<IntervalBridge> {
    public let interval: Interval
    public init(interval: Interval) { this.interval = interval }
    public func compare(rhs: IntervalBridge): Ordering { return interval.compareTo(rhs.interval).compare(0) }
}
private class UnrelatedValue { public init() {} }
@Test
class IntervalTest {
'''
    code = header
    mapping = []
    for number, member in enumerate(methods, 1):
        slot = 'W12_' + str(number).zfill(2)
        signature = 'func ' + member['name'] + '(): Unit'
        code += '    @TestCase\n    ' + signature + ' {\n        /* FRAGMENT_BEGIN:' + slot + ' */\n        throw Exception("SKELETON_PLACEHOLDER:' + slot + '")\n        /* FRAGMENT_END:' + slot + ' */\n    }\n'
        mapping.append({'source_members_file': 'members.json', 'source_member_id': member['id'],
            'source_location': member['source_location'], 'java_skeleton_location': member['skeleton_location'],
            'target_file': 'interval_test.cj', 'target_class': 'IntervalTest', 'target_member': member['name'],
            'target_signature': signature, 'status': 'mapped', 'fill_slot': 'body', 'slot_id': slot,
            'adaptation': '完整测试方法，填充时保留原输入、断言和调用顺序。'})
    code += '}\n'
    # 正向覆盖 week12 修复点：无初值字段之后紧接带 public 修饰符的构造器。
    mapping.append({'source_member_id': None, 'target_file': 'interval_test.cj', 'target_class': 'IntervalBridge',
        'target_member': 'interval', 'target_signature': 'public let interval: Interval', 'status': 'mapped',
        'fill_slot': None, 'adaptation': '测试端比较适配器保存真实业务对象，比较委托现有 compareTo。'})
    (skeleton / 'interval_test.cj').write_text(code, encoding='utf-8')
    save(skeleton / 'member_mapping.json', mapping)
    template = json.loads((ROOT / '主体/config/whole_task.template.json').read_text(encoding='utf-8'))
    template.update(is_template=False, task_id='week12-interval-integration', project_root=str(project), output_dir=str(out / 'translation'))
    template['context'].update(index=str(index), source_manifest=str(index.parent / 'source_manifest.json'))
    template['java_extractions'][0].update(extraction_root=str(extraction), members_file=str(extraction / 'members.json'))
    template['skeleton_bundles'][0].update(skeleton_root=str(skeleton), mapping_file=str(skeleton / 'member_mapping.json'),
        source_members_base=str(extraction), target_files_base=str(skeleton))
    template['targets'][0].update(source_type='org.ahocorasick.interval.IntervalTest', source_file=selected)
    template['allowed_target_source_roots'] = [str(target_source)]
    save(out / 'whole_task.json', template)
    adapter = ROOT / '主体/集成适配/prepare_skeleton_check.py'
    run('10-adapt-check-layout', [sys.executable, adapter, '--task', out / 'whole_task.json', '--output', out / 'checker-run'], json_output=True)
    checker = ROOT / '主体/仓颉骨架翻译器/check_skeleton.py'
    passed = run('11-check-skeleton', [sys.executable, checker, '--run', out / 'checker-run', '--target-source', target_source,
                   '--report', out / 'structure-check.json'], json_output=True)
    check('九测试与无初值字段结构通过', passed['status'] == 'passed' and passed['required_members'] == 9 and passed['slots'] == 9)
    # 对同一合法布局做可逆负向变体，检查器必须真实拒绝。
    prepared = out / 'checker-run'
    spec = importlib.util.spec_from_file_location('week12_skeleton_checker', checker)
    module = importlib.util.module_from_spec(spec)
    sys.modules[spec.name] = module
    spec.loader.exec_module(module)
    map_file = prepared / '05-cangjie-skeleton/member_mapping.json'
    original_map = json.loads(map_file.read_text(encoding='utf-8'))
    bad = [r for r in original_map if r.get('target_member') != methods[0]['name']]
    save(map_file, bad)
    check('缺失测试映射被拒绝', module.verify(prepared, [target_source])['status'] == 'failed')
    bad = json.loads(json.dumps(original_map))
    bad[1]['slot_id'] = bad[0]['slot_id']
    save(map_file, bad)
    check('重复槽位被拒绝', module.verify(prepared, [target_source])['status'] == 'failed')
    bad = json.loads(json.dumps(original_map))
    bad[0]['status'] = 'blocked'
    bad[0]['adaptation'] = '明确的未实现项'
    for field in ['slot_id', 'fill_slot']:
        bad[0].pop(field, None)
    save(map_file, bad)
    # 阻塞行的旧槽标记也应从骨架移除；不以遗留标记错误冒充 partial。
    check_file = prepared / '05-cangjie-skeleton/interval_test.cj'
    check_original = check_file.read_text(encoding='utf-8')
    blocked_code = re.sub(r'/\* FRAGMENT_BEGIN:W12_01 \*/.*?/\* FRAGMENT_END:W12_01 \*/', 'throw Exception("blocked")', check_original, flags=re.S)
    check_file.write_text(blocked_code, encoding='utf-8')
    check('阻塞映射保留 partial', module.verify(prepared, [target_source])['status'] == 'partial')
    check_file.write_text(check_original, encoding='utf-8')
    save(map_file, original_map)
    namespace_source = out / 'namespaced.cj'
    namespace_source.write_text('package demo_namespace::actual\n', encoding='utf-8')
    check_file.write_text('import actual.*\n' + check_original, encoding='utf-8')
    check('错误短命名空间被拒绝', module.verify(prepared, [namespace_source])['status'] == 'failed')
    check_file.write_text(check_original, encoding='utf-8')
    # 字段签名不能截短泛型。
    truncated = json.loads(json.dumps(original_map))
    truncated[-1]['target_signature'] = 'public let interval: Interval'
    check_file.write_text(check_original.replace('public let interval: Interval\n', 'public let interval: ArrayList<Interval>\n'), encoding='utf-8')
    save(map_file, truncated)
    check('截短泛型字段签名被拒绝', module.verify(prepared, [target_source])['status'] == 'failed')
    check_file.write_text(check_original, encoding='utf-8')
    save(map_file, original_map)

    bodies = {
        'test_construct': 'let interval = Interval(1, 3)\n        @Assert(Int32(1), interval.getStart())\n        @Assert(Int32(3), interval.getEnd())',
        'test_size': '@Assert(Int32(3), Interval(0, 2).size())',
        'test_intervaloverlaps': '@Assert(Interval(1, 3).overlapsWith(Interval(2, 4)))',
        'test_intervalDoesNotOverlap': '@Assert(!Interval(1, 13).overlapsWith(Interval(27, 42)))',
        'test_pointOverlaps': '@Assert(Interval(1, 3).overlapsWith(Int32(2)))',
        'test_pointDoesNotOverlap': '@Assert(!Interval(1, 13).overlapsWith(Int32(42)))',
        'test_comparable': '''let ordered = TreeSet<IntervalBridge>()
        ordered.add(IntervalBridge(Interval(4, 6)))
        ordered.add(IntervalBridge(Interval(2, 7)))
        ordered.add(IntervalBridge(Interval(3, 4)))
        let cursor = ordered.iterator()
        @Assert(Int32(2), cursor.next().getOrThrow().interval.getStart())
        @Assert(Int32(3), cursor.next().getOrThrow().interval.getStart())
        @Assert(Int32(4), cursor.next().getOrThrow().interval.getStart())''',
        'test_checkToString': '@Assert("4:6", Interval(4, 6).toString())',
        'test_compareToNegativeTest': '@Assert(Int32(-1), Interval(4, 6).compareTo(UnrelatedValue()))'}
    translated = code
    for number, method in enumerate(methods, 1):
        slot = 'W12_' + str(number).zfill(2)
        pattern = r'/\* FRAGMENT_BEGIN:' + slot + r' \*/.*?/\* FRAGMENT_END:' + slot + r' \*/'
        translated = re.sub(pattern, lambda match, body=bodies[method['name']]: body, translated, flags=re.S)
    translated_file = out / 'translation/translated/interval_test.cj'
    translated_file.parent.mkdir(parents=True)
    translated_file.write_text(translated, encoding='utf-8')
    check('整体填充保留九方法并移除占位', translated.count('@TestCase') == 9 and 'FRAGMENT_' not in translated and 'SKELETON_PLACEHOLDER' not in translated)
    cj_sources = out / 'cangjie-run/src'
    shutil.copytree(target_source, cj_sources)
    shutil.copyfile(translated_file, cj_sources / translated_file.name)
    binary = out / 'cangjie-run' / ('tests.exe' if os.name == 'nt' else 'tests')
    version = run('12-cjc-version', [CJC, '--version'])
    run('13-cj-compile', [CJC, '--test', '-p', cj_sources, '-o', binary, '--diagnostic-format', 'noColor'])
    executed = run('14-cj-execute', [binary])
    clean = re.sub(r'\x1b\[[0-9;]*m', '', executed)
    (out / 'cangjie-tests.clean.log').write_text(clean, encoding='utf-8')
    check('仓颉九测试实际通过', re.search(r'PASSED:\s*9', clean) is not None and re.search(r'FAILED:\s*0', clean) is not None)

    # 原 Java 九测试的真实基准；依赖从 Maven Central 固定坐标取得，文件留本机。
    deps = out / 'java-deps'
    deps.mkdir()
    jars = []
    for relative in ['junit/junit/4.13.2/junit-4.13.2.jar', 'org/hamcrest/hamcrest-core/1.3/hamcrest-core-1.3.jar']:
        url = 'https://repo.maven.apache.org/maven2/' + relative
        jar = deps / relative.rsplit('/', 1)[1]
        with urllib.request.urlopen(url, timeout=45) as response:
            jar.write_bytes(response.read())
        with urllib.request.urlopen(url + '.sha1', timeout=45) as response:
            expected = response.read().decode().split()[0]
        check('Java 依赖原站摘要 ' + jar.name, hashlib.sha1(jar.read_bytes()).hexdigest() == expected)
        jars.append(jar)
    java_classes = out / 'java-test-classes'
    java_classes.mkdir()
    classpath = os.pathsep.join(map(str, jars))
    java_sources = sorted((project / 'src/main/java').rglob('*.java')) + [project / selected]
    run('15-java-compile', [JAVAC, '-encoding', 'UTF-8', '--release', '17', '-cp', classpath, '-d', java_classes, *java_sources])
    java_result = run('16-java-execute', [JAVA, '-cp', str(java_classes) + os.pathsep + classpath, 'org.junit.runner.JUnitCore', 'org.ahocorasick.interval.IntervalTest'])
    check('Java 原九测试实际通过', 'OK (9 tests)' in java_result)
    summary = {'status': 'PASSED', 'upstream_commit': 'a546d3efbd156e02c4c9d48f2a93a0e9ddc51d29',
               'source_tests': 9, 'context_tests': 9, 'skeleton_check': passed,
               'checks_passed': len(checks), 'commands': len(commands), 'java_tests_passed': 9, 'cangjie_tests_passed': 9,
               'cangjie_sdk': version.strip(), 'scope': 'Interval class end-to-end plus synthetic interface boundary checks; not all eight upstream projects.',
               'business_modified': False, 'model_api_used': False}
    save(out / 'integration_summary.json', summary)
    print(json.dumps(summary, ensure_ascii=True, indent=2))


if __name__ == '__main__':
    main()
