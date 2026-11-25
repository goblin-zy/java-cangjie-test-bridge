"""Local command interface for the current Agent; JSON on stdout, no server."""
import argparse
import json
import sys

from assemble import PROFILES, assemble, write_context, write_suite
from indexer import build
from project import Project
from internal_analysis import query_member, query_features


def parser():
    """集中声明命令参数；索引构建、上下文导出、只读查询各有明确入口。"""
    p = argparse.ArgumentParser(description=__doc__)
    commands = p.add_subparsers(dest="command", required=True)
    b = commands.add_parser("build")
    b.add_argument("--project", dest="project_root", required=True, help="Java 项目源码根目录")
    b.add_argument("--output", required=True)
    b.add_argument("--java", default="java")
    b.add_argument("--javac", default="javac")
    b.add_argument("--classpath", action="append", default=[])
    b.add_argument("--timeout", type=int, default=300)
    b.add_argument("--syntax-only", action="store_true")
    for flag, dest in [("business-root", "business_roots"), ("test-root", "test_roots"),
                       ("support-root", "support_roots"), ("resource-root", "resource_roots")]:
        b.add_argument("--" + flag, dest=dest, action="append", help="相对项目的目录，可重复")
    b.add_argument("--test-scope", action="append", default=[], help="测试文件相对路径 glob，可重复")
    b.add_argument("--exclude", action="append", default=[])
    for name in ["materials", "rules", "member-map"]:
        b.add_argument("--" + name)
    for name in ["overview", "search", "read", "file", "references", "resolve", "resources", "initial", "suite", "lookup", "analyze", "features"]:
        sub = commands.add_parser(name)
        sub.add_argument("--index", required=True)
        if name == "search":
            sub.add_argument("--name", default="")
            sub.add_argument("--kind", default="all", choices=["all", "type", "method", "constructor", "field", "initializer", "file", "resource", "config"])
            sub.add_argument("--offset", type=int, default=0)
            sub.add_argument("--limit", type=int, default=50)
        if name in {"read", "references"}:
            sub.add_argument("--id", required=True)
        if name == "read":
            sub.add_argument("--mode", default="full", choices=["full", "signature"])
            sub.add_argument("--max-chars", type=int, default=30000)
        if name == "references":
            sub.add_argument("--direction", default="outgoing", choices=["outgoing", "incoming"])
            sub.add_argument("--offset", type=int, default=0)
            sub.add_argument("--limit", type=int, default=50)
        if name == "file":
            sub.add_argument("--path", required=True)
            sub.add_argument("--start-line", type=int)
            sub.add_argument("--end-line", type=int)
            sub.add_argument("--max-chars", type=int, default=30000)
        if name in {"resolve", "resources"}:
            sub.add_argument("--reference", required=True)
        if name == "resources":
            sub.add_argument("--target-type")
        if name in {"initial", "suite"}:
            sub.add_argument("--target", required=True)
            sub.add_argument("--output", required=True)
            sub.add_argument("--max-depth", type=int, default=6)
            sub.add_argument("--max-members", type=int, default=200)
            sub.add_argument("--max-chars", type=int, default=30000)
        if name == "initial":
            sub.add_argument("--view", choices=["compact", "full"], default="compact")
            sub.add_argument("--profile", choices=PROFILES, default="whole")
        if name == "lookup":
            sub.add_argument("--kind", choices=["materials", "rules", "member_map"], default="materials")
            sub.add_argument("--query", default="")
            sub.add_argument("--limit", type=int, default=20)
        if name in {"analyze", "features"}:
            sub.add_argument("--id", required=name == "analyze")
            sub.add_argument("--offset", type=int, default=0)
            sub.add_argument("--limit", type=int, default=100)
        if name == "analyze":
            sub.add_argument("--include-source", action="store_true")
            sub.add_argument("--max-chars", type=int, default=12000)
    return p


def main():
    """把命令分派到普通 Python 函数，向当前 Agent 返回 JSON 和退出码。"""
    sys.stdout.reconfigure(encoding="utf-8")
    sys.stderr.reconfigure(encoding="utf-8")
    args = vars(parser().parse_args())
    command = args.pop("command")
    try:
        if command == "build":
            result = build(**args)
        else:
            project = Project(args.pop("index"))
            if command == "overview":
                result = project.overview()
            elif command == "search":
                result = project.search(**args)
            elif command == "read":
                result = project.read(args.pop("id"), **args)
            elif command == "file":
                result = project.read_file(args["path"], args["start_line"], args["end_line"], args["max_chars"])
            elif command == "references":
                result = project.related(args.pop("id"), **args)
            elif command == "resolve":
                result = project.resolve(args["reference"])
            elif command == "resources":
                type_key = project.key(args["target_type"]) if args["target_type"] else None
                result = project.resources(args["reference"], type_key) or {"status": "NOT_RECOGNIZED_RESOURCE_API"}
            elif command == "lookup":
                result = project.materials(**args)
            elif command == "initial":
                output = args.pop("output")
                view = args.pop("view")
                result = write_context(project, assemble(project, **args), output, view)
            elif command == "suite":
                result = write_suite(project, **args)
            elif command == "analyze":
                result = query_member(project, args.pop("id"), **args)
            elif command == "features":
                result = query_features(project, args.pop("id"), **args)
            project.log(command, args, result)
        print(json.dumps(result, ensure_ascii=True, indent=2))
        return 0
    except (Exception, KeyboardInterrupt) as exc:
        print(json.dumps({"status": "ERROR", "error_type": type(exc).__name__, "message": str(exc)}, ensure_ascii=False))
        return 1


if __name__ == "__main__":
    sys.exit(main())
