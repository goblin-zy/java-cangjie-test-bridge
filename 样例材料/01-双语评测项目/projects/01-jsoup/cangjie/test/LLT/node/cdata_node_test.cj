// EXEC: cjc %import-path %L %l %f
// EXEC: ./main
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.unittest.testmacro.*

main(): Int64 {
    let cDataNodeTest: CDataNodeTest = CDataNodeTest()

    cDataNodeTest.cloneTest()

    return 0
}

@Test
public class CDataNodeTest {
    @TestCase
    public func cloneTest(): Unit {
        // 1
        var cDataNode1: CDataNode = CDataNode("CDataNode")
        @Assert(cDataNode1.nodeName(), "#cdata")
        @Assert(cDataNode1.text(), "CDataNode")
        var cDataNode2: CDataNode = cDataNode1.clone()
        @Assert(cDataNode1 == cDataNode2, false)
        @Assert(refEq(cDataNode1, cDataNode2), false)

        println("Pass1")
    }
}
