// EXEC: cjc %import-path %L %l %f
// EXEC: ./main
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.unittest.testmacro.*

main(): Int64 {
    let dataNodeTest: DataNodeTest = DataNodeTest()

    dataNodeTest.initTest()

    return 0
}

@Test
public class DataNodeTest {
    @TestCase
    public func initTest(): Unit {
        // 1
        var dataNode1: DataNode = DataNode("DataNode")
        @Assert(dataNode1.nodeName(), "#data")
        @Assert(dataNode1.getWholeData(), "DataNode")
        @Assert(dataNode1.toString(), "DataNode")
        dataNode1.setWholeData("new DataNode")
        @Assert(dataNode1.getWholeData(), "new DataNode")
        @Assert(dataNode1.toString(), "new DataNode")  
        var dataNode2: DataNode = dataNode1.clone()
        @Assert(dataNode1 == dataNode2, false)
        @Assert(refEq(dataNode1, dataNode2), false)

        println("Pass1")
    }
}