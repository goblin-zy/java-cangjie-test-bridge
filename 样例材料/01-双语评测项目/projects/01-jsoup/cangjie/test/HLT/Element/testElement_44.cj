// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

@Test
public class NodeTest {
    @TestCase
    func testElement_44_01(): Unit {
        let cou = "<html><span><body><div><!-- a simple comment --></div><b>two</b></body></span></html>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("html").first().getOrThrow()
        let sc = str.getElementsContainingText("two")
        @Assert(285,sc.toString().toRuneArray().size)
        @Assert(sc.toString().contains("<head></head>"),true)
    }

    @TestCase
    func testElement_44_02(): Unit {
        let cou = "<div id=1>@#</div><div>Two</div>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("div").first().getOrThrow()
        let sc = str.getElementsContainingText("@#")
        @Assert(23,sc.toString().toRuneArray().size)
        @Assert(sc.toString().contains("<div id=\"1\""),true)
    }

    @TestCase
    func testElement_44_03(): Unit {
        let cou = "<div id=1>@#</div><div>Two</div>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("div").first().getOrThrow()
        let sc = str.getElementsContainingText("")
        @Assert(23,sc.toString().toRuneArray().size)
        @Assert(sc.toString().contains("<div id=\"1\""),true)
    }

    @TestCase
    func testElement_44_04(): Unit {
        let cou = "<div id=1>你好仓颉！【】</div><div>Two</div>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("div").first().getOrThrow()
        let sc = str.getElementsContainingText("你好仓颉！【】")
        @Assert(28,sc.toString().toRuneArray().size)
        @Assert(sc.toString().contains("好仓颉！【】"),true)
    }

    @TestCase
    func testElement_44_05(): Unit {
        let cou = "<div id=1>你好仓颉！【】</div><div>Two</div>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("div").first().getOrThrow()
        let sc = str.getElementsContainingText("mvp")
        @Assert(0,sc.toString().toRuneArray().size)
    }

    @TestCase
    func testElement_44_06(): Unit {
        let cou = "<div id=1>data-se</div><div>Two</div>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("div").first().getOrThrow()
        let sc = str.getElementsContainingText("data-se")
        @Assert(28,sc.toString().toRuneArray().size)
        @Assert(sc.toString().contains("data-se"),true)
    }

    @TestCase
    func testElement_44_07(): Unit {
        let cou = "<div id=1>/tt</div><div>Two</div>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("div").first().getOrThrow()
        let sc = str.getElementsContainingText("/tt")
        @Assert(24,sc.toString().toRuneArray().size)
        @Assert(sc.toString().contains("/tt"),true)
    }
}
