"""把整体任务、新上下文和最终译文接到静态验证；输入文件保持不变。

复用骨架检查的来源校验和路径适配，另交付最终译文及上下文副本。
检查骨架与审阅最终译文使用不同目录，不能拿占位骨架当最终译文。
"""
import argparse
import json
from pathlib import Path
import shutil
import sys

from prepare_skeleton_check import prepare, load, save


def build(task_file, translated, output, bundle_id=None):
    task_file, translated, output = map(lambda p: Path(p).resolve(), (task_file, translated, output))
    task = load(task_file)
    base = task_file.parent
    bundles = [b for b in task['skeleton_bundles'] if not bundle_id or b['id'] == bundle_id]
    if len(bundles) != 1:
        raise ValueError('请指定唯一骨架 bundle')
    bundle = bundles[0]
    targets = [t for t in task['targets'] if t['skeleton_bundle_id'] == bundle['id']]
    if len(targets) != 1 or len({t['java_extraction_id'] for t in targets}) != 1:
        raise ValueError('静态验证当前每轮接收一个测试文件/执行类，请拆分任务')
    if not translated.is_dir() or not any(translated.rglob('*.cj')):
        raise ValueError('必须提供实际最终译文目录')
    if output.is_relative_to(translated) or translated.is_relative_to(output):
        raise ValueError('验证准备目录不能与最终译文目录互相包含')
    prepare(task_file, output, bundle['id'])
    try:
        manifest = load(output / 'adapter_manifest.json')
        if len(manifest['inputs']) != 1:
            raise ValueError('静态验证当前每轮接收一份 Java 提取结果')
        config = load(output / 'translation_config.json')
        config['java_members_file'] = manifest['inputs'][0]['copy']
        config['execution_classes'] = [targets[0]['source_type']]
        shutil.copytree(translated, output / '06-whole-translation/test')

        # 只读真实 suite；核对共享与逐条摘要，不修改内容来迁就新目录。
        suites = [s for s in task['context']['suites'] if s['id'] == targets[0]['context_suite_id']]
        if len(suites) != 1 or not suites[0].get('output_dir'):
            raise ValueError('缺少本测试类的实际上下文 suite 目录')
        source = (base / suites[0]['output_dir']).resolve()
        tasks = load(source / 'tasks.json')
        import hashlib
        def checked(relative, expected):
            file = (source / relative).resolve()
            if not file.is_relative_to(source) or hashlib.sha256(file.read_bytes()).hexdigest() != expected:
                raise ValueError('上下文文件越界或摘要不符: ' + relative)
            return file
        shared = checked(tasks['shared']['file'], tasks['shared']['sha256'])
        if load(shared)['index_id'] != tasks['index_id']:
            raise ValueError('共享上下文身份不一致')
        for entry in tasks['tests']:
            file = checked(entry['file'], entry['sha256'])
            value = load(file)
            pointer = (file.parent / value['shared_ref']['file']).resolve()
            if pointer != shared or value['shared_ref']['sha256'] != tasks['shared']['sha256'] or value['index_id'] != tasks['index_id']:
                raise ValueError('逐条上下文与共享身份不一致')
        whole = load(source / 'agent_context.json')
        if whole['index_id'] != tasks['index_id']:
            raise ValueError('整类上下文与任务身份不一致')
        checked('initial_context.json', whole['full_context_sha256'])
        destination = output / '04-test-context' / suites[0]['id']
        shutil.copytree(source, destination)
        config['context_files'] = [p.relative_to(output).as_posix() for p in sorted(destination.rglob('*.json'))]
        config['context_identity'] = {'index_id': tasks['index_id'], 'snapshot_id': tasks['snapshot_id']}

        # 各侧仅收到本语言的业务定义；混合材料留到联合比较阶段。
        config['side_sources'] = {'java': [], 'cangjie': []}
        project = Path(config['project_root'])
        index_file = task.get('context', {}).get('index')
        if index_file:
            index_path = (base / index_file).resolve()
            schema = load(index_path)
            if schema['index_id'] != tasks['index_id']:
                raise ValueError('传入索引与 suite 不是同一轮')
            source_manifest = (index_path.parent / schema['source_manifest']).resolve()
            if not source_manifest.is_relative_to(index_path.parent) or hashlib.sha256(source_manifest.read_bytes()).hexdigest() != schema['source_manifest_sha256']:
                raise ValueError('源码清单位置或摘要不符')
            frozen = (source_manifest.parent / load(source_manifest)['project_root']).resolve()
            if not frozen.is_relative_to(index_path.parent):
                raise ValueError('冻结源码目录越界')
            for file, facts in schema['files'].items():
                if facts.get('source_role') in {'business_source', 'support_source'}:
                    actual = (frozen / file).resolve()
                    if not actual.is_relative_to(frozen) or hashlib.sha256(actual.read_bytes()).hexdigest() != facts['source_sha256']:
                        raise ValueError('业务源码位置或摘要不符')
                    config['side_sources']['java'].append(str(actual))
        config['side_sources']['cangjie'] = [str((base / p).resolve()) for p in task.get('allowed_target_source_roots', [])]
        save(output / 'translation_config.json', config)
        save(output / 'static_adapter_manifest.json', {'task': str(task_file), 'translated': str(translated),
            'source_ids': 'UNCHANGED', 'context_identity': config['context_identity'],
            'scope': 'ONE_EXECUTION_CLASS_FINAL_WHOLE_TRANSLATION',
            'inherited_cross_file_annotations': 'REPORTED_AS_BLOCKED_BY_VALIDATOR'})
        return {'status': 'PREPARED', 'translation': str(output), 'context_files': len(config['context_files'])}
    except Exception as exc:
        save(output / 'FAILED.json', {'message': str(exc)})
        raise


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--task', required=True)
    parser.add_argument('--translated', required=True)
    parser.add_argument('--output', required=True)
    parser.add_argument('--bundle')
    args = parser.parse_args()
    try:
        print(json.dumps(build(args.task, args.translated, args.output, args.bundle), ensure_ascii=True, indent=2))
        return 0
    except Exception as exc:
        print(json.dumps({'status': 'ERROR', 'message': str(exc)}, ensure_ascii=True))
        return 1


if __name__ == '__main__':
    sys.exit(main())
