import com.github.javaparser.*;
import com.github.javaparser.ast.*;
import com.github.javaparser.ast.body.*;
import com.github.javaparser.ast.expr.*;
import com.github.javaparser.ast.stmt.*;
import com.github.javaparser.ast.nodeTypes.NodeWithAnnotations;
import com.github.javaparser.ast.nodeTypes.NodeWithModifiers;
import com.github.javaparser.resolution.declarations.*;
import com.github.javaparser.symbolsolver.JavaSymbolSolver;
import com.github.javaparser.symbolsolver.resolution.typesolvers.*;
import com.google.gson.*;
import java.nio.file.*;
import java.nio.charset.StandardCharsets;
import java.util.*;

/**
 * 本地源码解析程序。Python 调用 main；这里调用 JavaParser.parse / findAll / resolve。
 * 不运行输入工程。语法结构与静态引用来自同一份 CompilationUnit。
 */
public final class SymbolFacts {
    static final Gson JSON = new GsonBuilder().disableHtmlEscaping().create();
    static final Map<Path,String> TEXT = new HashMap<>();
    static boolean SYNTAX_ONLY = false;
    static Map<String,Object> obj(Object... items) {
        Map<String,Object> result=new LinkedHashMap<>();
        for(int i=0;i<items.length;i+=2) result.put((String)items[i],items[i+1]);
        return result;
    }
    static int offset(String text, int line, int column) {
        int pos=0;
        for(int i=1;i<line;i++) { int next=text.indexOf('\n',pos); if(next<0)return -1; pos=next+1; }
        return pos+column-1;
    }
    static Map<String,Object> location(Node node) {
        try {
            CompilationUnit unit=node.findCompilationUnit().orElseThrow();
            Path file=unit.getStorage().orElseThrow().getPath().toAbsolutePath().normalize();
            String text=TEXT.get(file);
            if(text==null) { text=Files.readString(file,StandardCharsets.UTF_8); TEXT.put(file,text); }
            Range range=node.getRange().orElseThrow();
            int a=offset(text,range.begin.line,range.begin.column),b=offset(text,range.end.line,range.end.column)+1;
            return obj("file",file.toString(),"start",a,"end",b);
        } catch(Exception ex) { return null; }
    }
    static String error(Throwable ex) { return ex.getClass().getSimpleName()+": "+String.valueOf(ex.getMessage()); }
    static String jsonText(Object value) {
        String raw=JSON.toJson(value);
        StringBuilder result=new StringBuilder();
        for(int i=0;i<raw.length();i++) {
            char c=raw.charAt(i);
            if(Character.isHighSurrogate(c) && i+1<raw.length() && Character.isLowSurrogate(raw.charAt(i+1))) {
                result.append(c).append(raw.charAt(++i));
            } else if(Character.isSurrogate(c))result.append(String.format("\\u%04x",(int)c));
            else result.append(c);
        }
        return result.toString();
    }
    static String owner(Node node) {
        Node current=node.getParentNode().orElse(null);
        while(current!=null) {
            if(current instanceof TypeDeclaration<?> type)return type.getFullyQualifiedName().orElse(type.getNameAsString());
            current=current.getParentNode().orElse(null);
        }
        return "";
    }
    static Map<String,Object> base(Node node,String name,String kind) {
        return obj("location",location(node),"name",name,"kind",kind,"resolution","unresolved");
    }

    /** 用 token 找声明体的左花括号，避开注解参数和构造参数中的花括号。 */
    static int headerEnd(Node node) {
        int parens=0, brackets=0;
        for(JavaToken token:node.getTokenRange().orElseThrow()) {
            String value=token.getText();
            if(value.equals("("))parens++;
            else if(value.equals(")"))parens--;
            else if(value.equals("["))brackets++;
            else if(value.equals("]"))brackets--;
            else if(value.equals("{") && parens==0 && brackets==0) {
                Range range=token.getRange().orElseThrow();
                Path file=node.findCompilationUnit().orElseThrow().getStorage().orElseThrow().getPath().toAbsolutePath().normalize();
                return offset(TEXT.get(file),range.begin.line,range.begin.column)+1;
            }
        }
        return ((Number)location(node).get("end")).intValue();
    }

