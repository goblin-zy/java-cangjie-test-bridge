// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

@Test
public class NodeTest {
    @TestCase
    func testNode_10_01(): Unit {
        var doc = Html4cj.parse("<p>One <b>two</b> three</p>")
        var str = doc.select("b").first().getOrThrow()
        str.wrap("CSEEE")
        @Assert("<b>two</b>",str.toString())
    }

    @TestCase
    func testNode_10_02(): Unit {
        var returntag = -1
        var doc = Html4cj.parse("<p>One <b>two</b> three</p>")
        var str = doc.select("b").first().getOrThrow()
        str.wrap("你好仓颉！【】")
        @Assert("<b>two</b>",str.toString())
        str.wrap("$%#")
        @Assert("<b>two</b>",str.toString())
        str.wrap("<input value='one' /><textarea>two</textarea>")
        @Assert("<b>two</b>",str.toString())
        try {
            str.wrap("")
        } catch (e: ValidationException) {
            @Assert(e.toString().contains("String must not be empty"), true)
            returntag = 1
        }
        @Assert(1,returntag)
    }

    @TestCase
    func testNode_10_03(): Unit {
        var doc = Html4cj.parse("<p>One <em>four</em><b>two</b> three</p>")
        var str = doc.select("b").first().getOrThrow()
        str.unwrap().getOrThrow()
        @Assert("<b></b>",str.toString())
    }

    @TestCase
    func testNode_10_04(): Unit {
        var returntag = -1
        var tag: Tag = Tag.valueOf("div")
        var noBase: Element = Element(tag, "")
        noBase.attr("FOO", "DE")
        try {
            noBase.unwrap()
        } catch (e: ValidationException) {
            @Assert(e.toString().contains("Object must not be null"), true)
            returntag = 1
        }
        @Assert(1,returntag)
    }
}
