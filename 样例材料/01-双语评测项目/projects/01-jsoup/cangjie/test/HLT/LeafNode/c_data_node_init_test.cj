// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

@Test
public class CDataNodeInitTest {
    let strAll1: String =
        "TextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNode"

    @TestCase
    func cDataNodeInit01(): Unit {
        var cDataNode: CDataNode = CDataNode("")
        @Assert(cDataNode.nodeName(), "#cdata")
    }

    @TestCase
    func cDataNodeInit02(): Unit {
        var cDataNode: TextNode = CDataNode(" ")
        @Assert(cDataNode.nodeName(), "#cdata")
    }

    @TestCase
    func cDataNodeInit03(): Unit {
        var cDataNode: CDataNode = CDataNode(strAll1)
        @Assert(cDataNode.nodeName(), "#cdata")
    }

    @TestCase
    func cDataNodeInit04(): Unit {
        var cDataNode: CDataNode = CDataNode("~!@#$%^&*(){}><asdasadsdadas")
        @Assert(cDataNode.nodeName(), "#cdata")
    }
}
