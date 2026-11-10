"""GUI helpers independent of Tk widgets; core analysis is not changed."""
from pathlib import Path
from datetime import datetime
import json
import re
import subprocess


def check_environment(java='java', javac='javac'):
    versions = {}
    for name, exe in [('java', java), ('javac', javac)]:
        try:
            p = subprocess.run([exe, '-version'], capture_output=True, timeout=15,
                               creationflags=getattr(subprocess, 'CREATE_NO_WINDOW', 0))
        except (OSError, subprocess.SubprocessError) as exc:
            raise ValueError(f'无法启动{name}进行环境检查。请点击“选择JDK”，选择包含bin/java与bin/javac的完整JDK。实际原因：{exc}') from exc
        text = (p.stdout+p.stderr).decode('utf-8', errors='replace').strip()
        match = re.search(r'(?:version\s+"|javac\s+)(\d+)', text)
        if p.returncode or not match or int(match[1]) < 17:
            raise ValueError(f'{name}需要17以上版本，且能正常启动。请通过“选择JDK”指定完整JDK。实际信息：{text}')
        versions[name] = {'major': int(match[1]), 'description': text.splitlines()[0]}
    if versions['javac']['major'] > versions['java']['major']:
        raise ValueError('javac版本高于java，可能无法运行生成的分析器。请选择同一套JDK。')
    return versions


def relative_root(project, selected):
    project, selected = Path(project).resolve(), Path(selected).resolve()
    if not selected.is_dir() or selected == project or not selected.is_relative_to(project):
        raise ValueError('测试／资源目录必须是所选工程内部的实际子目录。')
    rel = selected.relative_to(project).as_posix()
    if 'src/main' in rel:
        raise ValueError('当前版本不接收src/main业务目录。请选择测试目录。')
    return rel


def validate_inputs(project, parent, tests, resources):
    project, parent = Path(project).resolve(), Path(parent).resolve()
    if not project.is_dir():
        raise ValueError('请先选择存在的Java工程根目录。')
    if not parent.is_dir():
        raise ValueError('请选择已存在的结果保存文件夹；工具会在其中新建一轮结果。')
    if not tests:
        raise ValueError('没有测试源码目录。请点击“添加测试目录”，选择含测试及辅助源码的目录。')
    roots = [Path(project/x).resolve() for x in tests+resources]
    for p in roots:
        relative_root(project, p)
    for i, p in enumerate(roots):
        if any(p.is_relative_to(q) or q.is_relative_to(p) for q in roots[i+1:]):
            raise ValueError('测试和资源根不能重复或相互包含，请移除重复项。')
    if parent.is_relative_to(project):
        raise ValueError('结果保存位置不能在输入工程内。请选择工程之外的文件夹。')
    return project, parent


def new_output(parent):
    name = '仅测试预处理_' + datetime.now().strftime('%Y%m%d_%H%M%S_%f')
    out = Path(parent).resolve()/name
    if out.exists():
        raise ValueError('轮次目录已存在，请重新开始以生成新名称。')
    return out


def load_settings(path):
    path = Path(path).resolve()
    config = json.loads(path.read_text(encoding='utf-8-sig'))
    if not isinstance(config, dict):
        raise ValueError('设置必须是JSON对象。')
    for key in ['project', 'output', 'output_parent']:
        if config.get(key):
            config[key] = str((path.parent/config[key]).resolve())
    if 'output_parent' not in config and 'output' in config:
        config['output_parent'] = str(Path(config['output']).parent)
    for key in ['test_roots', 'resource_roots']:
        if key in config and (not isinstance(config[key], list) or any(not isinstance(x, str) for x in config[key])):
            raise ValueError(key+'应是目录字符串列表。')
    return config
