// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

@Test
public class NodeTest {
    @TestCase
    func testElement_41_01(): Unit {
        let cou = "<html><span><body><div><!-- a simple comment --></div><b>two</b></body></span></html>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("html").first().getOrThrow()
        let sc = str.getElementsByIndexLessThan(-6)
        @Assert(0,sc.toString().toRuneArray().size)
    }

    @TestCase
    func testElement_41_02(): Unit {
        let cou = "<html><span><body><div><!-- a simple comment --></div><b>two</b></body></span></html>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("html").first().getOrThrow()
        let sc = str.getElementsByIndexLessThan(-1)
        @Assert(0,sc.toString().toRuneArray().size)
    }

    @TestCase
    func testElement_41_03(): Unit {
        let cou = "<html><span><body><div><!-- a simple comment --></div><b>two</b></body></span></html>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("html").first().getOrThrow()
        let sc = str.getElementsByIndexLessThan(0)
        @Assert(0,sc.toString().toRuneArray().size)
    }

    @TestCase
    func testElement_41_04(): Unit {
        let cou = "<html><span><body><div><!-- a simple comment --></div><b>two</b></body></span></html>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("html").first().getOrThrow()
        let sc = str.getElementsByIndexLessThan(1)
        @Assert(sc.toString().contains("</div><b>two</b></span>"),true)
        @Assert(120,sc.toString().toRuneArray().size)
    }

    @TestCase
    func testElement_41_05(): Unit {
        let cou = "<html><span><body><div><!-- a simple comment --></div><b>two</b></body></span></html>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("html").first().getOrThrow()
        let sc = str.getElementsByIndexLessThan(1000)
        @Assert(sc.toString().contains("<b>two</b>"),true)
        @Assert(217,sc.toString().toRuneArray().size)
    }
}
