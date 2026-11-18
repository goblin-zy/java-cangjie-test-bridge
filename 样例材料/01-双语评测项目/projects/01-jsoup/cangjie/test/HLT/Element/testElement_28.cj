// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

@Test
public class NodeTest {
    @TestCase
    func testElement_28_01(): Unit {
        let cou = "<html><span><body><div><!-- a simple comment --></div><b>two</b></body></span></html>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("html").first().getOrThrow()
        let sc = str.firstElementChild().getOrThrow()
        @Assert("<head></head>",sc.toString())
    }

    @TestCase
    func testElement_28_02(): Unit {
        let cou = "<html><span><body><div><!-- a simple comment --></div><b>two</b></body></span></html>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("body").first().getOrThrow()
        let sc = str.firstElementChild().getOrThrow()
        @Assert(sc.toString().contains("</div><b>two</b></span>"),true)
        @Assert(66,sc.toString().toRuneArray().size)
    }

    @TestCase
    func testElement_28_03(): Unit {
        let cou = "<html><span><body><div><!-- a simple comment --></div><b>two</b></body></span></html>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("div").first().getOrThrow()
        let sc = str.firstElementChild()
        @Assert("None",sc.toString())
    }

    @TestCase
    func testElement_28_04(): Unit {
        let cou = "<html><span><body><div><!-- a simple comment --></div><b>two</b></body></span></html>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("div").first().getOrThrow()
        let sc = str.lastElementChild()
        @Assert("None",sc.toString())
    }

    @TestCase
    func testElement_28_05(): Unit {
        let cou = "<html><span><body><div><!-- a simple comment --></div><b>two</b></body></span></html>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("body").first().getOrThrow()
        let sc = str.lastElementChild().getOrThrow()
        @Assert(sc.toString().contains("</div><b>two<"),true)
        @Assert(66,sc.toString().toRuneArray().size)
    }

    @TestCase
    func testElement_28_06(): Unit {
        let cou = "<html><span><body><div><!-- a simple comment --></div><b>two</b></body></span></html>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("html").first().getOrThrow()
        let sc = str.lastElementChild().getOrThrow()
        @Assert(sc.toString().contains("</div><b>two</b></span>"),true)
        @Assert(85,sc.toString().toRuneArray().size)
    }
}