    /** 匿名类也有独立 owner，防止其同名字段被错误归到外层类。 */
    static boolean isType(Node node) {
        return node instanceof TypeDeclaration<?> ||
            node instanceof ObjectCreationExpr e && e.getAnonymousClassBody().isPresent() ||
            node instanceof EnumConstantDeclaration e && !e.getClassBody().isEmpty();
    }
    static Node enclosingType(Node node) {
        Node current=node.getParentNode().orElse(null);
        while(current!=null && !isType(current))current=current.getParentNode().orElse(null);
        return current;
    }
    static String typeId(Node node) {
        if(node instanceof TypeDeclaration<?> t && t.getFullyQualifiedName().isPresent())return t.getFullyQualifiedName().get();
        Node parent=enclosingType(node);
        String prefix=parent==null?"":typeId(parent);
        String name=node instanceof TypeDeclaration<?> t?t.getNameAsString():"<anonymous@"+location(node).get("start")+">";
        return (prefix.isEmpty()?"":prefix+".")+name;
    }
    static List<String> modifiers(Node node) {
        if(node instanceof NodeWithModifiers<?> n)return n.getModifiers().stream().map(m->m.getKeyword().asString()).toList();
        return List.of();
    }
    static void annotations(Map<String,Object> row,Node node) {
        List<Object> details=new ArrayList<>();
        List<String> names=new ArrayList<>();
        if(node instanceof NodeWithAnnotations<?> n)for(AnnotationExpr a:n.getAnnotations()) {
            names.add(a.getNameAsString());
            Map<String,Object> detail=new LinkedHashMap<>(location(a));
            detail.remove("file"); detail.put("source",a.toString()); detail.put("name",a.getNameAsString());
            details.add(detail);
        }
        row.putAll(obj("annotations",names,"annotation_details",details,"modifiers",modifiers(node)));
    }
    static Map<String,Object> syntaxNode(Node node,String id,String kind,String name) {
        Map<String,Object> row=new LinkedHashMap<>(location(node)); row.remove("file");
        Range range=node.getRange().orElseThrow();
        row.putAll(obj("id",id,"kind",kind,"name",name,"start_line",range.begin.line,"end_line",range.end.line));
        annotations(row,node);
        return row;
    }

    /** 找真正拥有该节点的成员；不能把匿名/局部类内部代码算进外层测试。 */
    static Node analysisOwner(Node node) {
        Node current=node.getParentNode().orElse(null);
        while(current!=null) {
            if(current instanceof CallableDeclaration<?> || current instanceof InitializerDeclaration)return current;
            if(current instanceof VariableDeclarator v && v.getParentNode().orElse(null) instanceof FieldDeclaration)return current;
            if(isType(current))return null;
            current=current.getParentNode().orElse(null);
        }
        return null;
    }

    /** 保留语句树以及不能安全剪开的控制/延迟执行容器；不是控制流图。 */
    static boolean analysisNode(Node node) {
        return node instanceof Statement || node instanceof LambdaExpr || node instanceof CatchClause ||
            node instanceof SwitchEntry || node instanceof SwitchExpr || node instanceof ConditionalExpr;
    }

    /** 同一个 if/try 下的不同区域要保留身份，不能把 then/else、try/finally 混在一起。 */
    static String analysisRole(Node node,Node parent) {
        if(parent instanceof IfStmt p) {
            if(p.getThenStmt()==node)return "THEN";
            if(p.getElseStmt().orElse(null)==node)return "ELSE";
        }
        if(parent instanceof TryStmt p) {
            if(p.getTryBlock()==node)return "TRY_BODY";
            if(p.getFinallyBlock().orElse(null)==node)return "FINALLY_BODY";
            if(node instanceof CatchClause)return "CATCH";
        }
        if(parent instanceof CatchClause p && p.getBody()==node)return "CATCH_BODY";
        if(parent instanceof LambdaExpr p && p.getBody()==node)return "LAMBDA_BODY";
        if(parent instanceof ForStmt p && p.getBody()==node || parent instanceof ForEachStmt p2 && p2.getBody()==node ||
            parent instanceof WhileStmt p3 && p3.getBody()==node || parent instanceof DoStmt p4 && p4.getBody()==node)return "LOOP_BODY";
        if(parent instanceof SwitchEntry)return "CASE_BODY";
        return "NESTED_SYNTAX";
    }

