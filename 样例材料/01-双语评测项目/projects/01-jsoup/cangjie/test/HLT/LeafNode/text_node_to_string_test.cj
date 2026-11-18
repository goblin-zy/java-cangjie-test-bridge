// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

@Test
public class TextNodeToStringTest {
    let strAll1: String =
        "TextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNode"

    @TestCase
    func textNodeToString01(): Unit {
        var textNode: TextNode = TextNode("")
        @Assert(textNode.toString(), "")
    }

    @TestCase
    func textNodeToString02(): Unit {
        var textNode: TextNode = TextNode(" ")
        @Assert(textNode.toString(), " ")
    }

    @TestCase
    func textNodeToString03(): Unit {
        var textNode: TextNode = TextNode(strAll1)
        @Assert(textNode.toString(), strAll1)
    }

    @TestCase
    func textNodeToString04(): Unit {
        var textNode: TextNode = TextNode("~!@#$%^&*(){}><asdasadsdadas")
        @Assert(textNode.toString(), "~!@#$%^&amp;*(){}&gt;&lt;asdasadsdadas")
    }
}
