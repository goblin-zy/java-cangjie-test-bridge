from __future__ import annotations
import argparse
import json
import re
import shutil
import sqlite3
import subprocess
import sys
from pathlib import Path
from pydantic import ValidationError
from . import db
from .frontends import doctor
from .materials import Contribution, check, draft, export_files, merge
from .models import ProjectConfig, Materials
from .packets import packets
from .scan import scan
from .util import TOOL_ROOT, load_config, read_json, run, write_json

def emit(value):
    print(json.dumps(value,ensure_ascii=False,indent=2))

def common_config(parser):
    parser.add_argument("--config",required=True,type=Path,help="项目输入配置JSON；相对路径按配置文件所在目录解释")

def common_index(parser):
    parser.add_argument("--index",required=True,type=Path,help="scan生成的index.sqlite")

def parser():
    p=argparse.ArgumentParser(prog="pmtool",description="有证据的项目材料提取、查询与Codex整理；不调用模型API。")
    sub=p.add_subparsers(dest="command",required=True)
    s=sub.add_parser("init",help="生成待填写的输入配置")
    s.add_argument("--output",required=True,type=Path)
    s=sub.add_parser("doctor",help="检查可执行路径和解析助手产物，不执行输入项目")
    common_config(s)
    s=sub.add_parser("scan",help="只读扫描、解析、索引及对应候选；不运行输入代码")
    common_config(s)
    s=sub.add_parser("query",help="查询文件、成员、引用、事实、候选或问题")
    common_index(s)
    s.add_argument("--table",choices=db.TABLES,default="members")
    s.add_argument("--module")
    s.add_argument("--file-id")
    s.add_argument("--name",help="名称/签名包含的文本")
    s.add_argument("--offset",type=int,default=0)
    s.add_argument("--limit",type=int,default=100)
    s=sub.add_parser("show",help="从扫描快照导出指定成员/文件内容，不偷读变更后的原文件")
    common_index(s)
    group=s.add_mutually_exclusive_group(required=True)
    group.add_argument("--member")
    group.add_argument("--file-id")
    s.add_argument("--start",type=int)
    s.add_argument("--end",type=int)
    s=sub.add_parser("packet",help="按预算导出完整分片的AI证据包")
    common_index(s)
    s.add_argument("--module")
    s.add_argument("--output",required=True,type=Path)
    s.add_argument("--max-chars",type=int,default=70000)
    s=sub.add_parser("draft",help="生成含实际程序事实和待核对候选的草稿")
    common_index(s)
    s.add_argument("--output",required=True,type=Path)
    s=sub.add_parser("merge",help="合并Codex贡献；冲突不静默覆盖")
    common_index(s)
    s.add_argument("--base",required=True,type=Path)
    s.add_argument("--analysis",required=True,type=Path,nargs="+")
    s.add_argument("--replace-id",action="append",default=[])
    s.add_argument("--mark-complete",action="store_true",help="明确声明已分析完整范围；程序核查已读文件与十一类覆盖")
    s.add_argument("--output",required=True,type=Path)
    s=sub.add_parser("check",help="检查结构、快照及引用；不证明语义")
    common_index(s)
    s.add_argument("--materials",required=True,type=Path)
    s.add_argument("--live",action="store_true",help="另核对原文件是否与快照一致")
    s=sub.add_parser("export",help="同一份JSON确定生成最终JSON与Markdown")
    common_index(s)
    s.add_argument("--materials",required=True,type=Path)
    s.add_argument("--output",required=True,type=Path)
    s.add_argument("--overwrite",action="store_true",help="明确允许覆盖最终两文件；使用前先保留人工修改")
    s=sub.add_parser("schema",help="导出配置、材料、AI贡献的JSON Schema")
    s.add_argument("--output",required=True,type=Path)
    s.add_argument("--overwrite",action="store_true",help="明确更新已存在的生成格式文件")
    s=sub.add_parser("fetch",help="克隆到新的本地目录并固定提交；不修改远端")
    s.add_argument("--url",required=True)
    s.add_argument("--commit",required=True)
    s.add_argument("--destination",required=True,type=Path)
    return p

