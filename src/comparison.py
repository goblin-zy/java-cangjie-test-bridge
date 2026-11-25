"""Comparison packets, evidence checking, class-level reconciliation and delivery."""
import json
from pathlib import Path
import shutil
import tempfile

from workflow import (RESULTS, SIDES, alignment, folder, put, ranges, read, render,
                      require, save, sha, stage)


def packet(run, unit, notes):
    a = alignment(run)
    bundle = {"unit": unit, "route": a["route"], "contract": a["contract"],
              "materials": a.get("materials", {}), "sides": {}}
    for side in SIDES:
        out = folder(run, side)
        loc = read(out / "source_locations.json")["original_to_annotated"]
        segments = {}
        for n in notes[side]:
            segments[n["片段编号"]] = {**n, "annotated": [loc[n["start"]-1], loc[n["end"]-1]]}
        bundle["sides"][side] = {"file": a["files"][side], "segments": segments,
            "context": read(out / f"context_{side}.json"), "edit_check": read(out / "edit_check.json")}
    digest = sha(json.dumps(bundle, ensure_ascii=False, sort_keys=True).encode())
    return {**bundle, "packet_hash":digest}


def bundles(run):
    notes = {side:render(run, side) for side in SIDES}
    return {u["id"]:packet(run,u,notes) for u in alignment(run)["units"]}


def make_packets(run):
    for uid, data in bundles(run).items():
        save(stage(run, 3) / f"compare_{uid}.json", data)


def unit_view(run, uid):
    available = bundles(run)
    require(uid in available, "未知比较单元")
    b = available[uid]
    for side in SIDES:
        peers = [span for key, other in available.items() if key != uid
                 for span in ranges(other["unit"],side)]
        segments = b["sides"][side]["segments"]
        b["sides"][side]["segments"] = {
            key:n for key,n in segments.items()
            if not any(lo <= n["start"] <= n["end"] <= hi for lo,hi in peers)}
    return b

def verdict(checks):
    values = {c["status"] for c in checks}
    return next(s for s in (RESULTS[1],RESULTS[2],RESULTS[0]) if s in values)


def checked(bundle, submission):
    u = bundle["unit"]
    require(submission["id"] == u["id"] and submission["packet_hash"] == bundle["packet_hash"],
            "提交引用了其他单元或旧版本材料，请重新比较")
    checks = submission["checks"]
    require(isinstance(checks,list) and checks, "需要逐项比较结果")
    require(all(u[s] for s in SIDES), "未定位单元应在清点时记录为受阻")
    require(any(c["kind"] == "source" for c in checks), "缺少源码层面的比较")
    covered = {side:set() for side in SIDES}
    for c in checks:
        require(c["kind"] in ("source","interface") and c["status"] in RESULTS, "比较类型或状态无效")
        require(all(isinstance(c[k],str) and c[k].strip() for k in ("topic","reason")), "缺少比较说明")
        if c["kind"] == "interface":
            if bundle["contract"]["status"] == "missing":
                require(c["status"] == RESULTS[2], "缺约定时接口语义须标为信息不足")
            elif c["status"] != RESULTS[2]:
                ref = c["contract_reference"]
                original = Path(bundle["contract"]["path"]).read_bytes()
                require(sha(original) == bundle["contract"]["sha256"], "接口约定快照已变更")
                require(ref["quote"].strip() and ref["quote"] in original.decode("utf-8-sig")
                        and ref["assumption"].strip(), "接口约定须注明可核验的原文及假设")
        if c["status"] != RESULTS[0]:
            require(c.get("recheck"), "差异或未知项需要回查说明")
        for side in SIDES:
            refs = c[side]
            require(isinstance(refs,list), "证据编号应为列表")
            require(set(refs) <= bundle["sides"][side]["segments"].keys(), "引用了未知片段")
            covered[side].update(refs)
        require(c["java"] or c["cangjie"], "比较项缺少源码证据")
        if c["status"] == RESULTS[0]:
            require(c["java"] and c["cangjie"], "一致结论需要双侧证据")
    for side in SIDES:
        inside = {k for k,n in bundle["sides"][side]["segments"].items()
                  if any(lo <= n["start"] <= n["end"] <= hi for lo,hi in ranges(u,side))}
        require(inside and inside <= covered[side], f"{side} 单元内有片段未交代")
    require(any(c["kind"]=="interface" for c in checks) or submission.get("no_interface_reason"),
            "请记录接口对应问题，或说明此测试为何不依赖业务接口")
    return {**submission, "name":u["name"], "status":verdict(checks)}


def submit(run, path):
    draft = read(path)
    available = bundles(run)
    uid = draft["id"]
    data = checked(available[uid], draft)
    out = stage(run,3)
    prior = out / f"result_{uid}.json"
    log = out / "recheck_log.json"
    events = read(log) if log.exists() else []
    if prior.exists() and read(prior) != data:
        require(data.get("revision_reason"), "修改已有结论需填写 revision_reason")
        events.append({"id":uid,"previous":read(prior),"revision_reason":data["revision_reason"]})
    for c in data["checks"]:
        if c.get("recheck"):
            event = {"id":uid,"topic":c["topic"],"recheck":c["recheck"],"status":c["status"]}
            if event not in events:
                events.append(event)
    save(log, events)
    save(prior, data)


