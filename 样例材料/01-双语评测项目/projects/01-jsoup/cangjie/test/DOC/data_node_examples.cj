// EXEC: cjc %import-path %L %l %f
// EXEC: ./main
import cangjie_tpc::html4cj.*

main(): Int64 {
    var dataNode1: DataNode = DataNode("DataNode")
    if (dataNode1.nodeName() == "#data") {
        println("pass1")
    }
    if (dataNode1.getWholeData() == "DataNode") {
        println("pass2")
    }
    if (dataNode1.toString() == "DataNode") {
        println("pass3")
    }
    dataNode1.setWholeData("new DataNode")
    if (dataNode1.getWholeData() == "new DataNode") {
        println("pass4")
    }
    if (dataNode1.toString() == "new DataNode") {
        println("pass5")
    }
    var dataNode2: DataNode = dataNode1.clone()
    if (dataNode1 != dataNode2) {
        println("pass6")
    }
    if (!refEq(dataNode1, dataNode2)) {
        println("pass7")
    }

    return 0
}
