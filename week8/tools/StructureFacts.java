import com.sun.source.tree.*;
import com.sun.source.util.*;
import javax.tools.*;
import java.nio.file.*;
import java.nio.charset.StandardCharsets;
import java.util.*;

/** JDK语法解析适配器：只提取声明，不进行类型绑定，不生成骨架。 */
public class StructureFacts {
    static String q(String s) {
        StringBuilder b=new StringBuilder("\"");
        for(char c:s.toCharArray()) {
            switch(c) {case '"': b.append("\\\"");break; case '\\':b.append("\\\\");break;
                case '\n':b.append("\\n");break;case '\r':b.append("\\r");break;case '\t':b.append("\\t");break;
                default:if(c<32)b.append(String.format("\\u%04x",(int)c));else b.append(c);}
        }
        return b.append('"').toString();
    }
    public static void main(String[] args) throws Exception {
        JavaCompiler compiler=ToolProvider.getSystemJavaCompiler();
        if(compiler==null)throw new IllegalStateException("Full JDK required");
        DiagnosticCollector<JavaFileObject> diagnostics=new DiagnosticCollector<>();
        try(StandardJavaFileManager fm=compiler.getStandardFileManager(diagnostics,Locale.ROOT,StandardCharsets.UTF_8)) {
            JavacTask task=(JavacTask)compiler.getTask(null,fm,diagnostics,List.of("-proc:none","--release","17"),null,fm.getJavaFileObjects(args[0]));
            CompilationUnitTree unit=task.parse().iterator().next();
            for(Diagnostic<?> d:diagnostics.getDiagnostics()) if(d.getKind()==Diagnostic.Kind.ERROR) {
                System.out.println("{\"type\":\"issue\",\"message\":"+q(d.getMessage(Locale.ROOT))+"}");
            }
            SourcePositions positions=Trees.instance(task).getSourcePositions();
            new TreePathScanner<Void,Void>() {
                String owner="";
                void emit(Tree node,String kind,String name,String annotations) {
                    long start=positions.getStartPosition(unit,node),end=positions.getEndPosition(unit,node);
                    if(start<0||end<start)return;
                    System.out.println("{\"type\":\"symbol\",\"kind\":"+q(kind)+",\"name\":"+q(name)+",\"owner\":"+q(owner)+",\"annotations\":"+q(annotations)+",\"start_utf16\":"+start+",\"end_utf16\":"+end+",\"line\":"+unit.getLineMap().getLineNumber(start)+"}");
                }
                public Void visitClass(ClassTree n,Void v) {
                    String before=owner;owner=owner.isEmpty()?n.getSimpleName().toString():owner+"."+n.getSimpleName();
                    emit(n,n.getKind().name(),owner,n.getModifiers().getAnnotations().toString());
                    super.visitClass(n,v);owner=before;return null;
                }
                public Void visitMethod(MethodTree n,Void v) {
                    emit(n,"METHOD",n.getName()+"("+String.join(",",n.getParameters().stream().map(p->p.getType().toString()).toList())+")",n.getModifiers().getAnnotations().toString());
                    return super.visitMethod(n,v);
                }
                public Void visitVariable(VariableTree n,Void v) {
                    Tree parent=getCurrentPath().getParentPath().getLeaf();
                    if(parent instanceof ClassTree)emit(n,"FIELD",n.getName().toString(),n.getModifiers().getAnnotations().toString());
                    return super.visitVariable(n,v);
                }
                public Void visitImport(ImportTree n,Void v) {emit(n,"IMPORT",n.getQualifiedIdentifier().toString(),"");return null;}
            }.scan(unit,null);
        }
    }
}
