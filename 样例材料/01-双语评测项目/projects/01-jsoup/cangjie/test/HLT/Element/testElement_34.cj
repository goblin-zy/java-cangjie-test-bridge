// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

@Test
public class NodeTest {
    @TestCase
    func testElement_34_01(): Unit {
        let cou = "<div style='bold'><p><p><b style></b></p></div>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("div").first().getOrThrow()
        let sc = str.getElementsByAttributeValue("style", "bold")
        @Assert(sc.toString().contains("style></b></p>"),true)
        @Assert(56,sc.toString().toRuneArray().size)
    }

    @TestCase
    func testElement_34_02(): Unit {
        let cou = "<div STYLE='你好仓颉！【】'><p><p><b style></b></p></div>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("div").first().getOrThrow()
        let sc = str.getElementsByAttributeValue("STYLE", "你好仓颉！【】")
        @Assert(sc.toString().contains("好仓颉！【】"),true)
        @Assert(59,sc.toString().toRuneArray().size)
    }

    @TestCase
    func testElement_34_03(): Unit {
        let cou = "<div STYLE='你好仓颉！【】'><p><p><b style></b></p></div>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("div").first().getOrThrow()
        var returntag = -1
        try {
            str.getElementsByAttributeValue("", "你好仓颉！【】")
        } catch (e: ValidationException) {
            @Assert(e.toString().contains("String must not be empty"), true)
            returntag = 1
        }
        @Assert(1,returntag)
    }

    @TestCase
    func testElement_34_04(): Unit {
        let cou = "<div STYLE='你好仓颉！【】'><p><p><b style></b></p></div>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("div").first().getOrThrow()
        var returntag = -1
        try {
            str.getElementsByAttributeValue("STYLE", "")
        } catch (e: ValidationException) {
            @Assert(e.toString().contains("String must not be empty"), true)
            returntag = 1
        }
        @Assert(1,returntag)
    }

    @TestCase
    func testElement_34_05(): Unit {
        let cou = "<div STYLE='你好仓颉！【】'><p><p><b style></b></p></div>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("div").first().getOrThrow()
        let sc = str.getElementsByAttributeValue("SE", "你好仓颉！【】")
        @Assert(0,sc.toString().toRuneArray().size)
    }

    @TestCase
    func testElement_34_06(): Unit {
        let cou = "<div STYLE='你好仓颉！【】'><p><p><b style></b></p></div>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("div").first().getOrThrow()
        let sc = str.getElementsByAttributeValue("STYLE", "你好")
        @Assert(0,sc.toString().toRuneArray().size)
    }

    @TestCase
    func testElement_34_07(): Unit {
        let cou = "<div data-STYLE='你好仓颉！【】'><p><p><b style></b></p></div>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("div").first().getOrThrow()
        let sc = str.getElementsByAttributeValue("data-STYLE", "你好仓颉！【】")

        @Assert(sc.toString().contains("p><b style></b></p>"),true)
        @Assert(64,sc.toString().toRuneArray().size)
    }

    @TestCase
    func testElement_34_08(): Unit {
        let cou = "<div /OP='/TT'><p><p><b style></b></p></div>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("div").first().getOrThrow()
        let sc = str.getElementsByAttributeValue("/OP", "/TT")
        @Assert(0,sc.toString().toRuneArray().size)
    }
}
