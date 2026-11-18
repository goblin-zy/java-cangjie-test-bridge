// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

@Test
public class TextNodeInitTest {
    let strAll1: String =
        "TextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNode"

    @TestCase
    func textNodeInit01(): Unit {
        var textNode: TextNode = TextNode("")
        @Assert(textNode.nodeName(), "#text")
    }

    @TestCase
    func textNodeInit02(): Unit {
        var textNode: TextNode = TextNode(" ")
        @Assert(textNode.nodeName(), "#text")
    }

    @TestCase
    func textNodeInit03(): Unit {
        var textNode: TextNode = TextNode(strAll1)
        @Assert(textNode.nodeName(), "#text")
    }

    @TestCase
    func textNodeInit04(): Unit {
        var textNode: TextNode = TextNode("~!@#$%^&*(){}><asdasadsdadas")
        @Assert(textNode.nodeName(), "#text")
    }
}
