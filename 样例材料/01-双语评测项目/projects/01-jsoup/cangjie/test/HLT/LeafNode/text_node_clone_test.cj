// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

@Test
public class TextNodeCloneTest {
    let strAll1: String =
        "TextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNode"

    @TestCase
    func textNodeClone01(): Unit {
        var textNode: TextNode = TextNode("")
        var textNode1: TextNode = textNode.clone()
        @Assert(refEq(textNode, textNode1), false)
        @Assert(textNode.getWholeText(), "")
        @Assert(textNode1.getWholeText(), "")
    }

    @TestCase
    func textNodeClone02(): Unit {
        var textNode: TextNode = TextNode(" ")
        var textNode1: TextNode = textNode.clone()
        @Assert(refEq(textNode, textNode1), false)
        @Assert(textNode.getWholeText(), " ")
        @Assert(textNode1.getWholeText(), " ")
    }

    @TestCase
    func textNodeClone03(): Unit {
        var textNode: TextNode = TextNode(strAll1)
        var textNode1: TextNode = textNode.clone()
        @Assert(refEq(textNode, textNode1), false)
        @Assert(textNode.getWholeText(), strAll1)
        @Assert(textNode1.getWholeText(), strAll1)
    }

    @TestCase
    func textNodeClone04(): Unit {
        var textNode: TextNode = TextNode("~!@#$%^&*(){}><asdasadsdadas")
        var textNode1: TextNode = textNode.clone()
        @Assert(refEq(textNode, textNode1), false)
        @Assert(textNode.getWholeText(), "~!@#$%^&*(){}><asdasadsdadas")
        @Assert(textNode1.getWholeText(), "~!@#$%^&*(){}><asdasadsdadas")
    }
}
