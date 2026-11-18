// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

@Test
public class NodeTest {
    @TestCase
    func testNode_11_01(): Unit {
        var doc = Html4cj.parse("<p>One <em>four</em><b>two</b> three</p>")
        var str = doc.select("b").first().getOrThrow()
        var str1 = doc.select("em").first().getOrThrow()
        str.replaceWith(str1)
        @Assert("<p>One <em>four</em> three</p>",doc.body().html())
    }

    @TestCase
    func testNode_11_02(): Unit {
        var doc = Html4cj.parse("<p>One <em>four</em><b>two</b> three</p>")
        var doc1 = Html4cj.parse("<div><p>Hello</p></div><div>There Now<p>Another</p></div>")
        var str = doc.select("b").first().getOrThrow()
        var str1 = doc1.select("p").first().getOrThrow()
        str.replaceWith(str1)
        @Assert("<p>One <em>four</em><p>Hello</p> three</p>",doc.body().html())
    }

    @TestCase
    func testNode_11_03(): Unit {
        var doc = Html4cj.parse("<div><p>Hello</p></div><div>There Now<p>Another</p></div>")
        var str = doc.select("p").first().getOrThrow()
        let sc = str.siblingNodes()
        @Assert(0,sc.size)
    }

    @TestCase
    func testNode_11_04(): Unit {
        var doc = Html4cj.parse("<div><p>Hello</p></div><div>There Now<p>Another</p></div>")
        var str = doc.select("div").first().getOrThrow()
        let sc = str.siblingNodes()
        @Assert(1,sc.size)
    }

    @TestCase
    func testNode_11_05(): Unit {
        var doc = Html4cj.parse("<div><p>Hello</p></div><div>There Now<p>Another</p></div>")
        var str = doc.select("div").first().getOrThrow()
        let sc = str.nextSibling().getOrThrow()
        @Assert("<div>\n There Now\n <p>Another</p>\n</div>",sc.toString())
    }

    @TestCase
    func testNode_11_06(): Unit {
        var doc = Html4cj.parse("<div><p>Hello</p></div><div>There Now<p>Another</p></div>")
        var str = doc.select("p").first().getOrThrow()
        var returntag = -1
        try {
            str.nextSibling().getOrThrow()
        } catch (e: NoneValueException) {
            @Assert(e.toString().contains("NoneValueException"), true)
            returntag = 1
        }
        @Assert(1,returntag)
    }
}
