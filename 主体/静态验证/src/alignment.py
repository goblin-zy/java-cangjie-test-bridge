"""Locate selected source tests and mapped declarations in the delivered files."""
from pathlib import Path
import re

from workflow import put, read, require, save, sha, stage


def within(root, relative):
    path = (root / relative).resolve()
    require(path.is_relative_to(root.resolve()), f"路径超出材料目录：{relative}")
    return path


def declarations(text, name, side):
    """Return candidate ranges for ordinary braced method declarations."""
    # Mask quoted strings and comments without changing offsets or newlines.
    tokens = r'//[^\n]*|/\*[\s\S]*?\*/|"""[\s\S]*?"""|"(?:\\.|[^"\\])*"|\'(?:\\.|[^\'\\])*\''
    clean = re.sub(tokens, lambda m: re.sub(r'[^\n]', ' ', m.group()), text)
    prefix = r'(?:\w+[ \t]+)*func[ \t]+' if side == "cangjie" else r'(?:\w+[ \t]+)+'
    pattern = r'^[ \t]*' + prefix + re.escape(name) + r'\s*\([^(){};]*\)[^;{}]*\{'
    matches = []
    lines = clean.splitlines()
    for match in re.finditer(pattern, clean, re.M):
        start = clean.count('\n', 0, match.start()) + 1
        while start > 1 and lines[start-2].strip().startswith('@'):
            start -= 1
        depth = 1
        for brace in re.finditer(r'[{}]', clean[match.end():]):
            depth += 1 if brace.group() == '{' else -1
            if depth == 0:
                end = clean.count('\n', 0, match.end() + brace.start()) + 1
                matches.append([start, end])
                break
    return matches


