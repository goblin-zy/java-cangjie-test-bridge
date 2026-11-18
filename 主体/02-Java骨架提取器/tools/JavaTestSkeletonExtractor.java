import com.sun.source.tree.*;
import com.sun.source.util.*;
import javax.tools.*;
import java.io.*;
import java.nio.charset.StandardCharsets;
import java.nio.file.*;
import java.security.MessageDigest;
import java.util.*;
import java.util.stream.*;
/** week7：通过JDK语法树识别成员和方法体边界。 */
public final class JavaTestSkeletonExtractor {
    private static final Set<String> TESTS=Set.of("Test","ParameterizedTest","RepeatedTest","TestFactory","TestTemplate");
    private static final Set<String> LIFECYCLES=Set.of("BeforeEach","AfterEach","BeforeAll","AfterAll");
    // 解析输入路径，逐文件生成骨架、原文件副本和成员对应表；语法错误返回非零退出码。
    public static void main(String[] args) throws Exception {
        if (Arrays.asList(args).contains("--help")) {
            System.out.println("JavaTestSkeletonExtractor --input <Java file/directory> --output <new/empty directory> (JDK17+)");
            return;
        }
        Map<String,String> opts=new HashMap<>();
        for(int i=0;i<args.length;i+=2){
            if(i+1>=args.length||!Set.of("--input","--output").contains(args[i]))throw new IllegalArgumentException("Use --help");
            opts.put(args[i],args[i+1]);
        }
        if(!opts.containsKey("--input")||!opts.containsKey("--output"))throw new IllegalArgumentException("Use --help");
        Path input=Path.of(opts.get("--input")).toAbsolutePath().normalize(),output=Path.of(opts.get("--output")).toAbsolutePath().normalize();
        if(!Files.exists(input))throw new IOException("Input not found");
        if(Files.isDirectory(input)&&output.startsWith(input))throw new IOException("Output must be outside input tree");
        if(Files.exists(output))try(Stream<Path>s=Files.list(output)){
            if(s.findAny().isPresent())throw new IOException("Output must be new or empty; previous results are not overwritten");
        }
        JavaCompiler compiler=ToolProvider.getSystemJavaCompiler();
        if(compiler==null)throw new IllegalStateException("A full JDK is required");
        List<Path> inputs;
        if(Files.isDirectory(input))try(Stream<Path>s=Files.walk(input)){
            inputs=s.filter(Files::isRegularFile).filter(p->p.toString().endsWith(".java")).sorted().toList();
        }
        else inputs=input.toString().endsWith(".java")?List.of(input):List.of();
        if(inputs.isEmpty())throw new IOException("No Java source files found");
        Files.createDirectories(output);
        Path inputRoot=Files.isDirectory(input)?input:input.getParent();
        List<Map<String,Object>> files=new ArrayList<>(),members=new ArrayList<>(),classes=new ArrayList<>(),issues=new ArrayList<>();
        boolean hasError=false;
        for(Path file:inputs){
            String relative=inputRoot.relativize(file).toString().replace('\\','/');
            byte[] bytes=Files.readAllBytes(file);
            String source=new String(bytes,StandardCharsets.UTF_8);
            write(output.resolve("original").resolve(relative),bytes);
            DiagnosticCollector<JavaFileObject> diagnostics=new DiagnosticCollector<>();
            try(StandardJavaFileManager fm=compiler.getStandardFileManager(diagnostics,Locale.ROOT,StandardCharsets.UTF_8)){
                JavacTask task=(JavacTask)compiler.getTask(null,fm,diagnostics,List.of("-proc:none","--release","17"),null,fm.getJavaFileObjects(file.toFile()));
                CompilationUnitTree unit=task.parse().iterator().next();
                boolean syntaxError=false;
                for(Diagnostic<? extends JavaFileObject>d:diagnostics.getDiagnostics()){
                    if(d.getKind()==Diagnostic.Kind.ERROR)syntaxError=true;
                    issues.add(obj("file",relative,"severity",d.getKind().name().toLowerCase(Locale.ROOT),"code",d.getCode(),"line",d.getLineNumber(),"column",d.getColumnNumber(),"message",d.getMessage(Locale.ROOT)));
                }
                if(syntaxError){
                    hasError=true;
                    files.add(obj("source_file",relative,"original_file","original/"+relative,"source_sha256",sha(bytes),"status","syntax_error","skeleton_file",null));
                    continue;
                }
                Collector c=new Collector(unit,Trees.instance(task).getSourcePositions(),source,relative,issues);
                c.scan(unit,null);
                c.edits.sort(Comparator.comparingInt(e->e.start));
                StringBuilder result=new StringBuilder();
                int cursor=0;
                for(Edit e:c.edits){
                    if(e.start<cursor)throw new IllegalStateException("Overlapping method bodies");
                    result.append(source,cursor,e.start).append(e.replacement);
                    cursor=e.end;
                }
                result.append(source,cursor,source.length());
                String skeleton=result.toString();
                write(output.resolve("skeleton").resolve(relative),skeleton.getBytes(StandardCharsets.UTF_8));
                for(Map<String,Object>m:c.members){
                    int a=(Integer)m.remove("_start"),b=(Integer)m.remove("_end");
                    m.put("skeleton_location",range("skeleton/"+relative,skeleton,map(a,c.edits),map(b,c.edits)));
                    if(m.containsKey("_body_start")){
                        int bs=(Integer)m.remove("_body_start"),be=(Integer)m.remove("_body_end");
                        m.put("skeleton_body_location",range("skeleton/"+relative,skeleton,map(bs,c.edits),map(be,c.edits)));
                    }
                    members.add(m);
                }
                for(Map<String,Object>t:c.classes){
                    int a=(Integer)t.remove("_start"),b=(Integer)t.remove("_end");
                    t.put("skeleton_location",range("skeleton/"+relative,skeleton,map(a,c.edits),map(b,c.edits)));
                    classes.add(t);
                }
                files.add(obj("source_file",relative,"original_file","original/"+relative,"source_sha256",sha(bytes),"skeleton_file","skeleton/"+relative,"skeleton_sha256",sha(skeleton.getBytes(StandardCharsets.UTF_8)),"status","extracted","package",c.pkg,"imports",c.imports,"members",c.members.size(),"replaced_bodies",c.edits.size()));
            }
        }
        Map<String,Long>roles=members.stream().collect(Collectors.groupingBy(m->String.valueOf(m.get("role")),TreeMap::new,Collectors.counting()));
        Map<String,Object> report=obj("schema_version","1.0","tool","week7-java-test-skeleton-extractor","java_language_level",17,"parser","JDK javac Tree API; parse only, no symbol attribution","offset_unit","UTF-16 code units; end offsets exclusive; line/column 1-based","input_root",inputRoot.toString(),"summary",obj("files",files.size(),"classes",classes.size(),"members",members.size(),"roles",roles,"errors",issues.stream().filter(x->"error".equals(x.get("severity"))).count()),"files",files,"classes",classes,"members",members,"diagnostics",issues);
        write(output.resolve("members.json"),(json(report)+"\n").getBytes(StandardCharsets.UTF_8));
        StringBuilder md=new StringBuilder("# Java测试骨架提取记录\n\n解析器：JDK javac语法树，Java17；仅解析，未执行符号绑定或测试。\n\n");
        md.append("文件：").append(files.size()).append("；成员：").append(members.size()).append("。\n\n|成员标识|角色|原始方法体|\n|---|---|---|\n");
        for(Map<String,Object>m:members)md.append('|').append(m.get("id")).append('|').append(m.get("role")).append('|').append(Boolean.TRUE.equals(m.get("has_body"))?"已保存":"无方法体／非方法").append("|\n");
        md.append("\n## 支持边界\n\n方法内局部类和匿名类只保存在完整原方法体中；字段初始化保持原样；类级初始化块原样保留并报告。参数类型按源码记录，未做完整类型解析。扩展JUnit机制只识别角色，不保证其可迁移性。骨架抛出占位异常，不可当成已恢复行为的测试。\n\n");
        for(Map<String,Object>i:issues)md.append("- ").append(i.get("file")).append("：").append(i.get("code")).append(" — ").append(i.get("message")).append('\n');
        write(output.resolve("extraction-report.md"),md.toString().getBytes(StandardCharsets.UTF_8));
        System.out.println("Extracted "+files.size()+" files, "+members.size()+" members; "+output.resolve("members.json"));
        if(hasError)System.exit(1);
    }
    private record Edit(int start,int end,String replacement){
    }
    // 基于AST收集类型、字段、构造器和方法；不在移除的方法体内重复提取局部成员。
    private static final class Collector extends TreePathScanner<Void,Void>{
        final CompilationUnitTree unit;
        final SourcePositions pos;
        final String source,file,pkg;
        final List<String>imports=new ArrayList<>();
        final Map<String,String>explicit=new HashMap<>();
        final Set<String>wildcards=new HashSet<>(),typeNames=new HashSet<>();
        final Deque<String>owners=new ArrayDeque<>();
        final List<Map<String,Object>>members=new ArrayList<>(),classes=new ArrayList<>(),issues;
        final List<Edit>edits=new ArrayList<>();
        Collector(CompilationUnitTree u,SourcePositions p,String s,String f,List<Map<String,Object>>warnings){
            unit=u;
            pos=p;
            source=s;
            file=f;
            issues=warnings;
            pkg=u.getPackageName()==null?"":u.getPackageName().toString();
            for(ImportTree it:u.getImports()){
                String n=it.getQualifiedIdentifier().toString();
                imports.add((it.isStatic()?"static ":"")+n);
                if(!it.isStatic()){
                    if(n.endsWith(".*"))wildcards.add(n.substring(0,n.length()-2));
                    else explicit.put(n.substring(n.lastIndexOf('.')+1),n);
                }
            }
            new TreeScanner<Void,Void>(){
                @Override public Void visitClass(ClassTree c,Void v){
                    if(!c.getSimpleName().isEmpty())typeNames.add(c.getSimpleName().toString());
                    return super.visitClass(c,v);
                }
            }
            .scan(u,null);
        }
        int start(Tree t){
            return Math.toIntExact(pos.getStartPosition(unit,t));
        }
        int end(Tree t){
            return Math.toIntExact(pos.getEndPosition(unit,t));
        }
        String slice(Tree t){
            int a=start(t),b=end(t);
            return a>=0&&b>=a?source.substring(a,b):t.toString();
        }
        String owner(){
            return(pkg.isEmpty()?"":pkg+".")+String.join("$",owners);
        }
        void warn(String code,String text,Tree t){
            issues.add(obj("file",file,"severity","warning","code",code,"line",position(source,Math.max(0,start(t)))[0],"message",text));
        }
        @Override public Void visitClass(ClassTree n,Void v){
            if(n.getSimpleName().isEmpty()){
                warn("ANONYMOUS_CLASS_NOT_EXPORTED","Anonymous type remains inside enclosing original code",n);
                return null;
            }
            owners.addLast(n.getSimpleName().toString());
            int a=start(n),b=end(n);
            classes.add(obj("id",file+"::"+owner(),"name",n.getSimpleName().toString(),"qualified_name",owner(),"kind",n.getKind().name(),"annotations",n.getModifiers().getAnnotations().stream().map(Object::toString).toList(),"source_location",range("original/"+file,source,a,b),"_start",a,"_end",b));
            if(n.getKind()==Tree.Kind.RECORD)warn("RECORD_LIMITATION","Confirm compiler-shaped record member source positions manually",n);
            super.visitClass(n,v);
            owners.removeLast();
            return null;
        }
        @Override public Void visitVariable(VariableTree n,Void v){
            if(getCurrentPath().getParentPath().getLeaf() instanceof ClassTree){
                int a=start(n),b=end(n);
                if(a<0||b<a){
                    warn("MISSING_SOURCE_POSITION","Field without usable source span was not exported",n);
                    return null;
                }
                members.add(obj("id",file+"::"+owner()+"#field:"+n.getName(),"kind","field","role","field","owner",owner(),"name",n.getName().toString(),"type",n.getType()==null?null:n.getType().toString(),"declaration",slice(n),"initializer",n.getInitializer()==null?null:slice(n.getInitializer()),"source_location",range("original/"+file,source,a,b),"has_body",false,"_start",a,"_end",b));
                return null;
            }
            return super.visitVariable(n,v);
        }
        @Override public Void visitBlock(BlockTree n,Void v){
            if(getCurrentPath().getParentPath().getLeaf() instanceof ClassTree)warn("CLASS_INITIALIZER_RETAINED","Class/static initializer retained unchanged, not treated as method",n);
            return null;
        }
        // 使用AST给出的精确方法体区间，保留原方法体、JUnit角色、签名及骨架回填位置。
        @Override public Void visitMethod(MethodTree n,Void v){
            int a=start(n),b=end(n);
            if(a<0||b<a){
                warn("MISSING_SOURCE_POSITION","Method without usable source span was not exported",n);
                return null;
            }
            boolean ctor=n.getReturnType()==null;
            String name=ctor?"<init>":n.getName().toString();
            List<String>types=n.getParameters().stream().map(x->x.getType().toString()).toList();
            String id=file+"::"+owner()+"#"+name+"("+types.stream().map(x->x.replaceAll("\\s+","")).collect(Collectors.joining(","))+")",role=ctor?"constructor":"helper";
            List<Map<String,Object>>annotations=new ArrayList<>();
            for(AnnotationTree ann:n.getModifiers().getAnnotations()){
                String type=ann.getAnnotationType().toString(),resolved=resolve(type),simple=type.substring(type.lastIndexOf('.')+1);
                boolean known=resolved!=null&&(resolved.startsWith("org.junit.jupiter.api.")||resolved.startsWith("org.junit.jupiter.params."));
                annotations.add(obj("source",ann.toString(),"name",type,"resolved_candidate",resolved,"resolution","syntactic import lookup, not full type attribution"));
                if(known&&TESTS.contains(simple)){
                    role="Test".equals(simple)?"test":"test_"+simple;
                    if(!"Test".equals(simple))warn("EXTENDED_TEST_MECHANISM","Identified "+simple+"; data/dynamic execution needs downstream support",ann);
                }
                if(known&&LIFECYCLES.contains(simple))role="lifecycle_"+simple;
                if(!known&&(TESTS.contains(simple)||LIFECYCLES.contains(simple)))warn("UNRESOLVED_TEST_ANNOTATION","No confirmed JUnit binding for "+type+"; no test role assumed",ann);
            }
            BlockTree body=n.getBody();
            int bs=body==null?-1:start(body),be=body==null?-1:end(body);
            Map<String,Object>m=obj("id",id,"kind",ctor?"constructor":"method","role",role,"owner",owner(),"name",name,"parameter_types",types,"parameters",n.getParameters().stream().map(Object::toString).toList(),"return_type",ctor?null:n.getReturnType().toString(),"annotations",annotations,"modifiers",n.getModifiers().getFlags().stream().map(Object::toString).toList(),"throws",n.getThrows().stream().map(Object::toString).toList(),"signature_source",source.substring(a,body==null?b:bs),"has_body",body!=null,"original_body",body==null?null:source.substring(bs,be),"source_location",range("original/"+file,source,a,b),"_start",a,"_end",b);
            if(body!=null){
                String indent=indent(a),delegation="";
                if(ctor&&!body.getStatements().isEmpty()&&body.getStatements().get(0) instanceof ExpressionStatementTree st&&st.getExpression() instanceof MethodInvocationTree call&&call.getMethodSelect() instanceof IdentifierTree ident&&Set.of("this","super").contains(ident.getName().toString()))delegation=slice(st);
                String replacement="{\n"+(delegation.isEmpty()?"":indent+"    "+delegation+"\n")+indent+"    throw new UnsupportedOperationException(\"SKELETON_PLACEHOLDER\");\n"+indent+"}";
                edits.add(new Edit(bs,be,replacement));
                m.put("body_source_location",range("original/"+file,source,bs,be));
                m.put("placeholder_kind","throw UnsupportedOperationException; structure only");
                m.put("constructor_delegation",delegation.isEmpty()?null:delegation);
                m.put("_body_start",bs);
                m.put("_body_end",be);
                new TreeScanner<Void,Void>(){
                    @Override public Void visitClass(ClassTree c,Void x){
                        warn("LOCAL_OR_ANONYMOUS_CLASS_IN_METHOD","Class inside removed body remains in original_body only",c);
                        return null;
                    }
                }
                .scan(body,null);
            }
            members.add(m);
            return null;
        }
        String resolve(String name){
            if(name.contains("."))return name;
            if(typeNames.contains(name))return null;
            if(explicit.containsKey(name))return explicit.get(name);
            String prefix="ParameterizedTest".equals(name)?"org.junit.jupiter.params":"org.junit.jupiter.api";
            return wildcards.contains(prefix)?prefix+"."+name:null;
        }
        String indent(int p){
            int a=source.lastIndexOf('\n',Math.max(0,p-1))+1,b=a;
            while(b<source.length()&&(source.charAt(b)==' '||source.charAt(b)=='\t'))b++;
            return source.substring(a,b);
        }
    }
    // 计算方法体替换后的偏移，供下游程序可靠定位骨架中的同一个成员。
    private static int map(int old,List<Edit>edits){
        int delta=0;
        for(Edit e:edits){
            if(old<e.start)break;
            if(old<e.end)return e.start+delta+Math.min(old-e.start,e.replacement.length());
            delta+=e.replacement.length()-(e.end-e.start);
        }
        return old+delta;
    }
    private static int[]position(String s,int offset){
        int line=1,col=1;
        for(int i=0;i<Math.min(offset,s.length());i++){
            if(s.charAt(i)=='\n'){
                line++;
                col=1;
            }
            else col++;
        }
        return new int[]{
            line,col
        }
        ;
    }
    // 同时记录UTF-16字符偏移和人可读的行列号，结束偏移不包含末尾字符。
    private static Map<String,Object>range(String f,String s,int a,int b){
        int[]first=position(s,Math.max(0,a)),last=position(s,Math.max(a,b-1));
        return obj("file",f,"start_offset_utf16",a,"end_offset_utf16_exclusive",b,"start_line",first[0],"start_column",first[1],"end_line",last[0],"end_column",last[1]);
    }
    private static Map<String,Object>obj(Object...pairs){
        Map<String,Object>m=new LinkedHashMap<>();
        for(int i=0;i<pairs.length;i+=2)m.put(String.valueOf(pairs[i]),pairs[i+1]);
        return m;
    }
    private static void write(Path p,byte[]bytes)throws IOException{
        Files.createDirectories(p.getParent());
        Files.write(p,bytes);
    }
    private static String sha(byte[]b)throws Exception{
        return HexFormat.of().formatHex(MessageDigest.getInstance("SHA-256").digest(b));
    }
    // 仅序列化本工具使用的基本JSON类型，避免增加外部运行依赖。
    private static String json(Object v){
        if(v==null)return "null";
        if(v instanceof String s){
            StringBuilder out=new StringBuilder("\"");
            for(char c:s.toCharArray())switch(c){
                case '"'->out.append("\\\"");
                case '\\'->out.append("\\\\");
                case '\n'->out.append("\\n");
                case '\r'->out.append("\\r");
                case '\t'->out.append("\\t");
                default->{
                    if(c<32)out.append(String.format("\\u%04x",(int)c));
                    else out.append(c);
                }
            }
            return out.append('"').toString();
        }
        if(v instanceof Map<?,?>m)return m.entrySet().stream().map(e->json(String.valueOf(e.getKey()))+":"+json(e.getValue())).collect(Collectors.joining(",","{","}"));
        if(v instanceof Collection<?>c)return c.stream().map(JavaTestSkeletonExtractor::json).collect(Collectors.joining(",","[","]"));
        return v.toString();
    }
}
