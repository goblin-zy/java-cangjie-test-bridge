// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

@Test
public class NodeTest {
    @TestCase
    func testElement_09_01(): Unit {
        let cou = "<html><span><body><￥%><!-- a simple comment --></￥%></body></span></html>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("html").first().getOrThrow()
        var returntag = -1
        try {
            str.selectFirst("￥%")
        } catch (e: SelectorParseException) {
            @Assert(e.message, "Could not parse query '￥%': unexpected token at '￥%'")
            returntag = 1
        }
        @Assert(1,returntag)
    }

    @TestCase
    func testElement_09_02(): Unit {
        let cou = "<html><span><body><￥%><!-- a simple comment --></￥%></body></span></html>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("html").first().getOrThrow()
        var returntag = -1
        try {
            str.selectFirst("")
        } catch (e: ValidationException) {
            @Assert(e.message, "String must not be empty")
            returntag = 1
        }
        @Assert(1,returntag)
    }

    @TestCase
    func testElement_09_03(): Unit {
        let cou = "<html><span><body><中国><!-- a simple comment --></中国></body></span></html>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("html").first().getOrThrow()
        let sc = str.selectFirst("中国")
        @Assert("None",sc.toString())
    }

    @TestCase
    func testElement_09_04(): Unit {
        let cou = "<html><span><body><div><!-- a simple comment --></div></body></span></html>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("html").first().getOrThrow()
        let sc = str.selectFirst("div")
        @Assert(sc.toString().contains("a simple comment -->"),true)
        @Assert(45,sc.toString().toRuneArray().size)
    }
}
