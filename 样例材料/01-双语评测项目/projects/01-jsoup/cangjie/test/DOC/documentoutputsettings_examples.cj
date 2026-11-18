// EXEC: cjc %import-path %L %l %f
// EXEC: ./main
import cangjie_tpc::html4cj.*

main(): Int64 {
    var documentOutputSettings: DocumentOutputSettings = DocumentOutputSettings()
    if (EscapeMode.base == documentOutputSettings.escapeMode()) {
        println("pass1")
    }
    documentOutputSettings.escapeMode(EscapeMode.xhtml)
    if (EscapeMode.xhtml == documentOutputSettings.escapeMode()) {
        println("pass2")
    }
    if ("UTF-8" == documentOutputSettings.charset()) {
        println("pass3")
    }
    documentOutputSettings.charset("ASCII")
    if ("ASCII" == documentOutputSettings.charset()) {
        println("pass4")
    }
    if (Syntax.htmlSyntax == documentOutputSettings.syntax()) {
        println("pass5")
    }
    documentOutputSettings.syntax(Syntax.xmlSyntax)
    if (Syntax.xmlSyntax == documentOutputSettings.syntax()) {
        println("pass6")
    }
    if (documentOutputSettings.prettyPrint()) {
        println("pass7")
    }
    documentOutputSettings.prettyPrint(false)
    if (!documentOutputSettings.prettyPrint()) {
        println("pass8")
    }
    if (!documentOutputSettings.outline()) {
        println("pass9")
    }
    documentOutputSettings.outline(true)
    if (documentOutputSettings.outline()) {
        println("pass10")
    }
    if (1 == documentOutputSettings.indentAmount()) {
        println("pass11")
    }
    documentOutputSettings.indentAmount(10)
    if (10 == documentOutputSettings.indentAmount()) {
        println("pass12")
    }
    if (30 == documentOutputSettings.maxPaddingWidth()) {
        println("pass13")
    }
    documentOutputSettings.maxPaddingWidth(10)
    if (10 == documentOutputSettings.maxPaddingWidth()) {
        println("pass14")
    }

    return 0
}
