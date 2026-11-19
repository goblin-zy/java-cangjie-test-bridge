"""Prepare fragment packets and assemble the Agent's test translations."""
import argparse
import hashlib
import json
from pathlib import Path
import re
import sys
import tempfile


def load(path):
    return json.loads(path.read_text(encoding="utf-8-sig"))


def save(path, value):
    path.parent.mkdir(parents=True, exist_ok=True)
    with tempfile.NamedTemporaryFile(dir=path.parent, delete=False, mode="w",
                                     encoding="utf-8", newline="\n") as stream:
        temporary = Path(stream.name)
        stream.write(value if isinstance(value, str) else
                     json.dumps(value, ensure_ascii=False, indent=2) + "\n")
    try:
        temporary.replace(path)
    finally:
        temporary.unlink(missing_ok=True)


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def inside(root, name):
    path = (root / name).resolve()
    if not path.is_relative_to(root):
        raise ValueError(f"路径超出允许目录: {name}")
    return path


def markers(slot):
    return f"/* FRAGMENT_BEGIN:{slot} */", f"/* FRAGMENT_END:{slot} */"


def region(source, slot):
    start, end = markers(slot)
    if source.count(start) != 1 or source.count(end) != 1:
        raise ValueError(f"{slot}: 起止标记必须各出现一次")
    a, b = source.index(start), source.index(end) + len(end)
    if a + len(start) >= b - len(end) or "/* FRAGMENT_" in source[a + len(start):b - len(end)]:
        raise ValueError(f"{slot}: 标记顺序错误、空槽或嵌套")
    return a, b


