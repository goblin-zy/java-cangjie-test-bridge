// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

@Test
public class TextNodeNodeNameTest {
    let strAll1: String =
        "TextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNode"

    @TestCase
    func textNodeNodeName01(): Unit {
        var textNode: TextNode = TextNode("")
        @Assert(textNode.nodeName(), "#text")
    }

    @TestCase
    func textNodeNodeName02(): Unit {
        var textNode: TextNode = TextNode(" ")
        @Assert(textNode.nodeName(), "#text")
    }

    @TestCase
    func textNodeNodeName03(): Unit {
        var textNode: TextNode = TextNode(strAll1)
        @Assert(textNode.nodeName(), "#text")
    }

    @TestCase
    func textNodeNodeName04(): Unit {
        var textNode: TextNode = TextNode("~!@#$%^&*(){}><asdasadsdadas")
        @Assert(textNode.nodeName(), "#text")
    }
}
