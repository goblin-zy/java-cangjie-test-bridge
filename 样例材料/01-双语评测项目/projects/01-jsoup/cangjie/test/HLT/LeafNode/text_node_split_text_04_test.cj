// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

@Test
public class TextNodeSplitTextTest {
    @TestCase
    func textNodeSplitText16(): Unit {
        var textNode: TextNode = TextNode("~!@#$%^&*(){}><asdasadsdadas")
        var isBool: Bool = false
        try {
            textNode.splitText(-3)
        } catch (e: ValidationException) {
            isBool = true
            @Assert(e.message, "Split offset must be not be negative")
        }
        @Assert(isBool, true)
    }

    @TestCase
    func textNodeSplitText17(): Unit {
        var textNode: TextNode = TextNode("~!@#$%^&*(){}><asdasadsdadas")
        var isBool: Bool = false
        try {
            textNode.splitText(-1)
        } catch (e: ValidationException) {
            isBool = true
            @Assert(e.message, "Split offset must be not be negative")
        }
        @Assert(isBool, true)
    }

    @TestCase
    func textNodeSplitText18(): Unit {
        var textNode: TextNode = TextNode("~!@#$%^&*(){}><asdasadsdadas")
        var textNode1: TextNode = textNode.splitText(0)
        @Assert(textNode.nodeName(), "#text")
        @Assert(textNode.isBlank(), true)
        @Assert(textNode1.nodeName(), "#text")
        @Assert(textNode1.isBlank(), false)
        @Assert(textNode1.getWholeText(), "~!@#$%^&*(){}><asdasadsdadas")
    }

    @TestCase
    func textNodeSplitText19(): Unit {
        var textNode: TextNode = TextNode("~!@#$%^&*(){}><asdasadsdadas")
        var textNode1: TextNode = textNode.splitText(2)
        @Assert(textNode.nodeName(), "#text")
        @Assert(textNode.isBlank(), false)
        @Assert(textNode.getWholeText(), "~!")
        @Assert(textNode1.nodeName(), "#text")
        @Assert(textNode1.isBlank(), false)
        @Assert(textNode1.getWholeText(), "@#$%^&*(){}><asdasadsdadas")
    }

    @TestCase
    func textNodeSplitText20(): Unit {
        var textNode: TextNode = TextNode("~!@#$%^&*(){}><asdasadsdadas")
        var isBool: Bool = false
        try {
            textNode.splitText(100)
        } catch (e: ValidationException) {
            isBool = true
            @Assert(e.message, "Split offset must not be greater than current text length")
        }
        @Assert(isBool, true)
    }
}
