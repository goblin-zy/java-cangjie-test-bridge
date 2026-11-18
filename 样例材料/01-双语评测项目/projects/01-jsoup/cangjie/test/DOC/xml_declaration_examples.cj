// EXEC: cjc %import-path %L %l %f
// EXEC: ./main
import cangjie_tpc::html4cj.*

main(): Int64 {
    var xmlDeclaration: XmlDeclaration = XmlDeclaration("xml", false)
    if (xmlDeclaration.nodeName() == "#declaration") {
        println("pass1")
    }
    if (xmlDeclaration.name() == "xml") {
        println("pass2")
    }
    xmlDeclaration.attr("version", "1.0")
    xmlDeclaration.attr("encoding", "UTF-8")
    if (xmlDeclaration.getWholeDeclaration() == "version=\"1.0\" encoding=\"UTF-8\"") {
        println("pass3")
    }
    if (xmlDeclaration.toString() == "<?xml version=\"1.0\" encoding=\"UTF-8\"?>") {
        println("pass4")
    }
    var xmlDeclaration1: XmlDeclaration = XmlDeclaration("xml", true)
    if (xmlDeclaration1.nodeName() == "#declaration") {
        println("pass5")
    }
    if (xmlDeclaration1.name() == "xml") {
        println("pass6")
    }
    xmlDeclaration1.attr("version", "1.0")
    xmlDeclaration1.attr("encoding", "UTF-8")
    if (xmlDeclaration1.getWholeDeclaration() == "version=\"1.0\" encoding=\"UTF-8\"") {
        println("pass7")
    }
    if (xmlDeclaration1.toString() == "<!xml version=\"1.0\" encoding=\"UTF-8\"!>") {
        println("pass8")
    }
    var xmlDeclaration2: XmlDeclaration = xmlDeclaration1.clone()
    if (xmlDeclaration1 != xmlDeclaration2) {
        println("pass9")
    }
    if (!refEq(xmlDeclaration1, xmlDeclaration2)) {
        println("pass10")
    }

    return 0
}
