// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

@Test
public class NodeTest {
    @TestCase
    func testElement_26_01(): Unit {
        let cou = "<html><span><body><div><!-- a simple comment --></div><b>two</b></body></span></html>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("html").first().getOrThrow()
        let sc = str.previousElementSiblings()
        @Assert("",sc.toString())
    }

    @TestCase
    func testElement_26_02(): Unit {
        let cou = "<html><span><body><div><!-- a simple comment --></div><b>two</b></body></span></html>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("body").first().getOrThrow()
        let sc = str.previousElementSiblings()
        @Assert("<head></head>",sc.toString())
    }

    @TestCase
    func testElement_26_03(): Unit {
        let cou = "<html><span><body><div><!-- a simple comment --></div><b>two</b></body></span></html>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("div").first().getOrThrow()
        let sc = str.previousElementSiblings()
        @Assert("",sc.toString())
    }

    @TestCase
    func testElement_26_04(): Unit {
        let cou = "<html><span><body><div><!-- a simple comment --></div><b>two</b></body></span></html>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("div").first().getOrThrow()
        let sc = str.firstElementSibling()
        @Assert(39,sc.toString().toRuneArray().size)
    }

    @TestCase
    func testElement_26_05(): Unit {
        let cou = "<html><span><body><div><!-- a simple comment --></div><b>two</b></body></span></html>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("body").first().getOrThrow()
        let sc = str.firstElementSibling()
        @Assert("<head></head>",sc.toString())
    }

    @TestCase
    func testElement_26_06(): Unit {
        let cou = "<html><span><body><div><!-- a simple comment --></div><b>two</b></body></span></html>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("html").first().getOrThrow()
        let sc = str.firstElementSibling()
        @Assert(sc.toString().contains("</div><b>two</b></span>"),true)
        @Assert(121,sc.toString().toRuneArray().size)
    }
}
