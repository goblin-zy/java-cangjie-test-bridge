package cangjie_tpc::html4cj

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
