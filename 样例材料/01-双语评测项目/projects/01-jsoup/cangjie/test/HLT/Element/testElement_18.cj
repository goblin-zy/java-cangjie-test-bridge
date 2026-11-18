// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

@Test
public class NodeTest {
    @TestCase
    func testElement_18_01(): Unit {
        let cou = "<div><!-- a simple comment -->"
        var doc = Html4cj.parse(cou)
        var str = doc.select("div").first().getOrThrow()
        let sc = str.prepend(" there & now >")
        @Assert(59,sc.toString().toRuneArray().size)
        @Assert(2,sc.childNodeSize())
    }

    @TestCase
    func testElement_18_02(): Unit {
        let cou = "<div><!-- a simple comment -->"
        var doc = Html4cj.parse(cou)
        var str = doc.select("div").first().getOrThrow()
        let sc = str.prepend("你好仓颉！【】")
        @Assert(sc.toString().contains("好仓颉！【】<!--"),true)
        @Assert(46,sc.toString().toRuneArray().size)
    }

    @TestCase
    func testElement_18_03(): Unit {
        let cou = "<div><!-- a simple comment -->"
        var doc = Html4cj.parse(cou)
        var str = doc.select("div").first().getOrThrow()
        let sc = str.prepend("")
        @Assert(sc.toString().contains("<!-- a simple"),true)
        @Assert(39,sc.toString().toRuneArray().size)
    }

    @TestCase
    func testElement_18_04(): Unit {
        let cou = "<div><!-- a simple comment -->"
        var doc = Html4cj.parse(cou)
        var str = doc.select("div").first().getOrThrow()
        let sc = str.prepend("Hello Cang!@#$%^&*()_+:<>?|jie Lang")
        @Assert(sc.toString().contains("()_+:&lt;&gt;?|jie Lang<!-- a "),true)
        @Assert(84,sc.toString().toRuneArray().size)
    }

    @TestCase
    func testElement_18_05(): Unit {
        let cou = "<div><!-- a simple comment -->"
        var doc = Html4cj.parse(cou)
        var str = doc.select("div").first().getOrThrow()
        let sc = str.prepend("<div id=\"id1\">A</div><div>B</div><div class=\"c1 c2\">C</div>")
        @Assert(sc.toString().contains("A"),true)
        @Assert(117,sc.toString().toRuneArray().size)
    }
}
