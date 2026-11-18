// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*
import std.regex.*

@Test
public class NodeTest {
    @TestCase
    func testElement_40_01(): Unit {
        let cou = "<a href=1one></a><a href=2one></a><a href=else</a>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("a").first().getOrThrow()
        let sc = str.getElementsByAttributeValueMatching("href", "\\d+")
        @Assert(sc.toString().contains("1one"),true)
        @Assert(1,sc.size)
    }

    @TestCase
    func testElement_40_02(): Unit {
        let cou = "<a HREF=1one></a><a href=2one></a><a href=else</a>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("a").first().getOrThrow()
        let sc = str.getElementsByAttributeValueMatching("HREF", "\\d+")
        @Assert(sc.toString().contains("1one"),true)
        @Assert(1,sc.size)
    }

    @TestCase
    func testElement_40_03(): Unit {
        let cou = "<a 你好仓颉！【】=1one></a><a href=2one></a><a href=else</a>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("a").first().getOrThrow()
        let sc = str.getElementsByAttributeValueMatching("你好仓颉！【】", "\\d+")
        @Assert(sc.toString().contains("好仓颉！【】="),true)
        @Assert(1,sc.size)
    }

    @TestCase
    func testElement_40_04(): Unit {
        let cou = "<a 你好仓颉！【】=1one></a><a href=2one></a><a href=else</a>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("a").first().getOrThrow()
        let sc = str.getElementsByAttributeValueMatching("seee", #"a\wa"#)
        @Assert(0,sc.size)
    }

    @TestCase
    func testElement_40_05(): Unit {
        let cou = "<a 你好仓颉！【】=1one></a><a href=2one></a><a href=else</a>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("a").first().getOrThrow()
        let sc = str.getElementsByAttributeValueMatching("", #"a\wa"#)
        @Assert(0,sc.size)
    }

    @TestCase
    func testElement_40_06(): Unit {
        let cou = "<a data-se=1one></a><a href=2one></a><a href=else</a>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("a").first().getOrThrow()
        let sc = str.getElementsByAttributeValueMatching("data-se", #"a\wa"#)
        @Assert(0,sc.size)
    }

    @TestCase
    func testElement_40_07(): Unit {
        let cou = "<a /ffe=1one></a><a href=2one></a><a href=else</a>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("a").first().getOrThrow()
        let sc = str.getElementsByAttributeValueMatching("/ffe", #"a\wa"#)
        @Assert(0,sc.size)
    }
}
