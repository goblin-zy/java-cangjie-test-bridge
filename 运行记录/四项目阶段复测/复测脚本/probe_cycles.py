"""诊断语法节点同区间造成的父节点环，不运行完整索引。"""
from pathlib import Path
import json

p = Path('D:/CodexArtifacts/four-projects-tests-20261125/01-jsoup/context-index/backend/semantic.json')
data = json.loads(p.read_text(encoding='utf-8'))
count, cycles = 0, []
for file in data['files']:
    nodes = file.get('facts', {}).get('body_nodes', [])
    at = {}
    for number, raw in enumerate(nodes):
        loc = raw['location']
        at[(raw['member_start'], raw['member_kind'], loc['start'], loc['end'])] = number
    for number, raw in enumerate(nodes):
        current, seen = number, set()
        while current is not None:
            if current in seen:
                cycles.append({'file': file['file'], 'node': raw, 'cycle_node': nodes[current]})
                break
            seen.add(current)
            node = nodes[current]
            parent = node.get('parent_location')
            current = at.get((node['member_start'], node['member_kind'], parent['start'], parent['end'])) if parent else None
        count += 1
print(json.dumps({'nodes': count, 'cycle_count': len(cycles), 'examples': cycles[:2]}, ensure_ascii=True, indent=2))
