// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

@Test
public class NodeTest {
    @TestCase
    func testElement_32_01(): Unit {
        let cou = "<div style='bold'><p title=qux><p><b style></b></p></div>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("div").first().getOrThrow()
        let sc = str.getElementsByAttribute("style")
        @Assert(sc.toString().contains("bold"),true)
        @Assert(82,sc.toString().toRuneArray().size)
    }

    @TestCase
    func testElement_32_02(): Unit {
        let cou = "<div AQE='bold'><p title=qux><p><b style></b></p></div>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("div").first().getOrThrow()
        let sc = str.getElementsByAttribute("AQE")
        @Assert(sc.toString().contains("style></b></p>"),true)
        @Assert(66,sc.toString().toRuneArray().size)
    }

    @TestCase
    func testElement_32_03(): Unit {
        let cou = "<div AQE='bold'><p 中国心=qux><p><b style></b></p></div>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("p").first().getOrThrow()
        let sc = str.getElementsByAttribute("中国心")
        @Assert(sc.toString().contains("<p 中国心=\"qux\"></p>"),true)
        @Assert(17,sc.toString().toRuneArray().size)
    }

    @TestCase
    func testElement_32_04(): Unit {
        let cou = "<div AQE='bold'><p */n=qux><p><b style></b></p></div>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("p").first().getOrThrow()
        let sc = str.getElementsByAttribute("*/n")
        @Assert(0,sc.toString().toRuneArray().size)
    }

    @TestCase
    func testElement_32_05(): Unit {
        let cou = "<div AQE='bold'><p */n=qux><p><b style></b></p></div>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("p").first().getOrThrow()
        let sc = str.getElementsByAttribute("sps")
        @Assert(0,sc.toString().toRuneArray().size)
    }

    @TestCase
    func testElement_32_06(): Unit {
        let cou = "<div AQE='bold'><p */n=qux><p><b style></b></p></div>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("p").first().getOrThrow()
        var returntag = -1
        try {
            str.getElementsByAttribute("")
        } catch (e: ValidationException) {
            @Assert(e.toString().contains("String must not be empty"), true)
            returntag = 1
        }
        @Assert(1,returntag)
    }
}
