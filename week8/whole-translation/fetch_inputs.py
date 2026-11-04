"""Fetch the pinned GitHub inputs for the whole-test workflow."""
import argparse
from http.client import HTTPException
import io
import json
from pathlib import Path, PurePosixPath
import tempfile
from urllib.request import Request, urlopen
from zipfile import ZipFile


def fetch(workspace, sources):
    root = workspace / '.deps'
    root.mkdir(exist_ok=True)
    if root.resolve().parent != workspace.resolve():
        raise ValueError('.deps must be inside the workspace')
    for name, spec in sources.items():
        if not name.isascii() or not name.replace('-', '').isalnum():
            raise ValueError(f'Invalid dependency name: {name}')
        destination = root / name
        expected = spec['commit']
        marker = destination / '.source-commit'
        if destination.exists():
            if destination.is_symlink() or not marker.is_file() or marker.read_text().strip() != expected:
                raise ValueError(f'Existing dependency does not match {expected}: .deps/{name}')
        else:
            url = f"https://api.github.com/repos/{spec['repository']}/zipball/{expected}"
            for attempt in range(3):
                try:
                    with urlopen(Request(url, headers={'User-Agent': 'whole-translation-inputs'}), timeout=45) as response:
                        payload = response.read()
                    break
                except (OSError, HTTPException):
                    if attempt == 2:
                        raise
            with tempfile.TemporaryDirectory(dir=root) as temp:
                staged = Path(temp) / name
                staged.mkdir()
                with ZipFile(io.BytesIO(payload)) as archive:
                    for member in archive.infolist():
                        if member.is_dir():
                            continue
                        parts = PurePosixPath(member.filename).parts[1:]
                        path = staged.joinpath(*parts).resolve()
                        if not path.is_relative_to(staged.resolve()):
                            raise ValueError(f'Archive path outside dependency: {member.filename}')
                        path.parent.mkdir(parents=True, exist_ok=True)
                        path.write_bytes(archive.read(member))
                check_files(staged, spec['required_files'])
                (staged / '.source-commit').write_text(expected + '\n', encoding='ascii')
                staged.rename(destination)
        check_files(destination, spec['required_files'])
        print(f'.deps/{name} @ {expected}')


def check_files(root, paths):
    for relative in paths:
        path = (root / relative).resolve()
        if not path.is_relative_to(root.resolve()) or not path.is_file():
            raise ValueError(f'Missing required input: {relative}')


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--workspace', type=Path, default=Path.cwd())
    options = parser.parse_args()
    manifest = Path(__file__).with_name('github_inputs.json')
    fetch(options.workspace.resolve(), json.loads(manifest.read_text(encoding='utf-8')))
