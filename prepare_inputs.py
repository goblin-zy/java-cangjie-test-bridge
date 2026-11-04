"""Fetch pinned sources and regenerate the source-side extraction inputs."""

import argparse
import hashlib
import io
import json
from pathlib import Path, PurePosixPath
import subprocess
import tempfile
import urllib.request
import zipfile

ROOT = Path(__file__).resolve().parent


def check_hash(path, expected):
    if not path.is_file() or hashlib.sha256(path.read_bytes()).hexdigest() != expected:
        raise ValueError(f'Unexpected test source: {path}')


def prepare_source(project):
    destination = ROOT / '01-projects' / project['name']
    if not destination.exists():
        url = f"https://codeload.github.com/{project['repository']}/zip/{project['commit']}"
        with urllib.request.urlopen(url, timeout=60) as response:
            payload = response.read()
        with tempfile.TemporaryDirectory(dir=destination.parent) as temporary:
            snapshot = Path(temporary) / 'snapshot'
            snapshot.mkdir()
            with zipfile.ZipFile(io.BytesIO(payload)) as archive:
                for item in archive.infolist():
                    if item.is_dir():
                        continue
                    parts = PurePosixPath(item.filename).parts[1:]
                    target = (snapshot / Path(*parts)).resolve()
                    if not target.is_relative_to(snapshot):
                        raise ValueError(f'Unsafe archive path: {item.filename}')
                    target.parent.mkdir(parents=True, exist_ok=True)
                    target.write_bytes(archive.read(item))
            check_hash(snapshot / project['selected_test'], project['sha256'])
            snapshot.rename(destination)
    test = destination / project['selected_test']
    check_hash(test, project['sha256'])
    return test


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--jdk', required=True, type=Path)
    jdk_bin = parser.parse_args().jdk.resolve() / 'bin'
    suffix = '.exe' if (jdk_bin / 'javac.exe').exists() else ''
    javac, java = (jdk_bin / (name + suffix) for name in ('javac', 'java'))
    classes = ROOT / '.build' / 'extractor'
    classes.mkdir(parents=True, exist_ok=True)
    extractor = ROOT / '02-java-skeleton/tools/JavaTestSkeletonExtractor.java'
    subprocess.run([javac, '-encoding', 'UTF-8', '-d', classes, extractor], check=True)
    projects = json.loads((ROOT / '01-projects/sources.json').read_text(encoding='utf-8'))
    for project in projects:
        test = prepare_source(project)
        output = ROOT / '02-java-skeleton' / project['name']
        if not output.exists():
            subprocess.run([java, '-Dfile.encoding=UTF-8', '-cp', classes, 'JavaTestSkeletonExtractor',
                            '--input', test, '--output', output], check=True)
        check_hash(output / 'original' / test.name, project['sha256'])
        print(f"{project['name']}: source and extraction ready", flush=True)


if __name__ == '__main__':
    main()