def inventory(run, available):
    rows = []
    source_units = read(stage(run,1) / "source_scope.json")["units"]
    require({u["id"] for u in source_units} == set(available), "源清单与对齐表的单元编号不一致，请复核第一步")
    for source in source_units:
        uid = source["id"]
        b = available[uid]
        u = b["unit"]
        require(u["source_member_id"] == source["source_member_id"], "源测试身份与对齐表不一致")
        path = stage(run,3) / f"result_{uid}.json"
        if not all(u[s] for s in SIDES):
            rows.append({"id":uid,"name":u["name"],"state":"定位受阻","reason":u["reason"]})
        elif not path.exists():
            rows.append({"id":uid,"name":u["name"],"state":"漏做","reason":"缺少逐项结论"})
        else:
            r = checked(b, read(path))
            rows.append({"id":uid,"name":u["name"],"state":"已比较","status":r["status"]})
    return rows


def audit(run, decision=None):
    available = bundles(run)
    rows = inventory(run, available)
    result = {"units":rows,"selected":len(rows),
              "compared":sum(r["state"]=="已比较" for r in rows), "cross_review":None}
    if decision is not None:
        require(decision["action"] in ("复用已有依据","已补查","待确认") and decision["reason"].strip(),
                "需说明类级补查决定及证据")
        require(isinstance(decision["affected"],list) and set(decision["affected"]) <= available.keys(),
                "受影响单元无效")
        if decision["action"] != "复用已有依据":
            require(decision["affected"], "请列出受影响单元")
        result["cross_review"] = decision
    save(stage(run,4) / "completeness.json",result)
    return result


def summarize(run, decision):
    a = alignment(run)
    state = audit(run,read(decision))
    require(not any(r["state"]=="漏做" for r in state["units"]), "仍有可定位测试漏做，请补做后汇总")
    out = stage(run,3)
    results = [read(out / ('result_'+r["id"]+'.json')) for r in state["units"] if r["state"]=="已比较"]
    review = state["cross_review"]
    if review["action"] == "待确认":
        for r in results:
            if r["id"] in review["affected"]:
                require(any(c.get("class_review") is True and c["status"] == RESULTS[2] for c in r["checks"]),
                        f'{r["id"]} 须先提交带 class_review=true 的跨测试未知项')
    if review["action"] != "复用已有依据":
        log_path = out / "recheck_log.json"
        events = read(log_path) if log_path.exists() else []
        event = {"stage":4, **review}
        if event not in events:
            save(log_path, events + [event])
    available = bundles(run)
    evidence = {}
    for r in results:
        b = available[r["id"]]
        for c in r["checks"]:
            for side in SIDES:
                for ident in c[side]:
                    n = b["sides"][side]["segments"][ident]
                    evidence[f"{side}/{ident}"] = {"file":a["files"][side],
                        "original":[n["start"],n["end"]],"annotated":n["annotated"],"quote":n["quote"]}
    log = out / "recheck_log.json"
    report = {"route":a["route"],"files":a["files"],"versions":a.get("versions",{}),
              "contract":a["contract"],"scope":state,"results":results,"evidence":evidence,
              "rechecks":read(log) if log.exists() else [],"method":"双侧源码静态比较"}
    save(stage(run,5) / "report.json", report)
    return report


def deliver(run, decision, narrative):
    target = run / "deliverables"
    require(not target.exists(), "此运行已交付，重新验证请使用新的运行目录")
    report = summarize(run, decision)
    prose = narrative.read_text(encoding="utf-8-sig").strip()
    require(prose and all(r["name"] in prose for r in report["scope"]["units"]), "报告正文需说明每个选定测试")
    lines = ["# 测试翻译静态验证报告", "",prose,"","## 范围与结果索引","",
             f'路线 `{report["route"]}`，选定 {report["scope"]["selected"]} 项，完成比较 {report["scope"]["compared"]} 项。',
             f'目标接口约定状态 `{report["contract"]["status"]}`。版本指纹见 [结构化报告](report.json) 的 versions。',""]
    for row in report["scope"]["units"]:
        lines.append(f'- {row["id"]} · {row["name"]} · {row.get("status",row["state"])}')
    lines.extend(["","## 原文证据","","行号指向交付包中带注释的源码。",""])
    for ident,ev in report["evidence"].items():
        lo,hi = ev["annotated"]
        lines.append(f'- {ident} · [{ev["file"]} 第 {lo}–{hi} 行]({ev["file"]}#L{lo})')
    out = stage(run,5)
    put(out / "report.md",("\n".join(lines)+"\n").encode())
    # Keep the stage report's relative source links usable before and after export.
    for side, name in report["files"].items():
        put(out / name, (folder(run,side) / name).read_bytes())
    with tempfile.TemporaryDirectory(dir=out) as temp:
        copied = Path(temp) / "delivery"
        copied.mkdir()
        files = [out/"report.md",out/"report.json"] + [out/n for n in report["files"].values()]
        for file in files:
            dest = copied/file.name
            require(not dest.exists(),"交付文件重名")
            shutil.copyfile(file,dest)
            require(sha(dest.read_bytes())==sha(file.read_bytes()),"复制校验失败")
        copied.rename(target)

