"""Run one or a batch of single-package Cangjie test combinations.

No model calls. Compile, discover and execute are separate subprocess stages.
Windows SDK 1.2.0 is the locally exercised backend. Original sources are read-only.
"""
from pathlib import Path
from datetime import datetime,timezone,timedelta
import argparse,csv,hashlib,json,os,re,shutil,subprocess,sys,tempfile,time
import xml.etree.ElementTree as ET

VERSION='1.0'
TZ=timezone(timedelta(hours=8))
ANSI=re.compile(r'\x1b(?:\[[0-?]*[ -/]*[@-~]|.)')
SKIP_DIRS={'target','build','.git','.cache','reports'}
def now():return datetime.now(TZ).isoformat()
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def dump(p,x):p.write_text(json.dumps(x,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
def decode(b):
    try:return b.decode('utf-8')
    except UnicodeDecodeError:return b.decode('gb18030',errors='replace')
def resolve(base,p):
    v=Path(p);return (base/v).resolve() if not v.is_absolute() else v.resolve()
def process(args,cwd,env,timeout,folder,stage):
    started=now();tick=time.monotonic();timed=False
    try:
        p=subprocess.Popen(args,cwd=cwd,env=env,stdout=subprocess.PIPE,stderr=subprocess.PIPE,creationflags=0x08000000 if os.name=='nt' else 0)
        try:out,err=p.communicate(timeout=timeout)
        except subprocess.TimeoutExpired:
            timed=True
            if os.name=='nt':subprocess.run(['taskkill','/PID',str(p.pid),'/T','/F'],stdout=subprocess.DEVNULL,stderr=subprocess.DEVNULL)
            else:p.kill()
            out,err=p.communicate()
        rec={'started_at':started,'finished_at':now(),'duration_seconds':round(time.monotonic()-tick,3),'argv':args,'cwd':str(cwd),'exit_code':None if timed else p.returncode,'timed_out':timed,'launch_error':None}
    except OSError as e:
        out=b'';err=str(e).encode('utf-8');rec={'started_at':started,'finished_at':now(),'duration_seconds':round(time.monotonic()-tick,3),'argv':args,'cwd':str(cwd),'exit_code':None,'timed_out':False,'launch_error':str(e)}
    (folder/(stage+'.stdout.log')).write_bytes(out);(folder/(stage+'.stderr.log')).write_bytes(err)
    clean=ANSI.sub('',decode(out)+decode(err)).replace('\r','')
    (folder/(stage+'.log')).write_text(clean,encoding='utf-8')
    rec['logs']={'stdout':stage+'.stdout.log','stderr':stage+'.stderr.log','readable':stage+'.log'}
    dump(folder/(stage+'.command.json'),rec)
    return rec,clean
def sdk_environment(sdk):
    env=dict(os.environ)
    if os.name!='nt':raise ValueError('当前后端仅支持Windows SDK；其他平台未验收。')
    setup=sdk/'envsetup.bat'
    if not setup.exists() or not (sdk/'bin/cjc.exe').exists():raise ValueError('SDK目录缺少envsetup.bat或bin/cjc.exe')
    if any(x in str(setup) for x in ['"','&','|','<','>','^','%','\n','\r']):raise ValueError('SDK路径含当前后端不支持的命令字符')
    cmd='"'+str(Path(os.environ.get('COMSPEC','C:/Windows/System32/cmd.exe')))+'" /d /s /c "call "'+str(setup)+'" >nul && set"'
    p=subprocess.run(cmd,capture_output=True,timeout=30,creationflags=0x08000000)
    if p.returncode:raise ValueError('SDK环境配置失败：'+decode(p.stderr))
    for line in decode(p.stdout).splitlines():
        if '=' in line and not line.startswith('='):
            key,val=line.split('=',1);env[key]=val
    return env
def collect(base,paths,role):
    if isinstance(paths,str):paths=[paths]
    if not isinstance(paths,list) or not paths:raise ValueError(role+'必须给出一个或多个路径')
    files=[]
    for value in paths:
        p=resolve(base,value)
        if not p.exists():raise ValueError('输入路径不存在：'+str(p))
        candidates=[p] if p.is_file() else sorted(p.rglob('*.cj'))
        for c in candidates:
            if c.suffix!='.cj' or any(x in SKIP_DIRS for x in c.relative_to(p if p.is_dir() else p.parent).parts):continue
            if role=='business' and c.name.endswith('_test.cj'):continue
            if c.resolve() not in files:files.append(c.resolve())
    if not files:raise ValueError(role+'没有收集到.cj文件')
    return files
def identity(cls,name):return cls+'#'+name+'()'
def discover(text):
    pkg=None;cls=None;cases={}
    for line in text.splitlines():
        m=re.match(r'\s*TP:\s*([^,]+),',line)
        if m:pkg=m[1].strip();continue
        m=re.match(r'\s*TCS:\s*([^,]+),',line)
        if m:cls=m[1].strip();continue
        m=re.search(r'\[\s*(NORUN|SKIPPED)\s*\]\s*CASE:\s*([A-Za-z_]\w*)\s*$',line)
        if m:
            if not pkg or not cls:raise ValueError('无法解析测试类，当前仅支持简单非参数化类测试')
            full=cls if cls.startswith(pkg+'.') else pkg+'.'+cls
            ident=identity(full,m[2])
            if ident in cases:raise ValueError('重复测试标识：'+ident)
            cases[ident]=m[1]
    totals=re.findall(r'Summary:\s*TOTAL:\s*(\d+)',text)
    if not totals:raise ValueError('测试发现输出缺少TOTAL，不能把解析失败写成零测试')
    total=int(totals[-1])
    skipped=re.findall(r'Summary:\s*TOTAL:\s*\d+,\s*SKIPPED:\s*(\d+)',text)
    hidden=total-len(cases)
    if hidden<0 or hidden>(int(skipped[-1]) if skipped else 0):raise ValueError('发现总数与可解析条目不一致，且无法用跳过项解释')
    return cases,total,hidden
def console_counts(text):
    matches=re.findall(r'Summary:\s*TOTAL:\s*(\d+)[\s,]+PASSED:\s*(\d+),\s*SKIPPED:\s*(\d+),\s*ERROR:\s*(\d+)\s+FAILED:\s*(\d+)',text)
    if not matches:raise ValueError('运行输出缺少完整数量汇总')
    total,passed,skipped,errors,failed=map(int,matches[-1])
    if passed+skipped+errors+failed!=total:raise ValueError('运行汇总数量不守恒')
    return {'total':total,'passed':passed,'failed':failed,'errors':errors,'skipped':skipped}
def xml_results(folder):
    paths=sorted(folder.rglob('*.xml'));cases={};suite_counts={'total':0,'passed':0,'failed':0,'errors':0,'skipped':0}
    if not paths:return None,[]
    for p in paths:
        root=ET.parse(p).getroot()
        suites=[root] if root.tag=='testsuite' else list(root.findall('.//testsuite'))
        for suite in suites:
            raw=list(suite.findall('testcase'))
            counts={k:int(suite.attrib.get(k,0)) for k in ['tests','failures','errors','skipped']}
            if counts['tests']!=len(raw):raise ValueError('XML套件总数与条目数不一致')
            local={'FAILED':0,'ERROR':0,'SKIPPED':0,'PASSED':0}
            for t in raw:
                name=t.attrib.get('name','');cls=t.attrib.get('classname',suite.attrib.get('name',''))
                if not re.fullmatch(r'[A-Za-z_]\w*',name):raise ValueError('当前不支持参数化或动态测试名：'+name)
                key=identity(cls,name)
                if key in cases:raise ValueError('XML重复测试标识：'+key)
                status='ERROR' if t.find('error') is not None else 'FAILED' if t.find('failure') is not None else 'SKIPPED' if t.find('skipped') is not None else 'PASSED'
                cases[key]=status;local[status]+=1
            if (local['FAILED'],local['ERROR'],local['SKIPPED'])!=(counts['failures'],counts['errors'],counts['skipped']):raise ValueError('XML套件汇总与用例状态不一致')
            suite_counts['total']+=counts['tests']
            for field,status in [('passed','PASSED'),('failed','FAILED'),('errors','ERROR'),('skipped','SKIPPED')]:suite_counts[field]+=local[status]
    return {'cases':cases,'counts':suite_counts},paths
def expected_set(names,inventory):
    resolved=[];unresolved=[]
    for name in names:
        matches=[x for x in inventory if x==name or x.endswith('.'+name)]
        if len(matches)>1:raise ValueError('预期标识不唯一：'+name)
        if not matches:unresolved.append(name)
        else:resolved.append(matches[0])
    if len(set(resolved))!=len(resolved):raise ValueError('预期测试清单存在重复')
    return set(resolved),unresolved

def one(config,case,base,output,env,compiler):
    ident=case.get('id','')
    if not re.fullmatch(r'[A-Za-z0-9_-]+',ident):raise ValueError('组合id只能含英文字母、数字、下划线、连字符')
    folder=output/ident;folder.mkdir()
    result={'schema_version':'cangjie-execution-v1','combination_id':ident,'business_role':case.get('business_role','unspecified'),'started_at':now(),'status':'PENDING','compile_status':'NOT_RUN','expected_count':None,'discovered_count':None,'executed_count':None,'passed_count':None,'failed_count':None,'error_count':None,'skipped_count':None,'compile_exit_code':None,'discovery_exit_code':None,'run_exit_code':None,'expected_execution_ratio':None,'pass_rate_executed':None,'expected_pass_ratio':None,'missing_expected':[],'not_executed_expected':[],'unexpected_executed':[],'stages':{},'sources':[],'source_integrity':None,'limitations':['单包、简单非参数化类测试；未判定测试意图或完整语义等价。']}
    def finish(status,message):
        result.update(status=status,message=message,finished_at=now())
        if result['sources']:result['source_integrity']=all(Path(s['original_path']).exists() and sha(Path(s['original_path']))==s['sha256'] for s in result['sources'])
        dump(folder/'result.json',result)
        lines=[f'# 运行报告 {ident}','',f"状态：{status}",f"说明：{message}",'','| 字段 | 值 |','| --- | --- |']
        for key in ['compile_status','expected_count','discovered_count','executed_count','passed_count','failed_count','error_count','skipped_count','compile_exit_code','discovery_exit_code','run_exit_code','expected_execution_ratio','expected_pass_ratio']:
            value=result[key];lines.append(f'| {key} | {"未取得／未执行" if value is None else value} |')
        lines+=['','本报告根据同目录result.json生成。缺少XML、发现失败等情况保留未知值，不填成0。','', '本结果只评价给定环境中的可执行性。']
        (folder/'report.md').write_text('\n'.join(lines)+'\n',encoding='utf-8')
        return result
    try:
        names=case.get('expected_tests');number=case.get('expected_count')
        if names is not None:
            if not isinstance(names,list) or not names or any(not isinstance(x,str) for x in names):raise ValueError('expected_tests应为非空标识列表')
            if len(names)!=len(set(names)):raise ValueError('预期清单重复')
            if number is not None and number!=len(names):raise ValueError('预期数量与清单长度冲突')
            number=len(names)
        if not isinstance(number,int) or isinstance(number,bool) or number<=0:raise ValueError('必须提供正的expected_count或非空expected_tests')
        result['expected_count']=number;result['expectation_mode']='names' if names is not None else 'count';result['expected_tests']=names
        business=collect(base,case.get('business'), 'business');tests=collect(base,case.get('tests'),'tests')
        if set(business)&set(tests):raise ValueError('业务与测试输入重叠')
        allfiles=business+tests;packages=set()
        for p in allfiles:
            m=re.search(r'^\s*package\s+([\w.]+)',p.read_text(encoding='utf-8-sig'),re.M)
            packages.add(m[1] if m else '<implicit>')
        if len(packages)!=1:raise ValueError('当前仅支持一个仓颉包，输入包含多个包')
        workroot=resolve(base,config['work_root']) if config.get('work_root') else Path(tempfile.gettempdir())
        if not workroot.is_dir():raise ValueError('work_root必须是已存在目录')
        work=Path(tempfile.mkdtemp(prefix='cj_exec_',dir=workroot));result['working_directory']=str(work)
        (work/'src').mkdir();(folder/'source').mkdir()
        staged=[]
        for n,p in enumerate(allfiles):
            name=f'{n:04d}_{p.name}';dest=work/'src'/name;shutil.copyfile(p,dest);shutil.copyfile(p,folder/'source'/name)
            result['sources'].append({'role':'business' if p in business else 'tests','original_path':str(p),'snapshot':'source/'+name,'sha256':sha(p)})
            staged.append(str(dest))
        options=case.get('compile_options',config.get('compile_options',[]));runopts=case.get('run_options',config.get('run_options',[]))
        if not isinstance(options,list) or not isinstance(runopts,list) or any(not isinstance(x,str) for x in options+runopts):raise ValueError('运行及编译选项必须是字符串数组')
        if any(x in ['-o','--output','--test','--test-only'] or x.startswith(('--output=','--output-type')) for x in options):raise ValueError('编译选项不可覆盖工具管理的测试输出参数')
        if any(x.split('=')[0] in ['--help','-h','--dry-run','--report-path','--report-format','--bench'] for x in runopts):raise ValueError('运行选项不可覆盖发现及XML报告参数')
        result['run_options']=runopts;result['compile_options']=options
        exe=work/'tests.exe';timeout=float(config.get('compile_timeout',120))
        stage,text=process([str(compiler),'--test',*staged,*options,'-o',str(exe)],work,env,timeout,folder,'compile');result['stages']['compile']=stage;result['compile_exit_code']=stage['exit_code']
        if stage['timed_out']:result['compile_status']='TIMEOUT';return finish('COMPILE_TIMEOUT','编译超时，未执行测试')
        if stage['launch_error']:result['compile_status']='ENVIRONMENT_ERROR';return finish('ENVIRONMENT_ERROR',stage['launch_error'])
        if stage['exit_code']!=0:result['compile_status']='FAILED';return finish('COMPILE_FAILED','编译失败，未执行测试')
        if not exe.exists():result['compile_status']='FAILED';return finish('BUILD_ARTIFACT_MISSING','编译退出码0，但没有测试产物')
        result['compile_status']='PASSED'
        stage,text=process([str(exe),'--dry-run','--no-color','--no-progress'],work,env,float(config.get('discovery_timeout',30)),folder,'discovery');result['stages']['discovery']=stage;result['discovery_exit_code']=stage['exit_code']
        if stage['timed_out']:return finish('DISCOVERY_TIMEOUT','测试发现超时')
        if stage['launch_error'] or stage['exit_code']!=0:return finish('DISCOVERY_ERROR','测试发现程序未正常完成')
        try:inventory,discovered_total,hidden_skips=discover(text)
        except ValueError as e:return finish('RESULT_PARSE_ERROR',str(e))
        result['discovered_count']=discovered_total;result['discovered_tests']=sorted(inventory);result['unidentified_discovery_skips']=hidden_skips
        result['discovery_identity_complete']=hidden_skips==0
        if not discovered_total:
            result.update(executed_count=0,passed_count=0,failed_count=0,error_count=0,skipped_count=0,expected_execution_ratio=0.0,expected_pass_ratio=0.0)
            return finish('NO_TESTS_FOUND','编译成功但未发现测试，不能报告通过')
        if names is not None:
            try:resolved,missing=expected_set(names,inventory)
            except ValueError as e:return finish('INVALID_EXPECTATION',str(e))
            result['resolved_expected_tests']=sorted(resolved)
            result['missing_expected']=missing if not hidden_skips else []
            result['unresolved_expected_in_discovery']=missing if hidden_skips else []
        else:resolved=set();missing=[]
        reportdir=work/'xml';reportdir.mkdir()
        stage,text=process([str(exe),'--no-color','--no-progress','--report-format=xml','--report-path='+str(reportdir),*runopts],work,env,float(case.get('run_timeout',config.get('run_timeout',60))),folder,'run');result['stages']['run']=stage;result['run_exit_code']=stage['exit_code']
        archive=folder/'xml';archive.mkdir()
        for p in reportdir.rglob('*.xml'):shutil.copyfile(p,archive/p.name)
        if stage['timed_out']:return finish('RUN_TIMEOUT','执行超时，部分结果不用于完整比例统计')
        if stage['launch_error']:return finish('RUNTIME_ERROR',stage['launch_error'])
        try:parsed,paths=xml_results(archive);observed=console_counts(text)
        except (ValueError,ET.ParseError) as e:return finish('RESULT_PARSE_ERROR',str(e))
        if observed['total']!=discovered_total:return finish('RESULT_INCONSISTENT','运行总数与发现总数不一致')
        if parsed is None:
            if observed['passed']+observed['failed']+observed['errors']!=0:return finish('RUNTIME_ERROR' if stage['exit_code']!=0 else 'REPORT_MISSING','未取得实际执行用例的XML，数量不用于成功判定')
            parsed={'counts':{'total':0,'passed':0,'failed':0,'errors':0,'skipped':0},'cases':{}}
            result['report_source']='console_summary_zero_execution'
        else:result['report_source']='xml_with_console_cross_check'
        xc=parsed['counts']
        if any(xc[k]!=observed[k] for k in ['passed','failed','errors']) or xc['skipped']>observed['skipped']:return finish('RESULT_INCONSISTENT','XML与运行汇总不一致')
        counts=observed;cases=parsed['cases'];result['cases']=cases
        result['unidentified_run_skips']=counts['skipped']-xc['skipped']
        result['run_identity_complete']=result['unidentified_run_skips']==0
        for key,field in [('passed','passed_count'),('failed','failed_count'),('errors','error_count'),('skipped','skipped_count')]:result[field]=counts[key]
        executed={x for x,status in cases.items() if status!='SKIPPED'}
        result['executed_count']=len(executed)
        if names is not None:
            try:resolved,missing=expected_set(names,set(inventory)|set(cases))
            except ValueError as e:return finish('INVALID_EXPECTATION',str(e))
            result['resolved_expected_tests']=sorted(resolved)
            result['missing_expected']=missing if not result['unidentified_run_skips'] else []
            result['unresolved_expected_after_run']=missing if result['unidentified_run_skips'] else []
            result['not_executed_expected']=sorted(resolved-executed)+missing
            result['unexpected_executed']=sorted(executed-resolved)
            result['expected_execution_ratio']=len(resolved&executed)/number
            result['expected_pass_ratio']=sum(cases.get(x)=='PASSED' for x in resolved)/number
        else:
            result['expected_execution_ratio']=len(executed)/number
            result['expected_pass_ratio']=counts['passed']/number
        result['pass_rate_executed']=counts['passed']/len(executed) if executed else None
        if executed-set(inventory):return finish('RESULT_INCONSISTENT','实际执行用例不在发现清单中')
        if len(cases)+result['unidentified_run_skips']!=discovered_total:return finish('RESULT_INCONSISTENT','命名条目和未识别跳过数与发现数不一致')
        if not executed:return finish('ZERO_TESTS_EXECUTED','测试全部跳过或被过滤，不能报告通过')
        if counts['errors']:return finish('TEST_ERROR','测试用例发生未预期运行异常')
        if counts['failed']:return finish('ASSERTION_FAILED','存在断言失败')
        if names is not None and (result['not_executed_expected'] or result['unexpected_executed']):return finish('TEST_SET_MISMATCH','预期测试未完整执行，或执行了清单外测试')
        if names is None and len(executed)!=number:return finish('TEST_COUNT_MISMATCH','实际执行数与预期数量不一致')
        if stage['exit_code']!=0:return finish('RUNTIME_ERROR','报告未含失败，但执行进程非正常退出')
        return finish('PASSED','编译、发现、执行及预期清单检查通过')
    except (ValueError,KeyError,TypeError,OSError) as e:return finish('INVALID_INPUT',str(e))

def main():
    parser=argparse.ArgumentParser(description=__doc__);parser.add_argument('--config',type=Path,required=True);parser.add_argument('--output',type=Path,required=True);args=parser.parse_args()
    cfgpath=args.config.resolve();out=args.output.resolve()
    if out.exists() and any(out.iterdir()):raise SystemExit('输出目录非空，请指定新目录保留历史记录')
    config=json.loads(cfgpath.read_text(encoding='utf-8-sig'));cases=config.get('combinations')
    if cases is None:cases=[config]
    if not isinstance(cases,list) or not cases:raise SystemExit('combinations应为非空列表')
    if any(not isinstance(x,dict) or not isinstance(x.get('id'),str) or not re.fullmatch(r'[A-Za-z0-9_-]+',x['id']) for x in cases):raise SystemExit('每个组合必须有合法的id')
    ids=[x.get('id') for x in cases]
    if len(set(ids))!=len(ids):raise SystemExit('组合id重复')
    out.mkdir(parents=True,exist_ok=True);shutil.copyfile(cfgpath,out/'input_config.json')
    base=cfgpath.parent
    setup_failed=False
    try:
        sdk=resolve(base,config['sdk_root']);env=sdk_environment(sdk)
        environment={'runner_version':VERSION,'platform':sys.platform,'python':sys.version,'sdk_root':str(sdk),'selected_environment':{k:v for k,v in env.items() if k.upper() in ['PATH','CANGJIE_HOME','TEMP','TMP','LANG']}}
        dump(out/'environment.json',environment)
        version,txt=process([str(sdk/'bin/cjc.exe'),'--version'],out,env,30,out,'compiler-version')
        if version['exit_code']!=0:raise ValueError('编译器版本检查失败')
        (out/'compiler-version.txt').write_text(txt,encoding='utf-8')
        results=[one(config,c,base,out,env,sdk/'bin/cjc.exe') for c in cases]
    except (OSError,KeyError,ValueError,subprocess.TimeoutExpired) as e:
        setup_failed=True
        dump(out/'setup_error.json',{'status':'ENVIRONMENT_ERROR','message':str(e),'at':now()})
        results=[]
        fields_unknown=['expected_count','discovered_count','executed_count','passed_count','failed_count','error_count','skipped_count','compile_exit_code','discovery_exit_code','run_exit_code','expected_execution_ratio','pass_rate_executed','expected_pass_ratio']
        for c in cases:
            r={k:None for k in fields_unknown}
            r.update(schema_version='cangjie-execution-v1',combination_id=c['id'],business_role=c.get('business_role','unspecified'),status='ENVIRONMENT_ERROR',compile_status='NOT_RUN',message=str(e),started_at=now(),finished_at=now(),stages={},sources=[],source_integrity=None,missing_expected=[],not_executed_expected=[],unexpected_executed=[],limitations=['环境准备失败，未收集或编译输入代码。'])
            names=c.get('expected_tests');count=c.get('expected_count')
            if isinstance(names,list) and names:r['expected_count']=len(names)
            elif isinstance(count,int) and not isinstance(count,bool) and count>0:r['expected_count']=count
            folder=out/c['id'];folder.mkdir();dump(folder/'result.json',r)
            (folder/'report.md').write_text('# 环境准备失败\n\n'+str(e)+'\n\n本组合未编译或执行；数量未知。详见result.json和上级setup_error.json。\n',encoding='utf-8')
            results.append(r)
    attempted=sum(r['compile_status'] in ['PASSED','FAILED','TIMEOUT'] for r in results);compiled=sum(r['compile_status']=='PASSED' for r in results)
    summary={'schema_version':'cangjie-execution-batch-v1','created_at':now(),'config_file':str(cfgpath),'combinations':results,'combination_count':len(results),'compile_attempted':attempted,'compile_succeeded':compiled,'compile_success_rate':compiled/attempted if attempted else None,'normal_combinations':[r['combination_id'] for r in results if r['business_role']=='normal'],'normal_combination_pass_rate':sum(r['status']=='PASSED' for r in results if r['business_role']=='normal')/sum(r['business_role']=='normal' for r in results) if any(r['business_role']=='normal' for r in results) else None,'all_combinations_passed':all(r['status']=='PASSED' for r in results),'scope':'可执行性评价；错误／诊断样例不作为正常业务通过率分母。'}
    dump(out/'results.json',summary)
    fields=['combination_id','business_role','status','compile_status','expected_count','discovered_count','executed_count','passed_count','failed_count','error_count','skipped_count','compile_exit_code','discovery_exit_code','run_exit_code','expected_execution_ratio','pass_rate_executed','expected_pass_ratio']
    with (out/'results.csv').open('w',encoding='utf-8-sig',newline='') as f:
        writer=csv.DictWriter(f,fieldnames=fields,extrasaction='ignore');writer.writeheader();writer.writerows(results)
    lines=['# 可执行性评价汇总','',f'组合数：{len(results)}。编译成功：{compiled}/{attempted}。','','| 组合 | 状态 | 预期 | 发现 | 执行 | 通过 | 失败 | 错误 | 跳过 |','| --- | --- | --- | --- | --- | --- | --- | --- | --- |']
    for r in results:lines.append('| '+' | '.join(str(r[k]) if r[k] is not None else '未取得' for k in ['combination_id','status','expected_count','discovered_count','executed_count','passed_count','failed_count','error_count','skipped_count'])+' |')
    lines+=['','JSON为详细记录，CSV及本报告由同一结果生成。所有输入代码保持只读，快照及完整分阶段日志保存在各组合目录。','', '退出码0仅在所有组合均PASSED时返回。诊断批次故意包含失败，退出码1是预期现象。']
    (out/'report.md').write_text('\n'.join(lines)+'\n',encoding='utf-8')
    print(json.dumps({'output':str(out),'statuses':{r['combination_id']:r['status'] for r in results},'compile_success_rate':summary['compile_success_rate']},ensure_ascii=False,indent=2))
    return 2 if setup_failed else (0 if summary['all_combinations_passed'] else 1)
if __name__=='__main__':
    if hasattr(sys.stdout,'reconfigure'):sys.stdout.reconfigure(encoding='utf-8')
    raise SystemExit(main())