class Workflow:
    def __init__(self, run):
        self.run = run.resolve()
        self.config = load(self.run / "translation_config.json")
        self.project = Path(self.config["project_root"]).resolve()
        self.skeleton = inside(self.run, "05-cangjie-skeleton")
        self.out = inside(self.run, "07-fragment-translation")
        self.plan_file = self.out / "fragment_plan.json"
        self.rules = (Path(__file__).resolve().parents[1] /
                      "three-material-get/Rule mapping")

    def source_member(self, row):
        table_path = inside(self.run, row["source_members_file"])
        inside(self.run / "02-java-skeleton", table_path)
        table = load(table_path)
        member = next(m for m in table["members"] if m["id"] == row["source_member_id"])
        original = member["source_location"]["file"]
        record = next(f for f in table["files"]
                      if f.get("original_file", "original/" + f["source_file"]) == original)
        path = inside(self.project, Path(table["input_root"]) / record["source_file"])
        allowed = self.config["test_files"] + self.config.get("test_support_files", [])
        if path not in {inside(self.project, p) for p in allowed} or not path.is_file():
            raise ValueError(f"成员不在选定测试范围: {path}")
        if record.get("source_sha256") and record["source_sha256"] != digest(path):
            raise ValueError(f"原测试已变化: {path}")
        return member

    def plan(self):
        if self.plan_file.exists():
            return {"plan": str(self.plan_file), "status": "existing"}
        tasks, blocked, files = {}, [], {}
        for path in sorted(self.skeleton.rglob("*.cj")):
            inside(self.skeleton, path)
            files[path.relative_to(self.skeleton).as_posix()] = digest(path)
        for row in load(self.skeleton / "member_mapping.json"):
            if row["status"] == "blocked":
                blocked.append(row)
            if row["status"] != "mapped" or row.get("fill_slot") not in {"body", "initializer"}:
                continue
            slot = row.get("slot_id", "")
            if not re.fullmatch(r"[A-Za-z0-9_-]+", slot) or slot in tasks:
                raise ValueError(f"缺少唯一 slot_id: {row.get('source_member_id')}")
            path = inside(self.skeleton, row["target_file"])
            if path.suffix != ".cj":
                raise ValueError(f"目标必须是仓颉骨架: {path}")
            name = path.relative_to(self.skeleton).as_posix()
            source = path.read_text(encoding="utf-8-sig")
            region(source, slot)
            member = self.source_member(row)
            code = member.get("original_body" if row["fill_slot"] == "body" else "initializer")
            if not code:
                raise ValueError(f"{slot}: 缺少 Java 原文")
            tasks[slot] = {"mapping": row, "file": name, "source": code,
                           "status": "unreviewed", "refs": [], "depends_on": []}
        if not tasks and not blocked:
            raise ValueError("成员对应表没有待翻译槽位或受阻项")
        save(self.plan_file, {"tasks": tasks, "files": files, "blocked_mappings": blocked})
        return {"plan": str(self.plan_file), "tasks": len(tasks)}

    def reference(self, ref):
        base = {"run": self.run, "project": self.project, "rules": self.rules}[ref.get("root", "run")]
        path = inside(base, ref["file"])
        if base == self.run and (path.is_relative_to(self.out) or
                                  path.is_relative_to(self.run / "06-whole-translation")):
            raise ValueError("材料引用须来自公共阶段或原项目")
        pointer = ref.get("pointer")
        if pointer is not None:
            value = load(path)
            if pointer and not pointer.startswith("/"):
                raise ValueError("JSON pointer 必须以 / 开始")
            for key in pointer.split("/")[1:]:
                key = key.replace("~1", "/").replace("~0", "~")
                value = value[int(key)] if isinstance(value, list) else value[key]
            return value
        lines = path.read_text(encoding="utf-8-sig").splitlines()
        if "lines" in ref:
            first, last = ref["lines"]
            if not 1 <= first <= last <= len(lines):
                raise ValueError(f"行号超出范围: {path}")
            lines = lines[first - 1:last]
        return "\n".join(lines)

    def review(self, plan, path):
        tasks = plan["tasks"]
        for slot, review in load(path).items():
            task = tasks[slot]
            if task["status"] not in {"unreviewed", "pending"}:
                raise ValueError(f"{slot}: 已提交或受阻的任务不可重审")
            deps = review.get("depends_on", [])
            if any(dep not in tasks or dep == slot for dep in deps):
                raise ValueError(f"{slot}: 无效前置任务")
            refs = review.get("refs", [])
            for ref in refs:
                self.reference(ref)
            task.update(status="pending", refs=refs, depends_on=deps,
                        unresolved=review.get("unresolved", []))
        save(self.plan_file, plan)
        return {"status": "reviewed"}

    def next(self, plan):
        tasks = plan["tasks"]
        for slot, task in tasks.items():
            if task["status"] != "pending" or any(tasks[d]["status"] != "applied"
                                                  for d in task["depends_on"]):
                continue
            refs = [{"reference": ref, "content": self.reference(ref)} for ref in task["refs"]]
            deps = {d: tasks[d]["result"]["code"] for d in task["depends_on"]}
            parts = {"任务和目标位置": {"task_id": slot, **task["mapping"]},
                     "待翻译 Java 原文": task["source"], "参考材料（仅供阅读）": refs,
                     "已完成的前置译文": deps, "待确认事项": task["unresolved"]}
            packet = self.out / "packets" / f"{slot}.md"
            save(packet, "\n\n".join(f"## {title}\n\n{json.dumps(value, ensure_ascii=False, indent=2)}"
                                      for title, value in parts.items()) + "\n")
            return {"status": "ready", "task_id": slot, "packet": str(packet),
                    "packet_sha256": digest(packet)}
        waiting = {s: {"status": t["status"], "depends_on": t["depends_on"],
                       "reason": t.get("reason")} for s, t in tasks.items() if t["status"] != "applied"}
        return {"status": "blocked" if waiting or plan["blocked_mappings"] else "complete",
                "waiting": waiting, "blocked_mappings": plan["blocked_mappings"]}

    def apply(self, plan, path):
        result = load(path)
        slot = result["task_id"]
        task = plan["tasks"][slot]
        if task["status"] == "applied" and task["result"] == result:
            return {"status": "applied", "task_id": slot}
        current = self.next(plan)
        if current.get("task_id") != slot or result["packet_sha256"] != current["packet_sha256"]:
            raise ValueError(f"{slot}: 当前任务或材料包版本不匹配")
        code = result["code"]
        imports = result.get("imports", [])
        if not code.strip() or any(x in code for x in ("FRAGMENT_", "SKELETON_PLACEHOLDER")):
            raise ValueError(f"{slot}: 译文为空或含占位符")
        if not isinstance(imports, list) or any(not re.fullmatch(r"[\w.]+(?:\.\*)?", x) for x in imports):
            raise ValueError(f"{slot}: 导入须为普通包或符号路径")
        save(self.out / "results" / f"{slot}.json", result)
        task.update(status="applied", result=result)
        save(self.plan_file, plan)
        return {"status": "applied", "task_id": slot}

    def finalize(self, plan):
        results, incomplete = {}, {}
        for name, expected in plan["files"].items():
            path = inside(self.skeleton, name)
            if digest(path) != expected:
                raise ValueError(f"骨架已变化: {name}")
            source = path.read_text(encoding="utf-8-sig")
            pending = []
            blocked = [row for row in plan["blocked_mappings"]
                       if row.get("target_file") and
                       inside(self.skeleton, row["target_file"]) == path]
            edits, imports = [], set()
            for slot, task in plan["tasks"].items():
                if task["file"] != name:
                    continue
                if task["status"] != "applied":
                    pending.append(slot)
                    continue
                a, b = region(source, slot)
                edits.append((a, b, task["result"]["code"]))
                imports.update(task["result"].get("imports", []))
            for a, b, code in sorted(edits, reverse=True):
                source = source[:a] + code + source[b:]
            if pending or blocked or "FRAGMENT_" in source or "SKELETON_PLACEHOLDER" in source:
                incomplete[name] = {"pending": pending, "reason": "仍有待填位置"}
                continue
            new = [f"import {i}" for i in sorted(imports)
                   if not re.search(r"(?m)^\s*import\s+" + re.escape(i) + r"\s*;?\s*$", source)]
            if new:
                package = re.search(r"(?m)^\s*package\s+[^\n]+", source)
                if not package:
                    raise ValueError(f"{name}: 找不到 package 声明")
                pos = package.end()
                source = source[:pos] + "\n" + "\n".join(new) + "\n" + source[pos:]
            results[name] = source
        for name, source in results.items():
            save(inside(self.out / "test", name), source)
        report = {"status": "partial" if incomplete or plan["blocked_mappings"] else "complete",
                  "generated": list(results), "incomplete": incomplete,
                  "blocked_mappings": plan["blocked_mappings"], "intent_review": "NOT_RUN",
                  "compile": "NOT_RUN", "test_execution": "NOT_RUN"}
        save(self.out / "assembly_report.json", report)
        return report


