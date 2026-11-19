import com.sun.source.tree.*;
import com.sun.source.util.*;
import javax.tools.*;
import java.nio.file.*;
import java.nio.charset.StandardCharsets;
import java.util.*;

/** 只解析Java语法并保存真实位置；不执行工程、注解处理器或测试。 */
public class JavaFacts {
    static Map<String,Object> obj(Object... kv){Map<String,Object> m=new LinkedHashMap<>();for(int i=0;i<kv.length;i+=2)m.put((String)kv[i],kv[i+1]);return m;}
    static String json(Object o){
        if(o==null)return "null";
        if(o instanceof Character)return json(o.toString());
        if(o instanceof String s){StringBuilder b=new StringBuilder("\"");for(char c:s.toCharArray())switch(c){case '"':b.append("\\\"");break;case '\\':b.append("\\\\");break;case '\n':b.append("\\n");break;case '\r':b.append("\\r");break;case '\t':b.append("\\t");break;default:if(c<32)b.append(String.format("\\u%04x",(int)c));else b.append(c);}return b.append('"').toString();}
        if(o instanceof Map<?,?> m){List<String> xs=new ArrayList<>();for(var e:m.entrySet())xs.add(json(e.getKey())+":"+json(e.getValue()));return "{"+String.join(",",xs)+"}";}
        if(o instanceof Iterable<?> xs){List<String> a=new ArrayList<>();for(Object x:xs)a.add(json(x));return "["+String.join(",",a)+"]";}
        return o.toString();
    }
    public static void main(String[] args)throws Exception{
        JavaCompiler c=ToolProvider.getSystemJavaCompiler();if(c==null)throw new IllegalStateException("Full JDK required");
        DiagnosticCollector<JavaFileObject> diagnostics=new DiagnosticCollector<>();
        List<Map<String,Object>> results=new ArrayList<>();
        try(StandardJavaFileManager fm=c.getStandardFileManager(diagnostics,Locale.ROOT,StandardCharsets.UTF_8)){
            List<String> paths=Files.readAllLines(Path.of(args[0]),StandardCharsets.UTF_8);
            JavacTask task=(JavacTask)c.getTask(null,fm,diagnostics,List.of("-proc:none","--release","17"),null,fm.getJavaFileObjectsFromStrings(paths));
            for(CompilationUnitTree unit:task.parse()){
                String path=Path.of(unit.getSourceFile().toUri()).toString();String text=Files.readString(Path.of(path),StandardCharsets.UTF_8);
                SourcePositions pos=Trees.instance(task).getSourcePositions();
                List<Object> types=new ArrayList<>(),members=new ArrayList<>(),calls=new ArrayList<>(),references=new ArrayList<>();
                String pkg=unit.getPackageName()==null?"":unit.getPackageName().toString();
                List<String> imports=unit.getImports().stream().map(x->(x.isStatic()?"static ":"")+x.getQualifiedIdentifier()).toList();
                List<Object> importLocations=new ArrayList<>();for(var it:unit.getImports()){long a=pos.getStartPosition(unit,it),b=pos.getEndPosition(unit,it);importLocations.add(obj("start",a,"end",b,"start_line",unit.getLineMap().getLineNumber(a),"end_line",unit.getLineMap().getLineNumber(b-1)));}
                Map<String,Object> file=obj("path",path,"package",pkg,"imports",imports,"import_locations",importLocations,"types",types,"members",members,"calls",calls,"references",references);results.add(file);
                new TreePathScanner<Void,Void>(){
                    String owner="",current="";Map<String,String> locals=null;int initCounter=0;
                    List<String> annotations(ModifiersTree n){return n.getAnnotations().stream().map(x->x.getAnnotationType().toString()).toList();}
                    Map<String,Object> entry(Tree n,String id,String kind){long a=pos.getStartPosition(unit,n),b=pos.getEndPosition(unit,n);return obj("id",id,"kind",kind,"owner",owner,"start",a,"end",b,"start_line",a<0?null:unit.getLineMap().getLineNumber(a),"end_line",b<0?null:unit.getLineMap().getLineNumber(Math.max(a,b-1)));}
                    public Void visitClass(ClassTree n,Void v){
                        String before=owner,previous=current;Map<String,String> old=locals;
                        String name=n.getSimpleName().toString();if(name.isEmpty())name="<anonymous@"+pos.getStartPosition(unit,n)+">";
                        owner=before.isEmpty()?(pkg.isEmpty()?name:pkg+"."+name):before+"."+name;current="";locals=null;
                        var e=entry(n,owner,"type");long first=pos.getEndPosition(unit,n);for(Tree member:n.getMembers()){long a=pos.getStartPosition(unit,member);if(a>=0&&a<first)first=a;}e.put("header_end",first);e.put("name",name);e.put("extends",n.getExtendsClause()==null?null:n.getExtendsClause().toString());e.put("implements",n.getImplementsClause().stream().map(Object::toString).toList());e.put("annotations",annotations(n.getModifiers()));types.add(e);
                        super.visitClass(n,v);owner=before;current=previous;locals=old;return null;
                    }
                    public Void visitMethod(MethodTree n,Void v){
                        String before=current;Map<String,String> old=locals;locals=new LinkedHashMap<>();
                        for(var p:n.getParameters())locals.put(p.getName().toString(),p.getType().toString());
                        List<String> params=n.getParameters().stream().map(p->p.getType().toString().replaceAll("\\s+","")).toList();
                        current=owner+"#"+n.getName()+"("+String.join(",",params)+")";
                        var e=entry(n,current,"method");e.put("name",n.getName().toString());e.put("parameters",params);e.put("annotations",annotations(n.getModifiers()));e.put("variables",locals);e.put("has_body",n.getBody()!=null);e.put("return_type",n.getReturnType()==null?null:n.getReturnType().toString());members.add(e);
                        super.visitMethod(n,v);current=before;locals=old;return null;
                    }
                    public Void visitVariable(VariableTree n,Void v){
                        Tree parent=getCurrentPath().getParentPath().getLeaf();
                        if(parent instanceof ClassTree){String before=current;Map<String,String> old=locals;current=owner+"#field:"+n.getName();locals=null;
                            var e=entry(n,current,"field");e.put("name",n.getName().toString());e.put("type",n.getType()==null?"":n.getType().toString());e.put("initializer",n.getInitializer()==null?null:n.getInitializer().toString());e.put("final",n.getModifiers().getFlags().contains(javax.lang.model.element.Modifier.FINAL));members.add(e);super.visitVariable(n,v);current=before;locals=old;return null;}
                        if(locals!=null&&n.getType()!=null)locals.put(n.getName().toString(),n.getType().toString());return super.visitVariable(n,v);
                    }
                    public Void visitBlock(BlockTree n,Void v){
                        if(getCurrentPath().getParentPath().getLeaf() instanceof ClassTree){String before=current;current=owner+"#initializer:"+(++initCounter);var e=entry(n,current,"initializer");e.put("name",current);members.add(e);super.visitBlock(n,v);current=before;return null;}
                        return super.visitBlock(n,v);
                    }
                    void call(Tree n,String name,String receiver,List<? extends ExpressionTree> args,boolean constructor){
                        if(current.isEmpty())return;var e=entry(n,current+"@"+pos.getStartPosition(unit,n),"call");e.put("caller",current);e.put("name",name);e.put("receiver",receiver);e.put("constructor",constructor);
                        e.put("arguments",args.stream().map(Object::toString).toList());List<Object> literals=new ArrayList<>();for(var a:args)literals.add(a instanceof LiteralTree l?l.getValue():null);e.put("literals",literals);calls.add(e);
                    }
                    public Void visitMethodInvocation(MethodInvocationTree n,Void v){
                        ExpressionTree expr=n.getMethodSelect();String name,receiver;
                        if(expr instanceof MemberSelectTree s){name=s.getIdentifier().toString();receiver=s.getExpression().toString();}else{name=expr.toString();receiver="";}
                        call(n,name,receiver,n.getArguments(),false);
                        if(!current.isEmpty()&&expr instanceof MemberSelectTree s&&s.getExpression() instanceof NewClassTree fresh){
                            @SuppressWarnings("unchecked") Map<String,Object> last=(Map<String,Object>)calls.get(calls.size()-1);last.put("receiver_type_hint",fresh.getIdentifier().toString());
                        }
                        return super.visitMethodInvocation(n,v);
                    }
                    public Void visitNewClass(NewClassTree n,Void v){call(n,"<init>",n.getIdentifier().toString(),n.getArguments(),true);return super.visitNewClass(n,v);}
                    public Void visitMemberReference(MemberReferenceTree n,Void v){
                        if(!current.isEmpty()){var e=entry(n,current+"@methodref"+pos.getStartPosition(unit,n),"call");e.put("caller",current);e.put("name",n.getName().toString());e.put("receiver",n.getQualifierExpression().toString());e.put("constructor",false);e.put("arguments",List.of());e.put("literals",List.of());e.put("method_reference",true);calls.add(e);}
                        return super.visitMemberReference(n,v);
                    }
                    public Void visitMemberSelect(MemberSelectTree n,Void v){
                        if(!current.isEmpty()){var e=entry(n,current+"@ref"+pos.getStartPosition(unit,n),"reference");e.put("caller",current);e.put("name",n.getIdentifier().toString());e.put("receiver",n.getExpression().toString());e.put("constructor",false);references.add(e);}
                        return super.visitMemberSelect(n,v);
                    }
                }.scan(unit,null);
            }
        }
        List<Object> errors=new ArrayList<>();for(var d:diagnostics.getDiagnostics())if(d.getKind()==Diagnostic.Kind.ERROR)errors.add(obj("path",d.getSource()==null?null:Path.of(d.getSource().toUri()).toString(),"line",d.getLineNumber(),"message",d.getMessage(Locale.ROOT)));
        System.out.println(json(obj("files",results,"errors",errors)));
    }
}
