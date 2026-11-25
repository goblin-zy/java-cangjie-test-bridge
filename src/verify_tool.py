"""Command-line entry point for a model-led static comparison."""
import argparse
import json
import shutil
import sys
from pathlib import Path

from alignment import prepare
from locating import resolve
from comparison import audit, deliver, make_packets, submit, summarize, unit_view
from workflow import SIDES, folder, packets, read, render, require, sha


def main():
    cli = argparse.ArgumentParser(description="Java → 仓颉测试翻译静态验证")
    commands = cli.add_subparsers(dest="action", required=True)
    for name in ("init","resolve","side-input","annotate","compare","unit-input","submit","audit","summary","deliver"):
        cmd = commands.add_parser(name)
        cmd.add_argument("--run", type=Path, required=True, help="本次运行目录")
        if name == "init":
            cmd.add_argument("--translation",type=Path,required=True,help="含 translation_config.json 的结果目录")
            cmd.add_argument("--route",choices=["whole","fragment"],required=True)
            cmd.add_argument("--contract",type=Path)
            cmd.add_argument("--project-root",type=Path,help="搬迁机器后可指定原始 Java 项目目录")
            cmd.add_argument("--test",action="append",default=[],help="测试名或成员编号，可重复")
        if name in ("annotate","side-input"):
            cmd.add_argument("--side",choices=list(SIDES),required=True)
        if name == "side-input":
            cmd.add_argument("--index",type=int, help="显示本侧材料清单中的一个文件，编号从 0 开始")
        if name == "unit-input":
            cmd.add_argument("--id",required=True,help="本轮单元编号，例如 U01")
        if name in ("resolve","submit"):
            cmd.add_argument("--input",type=Path,required=True)
        if name in ("summary","deliver"):
            cmd.add_argument("--decision",type=Path,required=True)
        if name == "deliver":
            cmd.add_argument("--narrative",type=Path,required=True)
    args = cli.parse_args()
    run = args.run.resolve()
    if args.action == "init":
        # reserve the run name before writing any stage artifacts
        run.mkdir(parents=True,exist_ok=False)
        try:
            prepare(args.translation,args.route,run,args.contract,args.test,args.project_root)
            packets(run)
        except Exception:
            # Only the directory just created by this command is removed.
            shutil.rmtree(run)
            raise
    elif args.action == "side-input":
        out = folder(run,args.side)
        materials = read(out / f"materials_{args.side}.json")
        if args.index is None:
            print(json.dumps({"task":read(out / f"task_{args.side}.json"),
                              "materials":materials},ensure_ascii=False,indent=2))
        else:
            require(0 <= args.index < len(materials),"材料编号超出本侧白名单")
            item = materials[args.index]
            path = (out / item["file"]).resolve()
            require(path.is_relative_to((out / "inputs").resolve()),"非法材料路径")
            data = path.read_bytes()
            require(sha(data) == item["sha256"],"材料副本已变更")
            print(data.decode("utf-8-sig"))
        return 0
    elif (run / "deliverables").exists():
        raise ValueError("此运行已交付。重新分析时请创建新的运行目录")
    elif args.action == "resolve":
        resolve(run,args.input)
    elif args.action == "annotate":
        render(run,args.side)
    elif args.action == "compare":
        make_packets(run)
    elif args.action == "unit-input":
        print(json.dumps(unit_view(run,args.id),ensure_ascii=False,indent=2))
        return 0
    elif args.action == "submit":
        submit(run,args.input)
    elif args.action == "audit":
        state = audit(run)
        print(f'选定 {state["selected"]}，已有比较 {state["compared"]}')
        if any(row["state"] == "漏做" for row in state["units"]):
            return 2
    elif args.action == "summary":
        summarize(run,args.decision)
    elif args.action == "deliver":
        deliver(run,args.decision,args.narrative)
    print(f"完成 {args.action} · {run}")
    return 0


if __name__ == "__main__":
    try:
        sys.exit(main())
    except (OSError,ValueError,KeyError,TypeError,IndexError) as exc:
        print(f"未完成：{exc}",file=sys.stderr)
        sys.exit(1)

