"""按项目串行复测真实配对用例。只操作新的运行目录，不改业务或原测试。"""
import argparse
import hashlib
import json
import os
from pathlib import Path
import shutil
import subprocess
import sys
import time
import urllib.request

TOOLS = Path('D:/CodexArtifacts/week12-integration-20261125/repository')
SAMPLES = Path('D:/CodexArtifacts/four-projects-20261125/样例材料/01-双语评测项目/projects')
RUNS = Path('D:/CodexArtifacts/four-projects-tests-20261125')
JAVA = 'C:/Program Files/Java/jdk-17/bin/java.exe'
JAVAC = 'C:/Program Files/Java/jdk-17/bin/javac.exe'
CJC = 'E:/cangjie/bin/cjc.exe'
PROJECTS = {
    '01-jsoup': {'type': 'org.jsoup.select.SelectorTest', 'file': 'src/test/java/org/jsoup/select/SelectorTest.java',
        'methods': ['testByTag', 'byEscapedTag', 'testById', 'byEscapedId', 'testByClass'],
        'support': ['src/test/java/org/jsoup/TextUtil.java', 'src/test/java/org/jsoup/MultiLocaleExtension.java'],
        'package': 'cangjie_tpc::html4cj'},
    '03-jmustache': {'type': 'com.samskivert.mustache.MustacheTest', 'file': 'src/test/java/com/samskivert/mustache/MustacheTest.java',
        'methods': ['testSimpleVariable', 'testPrimitiveArrayVariable', 'testPrimitiveArrayIndexVariable',
                    'testPrimitiveArrayIndexOutOfBoundsVariable', 'testOneShotSection', 'testListSection'],
        'support': 'ALL', 'package': 'cjmustache'},
    '05-diff-utils': {'type': 'diffutils.DiffTest', 'file': 'src/test/java/diffutils/DiffTest.java',
        'methods': ['testDiff_Insert', 'testDiff_Delete', 'testDiff_Change'], 'support': [], 'package': 'diffutils4cj'},
    '07-levenshtein': {'type': 'org.apache.commons.text.similarity.LevenshteinDistanceTest',
        'file': 'src/test/java/org/apache/commons/text/similarity/LevenshteinDistanceTest.java',
        'methods': ['testGetLevenshteinDistance_StringString'], 'support': [], 'package': 'leven4cj'},
}


