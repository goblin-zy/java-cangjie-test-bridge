"""Check a frozen handoff without reading the original project or business code."""
import argparse
import hashlib
import json
from pathlib import Path

from analysis_reports import member_key


def check(run):
    root = Path(run).resolve()

    def safe(relative):
        p = (root / relative).resolve()
        if not p.is_relative_to(root) or p == root:
            raise ValueError('交接路径越界: ' + relative)
        return p

    def load(relative):
        return json.loads(safe(relative).read_text(encoding='utf-8'))

    if safe('FAILED.json').exists():
        raise ValueError('本轮有FAILED.json，拒绝作为完整交接')
    h = load('handoff.json')
    if h.get('schema_version') != '1.1':
        raise ValueError('此检查器只支持schema_version=1.1；请核对交接格式')
    manifest = load('manifest.json')
    actual = {p.relative_to(root).as_posix() for p in root.rglob('*') if p.is_file()} - {'manifest.json'}
    if actual != set(manifest):
        raise ValueError('输出文件集合与manifest不一致')
    for rel, digest in manifest.items():
        if hashlib.sha256(safe(rel).read_bytes()).hexdigest() != digest:
            raise ValueError('输出摘要不符: ' + rel)
    for field in ['input_root', 'members', 'structure', 'external_references', 'inventory', 'issues',
                  'test_candidates', 'prompt', 'report', 'consumer_guide', 'downstream_handoff',
                  'capabilities', 'source_mapping', 'features']:
        if not safe(h[field]).exists():
            raise ValueError('入口缺少文件: ' + field)
    for field in ['members', 'capabilities', 'source_mapping', 'features', 'downstream_handoff']:
        if load(h[field])['snapshot_id'] != h['snapshot_id']:
            raise ValueError('快照不一致: ' + field)
    inventory = load(h['inventory'])
    for record in inventory:
        copied = safe(h['input_root'] + '/' + record['file'])
        if hashlib.sha256(copied.read_bytes()).hexdigest() != record['sha256']:
            raise ValueError('输入副本摘要不符: ' + record['file'])
    mapping = load(h['source_mapping'])
    expected = {r['file']: r['sha256'] for r in inventory}
    if mapping['transformation'] != 'IDENTITY_ONLY' or mapping['rewrites']:
        raise ValueError('本版必须为恒等映射')
    if len(mapping['files']) != len(expected):
        raise ValueError('源文件映射数量不符')
    seen = set()
    for record in mapping['files']:
        rel = record['source_relative_path']
        if rel in seen or record['frozen_path'] != h['input_root'] + '/' + rel:
            raise ValueError('源文件映射重复或路径不符')
        seen.add(rel)
        if record['source_sha256'] != expected.get(rel) or record['frozen_sha256'] != expected.get(rel):
            raise ValueError('源文件映射摘要不符')
    keys = set()
    members = load(h['members'])['members']
    for m in members:
        if m['file'] not in expected:
            raise ValueError('成员来源不在清单中')
        raw = safe(h['input_root'] + '/' + m['file']).read_bytes().decode('utf-8').encode('utf-16-le')
        a, b = m['start'], m['end']
        if not 0 <= a <= b <= len(raw) // 2 or raw[a*2:b*2].decode('utf-16-le') != m['original_source']:
            raise ValueError('成员原文与区间不符')
        key = m['source_member_key']
        if key != member_key(h['snapshot_id'], m) or key in keys:
            raise ValueError('成员身份错误或重复')
        keys.add(key)
    for feature in load(h['features'])['features']:
        if not feature['source_member_keys'] or not set(feature['source_member_keys']) <= keys:
            raise ValueError('特性引用了未知成员')
    for consumer in load(h['downstream_handoff'])['consumers']:
        for rel in consumer['available'] + [consumer['prompt']]:
            if not safe(rel).exists():
                raise ValueError('消费者引用了不存在的材料: ' + rel)
    return {'status': 'HANDOFF_MATERIAL_CHECKS_PASSED', 'material_status': h['status'],
            'snapshot_id': h['snapshot_id'], 'members': len(members),
            'original_project_compared': False, 'test_execution': 'NOT_RUN',
            'target_semantics': 'NOT_VERIFIED', 'translation_improvement': 'NOT_EVALUATED'}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--run', required=True, help='本轮结果根目录，不是源工程')
    args = parser.parse_args()
    try:
        print(json.dumps(check(args.run), ensure_ascii=False, indent=2))
    except (ValueError, OSError, KeyError, TypeError) as error:
        parser.exit(1, str(error) + '\n')


if __name__ == '__main__':
    main()
