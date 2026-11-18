// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

@Test
public class NodeTest {
    @TestCase
    func testElement_29_01(): Unit {
        let cou = "<html><span><body><div><!-- a simple comment --></div><b>two</b></body></span></html>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("html").first().getOrThrow()
        var returntag = -1
        try {
            str.getElementsByTag("")
        } catch (e: ValidationException) {
            @Assert(e.toString().contains("String must not be empty"), true)
            returntag = 1
        }
        @Assert(1,returntag)
    }

    @TestCase
    func testElement_29_02(): Unit {
        let cou = "<html><span><body><div><!-- a simple comment --></div><b>two</b></body></span></html>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("html").first().getOrThrow()
        let sc = str.getElementsByTag("span")
        @Assert(sc.toString().contains("</div><b>two</b></span>"),true)
        @Assert(66,sc.toString().toRuneArray().size)
    }

    @TestCase
    func testElement_29_03(): Unit {
        let cou = "<html><span><body><中国><!-- a simple comment --></中国><b>two</b></body></span></html>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("html").first().getOrThrow()
        let sc = str.getElementsByTag("中国")
        @Assert(0,sc.toString().toRuneArray().size)
    }

    @TestCase
    func testElement_29_04(): Unit {
        let cou = "<html><span><body><￥%><!-- a simple comment --></￥%><b>two</b></body></span></html>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("html").first().getOrThrow()
        let sc = str.getElementsByTag("￥%")
        @Assert(0,sc.toString().toRuneArray().size)
    }

    @TestCase
    func testElement_29_05(): Unit {
        let cou = "<html><span><body><￥%><!-- a simple comment --></￥%><b>two</b></body></span></html>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("body").first().getOrThrow()
        let sc = str.getElementsByTag("￥%")
        @Assert(0,sc.toString().toRuneArray().size)
    }

    @TestCase
    func testElement_29_06(): Unit {
        let cou = "<html><span><body><中国><!-- a simple comment --></中国><b>two</b></body></span></html>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("body").first().getOrThrow()
        let sc = str.getElementsByTag("中国")
        @Assert(0,sc.toString().size)
        let sc1 = str.getElementsByTag("see")
        @Assert(sc.toString(),"")
        @Assert(0,sc1.toString().toRuneArray().size)
    }
}
