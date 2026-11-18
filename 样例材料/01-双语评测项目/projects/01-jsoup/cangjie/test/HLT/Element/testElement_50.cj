// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*
import std.regex.*

@Test
public class NodeTest {
    @TestCase
    func testElement_50_01(): Unit {
        let cou = "<html><span><body><div><!-- a simple comment -->One</div><b> two </b></body></span></html>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("html").first().getOrThrow()
        let sc = str.hasText()
        @Assert(true,sc)
    }

    @TestCase
    func testElement_50_02(): Unit {
        let cou = "<html><span><body><div><!-- a simple comment -->One</div><b>two</b></body></span></html>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("span").first().getOrThrow()
        let sc = str.hasText()
        @Assert(true,sc)
    }

    @TestCase
    func testElement_50_03(): Unit {
        let cou = "<html><span><body><div><!-- a simple comment -->One</div><b>two</b></body></span></html>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("b").first().getOrThrow()
        let sc = str.hasText()
        @Assert(true,sc)
    }

    @TestCase
    func testElement_50_04(): Unit {
        let cou = "<html><span><body><div><!-- a simple comment -->One</div><b>two</b></body></span></html>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("html").first().getOrThrow()
        let sc = str.data()
        @Assert(18,sc.size)
        @Assert(sc.toString().contains("a simple comment"),true)
    }

    @TestCase
    func testElement_50_05(): Unit {
        let cou = "<html><span><body><div><!-- a simple comment -->One</div><b>two</b></body></span></html>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("div").first().getOrThrow()
        let sc = str.data()
        @Assert(18,sc.size)
        @Assert(sc.toString().contains("a simple comment"),true)
    }

    @TestCase
    func testElement_50_06(): Unit {
        let cou = "<html><span><body><div><!-- a simple comment -->One</div><b>two</b></body></span></html>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("b").first().getOrThrow()
        let sc = str.data()
        @Assert(0,sc.size)
    }
}