def main(argv=None):
    args=parser().parse_args(argv)
    try:
        command=args.command
        if command=="init":
            config={
                "project_name":"填写项目名称",
                "sources":[
                    {"name":"java_business","path":"填写Java业务或项目目录","language":"java","role":"business",
                     "include":["**/*.java","**/pom.xml"],"exclude":["**/src/test/**"]},
                    {"name":"java_tests","path":"填写Java测试目录","language":"java","role":"test","include":["**/*.java"]},
                    {"name":"cangjie_business","path":"填写已有仓颉业务目录","language":"cangjie","role":"business","include":["**/*.cj","**/cjpm.toml"]},
                    {"name":"project_docs","path":"填写项目文档目录","language":"documents","role":"documentation","include":["**/*.md","**/*.toml","**/*.ps1"]}
                ],
                "output_dir":"outputs/run-001","allow_target_tests":False,
                "allow_unparsed_target_evidence":False,"exclude":[],
                "max_file_bytes":3000000,
                "parsers":{"java":"java","javac":"javac","cjc":"cjc","cangjie_helper":None,
                           "java_source_roots":[],"java_classpath":[],"java_language_level":"JAVA_17","timeout_seconds":120}}
            write_json(args.output,config)
            emit({"created":str(args.output),"next":"填写真实路径；不需要的来源整项删除，不保留占位路径。"})
        elif command=="doctor":
            emit(doctor(load_config(args.config).parsers))
        elif command=="scan":
            emit(scan(load_config(args.config),args.config))
        elif command=="query":
            if args.offset<0 or args.limit<1:raise ValueError("offset须非负，limit须大于0")
            rows=db.records(args.index,args.table,module=args.module,file_id=args.file_id)
            if args.name:
                rows=[r for r in rows if args.name.casefold() in (
                    r.get("name","")+" "+r.get("qualified_name","")+" "+r.get("subject","")+" "+r.get("signature","")).casefold()]
            total=len(rows)
            page=rows[args.offset:args.offset+args.limit]
            if args.table=="files":
                page=[{k:v for k,v in r.items() if k!="content"} for r in page]
            emit({"total":total,"offset":args.offset,"returned":len(page),
                  "next_offset":args.offset+len(page) if args.offset+len(page)<total else None,"records":page})
        elif command=="show":
            member=db.record(args.index,"members",args.member) if args.member else None
            fid=member["file_id"] if member else args.file_id
            f=db.record(args.index,"files",fid)
            if not f.get("content"):raise ValueError("此文件没有可读快照，可能被排除或读取失败")
            if not f.get("evidence_allowed",True):
                raise ValueError("未完整分类的目标文件已隔离，不导出正文。核对输入确为业务后，可明确配置allow_unparsed_target_evidence并重新扫描。")
            lines=f["content"].splitlines()
            begin=args.start or (member["start_line"] if member else 1)
            end=args.end or (member["end_line"] if member else len(lines))
            if not 1<=begin<=end<=len(lines):raise ValueError(f"请求行号超出快照，有效范围为1到{len(lines)}")
            emit({"snapshot_id":db.metadata(args.index)["snapshot_id"],"file_id":fid,
                  "member":member,"start_line":begin,"end_line":end,
                  "content":"\n".join(lines[begin-1:end]),
                  "numbered_content":"\n".join(f"{n}: {lines[n-1]}" for n in range(begin,end+1))})
        elif command=="packet":
            emit(packets(args.index,args.output,args.module,args.max_chars))
        elif command=="draft":
            result=draft(args.index)
            report=check(result,args.index)
            if report["errors"]:raise ValueError("内部草稿引用检查失败："+str(report["errors"]))
            write_json(args.output,result.model_dump())
            emit({"created":str(args.output),"items":len(result.items),"phase":result.phase,
                  "note":"不是AI分析完成，不是测试结果。"})
        elif command=="merge":
            base=Materials.model_validate(read_json(args.base))
            additions=[Contribution.model_validate(read_json(p)) for p in args.analysis]
            result,audit=merge(base,additions,set(args.replace_id),args.mark_complete)
            report=check(result,args.index)
            if report["errors"]:raise ValueError("合并引用检查失败："+str(report["errors"]))
            audit_path=args.output.with_name(args.output.stem+".merge_audit.json")
            if args.output.exists() or audit_path.exists():raise FileExistsError("合并输出或审计文件已存在，未覆盖")
            write_json(args.output,result.model_dump())
            write_json(audit_path,{"snapshot_id":result.snapshot_id,"revisions":audit,
                "contributions":[str(p) for p in args.analysis]})
            emit({"created":str(args.output),"audit":str(audit_path),"warnings":report["warnings"]})
        elif command=="check":
            result=Materials.model_validate(read_json(args.materials))
            report=check(result,args.index,check_live=args.live);emit(report)
            return 0 if report["structurally_valid"] else 2
        elif command=="export":
            result=Materials.model_validate(read_json(args.materials))
            emit(export_files(result,args.index,args.output,overwrite=args.overwrite))
        elif command=="schema":
            for name,model in (("project_config",ProjectConfig),("project_materials",Materials),("analysis_contribution",Contribution)):
                write_json(args.output/(name+".schema.json"),model.model_json_schema(),overwrite=args.overwrite)
            emit({"directory":str(args.output)})
        elif command=="fetch":
            if not re.fullmatch(r"https://github\.com/[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+(?:\.git)?",args.url):
                raise ValueError("只接收不带凭证/查询参数的https GitHub仓库地址")
            if not re.fullmatch(r"[0-9a-fA-F]{40}",args.commit):
                raise ValueError("commit必须是完整40位提交哈希")
            dest=args.destination.resolve()
            if dest.exists():raise FileExistsError("目标目录已存在，未修改；请选择新的工作副本目录")
            dest.parent.mkdir(parents=True,exist_ok=True)
            run(["git","clone","--no-checkout","--",args.url,str(dest)],timeout=300)
            run(["git","-C",str(dest),"checkout","--detach",args.commit],timeout=180)
            actual=run(["git","-C",str(dest),"rev-parse","HEAD"],timeout=20).stdout.strip()
            if actual.lower()!=args.commit.lower():raise ValueError("实际提交与要求不符")
            emit({"directory":str(dest),"commit":actual,"note":"只获取本地副本，未修改远端；未执行仓库脚本。"})
        return 0
    except (ValidationError,ValueError,KeyError,FileExistsError,OSError,RuntimeError,sqlite3.Error,subprocess.TimeoutExpired) as ex:
        print(json.dumps({"error":str(ex),"command":args.command},ensure_ascii=False,indent=2),file=sys.stderr)
        return 2

if __name__=="__main__":
    raise SystemExit(main())

