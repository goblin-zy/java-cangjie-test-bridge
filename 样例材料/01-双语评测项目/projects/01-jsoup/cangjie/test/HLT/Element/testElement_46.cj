// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*
import std.regex.*

@Test
public class NodeTest {
    @TestCase
    func testElement_46_01(): Unit {
        let cou = "<html><span><body><div><!-- a simple comment -->One</div><b>two</b></body></span></html>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("html").first().getOrThrow()
        let sc = str.getElementsMatchingText("O\\w+")
        @Assert(326,sc.toString().toRuneArray().size)
        @Assert(sc.toString().contains("</div><b>two</b></span>"),true)
    }

    @TestCase
    func testElement_46_02(): Unit {
        let cou = "<html><span><body><div><!-- a simple comment -->One</div><b>two</b></body></span></html>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("body").first().getOrThrow()
        let sc = str.getElementsMatchingText("O\\w+")
        @Assert(201,sc.toString().toRuneArray().size)
        @Assert(sc.toString().contains("</div><b>two</b></span>"),true)
    }

    @TestCase
    func testElement_46_03(): Unit {
        let cou = "<html><span><body><div><!-- a simple comment -->One</div><b>two</b></body></span></html>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("html").first().getOrThrow()
        let sc = str.getElementsMatchingText(Regex("^\\d\\w+"))
        @Assert(0,sc.toString().toRuneArray().size)
    }

    @TestCase
    func testElement_46_04(): Unit {
        let cou = "<html><span><body><div><!-- a simple comment -->One</div><b>two</b></body></span></html>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("body").first().getOrThrow()
        let sc = str.getElementsMatchingText(Regex("^\\d\\w+"))
        @Assert(0,sc.toString().toRuneArray().size)
    }

    @TestCase
    func testElement_46_05(): Unit {
        let cou = "<html><span><body><div><!-- a simple comment -->One</div><b>two</b></body></span></html>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("html").first().getOrThrow()
        let sc = str.getElementsMatchingOwnText(Regex("^\\d\\w+"))
        @Assert(0,sc.toString().toRuneArray().size)
    }

    @TestCase
    func testElement_46_06(): Unit {
        let cou = "<html><span><body><div><!-- a simple comment -->One</div><b>two</b></body></span></html>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("div").first().getOrThrow()
        let sc = str.getElementsMatchingOwnText(Regex("^\\d\\w+"))
        @Assert(0,sc.toString().toRuneArray().size)
    }

    @TestCase
    func testElement_46_07(): Unit {
        let cou = "<html><span><body><div><!-- a simple comment -->One</div><b>two</b></body></span></html>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("html").first().getOrThrow()
        let sc = str.getElementsMatchingOwnText("O\\w+")
        @Assert(42,sc.toString().toRuneArray().size)
        @Assert(sc.toString().contains("<!-- a simple comment -->One"),true)
    }

    @TestCase
    func testElement_46_08(): Unit {
        let cou = "<html><span><body><div><!-- a simple comment -->One</div><b>two</b></body></span></html>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("div").first().getOrThrow()
        let sc = str.getElementsMatchingOwnText("O\\w+")
        @Assert(42,sc.toString().toRuneArray().size)
        @Assert(sc.toString().contains("<!-- a simple comment -->One"),true)
    }
}
