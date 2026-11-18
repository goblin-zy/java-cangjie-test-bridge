// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

@Test
public class NodeTest {
    @TestCase
    func testElement_05_01(): Unit {
        let cou = "<html> <head></head><span><body><div><!-- a simple comment --><div></body></span></html>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("html").first().getOrThrow()
        let sc = str.children()
        @Assert(sc.toString().contains("<head></head>"),true)
        @Assert(104,sc.toString().toRuneArray().size)
    }

    @TestCase
    func testElement_05_02(): Unit {
        let cou = "<html> <head></head><span><body><div><!-- a simple comment --><div></body></span></html>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("body").first().getOrThrow()
        let sc = str.children()
        @Assert(sc.toString().contains("<div></div>"),true)
        @Assert(70,sc.toString().toRuneArray().size)
    }

    @TestCase
    func testElement_05_03(): Unit {
        let cou = "<html> <head></head><span><body><div><!-- a simple comment --><div></body></span></html>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("div").first().getOrThrow()
        let sc = str.children()
        @Assert(sc.toString().contains("-->"),false)
        @Assert(11,sc.toString().toRuneArray().size)
    }

    @TestCase
    func testElement_05_04(): Unit {
        let cou = "<html> <head></head><span><body><div><!-- a simple comment --><div></body></span></html>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("body").first().getOrThrow()
        let sc = str.children()
        @Assert(sc.toString().contains("</div></span>"),true)
        @Assert(70,sc.toString().toRuneArray().size)
    }
}
