// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

@Test
public class TextNodeTextTest {
    let strAll1: String =
        "TextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNode"

    @TestCase
    func textNodeText01(): Unit {
        var textNode: TextNode = TextNode("")
        @Assert(textNode.text(), "")
        textNode.text(" ")
        @Assert(textNode.text(), " ")
    }

    @TestCase
    func textNodeText02(): Unit {
        var textNode: TextNode = TextNode(" ")
        @Assert(textNode.text(), " ")
        textNode.text("")
        @Assert(textNode.text(), "")
        textNode.text("~!@#$%^&*(){}><asdasadsdadas")
        @Assert(textNode.text(), "~!@#$%^&*(){}><asdasadsdadas")
        textNode.text(strAll1)
        @Assert(textNode.text(), strAll1)
    }

    @TestCase
    func textNodeText03(): Unit {
        var textNode: TextNode = TextNode(strAll1)
        @Assert(textNode.text(), strAll1)
        textNode.text("textNodeText03")
        @Assert(textNode.text(), "textNodeText03")
    }

    @TestCase
    func textNodeText04(): Unit {
        var textNode: TextNode = TextNode("~!@#$%^&*(){}><asdasadsdadas")
        @Assert(textNode.text(), "~!@#$%^&*(){}><asdasadsdadas")
        textNode.text("textNodeText04")
        @Assert(textNode.text(), "textNodeText04")
    }
}
