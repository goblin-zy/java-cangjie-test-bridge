// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

@Test
public class NodeTest {
    @TestCase
    func testElement_17_01(): Unit {
        let cou = "<div><!-- a simple comment -->"
        var doc = Html4cj.parse(cou)
        var str = doc.select("div").first().getOrThrow()
        let sc = str.append(" there & now >")
        @Assert(60,sc.toString().toRuneArray().size)
        @Assert(2,sc.childNodeSize())
    }

    @TestCase
    func testElement_17_02(): Unit {
        let cou = "<div><!-- a simple comment -->"
        var doc = Html4cj.parse(cou)
        var str = doc.select("div").first().getOrThrow()
        let sc = str.append("你好仓颉！【】")
        @Assert(sc.toString().contains("-->你好仓颉！【】"),true)
        @Assert(46,sc.toString().toRuneArray().size)
    }

    @TestCase
    func testElement_17_03(): Unit {
        let cou = "<div><!-- a simple comment -->"
        var doc = Html4cj.parse(cou)
        var str = doc.select("div").first().getOrThrow()
        let sc = str.append("")
        @Assert(sc.toString().contains("<!--"),true)
        @Assert(39,sc.toString().toRuneArray().size)
    }

    @TestCase
    func testElement_17_04(): Unit {
        let cou = "<div><!-- a simple comment -->"
        var doc = Html4cj.parse(cou)
        var str = doc.select("div").first().getOrThrow()
        let sc = str.append("Hello Cang!@#$%^&*()_+:<>?|jie Lang")
        @Assert(sc.toString().contains("_+:&lt;&gt;?|jie"),true)
        @Assert(84,sc.toString().toRuneArray().size)
    }

    @TestCase
    func testElement_17_05(): Unit {
        let cou = "<div><!-- a simple comment -->"
        var doc = Html4cj.parse(cou)
        var str = doc.select("div").first().getOrThrow()
        let sc = str.append("<div id=\"id1\">A</div><div>B</div><div class=\"c1 c2\">C</div>")
        @Assert(sc.toString().contains("<div class=\"c1 c2\">"),true)
        @Assert(119,sc.toString().toRuneArray().size)
    }
}