def prepare(translation: Path, route: str, run: Path, contract: Path | None,
            selection: list[str], project_root: Path | None = None):
    root = translation.resolve()
    require(not (root / 'FAILED.json').exists(), '验证输入准备失败，不能继续使用')
    stages = {'whole': '06-whole-translation', 'fragment': '07-fragment-translation'}
    require(route in stages, "路线须为 whole 或 fragment")
    config_file = root / 'translation_config.json'
    config = read(config_file)
    require(len(config['test_files']) == 1, "当前每轮支持一对测试文件，请提供单文件翻译配置。")
    project = project_root.resolve() if project_root else Path(config['project_root'])
    if not project.is_absolute():
        project = root / project
    java = within(project, config['test_files'][0])
    member_file = within(root, config.get('java_members_file', '02-java-skeleton/members.json'))
    extraction = member_file.parent
    inventory = read(member_file)
    rows = [f for f in inventory['files'] if Path(f['source_file']).name == java.name]
    require(len(rows) == 1, "成员表无法唯一识别选定 Java 文件")
    info = rows[0]
    original = within(extraction, info['original_file'])
    skeleton = within(extraction, info['skeleton_file'])
    target_root = root / '05-cangjie-skeleton'
    mapping_file = target_root / 'member_mapping.json'
    mappings = read(mapping_file)
    # week12 区分声明类与执行类；跨文件基类仍列入清单，后续明确标为定位受阻。
    invocations = [i for i in inventory.get('test_invocations', [])
                   if i['execution_class'].replace('$', '.') in
                   {t.replace('$', '.') for t in config.get('execution_classes', [])}]
    selected_ids = {i['source_member_id'] for i in invocations}
    tests = [m for m in inventory['members'] if
             (m['id'] in selected_ids if config.get('execution_classes') and 'test_invocations' in inventory else
              (m['role'] == 'test' or m['role'].startswith('test_')) and
              m['source_location']['file'] == info['original_file'])]
    for key in selection:
        require(sum(key in (m['id'], m['name']) for m in tests) == 1,
                f"测试名缺失或不唯一：{key}")
    tests = [m for m in tests if not selection or any(k in selection for k in (m['id'], m['name']))]
    require(tests, "范围内没有已提取的测试成员")
    delivery = root / stages[route] / 'test'
    targets = {within(delivery, m['target_file']) for m in mappings if m.get('target_file')
               and any(t['id'] == m['source_member_id'] for t in tests)}
    if len(targets) != 1:
        targets = set(delivery.rglob('*.cj'))
    require(len(targets) == 1, "无法唯一选择路线的最终仓颉文件")
    target = targets.pop()
    dest = stage(run, 1)
    source_scope = [
        {'id': f'U{index:02d}', 'name': test['name'], 'source_member_id': test['id']}
        for index, test in enumerate(tests, 1)]
    save(dest / 'source_scope.json', {'units': source_scope, 'configuration': str(config_file),
                                     'members_file': str(member_file)})
    versions = {}

    def record(path):
        raw = path.read_bytes()
        versions[str(path.resolve())] = sha(raw)
        return raw

    java_bytes = record(java)
    cj_bytes = record(target)
    current = sha(java_bytes) == sha(record(original)) == info['source_sha256'].lower()
    require(current or selection, "Java 原文已变化。请重新提取成员表以验证全部测试；也可用 --test 明确选择仍需核查的旧成员。")
    jtext = java_bytes.decode('utf-8-sig')
    ctext = cj_bytes.decode('utf-8-sig')
    jskeleton = skeleton.read_text(encoding='utf-8-sig') if skeleton.is_file() else ''
    cj_skeleton = within(target_root, target.relative_to(delivery))
    cskeleton = cj_skeleton.read_text(encoding='utf-8-sig') if cj_skeleton.is_file() else ''
    units = []
    for index, test in enumerate(tests, 1):
        loc = test['source_location']
        reasons = []
        same_file = loc['file'] == info['original_file']
        jr = [loc['start_line'], loc['end_line']] if same_file else None
        if not same_file:
            reasons.append('跨文件继承测试已计入清单；当前单文件标注不能覆盖基类声明，需拆分或扩展多文件支持')
        elif not current:
            candidates = declarations(jtext, test['name'], 'java')
            jr = candidates[0] if len(candidates) == 1 else None
            reasons.append(f"Java 版本与提取记录不符，按声明重新定位，候选 {candidates}")
        mapped = [m for m in mappings if m['source_member_id'] == test['id']]
        skloc = test.get('skeleton_location', {})
        skeleton_ranges = declarations(jskeleton, test['name'], 'java')
        if [skloc.get('start_line'), skloc.get('end_line')] not in skeleton_ranges:
            reasons.append("Java 骨架成员声明与成员表位置未能吻合")
        cr = None
        candidates = []
        for m in mapped:
            if m.get('target_member') and m.get('target_file') and within(delivery, m['target_file']) == target:
                if len(declarations(cskeleton, m['target_member'], 'cangjie')) != 1:
                    reasons.append("仓颉骨架中的对应声明缺失或不唯一")
                candidates.extend(declarations(ctext, m['target_member'], 'cangjie'))
        if len(mapped) == len(candidates) == 1 and mapped[0].get('status') == 'mapped':
            cr = candidates[0]
        else:
            reasons.append("成员映射或最终声明缺失、适配或不唯一，需复核")
        units.append(dict(id=f'U{index:02d}', name=test['name'], source_member_id=test['id'],
                          source_file=loc['file'], test_framework=test.get('test_framework'),
                          test_invocations=[i for i in invocations if i['source_member_id'] == test['id']],
                          java=jr, cangjie=cr, candidates=candidates, mapping=mapped,
                          reason='；'.join(reasons) or 'Java 成员位置与提取版本一致，已定位唯一目标声明'))
    sides = {'java': [skeleton], 'cangjie': [cj_skeleton]}
    # 第二版上下文仅向 Java 单侧提供；混合接口材料不进入盲侧输入。
    context_files = [within(root, p) for p in config.get('context_files', [])]
    sides['java'].extend(context_files)
    for side, paths in config.get('side_sources', {}).items():
        require(side in sides, '未知单侧语言')
        suffix = '.java' if side == 'java' else '.cj'
        for spelling in paths:
            path = Path(spelling)
            path = path if path.is_absolute() else root / path
            if path.is_dir():
                sides[side].extend(sorted(path.rglob('*' + suffix)))
            elif path.is_file() and path.suffix == suffix:
                sides[side].append(path)
    coverage = root / 'java-coverage/java_coverage.json'
    if coverage.is_file():
        sides['java'].append(coverage)
    project_config = root / '03-project-materials/project_config.json'
    if project_config.is_file():
        for entry in read(project_config).get('sources', []):
            side = entry.get('language')
            if entry.get('role') == 'business' and side in sides:
                source = Path(entry['path'])
                suffix = '.java' if side == 'java' else '.cj'
                if source.is_dir():
                    sides[side].extend(sorted(source.rglob('*' + suffix)))
                elif source.is_file() and source.suffix == suffix:
                    sides[side].append(source)
    rule_dir = root.parent.parent / 'three-material-get/Rule mapping'
    comparison_materials = [config_file, member_file, mapping_file,
                            target_root / 'translation_report.json', target_root / 'handoff.md',
                            root / '03-project-materials/final/project_materials.json',
                            rule_dir / 'translation_rules.json',
                            *sorted((root / '04-test-context').rglob('context_*.json'))]
    comparison_materials.extend(context_files)
    if route == 'fragment':
        comparison_materials.append(root / stages[route] / 'assembly_report.json')
    for path in [*comparison_materials, *sides['java'], *sides['cangjie']]:
        if path.is_file():
            record(path)
    contract_info = {'status': 'missing'}
    if contract:
        try:
            contract_raw = contract.read_bytes()
            require(contract_raw.decode('utf-8-sig').strip(), '约定文件为空')
        except (OSError, ValueError) as exc:
            contract_info.update(requested=str(contract), reason=f'未获得可读目标接口约定：{exc}')
        else:
            snapshot = dest / 'contract' / contract.name
            put(snapshot, contract_raw)
            fingerprint = sha(contract_raw)
            versions[str(contract.resolve())] = fingerprint
            contract_info = {'status': 'assumed', 'path': str(snapshot.resolve()),
                             'snapshot': 'contract/' + contract.name, 'sha256': fingerprint}
    for path, raw in ((java, java_bytes), (target, cj_bytes)):
        put(dest / path.name, raw)
    data = dict(route=route, units=units, files={'java': java.name, 'cangjie': target.name},
                contract=contract_info, versions=versions,
                materials=[str(path) for path in comparison_materials if path.is_file()],
                missing_materials=[str(path) for path in comparison_materials if not path.is_file()],
                side_inputs={s:[str(p.resolve()) for p in paths if p.is_file()] for s, paths in sides.items()},
                extraction_matches=current, selection=selection or [m['id'] for m in tests])
    save(dest / 'alignment.json', data)
    return data
