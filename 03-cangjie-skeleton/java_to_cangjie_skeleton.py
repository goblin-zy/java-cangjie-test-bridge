"""Translate week7 extractor output into Cangjie skeletons using explicit rules."""
import argparse
import hashlib
import json
import os
from pathlib import Path
import re
import sys

PRIMITIVES = {
    'boolean': ('Bool', 'false'), 'byte': ('Int8', '0'), 'short': ('Int16', '0'),
    'int': ('Int32', '0'), 'long': ('Int64', '0'), 'float': ('Float32', '0.0'),
    'double': ('Float64', '0.0'), 'char': ('Rune', "r'\\u{0}'"),
}
ROLES = {'test': '@TestCase', 'helper': '', **{
    'lifecycle_' + name: '@' + name for name in ('BeforeEach', 'AfterEach', 'BeforeAll', 'AfterAll')
}}
IDENTIFIER = re.compile(r'[A-Za-z_][A-Za-z_0-9]*\Z')
RESERVED = set('package import class interface enum struct func let var static public private protected internal init main if else match case for while in return throw try catch finally true false this super as is type where extend mut open abstract sealed override operator'.split())


def identifier(name):
    if not IDENTIFIER.fullmatch(name) or name in RESERVED:
        raise ValueError(f'需要配置目标标识符的 Java 名称 {name}')
    return name


def load(path):
    return json.loads(path.read_text(encoding='utf-8-sig'))


