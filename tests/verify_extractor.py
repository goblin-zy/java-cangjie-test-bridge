from pathlib import Path
import argparse,subprocess,json,sys,hashlib,datetime
ROOT=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(ROOT/'tools'))
from restore_methods import reconstruct

def run(args,cwd=None):
    p=subprocess.run([str(x) for x in args],cwd=cwd,capture_output=True,encoding='utf-8',errors='replace')
    return p
def check_spans(metadata):
    data=json.loads(metadata.read_text(encoding='utf-8'))
    assert len({m['id'] for m in data['members']})==len(data['members'])
    for f in data['files']:
        if f['status']=='extracted':
            assert reconstruct(metadata,f)==(metadata.parent/f['original_file']).read_bytes()
    for m in data['members']:
        if not m.get('has_body'):continue
        loc=m['body_source_location'];raw=(metadata.parent/loc['file']).read_bytes().decode('utf-8').encode('utf-16-le')
        assert raw[2*loc['start_offset_utf16']:2*loc['end_offset_utf16_exclusive']].decode('utf-16-le')==m['original_body']
    return data
def main():
    a=argparse.ArgumentParser();a.add_argument('--java-home',type=Path,required=True);a.add_argument('--output',type=Path,required=True);a.add_argument('--classpath-file',type=Path);args=a.parse_args()
    args.output.mkdir(parents=True,exist_ok=True)
    if any(args.output.iterdir()):raise SystemExit('Acceptance output must be new or empty')
    classes=ROOT/'build/extractor';classes.mkdir(parents=True,exist_ok=True)
    javac=args.java_home/'bin/javac.exe';java=args.java_home/'bin/java.exe'
    compile_result=run([javac,'-encoding','UTF-8','--add-modules','jdk.compiler','-d',classes,ROOT/'src/main/java/JavaTestSkeletonExtractor.java'])
    (args.output/'compile.log').write_text(compile_result.stdout+compile_result.stderr,encoding='utf-8');assert compile_result.returncode==0,compile_result.stderr
    base=[java,'-Dfile.encoding=UTF-8','--add-modules','jdk.compiler','-cp',classes,'JavaTestSkeletonExtractor']
    results=[]
    for label,inp in [('business',ROOT/'src/test/java/study/translation'),('structural',ROOT/'tests/fixtures')]:
        out=args.output/label;p=run(base+['--input',inp,'--output',out])
        (args.output/(label+'.log')).write_text(p.stdout+p.stderr,encoding='utf-8');assert p.returncode==0,p.stderr
        data=check_spans(out/'members.json')
        if label=='business':
            assert data['summary']['roles']=={'field':1,'helper':1,'lifecycle_BeforeEach':1,'test':24}
            assert data['summary']['files']==3
        else:
            mm=data['members'];codes={d['code'] for d in data['diagnostics']}
            overloads=[m for m in mm if m['name']=='overloaded'];assert len(overloads)==2 and overloads[0]['id']!=overloads[1]['id']
            assert any(m['role']=='constructor' and m.get('constructor_delegation')=='this(3);' for m in mm)
            assert any(m['role']=='constructor' and m.get('constructor_delegation')=='super(value);' for m in mm)
            assert any(m['role']=='test_ParameterizedTest' for m in mm)
            assert any(m['name']=='fetch' and m['original_body'] is None for m in mm)
            assert any(m['name']=='customAnnotation' and m['role']=='helper' for m in mm)
            assert any(m['owner'].endswith('$NestedCase') and m['role']=='test' for m in mm)
            assert {'CLASS_INITIALIZER_RETAINED','LOCAL_OR_ANONYMOUS_CLASS_IN_METHOD','UNRESOLVED_TEST_ANNOTATION','EXTENDED_TEST_MECHANISM'}<=codes
            assert not any('$Local#' in m['id'] for m in mm)
        # 再次解析生成骨架：语法结构必须仍可读取。
        parsed=run(base+['--input',out/'skeleton','--output',args.output/(label+'-reparsed')]);assert parsed.returncode==0,parsed.stderr
        if args.classpath_file:
            typed=args.output/(label+'-compiled');typed.mkdir()
            cp=args.classpath_file.read_text(encoding='utf-8').strip()
            checked=run([javac,'-encoding','UTF-8','--release','17','-classpath',cp,'-d',typed,*sorted((out/'skeleton').rglob('*.java'))])
            (args.output/(label+'-typecheck.log')).write_text(checked.stdout+checked.stderr,encoding='utf-8')
            assert checked.returncode==0,checked.stderr
        # 输出目录保护：重复输出必须拒绝，不能静默覆盖旧证据。
        before=hashlib.sha256((out/'members.json').read_bytes()).hexdigest()
        denied=run(base+['--input',inp,'--output',out]);assert denied.returncode!=0
        assert hashlib.sha256((out/'members.json').read_bytes()).hexdigest()==before
        results.append({'case':label,'status':'passed','files':data['summary']['files'],'members':data['summary']['members'],'checks':['roles','unique_ids','UTF16_source_spans','byte_exact_restoration','skeleton_reparse','output_overwrite_protection']})
    bad=run(base+['--input',ROOT/'tests/invalid/Broken.java','--output',args.output/'invalid'])
    bad_data=json.loads((args.output/'invalid/members.json').read_text(encoding='utf-8'));assert bad.returncode==1 and bad_data['summary']['errors']>0
    assert bad_data['files'][0]['status']=='syntax_error' and bad_data['files'][0]['skeleton_file'] is None
    (args.output/'invalid.log').write_text(bad.stdout+bad.stderr,encoding='utf-8')
    results.append({'case':'invalid_syntax','status':'passed','checks':['nonzero_exit','error_diagnostics','no_fake_success_skeleton']})
    report={'time':datetime.datetime.now(datetime.timezone(datetime.timedelta(hours=8))).isoformat(),'java_home':str(args.java_home),'status':'passed','results':results}
    (args.output/'acceptance.json').write_text(json.dumps(report,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
    print(json.dumps(report,ensure_ascii=True))
if __name__=='__main__':main()
