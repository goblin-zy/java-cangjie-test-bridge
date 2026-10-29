"""仅修改独立业务副本，用有针对性的错误检查参考测试的检查能力。"""
from pathlib import Path
import argparse,subprocess,json,shutil,hashlib,difflib,datetime
ROOT=Path(__file__).resolve().parents[1]
FAULTS=[
    dict(id='account_add',file='account.cj',before='balance -= amount',after='balance += amount',meaning='取款错误地增加余额',trigger='余额100时取30或取100；连续操作和失败后合法取款',expected=['A03','A04','A05','A06']),
    dict(id='rectangle_touch',file='rectangle.cj',before='r.left > right',after='r.left >= right',meaning='共享边被错误判为完全分离',trigger='(0,0,1,1)与(1,0,2,1)',expected=['R04']),
    dict(id='parser_inc',file='instruction_parser.cj',before='case "INC" => result.add(1)',after='case "INC" => result.add(2)',meaning='INC错误映射成2',trigger='ZERO INC DEC或INC 35 DEC',expected=['P03','P05']),
    dict(id='account_failed_state',file='account.cj',before='if (amount > balance) { throw InsufficientFundsException("insufficient funds") }',after='if (amount > balance) { balance -= 1; throw InsufficientFundsException("insufficient funds") }',meaning='余额不足时仍错误扣除1个单位',trigger='余额100时尝试取101，随后合法取40',expected=['A06'])
]
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def main():
    parser=argparse.ArgumentParser();parser.add_argument('--sdk-home',type=Path,required=True);parser.add_argument('--output',type=Path,required=True);parser.add_argument('--scratch',type=Path,required=True);args=parser.parse_args()
    args.output=args.output.resolve();args.scratch=args.scratch.resolve();args.sdk_home=args.sdk_home.resolve()
    if args.output.exists() and any(args.output.iterdir()):raise SystemExit('Output must be new or empty')
    if args.scratch.exists() and any(args.scratch.iterdir()):raise SystemExit('Scratch must be new or empty')
    args.output.mkdir(parents=True,exist_ok=True);args.scratch.mkdir(parents=True,exist_ok=True)
    shell=shutil.which('pwsh') or shutil.which('powershell')
    if not shell:raise SystemExit('PowerShell required')
    original=ROOT/'reference/cangjie/implementation';tests=ROOT/'reference/cangjie/tests'
    test_hashes={p.name:sha(p) for p in tests.glob('*.cj')}
    original_hashes={p.name:sha(p) for p in original.glob('*.cj')}
    records=[]
    for spec in FAULTS:
        copy=args.scratch/spec['id'];shutil.copytree(original,copy)
        target=copy/spec['file'];before=target.read_text(encoding='utf-8');assert before.count(spec['before'])==1,spec['id']
        after=before.replace(spec['before'],spec['after'],1);target.write_text(after,encoding='utf-8')
        patch=''.join(difflib.unified_diff(before.splitlines(True),after.splitlines(True),fromfile='a/'+spec['file'],tofile='b/'+spec['file']))
        (args.output/(spec['id']+'.patch')).write_text(patch,encoding='utf-8')
        out=args.output/spec['id']
        command=[shell,'-NoProfile','-File',str(ROOT/'scripts/run-reference-cangjie.ps1'),'-SdkHome',str(args.sdk_home),'-ImplementationDirectory',str(copy.resolve()),'-TestsDirectory',str(tests),'-OutputDirectory',str(out.resolve())]
        run=subprocess.run(command,capture_output=True,encoding='utf-8',errors='replace')
        (args.output/(spec['id']+'-driver.log')).write_text(run.stdout+run.stderr,encoding='utf-8')
        result=json.loads((out/'results.json').read_text(encoding='utf-8-sig'))
        failed={x['id'] for x in result['cases'] if x['status']=='failed'}
        assert result['compile_exit']==0 and result['not_executed']==0 and result['discovered_in_final_report']==24,result
        assert result['error']==0 and result['skipped']==0,result
        assert failed==set(spec['expected']),(spec['id'],failed,spec['expected'])
        assert result['run_exit']!=0 and run.returncode!=0
        records.append({'id':spec['id'],'file':spec['file'],'meaning':spec['meaning'],'trigger':spec['trigger'],'predicted_related_tests':spec['expected'],'actual_failed_tests':sorted(failed),'compile_exit':result['compile_exit'],'run_exit':result['run_exit'],'passed':result['passed'],'failed':result['failed'],'error':result['error'],'skipped':result['skipped'],'result_file':str((out/'results.json').relative_to(ROOT)) if out.is_relative_to(ROOT) else str(out/'results.json')})
    assert {p.name:sha(p) for p in tests.glob('*.cj')}==test_hashes
    assert {p.name:sha(p) for p in original.glob('*.cj')}==original_hashes
    report={'time':datetime.datetime.now(datetime.timezone(datetime.timedelta(hours=8))).isoformat(),'status':'passed','normal_source_unchanged':True,'reference_tests_unchanged':True,'scope':'four selected business faults; not comprehensive mutation testing','faults':records}
    (args.output/'fault-checks.json').write_text(json.dumps(report,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
    print(json.dumps(report,ensure_ascii=True))
if __name__=='__main__':main()
