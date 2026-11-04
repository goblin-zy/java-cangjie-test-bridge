"""Java测试具体上下文查找：项目路径＋测试文件/方法标识，无选择清单。"""
from pathlib import Path
from collections import defaultdict, deque
import argparse
import base64
import hashlib
import json
import re
import subprocess
import tempfile
import xml.etree.ElementTree as ET

SKIP = {'.git', '.cache', '.gradle', '.idea', 'node_modules', 'target', 'build', '__pycache__'}
TEST_ANNOTATIONS = {'Test', 'ParameterizedTest', 'RepeatedTest', 'TestFactory', 'TestTemplate'}
LIFECYCLE = {'Before', 'After', 'BeforeClass', 'AfterClass', 'BeforeEach', 'AfterEach', 'BeforeAll', 'AfterAll'}


def sha(data): return hashlib.sha256(data).hexdigest()


def write_json(path, value):
    path.write_text(json.dumps(value, ensure_ascii=False, indent=2)+'\n', encoding='utf-8')


def walk(root):
    """不跟随链接或目录联接，排除构建输出；显式源码根在报告中列出。"""
    for p in sorted(root.iterdir()):
        if p.is_symlink() or (hasattr(p, 'is_junction') and p.is_junction()): continue
        if p.is_dir():
            if p.name not in SKIP: yield from walk(p)
        elif p.is_file(): yield p


def clean_type(value):
    value = re.sub(r'<.*>', '', value or '').replace('[]', '').replace('...', '').strip()
    return value


def discover(project, extra_sources=(), extra_resources=()):
    paths = list(walk(project)); sources, resources, issues = set(), set(), []
    # 优先由工程入口/声明模块确定根，防止把历史快照中的src树再次当成正式源码。
    bases={project} if any((project/p).exists() for p in ['pom.xml','build.gradle','build.gradle.kts','src/main/java','src/test/java']) else set()
    if not (project/'pom.xml').is_file() and any((project/p).is_file() for p in ['build.gradle','build.gradle.kts']):
        bases.update(p.parent for p in paths if p.name in {'build.gradle','build.gradle.kts'})
        issues.append({'kind':'GRADLE_STATIC_LAYOUT','reason':'按描述文件及常规源码目录发现候选模块，未执行settings/build脚本'})
    pending=list(bases);seen=set()
    while pending:
        folder=pending.pop()
        if folder in seen:continue
        seen.add(folder)
        descriptor=folder/'pom.xml'
        if descriptor.is_file():
            try:
                doc=ET.fromstring(descriptor.read_bytes())
                ns={'m':doc.tag.split('}')[0][1:]} if '}' in doc.tag else {}
                for node in doc.findall('m:modules/m:module' if ns else 'modules/module',ns):
                    child=(folder/(node.text or '')).resolve()
                    if child.is_relative_to(project) and child.is_dir():bases.add(child);pending.append(child)
            except ET.ParseError:pass
    if not bases:
        bases={p.parent for p in paths if p.name in {'pom.xml','build.gradle','build.gradle.kts'}}
    for folder in bases:
        for kind in ['main','test']:
            p=folder/'src'/kind/'java'
            if p.is_dir():sources.add(p)
            p=folder/'src'/kind/'resources'
            if p.is_dir():resources.add(p)
    for p in paths:
        if p.name == 'pom.xml' and p.parent in bases:
            try:
                tree = ET.fromstring(p.read_bytes())
                for node in tree.iter():
                    tag = node.tag.split('}')[-1]; text = (node.text or '').strip()
                    if tag in {'sourceDirectory', 'testSourceDirectory', 'directory'} and text:
                        if '${' in text:
                            issues.append({'kind': 'BUILD_PATH_UNRESOLVED', 'file': str(p.relative_to(project)), 'detail': text}); continue
                        # Maven directory只作为资源路径候选，不解释任意插件配置。
                        dest = (p.parent/text).resolve()
                        if dest.is_relative_to(project) and dest.is_dir():
                            (sources if tag != 'directory' else resources).add(dest)
            except ET.ParseError as e: issues.append({'kind': 'BUILD_PARSE_ERROR', 'file': str(p.relative_to(project)), 'detail': str(e)})
    if extra_sources:sources.clear()
    for target_set, values in [(sources,extra_sources),(resources,extra_resources)]:
        for value in values:
            p=(project/value).resolve()
            if not p.is_relative_to(project) or not p.is_dir(): raise ValueError('指定根目录须在项目内且存在: '+str(value))
            target_set.add(p)
    fallback = not sources
    if fallback: sources.add(project)
    java_files=sorted({p for root in sources for p in walk(root) if p.suffix=='.java'})
    return java_files, sorted(sources), sorted(resources), issues, fallback


