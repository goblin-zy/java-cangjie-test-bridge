"""Check the supported declaration shapes and generate the handoff mapping."""
import hashlib
import json
from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[1]
TARGET = ROOT / '03-cangjie-skeleton'
CASES = {
    'smart-library': ('week8_library', 'DefaultBorrowPolicyUnitTest'),
    'commons-io': ('week8_io', 'ByteOrderMarkTest'),
}


def require(condition, message):
    if not condition:
        raise ValueError(message)


def main():
    mapping = []
    for group, (package, cls) in CASES.items():
        java = ROOT / '02-java-skeleton' / group
        metadata = json.loads((java / 'members.json').read_text(encoding='utf-8'))
        require(metadata['summary']['errors'] == 0, f'{group}: 提取存在错误')
        for entry in metadata['files']:
            for kind, hash_key in [('original', 'source_sha256'), ('skeleton', 'skeleton_sha256')]:
                path = java / entry[kind + '_file']
                require(hashlib.sha256(path.read_bytes()).hexdigest() == entry[hash_key], f'哈希不一致 {path}')
        path = TARGET / 'model-output' / (cls + '.cj')
        code = path.read_text(encoding='utf-8')
        require(re.search(rf'^package {package}$', code, re.M), f'{group}: 包名不符')
        require(re.findall(r'^@Test\s*\nclass (\w+)\s*\{', code, re.M) == [cls], f'{group}: 测试类不符')
        methods = re.findall(r'^[ \t]*func (\w+)\(', code, re.M)
        fields = re.findall(r'^[ \t]*(?:private )?(?:static )?(?:let|var) (\w+)\s*:', code, re.M)
        require(sorted(methods) == sorted(m['name'] for m in metadata['members'] if m['role'] == 'test'), f'{group}: 测试成员遗漏或重复')
        require(sorted(fields) == sorted(m['name'] for m in metadata['members'] if m['role'] == 'field'), f'{group}: 字段遗漏或重复')
        for member in metadata['members']:
            name = member['name']
            if member['role'] == 'test':
                require(member['return_type'] == 'void' and not member['parameter_types'], f'签名超出检查范围 {name}')
                pattern = rf'@TestCase\s+func {name}\(\): Unit \{{\s*throw Exception\("SKELETON_PLACEHOLDER: {name}"\)\s*\}}'
                slot = 'body'
            elif member['role'] == 'field':
                require(member['type'] == 'ByteOrderMark' and 'static final' in member['declaration'], f'字段超出检查范围 {name}')
                pattern = rf'private static let {name}: Option<ByteOrderMark> = None'
                slot = 'initializer'
            else:
                raise ValueError(f'未支持角色 {member["role"]}')
            match = re.search(pattern, code)
            require(match, f'目标声明或占位不符 {name}')
            mapping.append({
                'source_members_file': (java / 'members.json').relative_to(ROOT).as_posix(),
                'source_member_id': member['id'], 'source_location': member['source_location'],
                'java_skeleton_location': member['skeleton_location'],
                'target_file': path.relative_to(ROOT).as_posix(), 'target_line': code.count('\n', 0, match.start()) + 1,
                'target_member': f'{package}.{cls}.{name}', 'fill_slot': slot,
                'source_initializer': member.get('initializer'),
            })
    (TARGET / 'member_mapping.json').write_text(json.dumps(mapping, ensure_ascii=False, indent=2)+'\n', encoding='utf-8')
    print(f'结构核对通过，{len(mapping)} 条成员对应')


if __name__ == '__main__':
    main()