def dump(path, data):
    path.write_text(json.dumps(data, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')


def within(root, name):
    path = (root / name).resolve()
    if not path.is_relative_to(root):
        raise ValueError(f'输入路径超出提取目录 {name}')
    return path


def read_extraction(root):
    root = root.resolve()
    data = load(root / 'members.json')
    if data['schema_version'] != '1.0' or data['summary']['errors']:
        raise ValueError(f'不支持的提取版本或提取结果包含错误 {root}')
    if any(d.get('code') == 'CLASS_INITIALIZER_RETAINED' for d in data.get('diagnostics', [])):
        raise ValueError(f'类初始化块需要显式迁移 {root}')
    texts = {}
    for row in data['files']:
        if row['status'] != 'extracted':
            raise ValueError(f'源文件提取未完成 {row["source_file"]}')
        path = within(root, row['skeleton_file'])
        raw = path.read_bytes()
        if hashlib.sha256(raw).hexdigest() != row['skeleton_sha256']:
            raise ValueError(f'骨架与成员表哈希不一致 {path}')
        texts[row['skeleton_file']] = raw.decode('utf-8').encode('utf-16-le')
    for item in [*data['classes'], *data['members']]:
        loc = item['skeleton_location']
        raw = texts[loc['file']]
        start, end = loc['start_offset_utf16'] * 2, loc['end_offset_utf16_exclusive'] * 2
        if not 0 <= start < end <= len(raw):
            raise ValueError(f'骨架位置无效 {item["id"]}')
        item['skeleton_fragment'] = raw[start:end].decode('utf-16-le')
        item['extraction'] = str(root / 'members.json')
    return data


def translate_type(source, types):
    source = source.strip()
    if source in types:
        result = types[source]
        if not isinstance(result, str) or not re.fullmatch(r'[\w.<>, ?]+', result, re.ASCII):
            raise ValueError(f'类型映射格式无效 {source}')
        return result
    if source in PRIMITIVES:
        return PRIMITIVES[source][0]
    if source in ('String', 'java.lang.String'):
        return 'String'
    if source == 'void':
        return 'Unit'
    if source.endswith('[]'):
        return f'Array<{translate_type(source[:-2], types)}>'
    raise ValueError(f'缺少 Java 类型映射 {source}')


def field(member, types):
    # The week7 field schema has no modifier array. Read modifiers from its declaration.
    declaration = member['declaration'].lstrip()
    match = re.match(r'(?:(?:public|protected|private|static|final)\s+)*', declaration)
    flags = set(match[0].split())
    if declaration[len(match[0]):].startswith(('@', 'volatile ', 'transient ')):
        raise ValueError('字段注解或修饰符需要显式适配')
    java_type = member['type']
    target_type = translate_type(java_type, types)
    initial = member['initializer']
    slot = None
    if java_type in ('String', 'java.lang.String') and initial and re.fullmatch(r'"[^"\\\r\n$]*"', initial):
        value = initial
    elif java_type in PRIMITIVES:
        value = PRIMITIVES[java_type][1]
        if initial is not None:
            slot = 'initializer'
    else:
        target_type = f'Option<{target_type}>'
        value = 'None'
        if initial not in (None, 'null'):
            slot = 'initializer'
    modifiers = 'private ' if 'private' in flags else ''
    if 'static' in flags:
        modifiers += 'static '
    binding = 'let' if 'final' in flags else 'var'
    text = f'{modifiers}{binding} {identifier(member["name"])}: {target_type} = {value}'
    return [text], text, slot, None


def method(member, types):
    role = member['role']
    if member['kind'] != 'method' or role not in ROLES or not member['has_body']:
        raise ValueError(f'当前不支持成员类型或角色 {member["kind"]} / {role}')
    if set(member['modifiers']) & {'abstract', 'native', 'synchronized'}:
        raise ValueError('方法修饰符需要显式适配')
    if re.search(r'\b(?:public|private|protected|static|final)\s+<|^\s*<', member['signature_source']):
        raise ValueError('泛型方法需要显式适配')
    annotations = {a['name'] for a in member['annotations']}
    expected = {'Test'} if role == 'test' else ({role.split('_', 1)[1]} if role.startswith('lifecycle_') else set())
    if annotations - expected - {'Disabled', 'SuppressWarnings'}:
        raise ValueError(f'未映射的方法注解 {sorted(annotations - expected - {"Disabled", "SuppressWarnings"})}')
    if 'Disabled' in annotations and role != 'test':
        raise ValueError('@Disabled 仅支持在普通测试方法上转换')
    if role != 'helper' and (member['parameters'] or member['return_type'] != 'void'):
        raise ValueError('当前仅支持无参 void 的测试和生命周期声明')
    parameters = []
    parameter_types = []
    if len(member['parameters']) != len(member['parameter_types']):
        raise ValueError('参数元数据不一致')
    for raw, source_type in zip(member['parameters'], member['parameter_types']):
        match = re.search(r'([A-Za-z_][A-Za-z_0-9]*)\s*$', raw)
        if not match or '...' in raw or '@' in raw:
            raise ValueError(f'参数需要显式适配 {raw}')
        target_type = translate_type(source_type, types)
        parameter_types.append(target_type)
        parameters.append(f'{identifier(match[1])}: {target_type}')
    target_name = identifier(member['name'])
    modifiers = 'private ' if 'private' in member['modifiers'] else ''
    if 'static' in member['modifiers']:
        if role not in ('helper', 'lifecycle_BeforeAll', 'lifecycle_AfterAll'):
            raise ValueError('静态测试或逐项生命周期需要显式适配')
        modifiers += 'static '
    signature = f'{modifiers}func {target_name}({", ".join(parameters)}): {translate_type(member["return_type"], types)}'
    lines = [ROLES[role]] if ROLES[role] else []
    if 'Disabled' in annotations:
        lines.append('@Skip')
    lines += [signature + ' {', f'    throw Exception("SKELETON_PLACEHOLDER: {target_name}")', '}']
    return lines, signature, 'body', (target_name, tuple(parameter_types))


def translate(extractions, package, rules):
    classes, grouped, mapping, outputs, errors = {}, {}, [], {}, []
    types = rules.get('types', {})
    flattened = rules.get('flatten_inheritance', {})
    names = rules.get('names', {})
    if set(rules) - {'types', 'flatten_inheritance', 'names'} or any(not isinstance(item, dict) for item in (types, flattened, names)):
        raise ValueError('规则文件字段应为 types、flatten_inheritance 和 names 对象')
    for data in extractions:
        for cls in data['classes']:
            owner = cls['qualified_name']
            if owner in classes:
                raise ValueError(f'重复 Java 类 {owner}')
            classes[owner] = cls
            grouped[owner] = []
    for data in extractions:
        for member in data['members']:
            grouped[member['owner']].append(member)
    parents = set(flattened.values())
    if not (set(flattened) | parents) <= classes.keys() or set(flattened) & parents:
        raise ValueError('继承规则应引用本次输入的子类和单层父类')
    if not classes:
        raise ValueError('提取结果没有类')
    for owner, cls in classes.items():
        try:
            name = identifier(names.get(cls['id'], cls['name']))
            header = cls['skeleton_fragment'].split('{', 1)[0]
            if cls['kind'] != 'CLASS' or '$' in owner or cls['annotations'] or re.search(r'\b(?:implements|abstract|sealed)\b|<', header):
                raise ValueError('嵌套类、泛型、类注解、接口关系或抽象类需要显式适配')
            inheritance = re.search(r'\bextends\s+([\w.]+)', header)
            parent = flattened.get(owner)
            if inheritance and (not parent or inheritance[1] not in {parent, parent.rsplit('.', 1)[-1]}):
                raise ValueError('继承关系需要显式配置 flatten_inheritance')
            if parent and not inheritance:
                raise ValueError('继承规则与 Java 骨架不符')
            if owner in parents:
                if inheritance or any(m['role'] not in {'helper', 'lifecycle_BeforeEach', 'lifecycle_AfterEach'} for m in grouped[owner]):
                    raise ValueError('仅支持展平无字段和构造器的单层生命周期父类')
                continue
            file = name + '.cj'
            if file in outputs:
                raise ValueError(f'目标包内类重名 {name}')
        except ValueError as error:
            errors.append({'source_id': cls['id'], 'message': str(error)})
            continue
        members = grouped[owner] + (grouped[parent] if parent else [])
        lifecycle_roles = [m['role'] for m in members if m['role'].startswith('lifecycle_')]
        if len(lifecycle_roles) != len(set(lifecycle_roles)):
            errors.append({'source_id': cls['id'], 'message': '同阶段多个生命周期方法需要显式安排执行顺序'})
            continue
        suite = any(m['role'] == 'test' or m['role'].startswith('lifecycle_') for m in members)
        lines = [f'package {package}', '']
        if suite:
            lines += ['import std.unittest.*', 'import std.unittest.testmacro.*', '', '@Test']
        lines.append(f'class {name} {{')
        signatures = set()
        field_names = set()
        for member in members:
            try:
                member = {**member, 'name': names.get(member['id'], member['name'])}
                is_field = member['kind'] == 'field'
                rendered, declaration, slot, signature = (field if is_field else method)(member, types)
                target_name = member['name']
                if is_field:
                    if target_name in field_names or any(s[0] == target_name for s in signatures):
                        raise ValueError('目标字段名称冲突')
                    field_names.add(target_name)
                else:
                    if signature in signatures or target_name in field_names:
                        raise ValueError('目标方法签名冲突')
                    signatures.add(signature)
                location = len(lines) + 1
                lines += ['    ' + line for line in rendered] + ['']
                mapping.append({'source_member_id': member['id'], 'source_members_file': member['extraction'],
                                'source_location': member['source_location'], 'source_skeleton_location': member['skeleton_location'],
                                'source_annotations': member.get('annotations', []), 'source_initializer': member.get('initializer'),
                                'source_throws': member.get('throws', []), 'target_file': file, 'target_line': location,
                                'target_member': f'{package}.{name}.{target_name}', 'target_declaration': declaration,
                                'role': member['role'], 'fill_slot': slot,
                                'disabled': any(a['name'] == 'Disabled' for a in member.get('annotations', [])),
                                'flattened_from': member['owner'] if member['owner'] != owner else None})
            except ValueError as error:
                errors.append({'source_id': member['id'], 'message': str(error)})
        lines.append('}')
        outputs[file] = '\n'.join(lines) + '\n'
    return outputs, mapping, errors


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--input', type=Path, action='append', required=True, help='提取结果目录，可重复')
    parser.add_argument('--output', type=Path, required=True, help='新的输出目录')
    parser.add_argument('--package', default='translated_tests')
    parser.add_argument('--rules', type=Path)
    args = parser.parse_args()
    if args.output.exists() or any(args.output.resolve().is_relative_to(root.resolve()) for root in args.input):
        parser.error('输出必须是输入目录之外的新目录')
    try:
        for part in args.package.split('.'):
            identifier(part)
        outputs, mapping, errors = translate([read_extraction(root) for root in args.input], args.package,
                                             load(args.rules) if args.rules else {})
    except (OSError, ValueError, KeyError, TypeError) as error:
        outputs, mapping, errors = {}, [], [{'message': str(error)}]
    args.output.mkdir(parents=True, exist_ok=False)
    dump(args.output / 'diagnostics.json', {'status': 'blocked' if errors else 'generated', 'errors': errors,
                                           'files': 0 if errors else len(outputs), 'members': 0 if errors else len(mapping)})
    if errors:
        print(f'转换受阻，共 {len(errors)} 项诊断，见 {args.output / "diagnostics.json"}', file=sys.stderr)
        return 1
    for file, content in outputs.items():
        (args.output / file).write_bytes(content.encode('utf-8'))
    for row in mapping:
        try:
            row['source_members_file'] = Path(os.path.relpath(row['source_members_file'], args.output)).as_posix()
        except ValueError:
            # Windows cannot form a relative path across different drives.
            pass
    dump(args.output / 'member-map.json', mapping)
    print(f'生成 {len(outputs)} 份仓颉骨架，映射 {len(mapping)} 个成员')
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
