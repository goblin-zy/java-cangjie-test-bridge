// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

@Test
public class NodeTest {
    @TestCase
    func testElement_22_01(): Unit {
        let cou = "<div><!-- a simple comment -->"
        var doc = Html4cj.parse(cou)
        var str = doc.select("div").first().getOrThrow()
        var tag: Tag = Tag.valueOf("div")
        var noBase: Element = Element(tag, "")
        let sc = str.after(noBase)
        @Assert(sc.toString().contains("<!-- a simple comment -->"),true)
        @Assert(39,sc.toString().toRuneArray().size)
    }

    @TestCase
    func testElement_22_02(): Unit {
        let cou = "<div><!-- a simple comment -->"
        var doc = Html4cj.parse(cou)
        var str = doc.select("div").first().getOrThrow()
        let four: TextNode = TextNode("Hello")
        let sc = str.after(four)
        @Assert(sc.toString().contains("<!-- a simple comment -->"),true)
        @Assert(39,sc.toString().toRuneArray().size)
    }

    @TestCase
    func testElement_22_03(): Unit {
        let cou = "<div><!-- a simple comment -->"
        var doc = Html4cj.parse(cou)
        var str = doc.select("div").first().getOrThrow()
        var dataNode1: DataNode = DataNode("DataNode")
        let sc = str.after(dataNode1)
        @Assert(sc.toString().contains("<!-- a simple comment -->"),true)
        @Assert(39,sc.toString().toRuneArray().size)
    }

    @TestCase
    func testElement_22_04(): Unit {
        let cou = "<div><!-- a simple comment -->"
        var doc = Html4cj.parse(cou)
        var str = doc.select("div").first().getOrThrow()
        var dataNode1: TextNode = TextNode("Hello///")
        let sc1 = str.after(dataNode1)
        var dataNode2: DataNode = DataNode("<head> <meta charset=\"utf-16\"> <title>SoupTest</title> </head> </html>")
        let sc = sc1.after(dataNode2)
        @Assert(sc.toString().contains("<!-- a simple comment -->"),true)
        @Assert(39,sc.toString().toRuneArray().size)
    }
}
