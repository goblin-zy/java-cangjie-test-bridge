// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

@Test
public class CDataNodeNodeNameTest {
    let strAll1: String =
        "TextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNode"

    @TestCase
    func cDataNodeNodeName01(): Unit {
        var cDataNode: CDataNode = CDataNode("")
        @Assert(cDataNode.nodeName(), "#cdata")
    }

    @TestCase
    func cDataNodeNodeName02(): Unit {
        var cDataNode: TextNode = CDataNode(" ")
        @Assert(cDataNode.nodeName(), "#cdata")
    }

    @TestCase
    func cDataNodeNodeName03(): Unit {
        var cDataNode: CDataNode = CDataNode(strAll1)
        @Assert(cDataNode.nodeName(), "#cdata")
    }

    @TestCase
    func cDataNodeNodeName04(): Unit {
        var cDataNode: CDataNode = CDataNode("~!@#$%^&*(){}><asdasadsdadas")
        @Assert(cDataNode.nodeName(), "#cdata")
    }
}