class Collector:
    def __init__(self, project, facts, snapshots, resources, max_depth=6, max_members=300, max_resource_bytes=262144):
        self.project=project;self.snapshots=snapshots;self.resource_roots=resources
        self.max_depth=max_depth;self.max_members=max_members;self.max_resource_bytes=max_resource_bytes
        self.files={};self.types=defaultdict(list);self.members={};self.by_owner=defaultdict(list);self.calls=defaultdict(list);self.references=defaultdict(list)
        self.records={};self.unresolved=[];self.boundaries=[];self.queue=deque();self.queued=set();self.file_imports=set();self.seeded_types=set();self.related=defaultdict(list)
        for f in facts['files']:
            rel=Path(f['path']).resolve().relative_to(project).as_posix();f['path']=rel;self.files[rel]=f
            for t in f['types']:t['file']=rel;self.types[t['id']].append(t)
            for m in f['members']:
                m['file']=rel
                # Duplicate source definitions are diagnosed, not silently overwritten.
                if m['id'] in self.members:self.unresolved.append({'kind':'DUPLICATE_MEMBER','reference':m['id'],'file':rel,'reason':'同一成员标识对应多个源码定义'})
                else:self.members[m['id']]=m
                self.by_owner[m['owner']].append(m)
            for call in f['calls']:call['file']=rel;self.calls[call['caller']].append(call)
            for ref in f['references']:ref['file']=rel;self.references[ref['caller']].append(ref)
        self.parse_errors={}
        for error in facts['errors']:
            if error.get('path'):
                rel=Path(error['path']).resolve().relative_to(project).as_posix();self.parse_errors.setdefault(rel,[]).append(error)

    def location(self, node):
        return {'file':node['file'],'start_line':node.get('start_line'),'end_line':node.get('end_line'),'start_offset_utf16':node.get('start'),'end_offset_utf16_exclusive':node.get('end'),'sha256':sha(self.snapshots[node['file']])}

    def content(self,node):
        raw=self.snapshots[node['file']].decode('utf-8').encode('utf-16-le')
        a,b=node.get('start'),node.get('end')
        if not isinstance(a,int) or not isinstance(b,int) or not 0<=a<=b<=len(raw)//2:raise ValueError('无效源码位置: '+node.get('id',''))
        return raw[a*2:b*2].decode('utf-16-le')

    def add(self,node,category,reason,via=None):
        key=node['id']
        if key not in self.records:
            self.records[key]={'id':key,'category':category,'content':self.content(node),'source':self.location(node),'reasons':[]}
        if category=='original_test_class':self.records[key]['category']=category
        if category not in self.records[key].setdefault('categories',[self.records[key]['category']]):self.records[key]['categories'].append(category)
        why={'reason':reason,'via':via}
        if why not in self.records[key]['reasons']:self.records[key]['reasons'].append(why)
        if node.get('kind') in {'method','field','initializer'} and key not in self.related[node['file']]:self.related[node['file']].append(key)

    def unresolved_call(self,c,kind,reason,candidates=None):
        value={'kind':kind,'reference':c.get('receiver','')+'.'+c.get('name',''),'caller':c['caller'],'content':self.content(c),'source':self.location(c),'reason':reason}
        if candidates is not None:value['candidates']=candidates
        if value not in self.unresolved:self.unresolved.append(value)

    def resolve_type(self,name,owner,file):
        name=clean_type(name)
        if not name:return []
        if name in self.types:return [name]
        f=self.files[file]; explicit=[]
        for imp in f['imports']:
            imp=imp.removeprefix('static ')
            if imp.rsplit('.',1)[-1]==name:explicit.append(imp)
        if explicit:return sorted(set(explicit))
        nested=owner+'.'+name
        if nested in self.types:return [nested]
        same=(f['package']+'.' if f['package'] else '')+name
        if same in self.types:return [same]
        wildcard=[i[:-1]+name for i in f['imports'] if i.endswith('.*') and not i.startswith('static ') and i[:-1]+name in self.types]
        return sorted(set(wildcard))

    def hierarchy(self,owner):
        chain=[];seen=set()
        while owner and owner not in seen:
            seen.add(owner);chain.append(owner);ts=self.types.get(owner,[])
            if len(ts)!=1:break
            t=ts[0];parent=t.get('extends')
            if not parent:break
            resolved=self.resolve_type(parent,owner,t['file'])
            if len(resolved)!=1 or len(self.types.get(resolved[0],[]))!=1:
                self.unresolved.append({'kind':'SUPERCLASS_UNRESOLVED','reference':parent,'source':self.location(t),'reason':'父类无法在索引内唯一定位','candidates':resolved});break
            owner=resolved[0]
        if owner in seen and chain and chain[-1]!=owner:self.unresolved.append({'kind':'INHERITANCE_CYCLE','reference':owner,'reason':'继承链出现循环，停止展开'})
        return chain

    def annotation(self,m,names):
        f=self.files[m['file']]
        for a in m.get('annotations',[]):
            short=a.rsplit('.',1)[-1]
            if short not in names:continue
            if a.startswith('org.junit.') or any(i in {f'org.junit.{short}',f'org.junit.jupiter.api.{short}',f'org.junit.jupiter.params.{short}','org.junit.*','org.junit.jupiter.api.*','org.junit.jupiter.params.*'} for i in f['imports']):return short
        return None

    def enqueue(self,node,category,reason,depth=0,via=None):
        self.add(node,category,reason,via)
        if node['id'] not in self.queued:self.queued.add(node['id']);self.queue.append((node,depth))

    def include_type(self,owner,depth,via):
        ts=self.types.get(owner,[])
        if len(ts)!=1:return False
        t=ts[0]
        if t['file'] in self.parse_errors:
            self.unresolved.append({'kind':'DEPENDENCY_PARSE_ERROR','reference':owner,'source':self.location(t),'reason':'相关文件含语法错误，停止展开'})
            return False
        definition=t
        reason='完整原测试类型；相关成员另行标记'
        if owner!=getattr(self,'target_type',None):
            definition=dict(t,end=t['header_end'])
            prefix=self.snapshots[t['file']].decode('utf-8').encode('utf-16-le')[:definition['end']*2].decode('utf-16-le')
            definition['end_line']=len(prefix.splitlines()) or 1
            reason='相关类型声明头；实际相关字段和方法另外提供'
        self.add(definition,'related_definition',reason,via)
        if owner in self.seeded_types:return True
        self.seeded_types.add(owner)
        self.include_imports(t['file'])
        for node in self.by_owner[owner]:
            if node['kind'] in {'field','initializer'}:self.enqueue(node,'field_initialization','保留相关类型的字段与初始化；未做字段最小化',depth,via)
        return True

    def include_imports(self,file):
        if file in self.file_imports:return
        self.file_imports.add(file)
        for i,loc in enumerate(self.files[file]['import_locations']):
            node=dict(loc,file=file,id=file+'#import:'+str(i));self.add(node,'imports','来源文件的原始导入')

    def resolve_receiver(self,c,caller):
        owner=caller['owner'];expr=c['receiver']
        if c['constructor']:return self.resolve_type(expr,owner,c['file'])
        if c.get('receiver_type_hint'):return self.resolve_type(c['receiver_type_hint'],owner,c['file'])
        if expr in {'','this'}:return [owner]
        if expr=='super':return self.hierarchy(owner)[1:2]
        if expr.startswith('this.'):expr=expr[5:]
        if expr in caller.get('variables',{}):return self.resolve_type(caller['variables'][expr],owner,c['file'])
        for parent in self.hierarchy(owner):
            fields=[m for m in self.by_owner[parent] if m['kind']=='field' and m['name']==expr]
            if fields:return self.resolve_type(fields[0]['type'],parent,fields[0]['file'])
        if '(' in expr or ')' in expr:return []
        return self.resolve_type(expr,owner,c['file'])

    def resource(self,c,caller):
        name=c['name'];receiver=c['receiver']
        is_classpath=name in {'getResource','getResourceAsStream'}
        is_path=(name in {'get','of'} and receiver.rsplit('.',1)[-1] in {'Paths','Path'})
        is_file=c['constructor'] and clean_type(receiver).rsplit('.',1)[-1] in {'File','FileInputStream','FileReader'}
        if not (is_classpath or is_path or is_file):return
        value=c['literals'][0] if c['literals'] else None
        if not isinstance(value,str) and c['arguments']:
            token=c['arguments'][0]
            fields=[m for parent in self.hierarchy(caller['owner']) for m in self.by_owner[parent] if m['kind']=='field' and m['name']==token and m.get('final')]
            if len(fields)==1:
                try:value=json.loads(fields[0].get('initializer') or 'null')
                except json.JSONDecodeError:pass
        if not isinstance(value,str):self.unresolved_call(c,'RESOURCE_DYNAMIC_PATH','资源路径不是可确认的字符串字面量或final字段');return
        if not value or '\x00' in value:self.unresolved_call(c,'RESOURCE_INVALID_PATH','空路径或非法路径');return
        candidates=[]
        if is_classpath:
            relative=value.lstrip('/')
            if not value.startswith('/') and 'ClassLoader' not in receiver and 'getClassLoader' not in receiver:
                package=self.files[c['file']]['package']
                if receiver.endswith('.class'):
                    types=self.resolve_type(receiver[:-6],caller['owner'],c['file'])
                    if len(types)!=1 or len(self.types.get(types[0],[]))!=1:
                        self.unresolved_call(c,'RESOURCE_CLASS_UNRESOLVED','类相对资源的所属类型无法唯一确定');return
                    package=self.files[self.types[types[0]][0]['file']]['package']
                relative=(package.replace('.','/')+'/' if package else '')+relative
            if '..' in Path(relative).parts:
                self.unresolved_call(c,'RESOURCE_OUTSIDE_SCOPE','类路径资源含父目录跳转，停止读取');return
            candidates=[p/relative for p in self.resource_roots]
        else:
            if Path(value).is_absolute():self.unresolved_call(c,'RESOURCE_OUTSIDE_SCOPE','绝对文件路径不自动读取');return
            candidates=[self.project/value]+[p/value for p in self.resource_roots]
        found=[]
        for p in candidates:
            p=p.resolve()
            if p.is_relative_to(self.project) and p.is_file() and not p.is_symlink():found.append(p)
        found=sorted(set(found))
        if len(found)!=1:self.unresolved_call(c,'RESOURCE_NOT_UNIQUE','资源不存在或有多个同名候选',[str(p.relative_to(self.project)) for p in found]);return
        path=found[0];data=path.read_bytes();rel=path.relative_to(self.project).as_posix()
        if len(data)>self.max_resource_bytes:self.unresolved_call(c,'RESOURCE_SIZE_LIMIT','资源超过本轮内容大小上限',[rel]);return
        try:content=data.decode('utf-8');encoding='utf-8'
        except UnicodeDecodeError:content=base64.b64encode(data).decode('ascii');encoding='base64'
        why={'reason':'资源读取调用所引用的实际内容','via':c['caller']}
        if 'resource:'+rel in self.records:
            record=self.records['resource:'+rel]
            if record['source']['sha256']!=sha(data):raise ValueError('查找期间资源发生变化: '+rel)
            if why not in record['reasons']:record['reasons'].append(why)
        else:
            self.records['resource:'+rel]={'id':'resource:'+rel,'category':'resource','categories':['resource'],'content':content,'encoding':encoding,'source':{'file':rel,'start_line':1 if encoding=='utf-8' else None,'end_line':len(content.splitlines()) if encoding=='utf-8' else None,'sha256':sha(data)},'reasons':[why]}

    def run(self,target_type,target_methods):
        self.target_type=target_type
        hierarchy=self.hierarchy(target_type);overridden=set()
        for owner in hierarchy:
            self.include_type(owner,0,target_type)
            for node in self.by_owner[owner]:
                if node['kind']!='method':continue
                signature=(node['name'],tuple(node['parameters']))
                if signature in overridden:continue
                overridden.add(signature)
                ann=self.annotation(node,LIFECYCLE)
                if ann:self.enqueue(node,'lifecycle','适用的JUnit生命周期声明: '+ann,0,target_type)
        for node in target_methods:
            self.enqueue(node,'target_test','本次查找的目标测试',0,target_type)
            if self.annotation(node,{'ParameterizedTest','TestFactory','TestTemplate'}):
                self.unresolved.append({'kind':'TEST_PROVIDER_NOT_ANALYZED','reference':node['id'],'source':self.location(node),'reason':'参数来源或动态测试生成语义未完整分析，保留原声明，需补查提供者'})
        expanded=0
        while self.queue:
            caller,depth=self.queue.popleft()
            if expanded>=self.max_members:
                self.unresolved.append({'kind':'MEMBER_LIMIT','reference':caller['id'],'reason':'达到成员展开上限','remaining':[caller['id']]+[x[0]['id'] for x in self.queue]});break
            expanded+=1
            for ref in self.references[caller['id']]:
                for typ in self.resolve_receiver(ref,caller):
                    if typ in self.types and depth<self.max_depth:self.include_type(typ,depth+1,caller['id'])
            for c in self.calls[caller['id']]:
                if c.get('method_reference'):
                    self.unresolved_call(c,'METHOD_REFERENCE_UNRESOLVED','方法引用的执行签名未绑定，未按零参数调用猜测');continue
                self.resource(c,caller)
                types=self.resolve_receiver(c,caller)
                if c['name'] in {'this','super'}:
                    types=[caller['owner']] if c['name']=='this' else self.hierarchy(caller['owner'])[1:2];c=dict(c,name='<init>',constructor=True)
                if not c['receiver'] and not types:types=[caller['owner']]
                candidates=[]
                for typ in types:
                    if len(self.types.get(typ,[]))>1:
                        self.unresolved_call(c,'TYPE_AMBIGUOUS','类型有多个定义',typ);continue
                    if typ not in self.types:continue
                    owners=[typ] if c['constructor'] else self.hierarchy(typ)
                    for own in owners:
                        found=[m for m in self.by_owner[own] if m['kind']=='method' and m['name']==c['name'] and len(m['parameters'])==len(c['arguments']) and m['file'] not in self.parse_errors]
                        if found:candidates.extend(found);break
                    self.include_type(typ,depth+1,caller['id'])
                if not candidates and not c['receiver'] and not c['constructor']:
                    for imp in self.files[c['file']]['imports']:
                        if not imp.startswith('static '):continue
                        value=imp[7:];owner,_,member=value.rpartition('.')
                        if member in {c['name'],'*'}:
                            found=[m for m in self.by_owner[owner] if m['kind']=='method' and m['name']==c['name'] and len(m['parameters'])==len(c['arguments']) and m['file'] not in self.parse_errors]
                            candidates+=found
                unique={m['id']:m for m in candidates}
                if len(unique)>1:self.unresolved_call(c,'OVERLOAD_AMBIGUOUS','仅按接收类型、名称与参数数量查找，无法唯一匹配',list(unique));continue
                if len(unique)==1:
                    node=next(iter(unique.values()))
                    if depth>=self.max_depth:self.unresolved_call(c,'DEPTH_LIMIT','达到依赖查找深度上限',[node['id']]);continue
                    self.include_type(node['owner'],depth+1,caller['id'])
                    if not node.get('has_body'):
                        self.unresolved_call(c,'DYNAMIC_IMPLEMENTATION_UNRESOLVED','找到接口或抽象声明，但未确定运行时实现',[node['id']])
                    category='helper' if '/src/test/' in '/'+node['file'] or node['file']==self.types[target_type][0]['file'] else 'called_code'
                    self.enqueue(node,category,'调用所需实现；包含其中的断言与进一步调用',depth+1,caller['id'])
                elif c['constructor'] and len(types)==1 and types[0] in self.types and not any(m['name']=='<init>' for m in self.by_owner[types[0]] if m['kind']=='method') and not c['arguments']:
                    self.boundaries.append({'kind':'IMPLICIT_DEFAULT_CONSTRUCTOR','reference':types[0],'source':self.location(c),'reason':'无显式构造器，保留类型与字段初始化'})
                else:
                    self.unresolved_call(c,'REFERENCE_UNRESOLVED','索引内未唯一找到定义；可能为外部API、未解析接收者、接口动态实现或隐式行为',types)
        return self


