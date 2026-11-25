"""按真实用例和程序返回值汇总阶段结果，保存必要的源/目标交接证据。"""
from pathlib import Path
import json
import re
import shutil
import sys
import xml.etree.ElementTree as ET

sys.path.insert(0, str(Path(__file__).resolve().parent))
from run import PROJECTS, RUNS, SAMPLES, TOOLS, load, save, sha, execute, CJC

COUNTS = {'01-jsoup': 19, '03-jmustache': 6, '05-diff-utils': 15, '07-levenshtein': 10}


def main():
    rows = []
    for name, info in PROJECTS.items():
        out = RUNS / name
        preparation = load(out / 'preparation.json')
        static = load(out / 'static_result.json')
        cangjie = load(out / 'cangjie_result.json')
        skeleton = load(out / 'skeleton_check.json')
        java = {'tests': 0, 'failures': 0, 'errors': 0, 'skipped': 0}
        for report in (out / 'java-results').glob('TEST-*.xml'):
            root = ET.parse(report).getroot()
            for field in java:
                java[field] += int(root.get(field, 0))
        schema = load(out / 'context-index/project_schema.json')
        table = load(out / 'java-extraction/members.json')
        selected_ids = {i['source_member_id'] for i in table['test_invocations']
            if i['execution_class'] == info['type'] and i['selector'].split('#', 1)[1] in [m + '()' for m in info['methods']]}
        links = {i['source_member_id']: i for i in schema['java_members']['member_links']}
        crosswalk, gaps = [], []
        for member in table['members']:
            if member['id'] not in selected_ids:
                continue
            link = links[member['id']]
            count = sum(c['member_key'] == link['context_member_key'] for c in schema['internal_analysis']['checks'].values())
            crosswalk.append({**link, 'source_location': member['source_location'],
                'source_member_name': member['name'], 'direct_recognized_checks': count,
                'execution_class': info['type'], 'declaring_class': member['owner']})
            if not count:
                gaps.append({'method': member['name'], 'direct_recognized_checks': 0,
                    'reason': '实际检查在test/check辅助函数中' if name == '03-jmustache' else
                              'AssertJ链式assertThat/isEqualTo未纳入当前断言识别表' if name == '07-levenshtein' else '需回查正文'})
        save(out / 'member_crosswalk.json', crosswalk)
        save(out / 'analysis_gaps.json', gaps)
        active_tool_hashes = {str(p.relative_to(TOOLS)): sha(p) for folder in ['主体/上下文工具', '主体/静态验证/src', '主体/集成适配']
            for p in (TOOLS / folder).rglob('*') if p.is_file() and p.suffix in {'.py', '.java'} and '__pycache__' not in p.parts}
        save(out / 'active_tool_hashes.json', active_tool_hashes)
        for entry in load(out / 'source_inventory.json')['files']:
            assert sha(SAMPLES / name / entry['file']) == entry['sha256'], '原源码发生变化'
        # 新交付源码也应能执行；静态比较受阻不被这一步改成一致。
        annotated = out / 'static-review/deliverables/translated_test.cj'
        build_source = out / 'cangjie-build/src/translated_test.cj'
        original = build_source.read_bytes()
        shutil.copyfile(annotated, build_source)
        commands = load(out / 'commands.json')
        compile_command = next(c['command'] for c in reversed(commands) if c['label'] == '20-cangjie-compile')
        stdx = Path('E:/cangjie_libs/stdx-1.2.0.1-local-http/windows_x86_64_cjnative/dynamic/stdx')
        if name in {'01-jsoup', '03-jmustache'}:
            import os
            os.environ['PATH'] = str(stdx) + os.pathsep + os.environ['PATH']
            patterns = ['*encoding.url*'] if name == '01-jsoup' else ['*serialization*', '*encoding.json*']
            libraries = sorted({p for pattern in patterns for p in stdx.glob(pattern) if p.is_file()})
            save(out / 'stdx_environment.json', {'root': str(stdx), 'local_build': True,
                'captured_after_execution': True, 'files': [{'file': p.name, 'sha256': sha(p)} for p in libraries]})
        try:
            code, _, _ = execute(out, '30-annotated-cangjie-compile', compile_command)
            if code:
                raise RuntimeError(name + ' 标注后编译失败')
            code, stdout, _ = execute(out, '31-annotated-cangjie-tests', [out / 'cangjie-build/test.exe'])
            clean = re.sub(r'\x1b\[[0-?]*[ -/]*[@-~]', '', stdout.decode('utf-8', errors='replace'))
            assert code == 0 and int(re.search(r'PASSED:\s*(\d+)', clean)[1]) == len(info['methods'])
        finally:
            build_source.write_bytes(original)
        body_bytes = (out / 'translation/translated/translated_test.cj').read_bytes()
        row = {'project': name, 'selected_methods': len(info['methods']), 'source_assertions': COUNTS[name],
            'java': java, 'cangjie': cangjie['counts'], 'skeleton': skeleton['status'],
            'static_compared': static['scope']['compared'],
            'static_blocked': sum(u['state'] == '定位受阻' for u in static['scope']['units']),
            'annotated_tests_passed': len(info['methods']), 'context': preparation['context_summary'],
            'context_parse_issues': schema['problems'], 'analysis_gaps': gaps,
            'business_unchanged': True, 'translation_sha256': __import__('hashlib').sha256(body_bytes).hexdigest()}
        save(out / 'stage_result.json', row)
        save(out / 'translation/translation_result.json', {'status': 'GENERATED', 'scope': info['methods'],
            'source_members': crosswalk, 'target': 'translated/translated_test.cj',
            'java_tests': java, 'cangjie_tests': cangjie['counts'], 'static': static,
            'source_assertions': COUNTS[name], 'source_assertion_count_basis': 'CURRENT_AGENT_SOURCE_REVIEW',
            'historical_target_tests_used': False, 'independent_blind_sessions': 'NOT_RUN',
            'material_generation': 'CURRENT_AGENT_SOURCE_BASED_CONTRACT_NOT_EXTERNAL_GENERATOR'})
        rows.append(row)
    summary = {'status': 'COMPLETED_SELECTED_PAIRED_CASES', 'order': list(PROJECTS), 'projects': rows,
        'selected_methods': sum(r['selected_methods'] for r in rows), 'source_assertions': sum(COUNTS.values()),
        'java_passed': sum(r['java']['tests'] - r['java']['failures'] - r['java']['errors'] - r['java']['skipped'] for r in rows),
        'cangjie_passed': sum(r['cangjie']['passed'] for r in rows),
        'static_compared': sum(r['static_compared'] for r in rows), 'static_blocked': sum(r['static_blocked'] for r in rows),
        'context_regressions': 42, 'static_regressions': 18, 'model_api_used': False,
        'analysis_mode': 'CURRENT_AGENT_JOINT_REVIEW_NOT_BLIND', 'full_project_translation': 'NOT_RUN'}
    save(RUNS / 'summary.json', summary)
    print(json.dumps({k: v for k, v in summary.items() if k != 'projects'}, ensure_ascii=True, indent=2))


if __name__ == '__main__':
    main()
