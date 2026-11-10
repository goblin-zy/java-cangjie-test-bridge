"""Reports derived exclusively from frozen syntax facts; no binding or execution."""
import hashlib
import json
from collections import defaultdict

VERSION = 'test-only-1.1.0'


def member_key(snapshot, member):
    """Unique within the source snapshot even for same names in different files."""
    identity = [snapshot, member['file'], member['id'], member['start'], member['end']]
    return hashlib.sha256(json.dumps(identity, ensure_ascii=False).encode('utf-8')).hexdigest()


def feature_report(snapshot, members, facts):
    features = []
    groups = defaultdict(list)

    def add(kind, entries, evidence, review):
        features.append({'kind': kind, 'file': entries[0]['file'],
                         'source_member_keys': [m['source_member_key'] for m in entries],
                         'evidence': evidence, 'analysis_level': 'SYNTAX_ONLY',
                         'requires_rewrite': 'NOT_DETERMINED', 'downstream_review': review})

    annotation_roles = {
        'Test': 'TEST_CANDIDATE', 'ParameterizedTest': 'PARAMETERIZED_TEST_CANDIDATE',
        'RepeatedTest': 'REPEATED_TEST_CANDIDATE', 'TestFactory': 'DYNAMIC_TEST_CANDIDATE',
        'TestTemplate': 'TEST_TEMPLATE_CANDIDATE', 'Before': 'SETUP_CANDIDATE',
        'BeforeEach': 'SETUP_CANDIDATE', 'BeforeAll': 'CLASS_SETUP_CANDIDATE',
        'BeforeClass': 'CLASS_SETUP_CANDIDATE', 'After': 'CLEANUP_CANDIDATE',
        'AfterEach': 'CLEANUP_CANDIDATE', 'AfterAll': 'CLASS_CLEANUP_CANDIDATE',
        'AfterClass': 'CLASS_CLEANUP_CANDIDATE', 'MethodSource': 'DATA_SOURCE_REFERENCE_CANDIDATE',
        'ValueSource': 'INLINE_DATA_CANDIDATE', 'CsvSource': 'INLINE_DATA_CANDIDATE',
        'CsvFileSource': 'RESOURCE_DATA_REFERENCE_CANDIDATE',
    }
    for m in members:
        if m['kind'] == 'method':
            groups[(m['file'], m['owner'], m['name'])].append(m)
            for annotation in m.get('annotations', []):
                role = annotation_roles.get(annotation.rsplit('.', 1)[-1])
                if role:
                    add('ANNOTATION_NAME_HINT', [m], {'annotation': annotation, 'role_hint': role},
                        '名称匹配，未绑定框架；核对实际角色、数据及执行顺序。')
        elif m['kind'] == 'field' and m.get('initializer') is not None:
            add('FIELD_INITIALIZER', [m], {'expression': m['initializer']}, '保留初始化表达式，目标初始化顺序另行确认。')
        elif m['kind'] == 'initializer':
            add('INITIALIZER_BLOCK', [m], {'start': m['start'], 'end': m['end']}, '保留初始化块，未推导其运行顺序。')

    for (_, _, name), entries in groups.items():
        if len(entries) > 1:
            signatures = [m.get('parameters', []) for m in entries]
            # Duplicate declarations in invalid input are not a proven overload set.
            if len({tuple(p) for p in signatures}) != len(signatures):
                continue
            add('MULTIPLE_CONSTRUCTOR_DECLARATIONS' if name == '<init>' else 'OVERLOAD_DECLARATION_CANDIDATE',
                entries, {'name': name, 'parameter_types_as_written': signatures},
                '仅按同文件同类型的声明分组，未解析类型别名、继承或调用绑定；不默认消除重载。')
    indexed = defaultdict(list)
    for m in members:
        indexed[(m['file'], m['id'])].append(m)
    for f in facts['files']:
        for call in f.get('calls', []):
            if call['name'] not in {'this', 'super'}:
                continue
            for m in indexed[(f['path'], call['caller'])]:
                if m.get('name') == '<init>' and m['start'] <= call['start'] < m['end']:
                    add('CONSTRUCTOR_DELEGATION', [m],
                        {'call_start': call['start'], 'call_end': call['end'],
                         'target_as_written': call['name'], 'arguments': call.get('arguments', [])},
                        '仅记录显式this/super调用，未绑定目标构造器或证明初始化等价。')
    return {'snapshot_id': snapshot, 'analysis_level': 'SYNTAX_ONLY',
            'framework_binding': 'NOT_ATTEMPTED', 'features': features,
            'coverage': ['声明重载候选', '多构造器声明', '显式构造器委托', '字段初始化', '初始化块', '注解名称提示'],
            'not_covered': ['完整语言特性识别', '断言语义分类', '框架角色绑定', '测试关系图', '依赖闭包', '自动改写']}


