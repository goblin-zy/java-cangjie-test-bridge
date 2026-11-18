// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

@Test
public class NodeTest {
    @TestCase
    func testNode_09_01(): Unit {
        var doc = Html4cj.parse("<p>One <b>two</b> three</p>")
        var newNode = Element(Tag.valueOf("em"), "")
        newNode.appendText("four")
        var str = doc.select("b").first().getOrThrow()
        str.before(newNode)
        @Assert("<p>One <em>four</em><b>two</b> three</p>",doc.body().html())
        let sc1 = doc.childNodeSize()
        @Assert(1,sc1)
    }

    @TestCase
    func testNode_09_02(): Unit {
        var doc = Html4cj.parse("<p>One <b>two</b> three</p>")
        var str = doc.select("b").first().getOrThrow()
        str.after("newNode")
        @Assert("<p>One <b>two</b>newNode three</p>",doc.body().html())
        str.after("CSS")
        @Assert("<p>One <b>two</b>CSSnewNode three</p>",doc.body().html())
        str.after("")
        @Assert("<p>One <b>two</b>CSSnewNode three</p>",doc.body().html())
        str.after("你好仓颉！【】")
        @Assert("<p>One <b>two</b>你好仓颉！【】CSSnewNode three</p>",doc.body().html())
    }

    @TestCase
    func testNode_09_03(): Unit {
        var doc = Html4cj.parse("<BODY> <p ID=\"id_p\"> <SPAN CLASS=\"cla_1\"> hello </SPAN> </p> </body>")
        var newNode = Element(Tag.valueOf("em"), "")
        newNode.appendText("four")
        var str = doc.select("p").first().getOrThrow()
        str.after(newNode)
        @Assert("<p id=\"id_p\"><span class=\"cla_1\"> hello </span></p><em>four</em>",doc.body().html())
        let sc1 = doc.childNodeSize()
        @Assert(1,sc1)
    }
}
