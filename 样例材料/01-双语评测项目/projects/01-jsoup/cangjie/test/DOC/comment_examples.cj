// EXEC: cjc %import-path %L %l %f
// EXEC: ./main
import cangjie_tpc::html4cj
import cangjie_tpc::html4cj.*

main(): Int64 {
    var commentNode: Comment = html4cj.Comment("public override func clone(): Comment")
    if (commentNode.nodeName() == "#comment") {
        println("pass1")
    }
    if (commentNode.getData() == "public override func clone(): Comment") {
        println("pass2")
    }
    commentNode.setData("注释")
    if (commentNode.getData() == "注释") {
        println("pass3")
    }
    if (commentNode.toString() == "<!--注释-->") {
        println("pass4")
    }
    if (!commentNode.isXmlDeclaration()) {
        println("pass5")
    }
    var commentNode1: Comment = html4cj.Comment("?xml encoding='ISO-8859-1'?")
    if (commentNode1.nodeName() == "#comment") {
        println("pass6")
    }
    if (commentNode1.getData() == "?xml encoding='ISO-8859-1'?") {
        println("pass6")
    }
    if (commentNode1.toString() == "<!--?xml encoding='ISO-8859-1'?-->") {
        println("pass7")
    }
    if (commentNode1.isXmlDeclaration()) {
        println("pass8")
    }
    var xmlDeclarat1: XmlDeclaration = commentNode1.asXmlDeclaration().getOrThrow()
    if (xmlDeclarat1.toString() == "<?xml encoding=\"ISO-8859-1\"?>") {
        println("pass9")
    }

    return 0
}
