"""Test-only identity preprocessing: no production-source discovery or rewriting."""
import argparse
import hashlib
import json
from pathlib import Path
import subprocess
import tempfile
import sys
from html import escape
from datetime import datetime
from analysis_reports import (VERSION, CONSUMERS, member_key, feature_report,
                              capability_report, source_mapping, downstream_report)

HERE = Path(__file__).resolve().parent


def save(path, obj):
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(obj, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')


def sha(data):
    return hashlib.sha256(data).hexdigest()


def walk(root):
    for p in sorted(root.iterdir()):
        if p.is_symlink() or (hasattr(p, 'is_junction') and p.is_junction()):
            raise ValueError('测试输入中存在链接，请明确提供实际目录: ' + p.name)
        if p.is_dir():
            yield from walk(p)
        elif p.is_file():
            yield p


def prepare(project, output, test_roots=None, resource_roots=None, java='java', javac='javac'):
    project, out = Path(project).resolve(), Path(output).resolve()
    if not project.is_dir():
        raise ValueError('找不到工程目录：' + str(project) + '\n请将--project或配置中的project填写为实际存在的工程目录。')
    if out.exists():
        raise ValueError('结果目录已存在：' + str(out) + '\n请更换--output或配置中的output目录名称。运行随包样例可使用--sample自动创建新目录。')
    if out.is_relative_to(project) or project.is_relative_to(out):
        raise ValueError('结果位置与输入工程重叠：' + str(out) + '\n请选择工程之外的独立结果目录。')
    tests = test_roots if test_roots is not None else ['src/test/java']
    if not isinstance(tests, list) or not tests:
        raise ValueError('测试源码根列表必须非空；不会回退为其他目录')
    resources = resource_roots if resource_roots is not None else (['src/test/resources'] if (project/'src/test/resources').is_dir() else [])
    # Roots are explicit: never fall back to scanning the whole repository.
    roots = []
    for kind, values in [('test_source', tests), ('test_resource', resources)]:
        for rel in values:
            if not isinstance(rel, str) or not rel:
                raise ValueError('测试根必须为非空路径字符串')
            declared = project / rel
            for component in [declared, *declared.parents]:
                if component == project:
                    break
                if component.is_symlink() or (hasattr(component, 'is_junction') and component.is_junction()):
                    raise ValueError('测试根路径中存在链接，请提供实际目录: ' + rel)
            p = (project / rel).resolve()
            if not p.is_relative_to(project) or p == project or not p.is_dir():
                raise ValueError('测试根须是工程内部存在的子目录: ' + rel)
            if 'src/main' in p.relative_to(project).as_posix():
                raise ValueError('测试范围排除src/main目录；仅接受明确的测试／测试资源根')
            roots.append((kind, p))
    for i, (_, a) in enumerate(roots):
        for _, b in roots[i+1:]:
            if a.is_relative_to(b) or b.is_relative_to(a):
                raise ValueError('输入根不能重复或相互包含')
    out.mkdir(parents=True)
    try:
        (out/'input').mkdir()
        inventory, java_files, originals, issues = [], [], {}, []
        for kind, root in roots:
            for p in walk(root):
                rel = p.relative_to(project).as_posix()
                if kind == 'test_source' and p.suffix != '.java':
                    issues.append({'kind': 'NON_JAVA_NOT_COPIED', 'file': rel, 'note': '需要的文件请另纳入测试资源根'})
                    continue
                data = p.read_bytes()
                dest = out / 'input' / rel
                dest.parent.mkdir(parents=True, exist_ok=True)
                dest.write_bytes(data)
                originals[rel] = p
                inventory.append({'file': rel, 'kind': kind, 'sha256': sha(data), 'size': len(data), 'operation': 'BYTE_IDENTICAL_COPY'})
                if kind == 'test_source':
                    try:
                        data.decode('utf-8')
                        java_files.append(dest.resolve())
                    except UnicodeDecodeError:
                        issues.append({'kind': 'SOURCE_ENCODING_NOT_UTF8', 'file': rel, 'analysis': 'NOT_PARSED'})
        snapshot = sha(json.dumps(inventory, sort_keys=True, ensure_ascii=False).encode('utf-8'))
        facts = {'files': [], 'errors': []}
        if java_files:
            with tempfile.TemporaryDirectory(prefix='test-only-') as td:
                temp = Path(td)
                listing = temp / 'files.txt'
                listing.write_text('\n'.join(map(str, java_files)), encoding='utf-8')
                for cmd in [[javac, '-encoding', 'UTF-8', '-d', str(temp), str(HERE/'tools/JavaFacts.java')],
                            [java, '-Dfile.encoding=UTF-8', '-cp', str(temp), 'JavaFacts', str(listing)]]:
                    result = subprocess.run(cmd, capture_output=True, timeout=180, creationflags=getattr(subprocess,'CREATE_NO_WINDOW',0))
                    if result.returncode:
                        raise ValueError('分析器执行失败: ' + result.stderr.decode('utf-8', errors='replace'))
                facts = json.loads(result.stdout.decode('utf-8'))
        members, imports, candidates = [], [], []
        for f in facts['files']:
            rel = Path(f['path']).relative_to(out/'input').as_posix()
            f['path'] = rel
            raw = (out/'input'/rel).read_bytes().decode('utf-8').encode('utf-16-le')
            for imp in f['imports']:
                imports.append({'file': rel, 'import': imp, 'status': 'RECORDED_NOT_RESOLVED',
                                'note': '不展开业务、框架或JDK源码；导入记录不证明当前测试必需'})
            for m in f['members']:
                a, b = m['start'], m['end']
                if not 0 <= a <= b <= len(raw)//2:
                    issues.append({'kind': 'INVALID_MEMBER_POSITION', 'file': rel, 'member': m['id']})
                    continue
                entry = dict(m, file=rel, original_source=raw[a*2:b*2].decode('utf-16-le'), source_sha256=sha((out/'input'/rel).read_bytes()))
                entry['source_member_key'] = member_key(snapshot, entry)
                members.append(entry)
                if m['kind'] == 'method':
                    annotations = m.get('annotations', [])
                    if any(x.rsplit('.',1)[-1] in {'Test','ParameterizedTest','RepeatedTest','TestFactory','TestTemplate'} for x in annotations):
                        candidates.append({'member': m['id'], 'source_member_key': entry['source_member_key'], 'file': rel, 'annotations': annotations, 'status': 'ANNOTATION_NAME_CANDIDATE_NOT_RUNTIME_DISCOVERY'})
        for e in facts['errors']:
            if e.get('path'):
                e['path'] = Path(e['path']).relative_to(out/'input').as_posix()
            issues.append({'kind': 'JAVA_PARSE_ERROR', **e})
        # Verify copying against inputs; analysis never changes original or frozen test bytes.
        for rec in inventory:
            rel = rec['file']
            if sha(originals[rel].read_bytes()) != rec['sha256'] or sha((out/'input'/rel).read_bytes()) != rec['sha256']:
                raise ValueError('输入在处理过程中发生变化: ' + rel)
        save(out/'inventory.json', inventory)
        save(out/'members.json', {'snapshot_id': snapshot, 'members': members, 'offset_unit': 'UTF-16 code units, end exclusive'})
        save(out/'test_candidates.json', candidates)
        save(out/'external_references.json', {'imports': imports, 'calls': [{'file': f['path'], **c} for f in facts['files'] for c in f['calls']],
                                             'resolution': 'NOT_ATTEMPTED', 'production_source_read': False})
        save(out/'test_structure.json', facts)
        save(out/'capabilities.json', capability_report(snapshot))
        save(out/'source_mapping.json', source_mapping(snapshot, inventory, members))
        save(out/'translation_features.json', feature_report(snapshot, members, facts))
        save(out/'issues.json', issues)
        status = 'ANALYZED_WITH_LIMITATIONS' if candidates else 'NO_TEST_CANDIDATE_REVIEW_REQUIRED'
        if facts['errors'] or any(x['kind'] in {'SOURCE_ENCODING_NOT_UTF8', 'INVALID_MEMBER_POSITION'} for x in issues):
            status = 'PARTIAL_ANALYSIS_REVIEW_REQUIRED'
        h = {'version': VERSION, 'schema_version': '1.1', 'snapshot_id': snapshot, 'status': status, 'input_root': 'input',
             'capabilities': 'capabilities.json', 'source_mapping': 'source_mapping.json', 'features': 'translation_features.json',
             'test_roots': [p.relative_to(project).as_posix() for k,p in roots if k=='test_source'],
             'resource_roots': [p.relative_to(project).as_posix() for k,p in roots if k=='test_resource'],
             'members': 'members.json', 'structure': 'test_structure.json', 'external_references': 'external_references.json',
             'inventory': 'inventory.json', 'issues': 'issues.json', 'test_candidates': 'test_candidates.json',
             'prompt': '交接提示词.md', 'report': '结果阅读说明.html', 'consumer_guide': '下游模块使用说明.md', 'downstream_handoff': 'downstream_handoff.json', 'source_transformation': 'IDENTITY_ONLY',
             'production_source_read': False, 'test_execution': 'NOT_RUN', 'target_semantics': 'NOT_VERIFIED',
             'input_scope_authority': 'USER_DECLARED_TEST_ROOTS_NOT_SEMANTIC_CLASSIFICATION'}
        save(out/'downstream_handoff.json', downstream_report(snapshot, status))
        save(out/'handoff.json', h)
        (out/'交接提示词.md').write_text((HERE.parent/'prompts/handoff.md').read_text(encoding='utf-8'), encoding='utf-8')
        (out/'prompts').mkdir()
        for _, prompt, *_ in CONSUMERS:
            (out/'prompts'/prompt).write_bytes((HERE.parent/'prompts'/prompt).read_bytes())
        (out/'下游模块使用说明.md').write_bytes((HERE.parents[1]/'说明文档/下游模块使用说明.md').read_bytes())
        (out/'结果阅读说明.html').write_text('''<!doctype html><html lang="zh-CN"><meta charset="utf-8"><title>本轮预处理结果</title>
<style>body{font:17px/1.8 sans-serif;max-width:900px;margin:40px auto;padding:0 24px;color:#25334a}table{border-collapse:collapse}td{padding:8px 24px;border:1px solid #ccd5df}a{color:#1763ae}code{overflow-wrap:anywhere}</style>
<h1>本轮仅测试预处理结果</h1><p>当前状态：<strong>'''+escape(status)+'''</strong></p>
<table><tr><td>测试Java文件</td><td>'''+str(sum(r['kind']=='test_source' for r in inventory))+'''</td></tr>
<tr><td>测试资源</td><td>'''+str(sum(r['kind']=='test_resource' for r in inventory))+'''</td></tr>
<tr><td>成员记录</td><td>'''+str(len(members))+'''</td></tr><tr><td>问题记录</td><td>'''+str(len(issues))+'''</td></tr></table>
<p>源码与选定资源按原字节保存，业务源码未读取。未执行JUnit或仓颉测试；这些数量不证明翻译语义或检错能力。</p>
<p>本版能力及未实现项见<a href="capabilities.json">能力清单</a>；<a href="translation_features.json">特性清单</a>仅为有限语法分析，不代表完整测试关系或语义判定。</p>
<h2>下一步</h2><ol><li>查看<a href="issues.json">问题记录</a>，分析完成不表示没有限制。</li>
<li>将整个本轮目录交给负责组员，不只发送一个JSON。</li><li>对照<a href="下游模块使用说明.md">下游模块使用说明</a>确认本模块的输入输出；Agent同时读取<a href="交接提示词.md">交接提示词</a>和<a href="downstream_handoff.json">下游交接清单</a>。</li></ol>
<p>程序入口：<a href="handoff.json">handoff.json</a>。输入原文在input文件夹。请勿直接改动本冻结结果。</p><p>本轮源码版本：<code>'''+snapshot+'''</code></p></html>''', encoding='utf-8')
        save(out/'manifest.json', {p.relative_to(out).as_posix():sha(p.read_bytes()) for p in out.rglob('*') if p.is_file()})
        return h
    except Exception as exc:
        save(out/'FAILED.json', {'reason': str(exc)})
        raise


def main():
    if hasattr(sys.stdout, 'reconfigure'):
        sys.stdout.reconfigure(encoding='utf-8')
    p = argparse.ArgumentParser(description='保存Java测试原文并生成分析与交接材料。')
    p.add_argument('--sample', action='store_true', help='运行随包样例，默认自动创建带时间标记的新结果目录')
    p.add_argument('--json', action='store_true', help='终端输出JSON索引，供程序读取；默认显示中文结果摘要')
    p.add_argument('--project', help='工程根；不会扫描整个工程')
    p.add_argument('--output', help='工程外尚不存在的新目录')
    p.add_argument('--test-root', action='append', help='工程相对测试源码根，可重复；默认src/test/java')
    p.add_argument('--resource-root', action='append', help='工程相对测试资源根，可重复')
    p.add_argument('--java', help='覆盖配置的java可执行文件；默认PATH中的java')
    p.add_argument('--javac', help='覆盖配置的javac可执行文件；默认PATH中的javac')
    p.add_argument('--config', help='配置JSON路径；其中project/output相对配置文件目录，命令行路径相对当前终端')
    a = p.parse_args()
    try:
        config = {}
        if a.sample:
            if a.config or a.project or a.test_root is not None or a.resource_root is not None:
                raise ValueError('--sample使用随包输入；请单独使用，或搭配--output、--java、--javac、--json。')
            root = HERE.parents[1]
            a.project = str(root/'样例/结果/input')
            if not a.output:
                a.output = str(root/'输出'/('样例运行_' + datetime.now().strftime('%Y%m%d_%H%M%S_%f')))
        if a.config:
            cfg_path = Path(a.config).resolve()
            config = json.loads(cfg_path.read_text(encoding='utf-8-sig'))
            if not isinstance(config, dict):
                raise ValueError('配置须为JSON对象')
            for key in ['project', 'output']:
                if key in config:
                    config[key] = str((cfg_path.parent / config[key]).resolve())
        project, output = a.project or config.get('project'), a.output or config.get('output')
        if not project or not output:
            raise ValueError('请通过配置或命令行提供project和output')
        test_roots = a.test_root if a.test_root is not None else config.get('test_roots')
        resource_roots = a.resource_root if a.resource_root is not None else config.get('resource_roots')
        for value in [test_roots, resource_roots]:
            if value is not None and (not isinstance(value,list) or any(not isinstance(x,str) for x in value)):
                raise ValueError('test_roots/resource_roots须为字符串列表')
        java = a.java or config.get('java', 'java')
        javac = a.javac or config.get('javac', 'javac')
        result = prepare(project,output,test_roots,resource_roots,java,javac)
        if a.json:
            print(json.dumps(result,ensure_ascii=False,indent=2))
        else:
            location = Path(output).resolve()
            inventory = json.loads((location/'inventory.json').read_text(encoding='utf-8'))
            issues = json.loads((location/'issues.json').read_text(encoding='utf-8'))
            status_text = {
                'ANALYZED_WITH_LIMITATIONS': '分析已完成，请按问题记录和能力范围使用材料',
                'PARTIAL_ANALYSIS_REVIEW_REQUIRED': '分析已生成，部分内容需要复核',
                'NO_TEST_CANDIDATE_REVIEW_REQUIRED': '分析已生成，请核对测试候选与实际框架',
            }
            print('预处理结果：' + status_text.get(result['status'], result['status']))
            print('输入工程：' + str(Path(project).resolve()))
            print('结果目录：' + str(location))
            print('已保存：' + str(sum(x['kind']=='test_source' for x in inventory)) + '个Java文件，' +
                  str(sum(x['kind']=='test_resource' for x in inventory)) + '个资源；问题记录：' + str(len(issues)) + '条')
            print('接下来：打开结果目录中的“结果阅读说明.html”，或从handoff.json读取各文件入口。')
            print('交接时提交整个结果目录。测试执行与译文验证由下游安排。')
    except (ValueError,OSError,subprocess.SubprocessError) as e:
        print(str(e),file=sys.stderr)
        return 1
    return 0


if __name__=='__main__':
    raise SystemExit(main())