    static List<Object> bodyNodes(CompilationUnit cu) {
        List<Object> rows=new ArrayList<>();
        for(Node node:cu.findAll(Node.class)) {
            if(!analysisNode(node))continue;
            Node member=analysisOwner(node);
            if(member==null)continue;
            Node parent=node.getParentNode().orElse(null);
            while(parent!=null && parent!=member && !analysisNode(parent))parent=parent.getParentNode().orElse(null);
            String kind=member instanceof ConstructorDeclaration?"constructor":member instanceof MethodDeclaration?"method":
                member instanceof InitializerDeclaration?"initializer":"field";
            boolean control=node instanceof IfStmt || node instanceof ForStmt || node instanceof ForEachStmt ||
                node instanceof WhileStmt || node instanceof DoStmt || node instanceof SwitchStmt || node instanceof TryStmt ||
                node instanceof SynchronizedStmt || node instanceof LabeledStmt || node instanceof LocalClassDeclarationStmt;
            Range range=node.getRange().orElseThrow();
            Map<String,Object> row=obj("location",location(node),"member_start",location(member).get("start"),"member_kind",kind,
                "ast_kind",node.getClass().getSimpleName(),"node_kind",node instanceof BlockStmt?"block":control?"control":
                node instanceof Statement?"statement":"container", "start_line",range.begin.line,"end_line",range.end.line,
                "parent_location",parent==null || parent==member?null:location(parent),
                "parent_ast_kind",parent==null || parent==member?null:parent.getClass().getSimpleName(),
                "role_in_parent",parent==member?"MEMBER_BODY":analysisRole(node,parent),
                "deferred",node instanceof LambdaExpr,"try_with_resources",node instanceof TryStmt t && !t.getResources().isEmpty());
            if(node instanceof IfStmt n)row.put("condition_as_written",n.getCondition().toString());
            else if(node instanceof WhileStmt n)row.put("condition_as_written",n.getCondition().toString());
            else if(node instanceof DoStmt n)row.put("condition_as_written",n.getCondition().toString());
            else if(node instanceof ForStmt n)row.put("condition_as_written",n.getCompare().map(Object::toString).orElse(null));
            else if(node instanceof ForEachStmt n)row.put("iterable_as_written",n.getIterable().toString());
            else if(node instanceof SwitchEntry n)row.put("case_labels",n.getLabels().stream().map(Object::toString).toList());
            if(node instanceof AssertStmt a)row.put("native_assert",obj("check",a.getCheck().toString(),
                "message",a.getMessage().map(Object::toString).orElse(null)));
            rows.add(row);
        }
        return rows;
    }

