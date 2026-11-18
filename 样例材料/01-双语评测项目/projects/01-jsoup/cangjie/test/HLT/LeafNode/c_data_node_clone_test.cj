// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

@Test
public class CDataNodeCloneTest {
    let strAll1: String =
        "TextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNode"

    @TestCase
    func cDataNodeClone01(): Unit {
        var cDataNode: CDataNode = CDataNode("")
        var cDataNode1: CDataNode = cDataNode.clone()
        @Assert(refEq(cDataNode, cDataNode1), false)
        @Assert(cDataNode.text(), "")
        @Assert(cDataNode1.text(), "")
    }

    @TestCase
    func cDataNodeClone02(): Unit {
        var cDataNode: CDataNode = CDataNode(" ")
        var cDataNode1: CDataNode = cDataNode.clone()
        @Assert(refEq(cDataNode, cDataNode1), false)
        @Assert(cDataNode.text(), " ")
        @Assert(cDataNode1.text(), " ")
    }

    @TestCase
    func cDataNodeClone03(): Unit {
        var cDataNode: CDataNode = CDataNode(strAll1)
        var cDataNode1: CDataNode = cDataNode.clone()
        @Assert(refEq(cDataNode, cDataNode1), false)
        @Assert(cDataNode.text(), strAll1)
        @Assert(cDataNode1.text(), strAll1)
    }

    @TestCase
    func cDataNodeClone04(): Unit {
        var cDataNode: CDataNode = CDataNode("~!@#$%^&*(){}><asdasadsdadas")
        var cDataNode1: CDataNode = cDataNode.clone()
        @Assert(refEq(cDataNode, cDataNode1), false)
        @Assert(cDataNode.text(), "~!@#$%^&*(){}><asdasadsdadas")
        @Assert(cDataNode1.text(), "~!@#$%^&*(){}><asdasadsdadas")
    }
}
