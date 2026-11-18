// EXEC: cjc %import-path %L %l %f
// EXEC: ./main
import cangjie_tpc::html4cj.*

main(): Int64 {
    var syntax1: Syntax = Syntax.htmlSyntax
    var syntax2: Syntax = Syntax.xmlSyntax
    if ("htmlSyntax" == syntax1.toString()) {
        println("pass1")
    }
    if ("xmlSyntax" == syntax2.toString()) {
        println("pass2")
    }
    if (syntax1 != syntax2) {
        println("pass3")
    }
    if (syntax2 == syntax2) {
        println("pass4")
    }

    return 0
}
