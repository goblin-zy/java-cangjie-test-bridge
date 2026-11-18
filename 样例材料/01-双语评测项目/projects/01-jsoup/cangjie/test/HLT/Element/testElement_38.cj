// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

@Test
public class NodeTest {
    @TestCase
    func testElement_38_01(): Unit {
        let cou = "<div style='bold'><p><p><b style></b></p></div>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("div").first().getOrThrow()
        let sc = str.getElementsByAttributeValueContaining("style", "bold")
        @Assert(sc.toString().contains("bold"),true)
        @Assert(56,sc.toString().toRuneArray().size)
    }

    @TestCase
    func testElement_38_02(): Unit {
        let cou = "<div STYLE='你好仓颉！【】'><p><p><b style></b></p></div>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("div").first().getOrThrow()
        let sc = str.getElementsByAttributeValueContaining("STYLE", "你好仓颉！【】")
        @Assert(sc.toString().contains("好仓颉！【】"),true)
        @Assert(59,sc.toString().toRuneArray().size)
    }

    @TestCase
    func testElement_38_03(): Unit {
        let cou = "<div STYLE='你好仓颉！【】'><p><p><b style></b></p></div>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("div").first().getOrThrow()
        var returntag = -1
        try {
            str.getElementsByAttributeValueContaining("", "你好仓颉！【】")
        } catch (e: ValidationException) {
            @Assert(e.toString().contains("String must not be empty"), true)
            returntag = 1
        }
        @Assert(1,returntag)
    }

    @TestCase
    func testElement_38_04(): Unit {
        let cou = "<div STYLE='你好仓颉！【】'><p><p><b style></b></p></div>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("div").first().getOrThrow()
        var returntag = -1
        try {
            str.getElementsByAttributeValueContaining("STYLE", "")
        } catch (e: ValidationException) {
            @Assert(e.toString().contains("String must not be empty"), true)
            returntag = 1
        }
        @Assert(1,returntag)
    }

    @TestCase
    func testElement_38_05(): Unit {
        let cou = "<div STYLE='你好仓颉！【】'><p><p><b style></b></p></div>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("div").first().getOrThrow()
        let sc = str.getElementsByAttributeValueContaining("SE", "你好仓颉！【】")
        @Assert(0,sc.toString().toRuneArray().size)
    }

    @TestCase
    func testElement_38_06(): Unit {
        let cou = "<div STYLE='你好仓颉！【】'><p><p><b style></b></p></div>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("div").first().getOrThrow()
        let sc = str.getElementsByAttributeValueContaining("STYLE", "你好")

        @Assert(sc.toString().contains("你好仓颉！【】"),true)
        @Assert(59,sc.toString().toRuneArray().size)
    }

    @TestCase
    func testElement_38_07(): Unit {
        let cou = "<div data-STYLE='你好仓颉！【】'><p><p><b style></b></p></div>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("div").first().getOrThrow()
        let sc = str.getElementsByAttributeValueContaining("data-STYLE", "你好仓颉！【】")
        @Assert(sc.toString().contains("你好仓颉！【】"),true)
        @Assert(64,sc.toString().toRuneArray().size)
    }

    @TestCase
    func testElement_38_08(): Unit {
        let cou = "<div /OP='/TT'><p><p><b style></b></p></div>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("div").first().getOrThrow()
        let sc = str.getElementsByAttributeValueContaining("/OP", "/TT")
        @Assert(0,sc.toString().toRuneArray().size)
    }
}