def main():
    sys.stdout.reconfigure(encoding="utf-8")
    sys.stderr.reconfigure(encoding="utf-8")
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--run", required=True, type=Path)
    sub = parser.add_subparsers(dest="command", required=True)
    for command in ("plan", "next", "finalize"):
        sub.add_parser(command)
    for command in ("review", "apply"):
        sub.add_parser(command).add_argument("file", type=Path)
    block = sub.add_parser("block")
    block.add_argument("task_id")
    block.add_argument("reason")
    args = parser.parse_args()
    try:
        workflow = Workflow(args.run)
        if args.command == "plan":
            result = workflow.plan()
        else:
            plan = load(workflow.plan_file)
            if args.command == "block":
                task = plan["tasks"][args.task_id]
                if task["status"] == "applied":
                    raise ValueError("已提交的任务不可标为受阻")
                task.update(status="blocked", reason=args.reason)
                save(workflow.plan_file, plan)
                result = {"status": "blocked", "task_id": args.task_id}
            else:
                parameters = [args.file] if args.command in {"review", "apply"} else []
                result = getattr(workflow, args.command)(plan, *parameters)
        print(json.dumps(result, ensure_ascii=False))
    except (OSError, ValueError, KeyError, TypeError, IndexError, StopIteration) as exc:
        print(f"片段工具: {exc or '成员或文件记录未找到'}", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
