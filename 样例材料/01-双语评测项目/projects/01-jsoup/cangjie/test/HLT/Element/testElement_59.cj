// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*
import std.regex.*

@Test
public class NodeTest {
    @TestCase
    func testElement_59_01(): Unit {
        let cou = "<html><span><body><div><!-- a simple comment -->One</div><b> two </b></body></span></html>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("html").first().getOrThrow()
        let sc = str.html("")
        @Assert(44,sc.toString().toRuneArray().size)
        @Assert(sc.toString().contains("<body></body>"),true)
    }

    @TestCase
    func testElement_59_02(): Unit {
        let cou = "<html><span><body><div><!-- a simple comment -->One</div><b> two </b></body></span></html>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("html").first().getOrThrow()
        let sc = str.html("你好仓颉！【】")
        @Assert(56,sc.toString().toRuneArray().size)
        @Assert(sc.toString().contains("好仓颉！【】"),true)
    }

    @TestCase
    func testElement_59_03(): Unit {
        let cou = "<html><span><body><div><!-- a simple comment -->One</div><b> two </b></body></span></html>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("html").first().getOrThrow()
        let sc = str.html("Hello Cang!@#$%^&*()_+:<>?|jie Lang")
        @Assert(94,sc.toString().toRuneArray().size)
        @Assert(sc.toString().contains("Hello Cang!@#$%^&amp;*()_+:&lt;&gt;?|jie Lang"),true)
    }

    @TestCase
    func testElement_59_04(): Unit {
        let cou = "<html><span><body><div><!-- a simple comment -->One</div><b> two </b></body></span></html>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("html").first().getOrThrow()
        let sc = str.html("<div id=\"id1\">A</div><div>B</div><div class=\"c1 c2\">C</div>")
        @Assert(135,sc.toString().toRuneArray().size)
        @Assert(sc.toString().contains("<div id=\"id1\">"),true)
    }

    @TestCase
    func testElement_59_05(): Unit {
        let cou = "<html><span><body><div><!-- a simple comment -->One</div><b> two </b></body></span></html>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("html").first().getOrThrow()
        let sc = str.clone()
        @Assert(126,sc.toString().toRuneArray().size)
        @Assert(sc.toString().contains("</div><b> two </b></span>"),true)
    }

    @TestCase
    func testElement_59_06(): Unit {
        let cou = "<html><span><body><div><!-- a simple comment -->One</div><b> two </b></body></span></html>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("b").first().getOrThrow()
        let sc = str.clone()
        @Assert(12,sc.toString().toRuneArray().size)
        @Assert(sc.toString().contains("<b> two </b>"),true)
    }
}