def save(path, data):
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(data, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')


def load(path):
    return json.loads(path.read_text(encoding='utf-8-sig'))


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def environment():
    return {**os.environ, 'PYTHONIOENCODING': 'utf-8', 'PYTHONDONTWRITEBYTECODE': '1',
        'PP_TEST_JAVA': JAVA, 'PP_TEST_JAVAC': JAVAC, 'TEMP': str(RUNS), 'TMP': str(RUNS),
        'CANGJIE_HOME': 'E:/cangjie',
        'PATH': 'E:/cangjie/bin;E:/cangjie/runtime/lib/windows_x86_64_cjnative;' + os.environ['PATH']}


def execute(out, label, command, timeout=300):
    start = time.monotonic()
    try:
        done = subprocess.run(list(map(str, command)), env=environment(), capture_output=True, cwd=out, timeout=timeout)
        stdout, stderr, code = done.stdout, done.stderr, done.returncode
    except subprocess.TimeoutExpired as exc:
        stdout, stderr, code = exc.stdout or b'', (exc.stderr or b'') + b'\nTIMEOUT', -999
    commands = load(out / 'commands.json') if (out / 'commands.json').exists() else []
    attempt = sum(item['label'] == label for item in commands)
    for suffix, data in [('stdout', stdout), ('stderr', stderr)]:
        log = out / (label + '.' + suffix + '.log')
        if log.exists():
            shutil.copyfile(log, out / (label + '.previous-' + str(attempt) + '.' + suffix + '.log'))
        log.write_bytes(data)
    commands.append({'label': label, 'command': list(map(str, command)), 'returncode': code,
                     'elapsed_seconds': round(time.monotonic() - start, 3)})
    save(out / 'commands.json', commands)
    print(label + ': ' + str(code) + ', ' + str(commands[-1]['elapsed_seconds']) + 's', flush=True)
    return code, stdout, stderr


def require_success(result, label):
    code, stdout, stderr = result
    if code:
        raise RuntimeError(label + ': ' + (stdout + stderr).decode('utf-8', errors='replace')[-3000:])
    return stdout


def dependency(relative):
    folder = RUNS / 'dependencies'
    folder.mkdir(parents=True, exist_ok=True)
    target = folder / relative.rsplit('/', 1)[1]
    if target.exists():
        return target
    url = 'https://repo.maven.apache.org/maven2/' + relative
    for attempt in range(3):
        try:
            with urllib.request.urlopen(url, timeout=45) as response:
                data = response.read()
            break
        except Exception:
            if attempt == 2:
                raise
    with urllib.request.urlopen(url + '.sha1', timeout=45) as response:
        expected = response.read().decode().split()[0]
    if hashlib.sha1(data).hexdigest() != expected:
        raise ValueError('依赖原站摘要不符: ' + relative)
    target.write_bytes(data)
    save(folder / (target.name + '.json'), {'url': url, 'sha256': sha(target), 'upstream_sha1': expected})
    return target


def prepare(name):
    info = PROJECTS[name]
    source = SAMPLES / name
    project = source / 'java'
    out = RUNS / name
    out.mkdir(parents=True, exist_ok=True)
    inventory = [{'file': str(p.relative_to(source)), 'sha256': sha(p), 'size': p.stat().st_size}
                 for p in source.rglob('*') if p.is_file() and '.git' not in p.parts and
                 (p.is_relative_to(project) or p.is_relative_to(source / 'cangjie/src'))]
    save(out / 'source_inventory.json', {'source_commit': 'c99fc226ac87379b9eaf81a9a61d52a32b86c822',
        'source': str(source), 'tools_commit': 'dbe58c8f4ff3849d2968471e41314842b6d3b3e7',
        'selected': info, 'files': inventory,
        'java_files': len(list(project.rglob('*.java'))), 'business_cangjie_files': len(list((source / 'cangjie/src').rglob('*.cj')))})
    console = dependency('org/junit/platform/junit-platform-console-standalone/1.9.2/junit-platform-console-standalone-1.9.2.jar')
    deps = [console]
    if name == '01-jsoup':
        deps.append(dependency('com/google/code/findbugs/jsr305/3.0.2/jsr305-3.0.2.jar'))
    if name == '03-jmustache':
        deps.append(dependency('org/yaml/snakeyaml/2.7/snakeyaml-2.7.jar'))
    if name == '07-levenshtein':
        deps.extend([dependency('org/assertj/assertj-core/3.24.2/assertj-core-3.24.2.jar'),
                     dependency('org/apache/commons/commons-lang3/3.14.0/commons-lang3-3.14.0.jar')])
    classes = RUNS / 'extractor-classes'
    if not classes.exists():
        classes.mkdir()
        require_success(execute(out, '01-extractor-javac', [JAVAC, '-encoding', 'UTF-8', '-d', classes,
            TOOLS / '主体/Java骨架提取器/JavaTestSkeletonExtractor.java']), 'compile extractor')
    extraction_input = project / 'src/test/java' if name == '03-jmustache' else project / info['file']
    if not (out / 'java-extraction/members.json').exists():
        require_success(execute(out, '02-extract', [JAVA, '-cp', classes, 'JavaTestSkeletonExtractor', '--input', extraction_input,
                                                  '--output', out / 'java-extraction']), 'extract')
    failed = out / 'context-index'
    if failed.exists() and not (failed / 'context_manifest.json').exists():
        attempt = 1
        while (out / ('context-index-failed-' + str(attempt))).exists():
            attempt += 1
        if not failed.resolve().is_relative_to(RUNS.resolve()):
            raise ValueError('失败目录不在本轮工作区内')
        failed.rename(out / ('context-index-failed-' + str(attempt)))
    if not (out / 'context-index/context_manifest.json').is_file():
        require_success(execute(out, '03-context-build', [sys.executable, TOOLS / '主体/上下文工具/context_tool.py', 'build',
        '--project', project, '--test-scope', info['file'], '--java-members', out / 'java-extraction/members.json',
        '--output', out / 'context-index', '--java', JAVA, '--javac', JAVAC,
            *[value for jar in deps for value in ['--classpath', jar]]], timeout=600), 'context build')
    if not (out / 'context-suite/tasks.json').is_file():
        require_success(execute(out, '04-context-suite', [sys.executable, TOOLS / '主体/上下文工具/context_tool.py', 'suite',
        '--index', out / 'context-index/project_schema.json', '--target', info['type'], '--output', out / 'context-suite']), 'suite')
    classpath = os.pathsep.join(map(str, deps))
    java_sources = sorted(p for p in (project / 'src/main/java').rglob('*.java') if p.name != 'module-info.java')
    if name == '07-levenshtein':
        # 已配对范围只需要距离实现；完整 Commons Text 中无关文件存在原始编码问题。
        # 让 javac 按源码路径编译真实依赖闭包，不改写或转码源文件。
        java_sources = [project / 'src/main/java/org/apache/commons/text/similarity/LevenshteinDistance.java']
    java_sources.append(project / info['file'])
    java_sources.extend((project / 'src/test/java').rglob('*.java') if info['support'] == 'ALL' else [project / p for p in info['support']])
    java_sources = sorted(set(java_sources))
    target = out / 'java-test-classes'
    target.mkdir(exist_ok=True)
    arguments = ['-encoding', 'UTF-8', '-proc:none', '--release', '17', '-cp', classpath, '-d', str(target), *map(str, java_sources)]
    if name == '07-levenshtein':
        arguments = ['-sourcepath', str(project / 'src/main/java'), *arguments]
    (out / 'javac.args').write_text('\n'.join('"' + arg.replace('\\', '/') + '"' for arg in arguments), encoding='utf-8')
    require_success(execute(out, '05-java-compile', [JAVAC, '-J-Dfile.encoding=UTF-8', '@' + str(out / 'javac.args')]), 'source Java compile')
    for resource in ['src/main/resources', 'src/test/resources']:
        if (project / resource).is_dir():
            shutil.copytree(project / resource, target, dirs_exist_ok=True)
    run = [JAVA, '-jar', console, '--class-path', os.pathsep.join([str(target), *map(str, deps[1:])]),
           '--disable-ansi-colors', '--details', 'summary', '--reports-dir', out / 'java-results']
    run.extend([value for method in info['methods'] for value in ['--select-method', info['type'] + '#' + method]])
    result = execute(out, '06-java-selected-tests', run)
    save(out / 'preparation.json', {'status': 'PREPARED' if result[0] == 0 else 'JAVA_BASELINE_FAILED',
        'project': name, 'selected_methods': info['methods'], 'selected_count': len(info['methods']),
        'java_returncode': result[0], 'dependencies': [{'path': str(d), 'sha256': sha(d)} for d in deps],
        'context_summary': load(out / 'context-index/project_schema.json')['summary']})
    print(json.dumps(load(out / 'preparation.json'), ensure_ascii=True, indent=2), flush=True)


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('action', choices=['prepare'])
    parser.add_argument('--project', choices=list(PROJECTS), required=True)
    args = parser.parse_args()
    RUNS.mkdir(parents=True, exist_ok=True)
    prepare(args.project)