    /** 提取结构，不依赖 resolve 成功；缺少 JUnit 等外部 JAR 时仍有完整方法原文。 */
    static Map<String,Object> syntaxFacts(CompilationUnit cu) {
        List<Object> types=new ArrayList<>(),members=new ArrayList<>(),imports=new ArrayList<>();
        for(ImportDeclaration i:cu.getImports()) {
            Map<String,Object> row=new LinkedHashMap<>(location(i)); row.remove("file");
            row.putAll(obj("name",i.getNameAsString()+(i.isAsterisk()?".*":""),"static",i.isStatic())); imports.add(row);
        }
        for(Node node:cu.findAll(Node.class)) {
            if(isType(node)) {
                String id=typeId(node);
                Map<String,Object> row=syntaxNode(node,id,"type",node instanceof TypeDeclaration<?> t?t.getNameAsString():"<anonymous>");
                List<String> extended=new ArrayList<>(),implemented=new ArrayList<>(),parameters=new ArrayList<>();
                if(node instanceof ClassOrInterfaceDeclaration t) {
                    extended.addAll(t.getExtendedTypes().stream().map(Object::toString).toList());
                    implemented.addAll(t.getImplementedTypes().stream().map(Object::toString).toList());
                    parameters.addAll(t.getTypeParameters().stream().map(Object::toString).toList());
                } else if(node instanceof EnumDeclaration t)implemented.addAll(t.getImplementedTypes().stream().map(Object::toString).toList());
                else if(node instanceof RecordDeclaration t) {
                    implemented.addAll(t.getImplementedTypes().stream().map(Object::toString).toList());
                    parameters.addAll(t.getTypeParameters().stream().map(Object::toString).toList());
                }
                row.putAll(obj("owner",id,"header_end",headerEnd(node),"extends",extended.isEmpty()?null:extended.get(0),
                    "extends_types",extended,"implements",implemented,"type_kind",node.getClass().getSimpleName(),"type_parameters",parameters,
                    "structure_boundary",node instanceof RecordDeclaration?"RECORD_IMPLICIT_MEMBERS_NOT_EXTRACTED":node instanceof TypeDeclaration<?>?null:"ANONYMOUS_RUNTIME_DISPATCH_REQUIRES_REVIEW"));
                types.add(row);
            }
            Node type=enclosingType(node);
            if(type==null)continue;
            String owner=typeId(type);
            Map<String,Object> row=null;
            if(node instanceof CallableDeclaration<?> c) {
                String kind=node instanceof ConstructorDeclaration?"constructor":"method";
                List<Object> params=new ArrayList<>(); List<String> paramTypes=new ArrayList<>();
                for(Parameter p:c.getParameters()) {
                    String spelling=p.getType().toString()+(p.isVarArgs()?"...":""); paramTypes.add(spelling);
                    params.add(obj("name",p.getNameAsString(),"type",spelling,"varargs",p.isVarArgs()));
                }
                String name=node instanceof ConstructorDeclaration?"<init>":c.getNameAsString();
                row=syntaxNode(node,owner+"#"+name+"("+String.join(",",paramTypes)+")",kind,name);
                Node body=node instanceof MethodDeclaration m?m.getBody().orElse(null):((ConstructorDeclaration)node).getBody();
                row.putAll(obj("parameters",params,"return_type",node instanceof MethodDeclaration m?m.getType().toString():null,
                    "type_parameters",c.getTypeParameters().stream().map(Object::toString).toList(),
                    "throws",c.getThrownExceptions().stream().map(Object::toString).toList(),
                    "signature_end",body==null?location(node).get("end"):location(body).get("start"),
                    "body_start",body==null?null:location(body).get("start"),"body_end",body==null?null:location(body).get("end")));
            } else if(node instanceof VariableDeclarator v && v.getParentNode().orElse(null) instanceof FieldDeclaration field) {
                row=syntaxNode(node,owner+"#field:"+v.getNameAsString(),"field",v.getNameAsString());
                annotations(row,field);
                row.putAll(obj("field_type",v.getType().toString(),"parameters",List.of(),
                    "read_start",location(field).get("start"),"read_end",location(field).get("end"),
                    "initializer",v.getInitializer().map(Object::toString).orElse(null)));
                if(v.getInitializer().isPresent())row.putAll(obj("initializer_start",location(v.getInitializer().get()).get("start"),
                    "initializer_end",location(v.getInitializer().get()).get("end")));
            } else if(node instanceof InitializerDeclaration init) {
                row=syntaxNode(node,owner+"#initializer@"+location(node).get("start"),"initializer","<initializer>");
                row.putAll(obj("parameters",List.of(),"static",init.isStatic(),"modifiers",init.isStatic()?List.of("static"):List.of(),
                    "body_start",location(init.getBody()).get("start"),
                    "body_end",location(init.getBody()).get("end")));
            } else if(node instanceof EnumConstantDeclaration e) {
                row=syntaxNode(node,owner+"#field:"+e.getNameAsString(),"field",e.getNameAsString());
                row.putAll(obj("parameters",List.of(),"modifiers",List.of("public","static","final"),"initializer",null));
            }
            if(row!=null) {
                row.putAll(obj("owner",owner,"owner_start",location(type).get("start")));
                members.add(row);
            }
        }
        return obj("package",cu.getPackageDeclaration().map(p->p.getNameAsString()).orElse(""),
            "imports",imports,"types",types,"members",members,"body_nodes",bodyNodes(cu));
    }
    static void method(Map<String,Object> row,ResolvedMethodDeclaration value) {
        row.putAll(obj("resolution","resolved_static","target_signature",value.getQualifiedSignature(),
            "target_owner",value.declaringType().getQualifiedName(),"static",value.isStatic(),
            "dispatch",value.isStatic()?"STATIC":"DECLARED_TARGET_ONLY",
            "target_location",value.toAst().map(SymbolFacts::location).orElse(null)));
    }
    static void field(Map<String,Object> row,ResolvedValueDeclaration value) {
        if(value.isEnumConstant()) {
            String type=value.getType().asReferenceType().getQualifiedName();
            row.putAll(obj("resolution","resolved_static","target_owner",type,"target_signature",type+"."+value.getName(),"dispatch","ENUM_CONSTANT",
                "target_location",value.toAst().map(SymbolFacts::location).orElse(null)));
            return;
        }
        if(!value.isField()) { row.put("resolution","local_or_parameter"); return; }
        ResolvedFieldDeclaration f=value.asField();
        // JavaParser 的字段 toAst() 可能返回整个 FieldDeclaration。
        // int a=1,b=2 必须按变量名定位到 VariableDeclarator，否则两字段会混淆。
        Node declaration=f.toAst().orElse(null);
        if(declaration instanceof FieldDeclaration d)declaration=d.getVariables().stream()
            .filter(v->v.getNameAsString().equals(f.getName())).findFirst().orElse(null);
        row.putAll(obj("resolution","resolved_static","target_owner",f.declaringType().getQualifiedName(),
            "target_signature",f.declaringType().getQualifiedName()+"."+f.getName(),
            "target_location",declaration==null?null:location(declaration)));
    }
    static Map<String,Object> extract(Path file,JavaParser parser) throws Exception {
        ParseResult<CompilationUnit> parsed=parser.parse(file,StandardCharsets.UTF_8);
        Map<String,Object> result=obj("file",file.toString(),"status",parsed.isSuccessful()?"parsed":"partial",
            "issues",parsed.getProblems().stream().map(Object::toString).toList());
        List<Object> declarations=new ArrayList<>(),references=new ArrayList<>(),types=new ArrayList<>();
        result.putAll(obj("declarations",declarations,"references",references,"types",types));
        if(parsed.getResult().isEmpty())return result;
        CompilationUnit cu=parsed.getResult().get();
        result.put("facts",syntaxFacts(cu));
        // syntax-only 不安装 SymbolResolver；下面的 resolve 异常会保留为未解析，
        // 语法调用位置仍登记，不能把“未做绑定”误解释为“没有依赖”。
        for(TypeDeclaration<?> type:cu.findAll(TypeDeclaration.class)) {
            Map<String,Object> row=obj("location",location(type),"owner",type.getFullyQualifiedName().orElse(type.getNameAsString()));
            try {row.put("ancestors",type.resolve().getAncestors().stream().map(t->t.getQualifiedName()).toList());}
            catch(Exception|StackOverflowError ex){row.put("reason",error(ex));}
            types.add(row);
        }
        for(CallableDeclaration<?> node:cu.findAll(CallableDeclaration.class)) {
            Map<String,Object> row=base(node,node.getNameAsString(),node instanceof ConstructorDeclaration?"constructor":"method");
            row.put("owner",owner(node));
            try {
                String signature=node instanceof MethodDeclaration m?m.resolve().getQualifiedSignature():((ConstructorDeclaration)node).resolve().getQualifiedSignature();
                row.putAll(obj("resolution","resolved_static","signature",signature));
            } catch(Exception|StackOverflowError ex){row.put("reason",error(ex));}
            declarations.add(row);
        }
        for(MethodCallExpr node:cu.findAll(MethodCallExpr.class)) {
            Map<String,Object> row=base(node,node.getNameAsString(),"method");
            row.put("arguments",node.getArguments().stream().map(Object::toString).toList());
            row.put("scope_as_written",node.getScope().map(Object::toString).orElse(null));
            try {method(row,node.resolve());}catch(Exception|StackOverflowError ex){row.put("reason",error(ex));}
            if(node.getScope().isPresent()) {
                Expression scope=node.getScope().get();
                try {row.put("receiver_type",scope.calculateResolvedType().describe());}catch(Exception|StackOverflowError ex){}
                if(scope instanceof ClassExpr cls) {
                    try {
                        var resolved=cls.getType().resolve();
                        row.put("class_resource_anchor",resolved.describe());
                        row.put("class_resource_package",resolved.asReferenceType().getTypeDeclaration().orElseThrow().getPackageName());
                    }catch(Exception|StackOverflowError ex){}
                }
                if(scope instanceof MethodCallExpr call && call.getNameAsString().equals("getClass") && call.getArguments().isEmpty()
                    && (call.getScope().isEmpty() || call.getScope().get() instanceof ThisExpr))row.put("self_get_class",true);
            }
            if(!node.getArguments().isEmpty() && node.getArgument(0) instanceof StringLiteralExpr str) row.put("literal_path",str.asString());
            references.add(row);
        }
        for(ObjectCreationExpr node:cu.findAll(ObjectCreationExpr.class)) {
            Map<String,Object> row=base(node,"<init>","constructor");
            try {
                ResolvedConstructorDeclaration value=node.resolve();
                row.putAll(obj("resolution","resolved_static","target_signature",value.getQualifiedSignature(),
                    "target_owner",value.declaringType().getQualifiedName(),"dispatch","CONSTRUCTOR",
                    "target_location",value.toAst().map(SymbolFacts::location).orElse(null)));
            }catch(Exception|StackOverflowError ex){row.put("reason",error(ex));}
            if(!node.getArguments().isEmpty() && node.getArgument(0) instanceof StringLiteralExpr str) row.put("literal_path",str.asString());
            references.add(row);
        }
        // 方法引用登记声明依赖，不宣称它已经在当前位置执行。
        for(MethodReferenceExpr node:cu.findAll(MethodReferenceExpr.class)) {
            Map<String,Object> row=base(node,node.getIdentifier(),"method_reference");
            try {method(row,node.resolve());}catch(Exception|StackOverflowError ex){row.put("reason",error(ex));}
            row.put("dispatch","METHOD_REFERENCE_DEFERRED_EXECUTION");
            references.add(row);
        }
        for(ExplicitConstructorInvocationStmt node:cu.findAll(ExplicitConstructorInvocationStmt.class)) {
            Map<String,Object> row=base(node,node.isThis()?"this":"super","method");
            try {
                ResolvedConstructorDeclaration value=node.resolve();
                row.putAll(obj("resolution","resolved_static","target_signature",value.getQualifiedSignature(),
                    "target_owner",value.declaringType().getQualifiedName(),"dispatch","CONSTRUCTOR",
                    "target_location",value.toAst().map(SymbolFacts::location).orElse(null)));
            }catch(Exception|StackOverflowError ex){row.put("reason",error(ex));}
            references.add(row);
        }
        for(FieldAccessExpr node:cu.findAll(FieldAccessExpr.class)) {
            Map<String,Object> row=base(node,node.getNameAsString(),"member_select");
            try {field(row,node.resolve());}catch(Exception|StackOverflowError ex){row.put("reason",error(ex));}
            references.add(row);
        }
        for(NameExpr node:cu.findAll(NameExpr.class)) {
            Map<String,Object> row=base(node,node.getNameAsString(),"identifier");
            try {field(row,node.resolve());}catch(Exception|StackOverflowError ex){row.put("reason",error(ex));}
            references.add(row);
        }
        return result;
    }
    public static void main(String[] args) throws Exception {
        JsonObject job=JsonParser.parseString(Files.readString(Path.of(args[0]),StandardCharsets.UTF_8)).getAsJsonObject();
        SYNTAX_ONLY=job.has("syntax_only") && job.get("syntax_only").getAsBoolean();
        ParserConfiguration settings=new ParserConfiguration().setLanguageLevel(ParserConfiguration.LanguageLevel.JAVA_17).setTabSize(1);
        CombinedTypeSolver solver=new CombinedTypeSolver(new ReflectionTypeSolver());
        for(JsonElement root:job.getAsJsonArray("source_roots"))solver.add(new JavaParserTypeSolver(Path.of(root.getAsString()),settings));
        for(JsonElement jar:job.getAsJsonArray("classpath"))solver.add(new JarTypeSolver(jar.getAsString()));
        if(!SYNTAX_ONLY)settings.setSymbolResolver(new JavaSymbolSolver(solver));
        JavaParser parser=new JavaParser(settings);
        List<Object> results=new ArrayList<>();
        for(JsonElement name:job.getAsJsonArray("files")) {
            Path file=Path.of(name.getAsString());
            try {results.add(extract(file,parser));}
            catch(Exception|StackOverflowError ex){results.add(obj("file",file.toString(),"status","failed","issues",List.of(error(ex)),"declarations",List.of(),"references",List.of(),"types",List.of()));}
        }
        Files.writeString(Path.of(args[1]),jsonText(obj("backend","JavaParser-SymbolSolver-3.26.3","files",results)),StandardCharsets.UTF_8);
    }
}