def collect(project, target, output, method=None, source_roots=(), resource_roots=(), java='java', javac='javac', max_depth=6, max_members=300, max_files=5000, max_resource_bytes=262144):
    project=Path(project).resolve();output=Path(output).resolve()
    if not project.is_dir():raise ValueError('项目路径不存在')
    if output.exists() or output.is_relative_to(project):raise ValueError('输出须为项目外尚不存在的新目录')
    if min(max_depth,max_members,max_files,max_resource_bytes)<1:raise ValueError('查找上限必须为正数')
    java_files,sources,resources,discovery,fallback=discover(project,source_roots,resource_roots)
    file_target=(project/target.split('#',1)[0]).resolve()
    if file_target.is_relative_to(project) and file_target.is_file() and file_target.suffix=='.java' and file_target not in java_files:java_files.append(file_target);java_files.sort()
    if not java_files:raise ValueError('未找到Java源码，请指定源码根')
    if len(java_files)>max_files:raise ValueError('源码文件数超过上限；请明确源码根或提高max_files，不进行静默截断')
    snapshots={};issues=list(discovery)
    for path in java_files:
        rel=path.relative_to(project).as_posix();data=path.read_bytes()
        try:data.decode('utf-8')
        except UnicodeDecodeError:issues.append({'kind':'SOURCE_ENCODING_UNSUPPORTED','file':rel,'reason':'首版Java解析仅支持UTF-8'});continue
        snapshots[rel]=data
    if not snapshots:raise ValueError('没有可解析的UTF-8 Java文件')
    with tempfile.TemporaryDirectory(prefix='test-context-') as temp:
        temp=Path(temp);mapping={}
        for rel,data in snapshots.items():
            path=temp/'sources'/rel;path.parent.mkdir(parents=True,exist_ok=True);path.write_bytes(data);mapping[str(path.resolve())]=rel
        file_list=temp/'files.txt';file_list.write_text('\n'.join(mapping),encoding='utf-8')
        adapter=Path(__file__).parent/'tools/JavaFacts.java'
        compile_run=subprocess.run([javac,'-encoding','UTF-8','-d',str(temp),str(adapter)],capture_output=True,timeout=90)
        if compile_run.returncode:raise ValueError('解析器构建失败: '+compile_run.stderr.decode('utf-8',errors='replace'))
        run=subprocess.run([java,'-Dfile.encoding=UTF-8','-cp',str(temp),'JavaFacts',str(file_list)],capture_output=True,timeout=180)
        if run.returncode:raise ValueError('Java解析失败: '+run.stderr.decode('utf-8',errors='replace'))
        facts=json.loads(run.stdout.decode('utf-8'))
        for f in facts['files']:f['path']=str(project/mapping[str(Path(f['path']).resolve())])
        for e in facts['errors']:
            if e.get('path'):e['path']=str(project/mapping[str(Path(e['path']).resolve())])
    c=Collector(project,facts,snapshots,resources,max_depth,max_members,max_resource_bytes)
    parts=target.split('#',1);anchor=method or (parts[1] if len(parts)>1 else None);base_target=parts[0]
    types=[t for entries in c.types.values() for t in entries if t['id']==base_target or (file_target.is_relative_to(project) and t['file']==file_target.relative_to(project).as_posix())]
    # 一个文件可包含多个类型，只接受含目标测试的唯一类。
    candidates=[]
    for t in types:
        tests=[];seen_signatures=set()
        for owner in c.hierarchy(t['id']):
            for m in c.by_owner[owner]:
                if m['kind']!='method':continue
                signature=(m['name'],tuple(m['parameters']))
                if signature in seen_signatures:continue
                seen_signatures.add(signature)
                if c.annotation(m,TEST_ANNOTATIONS):tests.append(m)
        if anchor:tests=[m for m in tests if m['id'].split('#',1)[1]==anchor or m['name']==anchor]
        if tests:candidates.append((t,tests))
    if len(candidates)!=1:raise ValueError('测试文件/类型不存在、存在歧义或没有已识别JUnit测试，请指定完整方法标识')
    t,tests=candidates[0]
    if len(c.types[t['id']])!=1:raise ValueError('目标类型有多个源码定义，请用source-root明确本轮模块范围')
    if anchor and len(tests)!=1:raise ValueError('目标方法存在歧义，请包含参数签名')
    if t['file'] in c.parse_errors:raise ValueError('目标测试文件含语法错误，无法可靠提取')
    c.run(t['id'],tests)
    # 保留完整测试类，但通过related_members明确标记参与本次查找的成员。
    c.add(t,'original_test_class','完整原始测试类；相关成员另行标记')
    used={rec['source']['file'] for rec in c.records.values() if rec['source']['file'] in snapshots}
    for rel in used:
        if (project/rel).read_bytes()!=snapshots[rel]:raise ValueError('查找期间源码发生变化: '+rel)
    for error in facts['errors']:issues.append({'kind':'JAVA_PARSE_ERROR','file':Path(error['path']).relative_to(project).as_posix() if error.get('path') else None,'line':error.get('line'),'reason':error['message']})
    ident=re.sub(r'[^\w.-]+','_',t['id']+('_'+anchor if anchor else ''),flags=re.UNICODE)[:100]+'_'+sha((t['id']+str(anchor)).encode())[:8]
    c.unresolved=list({json.dumps(x,sort_keys=True,ensure_ascii=False):x for x in c.unresolved}.values())
    result={'schema_version':'concrete-test-context-1.0','target':{'project':str(project),'type':t['id'],'methods':[m['id'] for m in tests],'file':t['file']},'scope':{'source_roots':[p.relative_to(project).as_posix() for p in sources],'resource_roots':[p.relative_to(project).as_posix() for p in resources],'fallback_project_scan':fallback,'java_files_indexed':len(facts['files']),'max_depth':max_depth,'max_members':max_members,'max_resource_bytes':max_resource_bytes,'stop_conditions':['外部定义或无法唯一匹配的引用','依赖循环去重','达到深度、成员或资源大小上限'],'analysis':'JDK17 syntax plus conservative project-local lookup; no compiler symbol attribution'},'original_tests':[{'id':m['id'],'content':c.content(m),'source':c.location(m)} for m in tests],'related_members':dict(c.related),'records':list(c.records.values()),'unresolved':c.unresolved,'boundaries':c.boundaries,'project_issues':issues,'completeness':'NOT_ESTABLISHED','limitations':['生命周期仅支持已识别JUnit4/5声明与简单继承，不解释组合注解、扩展注册和接口默认方法','重载按名称和参数数量筛选；接口动态实现、链式接收者、反射与动态路径会报告未解析','保留完整类型可含无关成员；不把类中所有成员视为本次相关成员','不提供跨语言规则、项目翻译约定筛选或完整模型输入组织','只读源工程，不执行构建、测试或业务代码']}
    output.mkdir(parents=True)
    write_json(output/f'context_{ident}.json',result)
    lines=['# 测试具体上下文','', '查找对象：`'+t['id']+(' # '+anchor if anchor else '')+'`','', '完整类保留原文；related_members列出本次已收集的相关成员。其他成员仅为周边参考。','', '## 查找范围','', '```json',json.dumps(result['scope'],ensure_ascii=False,indent=2),'```']
    grouped=defaultdict(list)
    for record in result['records']:grouped[record['category']].append(record)
    for category,records in grouped.items():
        titles={'imports':'所在类导入','related_definition':'相关类型与业务定义','field_initialization':'字段及初始化','lifecycle':'初始化与清理','target_test':'目标测试','helper':'辅助逻辑与断言','called_code':'进一步调用依赖','resource':'资源实际内容','original_test_class':'完整原始测试类'}
        lines+=['','## '+titles.get(category,category),'']
        for rec in records:
            source=rec['source'];fence='`'*max(3,max([len(x)+1 for x in re.findall(r'`+',rec['content'])]+[3]))
            lines+=['','### '+rec['id'],'','来源：`'+source['file']+'`，行 '+str(source.get('start_line'))+'—'+str(source.get('end_line'))+('；内容编码：'+rec['encoding'] if category=='resource' else ''),'','查找原因：'+ '; '.join(x['reason'] for x in rec['reasons']),'',fence+('text' if category=='resource' else 'java'),rec['content'],fence]
    for title,value in [('相关成员标记',result['related_members']),('未解析引用',result['unresolved']),('停止边界',result['boundaries']),('工程问题',result['project_issues'])]:lines+=['','## '+title,'','```json',json.dumps(value,ensure_ascii=False,indent=2),'```']
    lines+=['','## 限制','']+['- '+x for x in result['limitations']]
    (output/f'context_{ident}.md').write_text(('\n'.join(lines)+'\n').replace('\r\n','\n'),encoding='utf-8')
    return result


def main():
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('--project',required=True);p.add_argument('--target',required=True);p.add_argument('--method');p.add_argument('--output',required=True)
    p.add_argument('--source-root',action='append',default=[]);p.add_argument('--resource-root',action='append',default=[])
    p.add_argument('--java',default='java');p.add_argument('--javac',default='javac');p.add_argument('--max-depth',type=int,default=6);p.add_argument('--max-members',type=int,default=300);p.add_argument('--max-files',type=int,default=5000);p.add_argument('--max-resource-bytes',type=int,default=262144)
    args=p.parse_args()
    try:
        r=collect(args.project,args.target,args.output,args.method,args.source_root,args.resource_root,args.java,args.javac,args.max_depth,args.max_members,args.max_files,args.max_resource_bytes)
        print(json.dumps({'records':len(r['records']),'unresolved':len(r['unresolved']),'target':r['target']},ensure_ascii=False))
    except (ValueError,OSError,subprocess.SubprocessError) as e:p.exit(1,str(e)+'\n')


if __name__=='__main__':main()
