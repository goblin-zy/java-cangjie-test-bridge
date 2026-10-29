"""Recheck portable saved evidence without requiring the old author's paths/SDK."""
from pathlib import Path
import argparse
import csv
import hashlib
import json
import sys

from context_lookup import source_text


def load(path):
    return json.loads(path.read_text(encoding="utf-8-sig"))


def check_all(module):
    checks = []
    def check(name, condition):
        checks.append({"check": name, "passed": bool(condition)})
    export = module / "validation/context/export"
    contexts = sorted(export.glob("context_*.json"))
    check("current_repository_three_contexts", len(contexts) == 3)
    for path in contexts:
        data = load(path)
        markdown = path.with_suffix(".md").read_text(encoding="utf-8")
        for entry in [data["target"], data["original_test_class"], *data["context"]]:
            src = export / entry["source"]["file"]
            check(path.name + ":source:" + entry["symbol"], hashlib.sha256(src.read_bytes()).hexdigest() == entry["source"]["sha256"])
            check(path.name + ":content:" + entry["symbol"], source_text(src, entry["source"]["location"]) == entry["content"])
            # Markdown rendering normalizes CRLF on read; compare normalized text.
            check(path.name + ":markdown:" + entry["symbol"], entry["content"].replace("\r\n", "\n") in markdown)
    runs = [module / "validation/evaluation-history" / name for name in ["批量验收_20261028_02", "单组运行_20261028_01", "环境失败_20261028_01", "数量不符_20261028_01"]]
    runs.append(module / "validation/repository-account-preupload/execution")
    for run in runs:
        data = load(run / "results.json")
        with (run / "results.csv").open(encoding="utf-8-sig", newline="") as handle:
            rows = list(csv.DictReader(handle))
        check(run.name + ":csv_count", len(rows) == len(data["combinations"]))
        for result, row in zip(data["combinations"], rows):
            folder = run / result["combination_id"]
            check(run.name + ":json:" + result["combination_id"], load(folder / "result.json") == result)
            check(run.name + ":csv:" + result["combination_id"], all(row[k] == ("" if result[k] is None else str(result[k])) for k in row))
            for source in result["sources"]:
                check(run.name + ":snapshot:" + source["snapshot"], hashlib.sha256((folder / source["snapshot"]).read_bytes()).hexdigest() == source["sha256"])
    batch = load(runs[0] / "results.json")
    expected = {"normal_account": "PASSED", "assertion_failure": "ASSERTION_FAILED", "runtime_error": "TEST_ERROR", "compile_failure": "COMPILE_FAILED", "no_tests": "NO_TESTS_FOUND", "skipped": "ZERO_TESTS_EXECUTED", "partial_filter": "TEST_SET_MISMATCH", "all_filtered": "ZERO_TESTS_EXECUTED", "wrong_expected_name": "TEST_SET_MISMATCH", "missing_source": "INVALID_INPUT", "count_only": "PASSED", "another_sample": "PASSED", "timeout": "RUN_TIMEOUT"}
    check("history_13_scenario_classifications", {r["combination_id"]: r["status"] for r in batch["combinations"]} == expected)
    current = load(runs[-1] / "results.json")["combinations"][0]
    check("repository_account_9_of_9", current["status"] == "PASSED" and current["expected_count"] == current["discovered_count"] == current["executed_count"] == current["passed_count"] == 9)
    runtime = load(module / "validation/repository-account-preupload/run_metadata.json")
    check("localfix_runtime_matches_upstream_disclosure", "69bb60978f2a0423b11859915fa2c0d84d5a7165caf90e49958ba301b7aa0f3f" in runtime["runtime_library_hashes"].values())
    return {"owner": "蒋逸舟", "all_passed": all(x["passed"] for x in checks), "passed": sum(x["passed"] for x in checks), "total": len(checks), "checks": checks, "scope": "portable saved evidence verification; no new test execution and no proof of semantic equivalence", "human_review": "PENDING"}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", type=Path, help="Optional new JSON result file; never overwrite")
    args = parser.parse_args()
    result = check_all(Path(__file__).resolve().parents[1])
    if args.output:
        if args.output.exists():
            parser.error("Output already exists")
        args.output.parent.mkdir(parents=True, exist_ok=True)
        args.output.write_text(json.dumps(result, ensure_ascii=False, indent=2), encoding="utf-8")
    print(json.dumps({k: result[k] for k in ["owner", "all_passed", "passed", "total"]}, ensure_ascii=False))
    return 0 if result["all_passed"] else 1


if __name__ == "__main__":
    sys.exit(main())
