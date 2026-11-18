// EXEC: cjc %import-path %L %l %f
// EXEC: ./main
import cangjie_tpc::html4cj.*

main(): Int64 {
    var cDataNode1: CDataNode = CDataNode("CDataNode")
    if (cDataNode1.nodeName() == "#cdata") {
        println("pass1")
    }
    if (cDataNode1.text() == "CDataNode") {
        println("pass2")
    }
    var cDataNode2: CDataNode = cDataNode1.clone()
    if (cDataNode1 != cDataNode2) {
        println("pass3")
    }
    if (!refEq(cDataNode1, cDataNode2)) {
        println("pass4")
    }

    return 0
}
