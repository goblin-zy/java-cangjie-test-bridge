// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

@Test
public class TextNodeSplitTextTest {
    @TestCase
    func textNodeSplitText06(): Unit {
        var textNode: TextNode = TextNode(" ")
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
    func textNodeSplitText07(): Unit {
        var textNode: TextNode = TextNode(" ")
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
    func textNodeSplitText08(): Unit {
        var textNode: TextNode = TextNode(" ")
        var textNode1: TextNode = textNode.splitText(0)
        @Assert(textNode.nodeName(), "#text")
        @Assert(textNode.isBlank(), true)
        @Assert(textNode1.nodeName(), "#text")
        @Assert(textNode1.isBlank(), true)
    }

    @TestCase
    func textNodeSplitText09(): Unit {
        var textNode: TextNode = TextNode(" ")
        var isBool: Bool = false
        try {
            textNode.splitText(2)
        } catch (e: ValidationException) {
            isBool = true
            @Assert(e.message, "Split offset must not be greater than current text length")
        }
        @Assert(isBool, true)
    }

    @TestCase
    func textNodeSplitText10(): Unit {
        var textNode: TextNode = TextNode(" ")
        var isBool: Bool = false
        try {
            textNode.splitText(10)
        } catch (e: ValidationException) {
            isBool = true
            @Assert(e.message, "Split offset must not be greater than current text length")
        }
        @Assert(isBool, true)
    }
}
