// EXEC: cjc %import-path %L %l %f
// EXEC: ./main
import cangjie_tpc::html4cj.*

main(): Int64 {
    var documentType: DocumentType = DocumentType("html", "", "")
    if (documentType.nodeName() == "#doctype") {
        println("pass1")
    }
    if (documentType.name() == "html") {
        println("pass2")
    }
    if (documentType.publicId() == "") {
        println("pass3")
    }
    if (documentType.systemId() == "") {
        println("pass4")
    }
    documentType.setPubSysKey("key")
    if (documentType.toString() == "<!doctype html key>") {
        println("pass5")
    }
    var documentType1: DocumentType = DocumentType("notHtml", "--public", "--system")
    if (documentType1.nodeName() == "#doctype") {
        println("pass6")
    }
    if (documentType1.name() == "html") {
        println("pass7")
    }
    if (documentType1.publicId() == "--public") {
        println("pass8")
    }
    if (documentType1.systemId() == "--system") {
        println("pass9")
    }
    if (documentType.toString() == "<!DOCTYPE notHtml PUBLIC \"--public\" \"--system\">") {
        println("pass10")
    }

    return 0
}
