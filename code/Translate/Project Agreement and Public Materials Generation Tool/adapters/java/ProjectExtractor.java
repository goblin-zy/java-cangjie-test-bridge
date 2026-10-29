import com.github.javaparser.*;
import com.github.javaparser.ast.*;
import com.github.javaparser.ast.body.*;
import com.github.javaparser.ast.expr.*;
import com.github.javaparser.ast.stmt.ExplicitConstructorInvocationStmt;
import com.github.javaparser.resolution.declarations.*;
import com.github.javaparser.symbolsolver.JavaSymbolSolver;
import com.github.javaparser.symbolsolver.resolution.typesolvers.*;
import com.google.gson.*;
import java.nio.charset.StandardCharsets;
import java.nio.file.*;
import java.util.*;
import java.util.stream.Collectors;

/** Standalone syntax/symbol bridge. Never compiles or executes the input project. */
public final class ProjectExtractor {
    private static final Gson GSON = new GsonBuilder().disableHtmlEscaping().create();

    static Map<String,Object> obj(Object... pairs) {
        Map<String,Object> result = new LinkedHashMap<>();
        for (int i=0;i<pairs.length;i+=2) result.put((String)pairs[i], pairs[i+1]);
        return result;
    }
    static int start(Node n) { return n.getBegin().map(p->p.line).orElse(1); }
    static int end(Node n) { return n.getEnd().map(p->p.line).orElse(start(n)); }
    static String pos(Node n) { return n.getRange().map(Object::toString).orElse("unknown"); }
    static String qualified(TypeDeclaration<?> type, CompilationUnit cu) {
        return type.getFullyQualifiedName().orElse(
            cu.getPackageDeclaration().map(p->p.getNameAsString()+".").orElse("")
            + type.getNameAsString()+"@"+pos(type));
    }
    static String owner(Node n, CompilationUnit cu) {
        Node p=n.getParentNode().orElse(null);
        while (p!=null) {
            if (p instanceof TypeDeclaration<?>) return qualified((TypeDeclaration<?>)p, cu);
            p=p.getParentNode().orElse(null);
        }
        return cu.getPackageDeclaration().map(pck->pck.getNameAsString()).orElse("");
    }
    static List<String> modifiers(Node n) {
        if (n instanceof com.github.javaparser.ast.nodeTypes.NodeWithModifiers<?>) {
            return ((com.github.javaparser.ast.nodeTypes.NodeWithModifiers<?>)n).getModifiers()
                .stream().map(m->m.getKeyword().asString()).collect(Collectors.toList());
        }
        return List.of();
    }
    static List<String> annotations(Node n) {
        if (n instanceof com.github.javaparser.ast.nodeTypes.NodeWithAnnotations<?>) {
            return ((com.github.javaparser.ast.nodeTypes.NodeWithAnnotations<?>)n).getAnnotations()
                .stream().map(AnnotationExpr::getNameAsString).collect(Collectors.toList());
        }
        return List.of();
    }
    static String role(Node n) {
        List<String> a=annotations(n);
        if (a.stream().anyMatch(s->Set.of("Test","ParameterizedTest","RepeatedTest","TestFactory","TestTemplate").contains(s.substring(s.lastIndexOf('.')+1)))) return "test";
        if (a.stream().anyMatch(s->Set.of("BeforeEach","BeforeAll").contains(s.substring(s.lastIndexOf('.')+1)))) return "setup";
        if (a.stream().anyMatch(s->Set.of("AfterEach","AfterAll").contains(s.substring(s.lastIndexOf('.')+1)))) return "cleanup";
        return "ordinary";
    }
    static Map<String,Object> base(Node n, CompilationUnit cu, String kind, String name) {
        return obj("local_key",kind+":"+pos(n)+":"+name, "kind",kind,"name",name,
            "owner",owner(n,cu), "start_line",start(n),"end_line",end(n),
            "modifiers",modifiers(n),"annotations",annotations(n),"role",role(n));
    }
    static String context(Node n) {
        Node p=n.getParentNode().orElse(null);
        while(p!=null) {
            if(p instanceof CallableDeclaration<?>) return pos(p);
            if(p instanceof InitializerDeclaration) return pos(p);
            p=p.getParentNode().orElse(null);
        }
        return "";
    }
    static Map<String,Object> extract(Path file, JavaParser parser) throws Exception {
        ParseResult<CompilationUnit> parsed=parser.parse(file, StandardCharsets.UTF_8);
        Map<String,Object> out=obj("path",file.toString(),"status",parsed.isSuccessful()?"parsed":"partial",
            "issues",parsed.getProblems().stream().map(Object::toString).collect(Collectors.toList()));
        List<Map<String,Object>> members=new ArrayList<>(), refs=new ArrayList<>();
        out.put("members",members); out.put("references",refs);
        if(parsed.getResult().isEmpty()) { out.put("status","parse_failure"); return out; }
        CompilationUnit cu=parsed.getResult().get();
        out.put("package",cu.getPackageDeclaration().map(p->p.getNameAsString()).orElse(""));
        out.put("imports",cu.getImports().stream().map(Object::toString).collect(Collectors.toList()));
        for(TypeDeclaration<?> t: cu.findAll(TypeDeclaration.class)) {
            String kind=t instanceof EnumDeclaration?"enum":t instanceof RecordDeclaration?"record":
                t instanceof AnnotationDeclaration?"annotation":t instanceof ClassOrInterfaceDeclaration &&
                ((ClassOrInterfaceDeclaration)t).isInterface()?"interface":"class";
            Map<String,Object> m=base(t,cu,kind,t.getNameAsString());
            m.put("qualified_name",qualified(t,cu));
            m.put("signature",t.getNameAsString());
            if(t instanceof ClassOrInterfaceDeclaration c) {
                m.put("extends",c.getExtendedTypes().stream().map(Object::toString).collect(Collectors.toList()));
                m.put("implements",c.getImplementedTypes().stream().map(Object::toString).collect(Collectors.toList()));
                m.put("type_parameters",c.getTypeParameters().stream().map(Object::toString).collect(Collectors.toList()));
            }
            if(t instanceof RecordDeclaration r) {
                m.put("record_components",r.getParameters().stream().map(p->obj("name",p.getNameAsString(),"type",p.getTypeAsString())).collect(Collectors.toList()));
                ((List<String>)out.get("issues")).add("record仅记录显式声明及components；未枚举编译器合成成员。");
            }
            members.add(m);
        }
        for(CompactConstructorDeclaration c:cu.findAll(CompactConstructorDeclaration.class)) {
            Map<String,Object> m=base(c,cu,"constructor",c.getNameAsString());
            Optional<RecordDeclaration> record=c.findAncestor(RecordDeclaration.class);
            List<Map<String,Object>> ps=record.map(r->r.getParameters().stream()
                .map(p->obj("name",p.getNameAsString(),"type",p.getTypeAsString(),"varargs",p.isVarArgs()))
                .collect(Collectors.toList())).orElse(List.of());
            String signature=c.getNameAsString()+"("+ps.stream().map(p->p.get("type").toString()).collect(Collectors.joining(","))+")";
            m.put("qualified_name",owner(c,cu)+"."+signature);
            m.put("parameters",ps); m.put("signature",signature);m.put("return_type",owner(c,cu));
            m.put("resolution_note","compact record constructor retained; binding not implemented");
            members.add(m);
        }
        for(CallableDeclaration<?> c:cu.findAll(CallableDeclaration.class)) {
            Map<String,Object> m=base(c,cu,c instanceof ConstructorDeclaration?"constructor":"method",c.getNameAsString());
            String params=c.getParameters().stream().map(p->p.getType().toString()+(p.isVarArgs()?"...":"")).collect(Collectors.joining(","));
            m.put("qualified_name",owner(c,cu)+"."+c.getNameAsString()+"("+params+")");
            m.put("signature",c.getDeclarationAsString(true,true,true));
            m.put("parameters",c.getParameters().stream().map(p->obj("name",p.getNameAsString(),"type",p.getType().toString(),"varargs",p.isVarArgs())).collect(Collectors.toList()));
            m.put("return_type",c instanceof MethodDeclaration?((MethodDeclaration)c).getType().toString():owner(c,cu));
            m.put("type_parameters",c.getTypeParameters().stream().map(Object::toString).collect(Collectors.toList()));
            m.put("throws",c.getThrownExceptions().stream().map(Object::toString).collect(Collectors.toList()));
            try {
                String resolved=c instanceof MethodDeclaration?
                    ((MethodDeclaration)c).resolve().getQualifiedSignature():
                    ((ConstructorDeclaration)c).resolve().getQualifiedSignature();
                m.put("resolved_signature",resolved);
            } catch(Exception ex) { m.put("resolution_note",ex.getClass().getSimpleName()+": "+ex.getMessage()); }
            members.add(m);
        }
        for(FieldDeclaration f:cu.findAll(FieldDeclaration.class)) for(VariableDeclarator v:f.getVariables()) {
            Map<String,Object> m=base(f,cu,"field",v.getNameAsString());
            m.put("local_key","field:"+pos(v)+":"+v.getNameAsString());
            m.put("qualified_name",owner(f,cu)+"."+v.getNameAsString());
            m.put("signature",v.getType()+" "+v.getNameAsString());
            m.put("declared_type",v.getType().toString());
            m.put("initializer",v.getInitializer().map(Object::toString).orElse(""));
            members.add(m);
        }
        for(InitializerDeclaration init:cu.findAll(InitializerDeclaration.class)) {
            Map<String,Object> m=base(init,cu,"initializer",init.isStatic()?"<static-init>":"<instance-init>");
            m.put("qualified_name",owner(init,cu)+"."+m.get("name")+"@"+pos(init));
            m.put("signature",m.get("name"));
            members.add(m);
        }
        for(EnumConstantDeclaration e:cu.findAll(EnumConstantDeclaration.class)) {
            Map<String,Object> m=base(e,cu,"enum_constant",e.getNameAsString());
            m.put("qualified_name",owner(e,cu)+"."+e.getNameAsString());
            m.put("signature",e.getNameAsString()); members.add(m);
        }
        for(MethodCallExpr call:cu.findAll(MethodCallExpr.class)) {
            Map<String,Object> r=obj("kind","call","name",call.getNameAsString(),
                "expression",call.toString(),"start_line",start(call),"end_line",end(call),"context_range",context(call));
            try {
                ResolvedMethodDeclaration d=call.resolve();
                r.put("resolution","resolved"); r.put("target_signature",d.getQualifiedSignature());
            } catch(Exception ex) {
                r.put("resolution","unresolved"); r.put("reason",ex.getClass().getSimpleName()+": "+ex.getMessage());
            }
            refs.add(r);
        }
        for(ObjectCreationExpr call:cu.findAll(ObjectCreationExpr.class)) {
            Map<String,Object> r=obj("kind","construction","name",call.getType().asString(),
                "expression",call.toString(),"start_line",start(call),"end_line",end(call),"context_range",context(call));
            try {
                r.put("target_signature",call.resolve().getQualifiedSignature());r.put("resolution","resolved");
            } catch(Exception ex) {
                r.put("resolution","unresolved");r.put("reason",ex.getClass().getSimpleName()+": "+ex.getMessage());
            }
            refs.add(r);
        }
        for(MethodReferenceExpr call:cu.findAll(MethodReferenceExpr.class)) {
            refs.add(obj("kind","method_reference","name",call.getIdentifier(),"expression",call.toString(),
                "start_line",start(call),"end_line",end(call),"resolution","unresolved",
                "reason","Method reference binding is not implemented; inspect scope and target functional interface."));
        }
        for(ExplicitConstructorInvocationStmt call:cu.findAll(ExplicitConstructorInvocationStmt.class)) {
            Map<String,Object> r=obj("kind","constructor_delegation","name",call.isThis()?"this":"super",
                "expression",call.toString(),"start_line",start(call),"end_line",end(call),"context_range",context(call));
            try {r.put("target_signature",call.resolve().getQualifiedSignature());r.put("resolution","resolved");}
            catch(Exception ex){r.put("resolution","unresolved");r.put("reason",ex.getClass().getSimpleName()+": "+ex.getMessage());}
            refs.add(r);
        }
        for(FieldAccessExpr field:cu.findAll(FieldAccessExpr.class)) {
            Map<String,Object> r=obj("kind","field_access","name",field.getNameAsString(),"expression",field.toString(),
                "start_line",start(field),"end_line",end(field));
            try {
                ResolvedValueDeclaration value=field.resolve();
                if(value.isField()) {
                    r.put("target_signature",value.asField().declaringType().getQualifiedName()+"."+value.getName());
                    r.put("resolution","resolved");
                } else {r.put("resolution","unresolved");r.put("reason","非字段值或合成成员，未关联");}
            } catch(Exception ex){r.put("resolution","unresolved");r.put("reason",ex.getClass().getSimpleName()+": "+ex.getMessage());}
            refs.add(r);
        }
        for(NameExpr name:cu.findAll(NameExpr.class)) {
            try {
                ResolvedValueDeclaration value=name.resolve();
                if(value.isField()) refs.add(obj("kind","field_name","name",name.getNameAsString(),"expression",name.toString(),
                    "start_line",start(name),"end_line",end(name),"resolution","resolved",
                    "target_signature",value.asField().declaringType().getQualifiedName()+"."+value.getName()));
            } catch(Exception ex) {
                refs.add(obj("kind","name","name",name.getNameAsString(),"expression",name.toString(),
                    "start_line",start(name),"end_line",end(name),"resolution","unresolved",
                    "reason",ex.getClass().getSimpleName()+": "+ex.getMessage()));
            }
        }
        out.put("coverage_note","Only explicit declarations. No generated/Lombok members, reflection or dynamic dispatch proof; source/classpath required.");
        return out;
    }
    public static void main(String[] args) throws Exception {
        if(args.length!=1) throw new IllegalArgumentException("Usage: ProjectExtractor job.json");
        JsonObject job=JsonParser.parseString(Files.readString(Path.of(args[0]), StandardCharsets.UTF_8)).getAsJsonObject();
        ParserConfiguration.LanguageLevel level=ParserConfiguration.LanguageLevel.valueOf(job.get("language_level").getAsString());
        CombinedTypeSolver types=new CombinedTypeSolver(new ReflectionTypeSolver());
        List<String> setupIssues=new ArrayList<>();
        for(JsonElement root:job.getAsJsonArray("source_roots")) {
            try { types.add(new JavaParserTypeSolver(Path.of(root.getAsString()),new ParserConfiguration().setLanguageLevel(level).setCharacterEncoding(StandardCharsets.UTF_8))); }
            catch(Exception ex) { setupIssues.add(root+": "+ex); }
        }
        for(JsonElement jar:job.getAsJsonArray("classpath")) {
            try { types.add(new JarTypeSolver(jar.getAsString())); }
            catch(Exception ex) { setupIssues.add(jar+": "+ex); }
        }
        ParserConfiguration conf=new ParserConfiguration().setSymbolResolver(new JavaSymbolSolver(types))
            .setLanguageLevel(level)
            .setCharacterEncoding(StandardCharsets.UTF_8);
        // Type solver uses the same language level; missing project JARs remain unresolved.
        JavaParser parser=new JavaParser(conf);
        List<Map<String,Object>> files=new ArrayList<>();
        for(JsonElement f:job.getAsJsonArray("files")) {
            Path path=Path.of(f.getAsString());
            try { files.add(extract(path,parser)); }
            catch(Exception ex) { files.add(obj("path",path.toString(),"status","parse_failure",
                "members",List.of(),"references",List.of(),"issues",List.of(ex.toString()))); }
        }
        System.out.print(GSON.toJson(obj("protocol","java-ast-v1","parser","javaparser-3.26.3",
            "setup_issues",setupIssues,"files",files)));
    }
}

