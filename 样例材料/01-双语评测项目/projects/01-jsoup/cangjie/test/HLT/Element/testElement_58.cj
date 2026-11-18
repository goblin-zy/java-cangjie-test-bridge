// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*
import std.regex.*

@Test
public class NodeTest {
    @TestCase
    func testElement_58_01(): Unit {
        let cou = "<html><span><body><div><!-- a simple comment -->One</div><b> two </b></body></span></html>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("html").first().getOrThrow()
        let sc = str.endSourceRange()
        @Assert(17,sc.toString().toRuneArray().size)
        @Assert(sc.toString().contains("-1,-1:-1--1,-1:-1"),true)
    }

    @TestCase
    func testElement_58_02(): Unit {
        let cou = "<html><span><body><div><!-- a simple comment -->One</div><b> two </b></body></span></html>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("div").first().getOrThrow()
        let sc = str.endSourceRange()
        @Assert(17,sc.toString().toRuneArray().size)
        @Assert(sc.toString().contains("-1,-1:-1--1,-1:-1"),true)
    }

    @TestCase
    func testElement_58_03(): Unit {
        let cou = "<html><span><body><div><!-- a simple comment -->One</div><b> two </b></body></span></html>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("b").first().getOrThrow()
        let sc = str.endSourceRange()
        @Assert(17,sc.toString().toRuneArray().size)
        @Assert(sc.toString().contains("-1,-1:-1--1,-1:-1"),true)
    }

    @TestCase
    func testElement_58_04(): Unit {
        let cou = "<html><span><body><div><!-- a simple comment -->One</div><b> two </b></body></span></html>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("b").first().getOrThrow()
        let sc = str.html()
        @Assert(3,sc.size)
        @Assert(sc.toString().contains("two"),true)
    }

    @TestCase
    func testElement_58_05(): Unit {
        let cou = "<html><span><body><div><!-- a simple comment -->One</div><b> two </b></body></span></html>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("body").first().getOrThrow()
        let sc = str.html()
        @Assert(71,sc.size)
        @Assert(sc.toString().contains("</div><b> two </b></span>"),true)
    }

    @TestCase
    func testElement_58_06(): Unit {
        let cou = "<html><span><body><div><!-- a simple comment -->One</div><b> two </b></body></span></html>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("body").first().getOrThrow()
        var builder: StringBuilder = StringBuilder()
        let sc = str.html(builder)
        @Assert(71,sc.size)
        @Assert(sc.toString().contains("</div><b> two </b></span>"),true)
    }

    @TestCase
    func testElement_58_07(): Unit {
        let cou = "<html><span><body><div><!-- a simple comment -->One</div><b> two </b></body></span></html>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("b").first().getOrThrow()
        var builder: StringBuilder = StringBuilder()
        let sc = str.html(builder)
        @Assert(5,sc.size)
        @Assert(sc.toString().contains("two"),true)
    }
}