def capability_report(snapshot):
    return {'version': VERSION, 'snapshot_id': snapshot,
            'implemented': {
                'source_snapshot': 'BYTE_IDENTICAL_SELECTED_FILES',
                'source_mapping': 'IDENTITY_FILES_AND_SOURCE_MEMBER_KEYS',
                'syntax_index': 'PARSE_ONLY_UTF16_SPANS',
                'feature_hints': 'LIMITED_SYNTAX_ONLY',
                'reference_recording': 'UNRESOLVED_IMPORTS_AND_CALLS',
                'module_handoff': 'FILES_AND_PROMPTS_ONLY'},
            'not_implemented': ['测试框架类型绑定与运行时测试发现', '测试依赖关系图与闭包',
                                '业务接口解析和契约补全', '翻译单元规划', '已有骨架及上下文工具自动适配',
                                '源码规范化或改写', '累计前缀测试生成', '动态插桩和行为规格',
                                '仓颉骨架和译文生成', '语义等价或检错能力验证'],
            'integration_mode': 'MANUAL_FILE_HANDOFF_NOT_AUTOMATIC_PIPELINE',
            'translation_improvement': 'NOT_EVALUATED'}


def source_mapping(snapshot, inventory, members):
    return {'snapshot_id': snapshot, 'transformation': 'IDENTITY_ONLY',
            'files': [{'source_relative_path': r['file'], 'frozen_path': 'input/' + r['file'],
                       'source_sha256': r['sha256'], 'frozen_sha256': r['sha256'],
                       'operation': 'BYTE_IDENTICAL_COPY'} for r in inventory],
            'members_index': 'members.json', 'member_key_field': 'source_member_key',
            'offset_unit': 'UTF-16 code units, end exclusive',
            'member_count': len(members), 'rewrites': [],
            'target_mapping': 'NOT_GENERATED_BY_PREPROCESSOR'}


CONSUMERS = [
    ('上下文查找', 'context.md', ['external_references.json', 'members.json', 'translation_features.json'],
     ['当前任务范围', '授权的上下文源与已有上下文工具'], ['上下文及来源', '未解析引用']),
    ('Java骨架提取', 'java_skeleton.md', ['input/', 'members.json', 'source_mapping.json', 'test_structure.json'],
     ['现有骨架提取器及输入格式适配'], ['Java骨架', '源成员与骨架对应']),
    ('仓颉骨架生成', 'cangjie_skeleton.md', ['input/', 'members.json', 'translation_features.json'],
     ['Java骨架（采用骨架流程时）', '目标类型与接口对应', '转换规则'], ['仓颉骨架', '源目标成员对应']),
    ('整体翻译', 'whole_translation.md', ['input/', 'members.json', 'external_references.json', 'translation_features.json'],
     ['目标接口或仓颉业务实现', '转换规则', '采用骨架流程时的目标骨架及对应'], ['完整测试译文', '资源安排及未完成项']),
    ('片段翻译', 'fragment_translation.md', ['input/', 'members.json', 'source_mapping.json', 'translation_features.json'],
     ['翻译单元规划与目标位置', '目标接口和规则', '已有译文及初始化上下文'], ['单元译文', '回填与状态记录']),
    ('验证', 'validation.md', ['input/', 'inventory.json', 'source_mapping.json', 'manifest.json'],
     ['完整源运行环境', '目标实现与译文', '用例对应及验证命令'], ['实际检查结果和日志', '未验证项']),
]


def downstream_report(snapshot, status):
    return {'snapshot_id': snapshot, 'material_status': status,
            'integration_mode': 'MANUAL_FILE_HANDOFF_NOT_AUTOMATIC_PIPELINE',
            'note': '六类消费者的文件约定与专属提示词；不表示已调用或实现这些模块。',
            'consumers': [{'module': module, 'prompt': 'prompts/' + prompt,
                           'available': ['capabilities.json', 'issues.json'] + available,
                           'usage': '按本模块prompt与consumer_guide读取材料，先登记缺项，不改冻结输入。',
                           'missing': missing, 'expected': expected}
                          for module, prompt, available, missing, expected in CONSUMERS]}
