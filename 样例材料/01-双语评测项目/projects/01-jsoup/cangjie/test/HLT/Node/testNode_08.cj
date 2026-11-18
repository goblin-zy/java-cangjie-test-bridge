// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

@Test
public class NodeTest {
    @TestCase
    func testNode_08_01(): Unit {
        var returntag = -1
        var doc = Element(Tag.valueOf("p"), "")
        let sc = doc.ownerDocument()
        match (sc) {
            case Some(v) =>
                v.toString()
                returntag = 0
            case None => returntag = 1
        }
        @Assert(1,returntag)

        var doc1 = Html4cj.parse("<div><p>Hello")
        let str = doc1.ownerDocument()
        match (str) {
            case Some(v) =>
                v.toString()
                returntag = 2
            case None => returntag = -1
        }
        @Assert(2,returntag)
    }

    @TestCase
    func testNode_08_02(): Unit {
        var doc = Html4cj.parse("<a id=1 href='/foo'>One</a> <a id=2 href='https://jsoup.org/'>Two</a>")
        var str = doc.select("#2").first().getOrThrow()
        @Assert(1,str.childNodeSize())
        str.childNode(0).remove()
        @Assert(0,str.childNodeSize())
    }

    @TestCase
    func testNode_08_03(): Unit {
        var doc = Html4cj.parse("<p>One <b>two</b> three</p>")
        var str = doc.select("b").first().getOrThrow()
        @Assert(1,str.childNodeSize())
        let sc = str.before("<span>foo</span>")
        @Assert(1,sc.childNodeSize())
        @Assert("<p>One <span>foo</span><b>two</b> three</p>",doc.body().html())
        str.before("FIVE")
        @Assert("<p>One <span>foo</span>FIVE<b>two</b> three</p>",doc.body().html())
        str.before("你好仓颉！【】")
        @Assert("<p>One <span>foo</span>FIVE你好仓颉！【】<b>two</b> three</p>",doc.body().html())
        let s9 = ##"你好\n"##
        str.before(s9)
        @Assert("<p>One <span>foo</span>FIVE你好仓颉！【】你好\\n<b>two</b> three</p>",doc.body().html())
        str.before("")
        @Assert("<p>One <span>foo</span>FIVE你好仓颉！【】你好\\n<b>two</b> three</p>",doc.body().html())
    }

    @TestCase
    func testNode_08_04(): Unit {
        var doc = Html4cj.parse("<p>One <b>two</b> three</p>")
        var str = doc.select("b").first().getOrThrow()

        str.before("<input value='one' /><textarea>two</textarea>")
        @Assert("<p>One <input value=\"one\"><textarea>two</textarea><b>two</b> three</p>",doc.body().html())
        @Assert(1,str.childNodeSize())
    }
}
