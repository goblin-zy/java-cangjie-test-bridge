// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

@Test
public class TextNodeIsBlankTest {
    let strAll1: String =
        "TextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNode"

    @TestCase
    func textNodeIsBlank01(): Unit {
        var textNode: TextNode = TextNode("")
        @Assert(textNode.isBlank(), true)
    }

    @TestCase
    func textNodeIsBlank02(): Unit {
        var textNode: TextNode = TextNode(" ")
        @Assert(textNode.isBlank(), true)
    }

    @TestCase
    func textNodeIsBlank03(): Unit {
        var textNode: TextNode = TextNode(strAll1)
        @Assert(textNode.isBlank(), false)
    }

    @TestCase
    func textNodeIsBlank04(): Unit {
        var textNode: TextNode = TextNode("~!@#$%^&*(){}><asdasadsdadas")
        @Assert(textNode.isBlank(), false)
    }

    @TestCase
    func textNodeIsBlank05(): Unit {
        var textNode: TextNode = TextNode("\n")
        @Assert(textNode.isBlank(), true)
    }
}
