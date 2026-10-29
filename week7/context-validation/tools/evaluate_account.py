"""Evaluate the repository's nine reference account tests with the existing runner."""
from pathlib import Path
import argparse
import hashlib
import json
import subprocess
import sys


NAMES = ["testInitialBalance", "testDeposit", "testWithdraw", "testWithdrawAll", "testSequence", "testInsufficientFunds", "testInvalidAmounts", "testBalanceLimit", "testInvalidInitialBalance"]


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--repo-root", type=Path, default=Path(__file__).resolve().parents[3])
    parser.add_argument("--sdk-root", type=Path, required=True)
    parser.add_argument("--runtime-label", required=True, help="Actual runtime description; e.g. localfix or official. A declaration, not a certification.")
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    repo, sdk, out = args.repo_root.resolve(), args.sdk_root.resolve(), args.output.resolve()
    if out.exists() and (not out.is_dir() or any(out.iterdir())):
        parser.error("Use a new or empty output directory")
    reference = repo / "week7/reference/cangjie"
    business, tests = reference / "implementation/account.cj", reference / "tests/account_test.cj"
    for path in (business, tests, sdk / "bin/cjc.exe"):
        if not path.is_file():
            parser.error("Missing required input: " + str(path))
    out.mkdir(parents=True, exist_ok=True)
    config = {"sdk_root": str(sdk), "id": "repository_account_reference", "business_role": "normal", "business": str(business), "tests": str(tests), "expected_tests": ["starter.AccountTest#" + name + "()" for name in NAMES]}
    (out / "config.json").write_text(json.dumps(config, ensure_ascii=False, indent=2), encoding="utf-8")
    runtime_hashes = {p.relative_to(sdk).as_posix(): hashlib.sha256(p.read_bytes()).hexdigest() for p in sdk.rglob("*runtime*.dll")}
    metadata = {"owner": "蒋逸舟", "execution_assistance": "Codex/software tools", "material": "existing repository reference tests; not a generated translation", "runtime_label_declared": args.runtime_label, "runtime_library_hashes": runtime_hashes, "compiler_sha256": hashlib.sha256((sdk / "bin/cjc.exe").read_bytes()).hexdigest(), "human_review": "PENDING", "expected_test_count": 9}
    (out / "run_metadata.json").write_text(json.dumps(metadata, ensure_ascii=False, indent=2), encoding="utf-8")
    runner = Path(__file__).with_name("cangjie_runner.py")
    return subprocess.run([sys.executable, str(runner), "--config", str(out / "config.json"), "--output", str(out / "execution")]).returncode


if __name__ == "__main__":
    sys.exit(main())
