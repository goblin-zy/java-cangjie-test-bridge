// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

@Test
public class TextNodeCreateFromEncodedTest {
    let strAll1: String =
        "TextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNodeTextNode"

    @TestCase
    func textNodeCreateFromEncoded01(): Unit {
        var textNode: TextNode = TextNode.createFromEncoded("")
        @Assert(textNode.getWholeText(), "")
    }

    @TestCase
    func textNodeCreateFromEncoded02(): Unit {
        var textNode: TextNode = TextNode.createFromEncoded(" ")
        @Assert(textNode.getWholeText(), " ")
    }

    @TestCase
    func textNodeCreateFromEncoded03(): Unit {
        var textNode: TextNode = TextNode.createFromEncoded(strAll1)
        @Assert(textNode.getWholeText(), strAll1)
    }

    @TestCase
    func textNodeCreateFromEncoded04(): Unit {
        var textNode: TextNode = TextNode.createFromEncoded("~!@#$%^&*(){}><asdasadsdadas")
        @Assert(textNode.getWholeText(), "~!@#$%^&*(){}><asdasadsdadas")
    }
}
