// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

@Test
public class NodeTest {
    @TestCase
    func testNode_13_01(): Unit {
        var doc = Html4cj.parse("<p>One <em>four</em><b>two</b> three</p>")
        var str = doc.select("b").first().getOrThrow()
        let sc = str.firstChild().getOrThrow()
        @Assert("two",sc.toString())
    }

    @TestCase
    func testNode_13_02(): Unit {
        var doc = Html4cj.parse("<p>One <em>four</em><b>two</b><a>CSSW</a> three</p>")
        var str = doc.select("p").first().getOrThrow()
        let sc = str.firstChild().getOrThrow()
        @Assert("One ",sc.toString())
    }

    @TestCase
    func testNode_13_03(): Unit {
        var doc = Html4cj.parse("<em>four</em>")
        var str = doc.select("em").first().getOrThrow()
        let sc = str.firstChild().getOrThrow()
        @Assert("four",sc.toString())
    }

    @TestCase
    func testNode_13_04(): Unit {
        var tag: Tag = Tag.valueOf("cc")
        var noBase: Element = Element(tag, "")
        let sc = noBase.firstChild()
        @Assert("None",sc.toString())
    }

    @TestCase
    func testNode_13_05(): Unit {
        var doc = Html4cj.parse("<p>One <em>four</em><b>two</b><a>CSSW</a> three</p>")
        var str = doc.select("p").first().getOrThrow()
        let sc = str.lastChild().getOrThrow()
        @Assert(" three",sc.toString())
    }

    @TestCase
    func testNode_13_06(): Unit {
        var tag: Tag = Tag.valueOf("cc")
        var noBase: Element = Element(tag, "")
        let sc = noBase.lastChild()
        @Assert("None",sc.toString())
    }
}
