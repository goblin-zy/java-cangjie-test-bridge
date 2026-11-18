// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

@Test
public class NodeTest {
    @TestCase
    func testElement_14_01(): Unit {
        let cou = "<div><!-- a simple comment -->"
        var doc = Html4cj.parse(cou)
        var str = doc.select("div").first().getOrThrow()
        let sc = str.prependElement("se")
        @Assert("<se></se>",sc.toString())
        @Assert(0,sc.childNodeSize())
    }

    @TestCase
    func testElement_14_02(): Unit {
        let cou = "<div><!-- a simple comment -->"
        var doc = Html4cj.parse(cou)
        var str = doc.select("div").first().getOrThrow()
        let sc = str.prependElement("中国心")
        @Assert("<中国心></中国心>",sc.toString())
        @Assert(0,sc.childNodeSize())
    }

    @TestCase
    func testElement_14_03(): Unit {
        let cou = "<div><!-- a simple comment -->"
        var doc = Html4cj.parse(cou)
        var str = doc.select("div").first().getOrThrow()
        var returntag = -1
        try {
            str.prependElement("")
        } catch (e: ValidationException) {
            @Assert(e.toString().contains("String must not be empty"), true)
            returntag = 1
        }
        @Assert(1,returntag)
    }

    @TestCase
    func testElement_14_04(): Unit {
        let cou = "<div><!-- a simple comment -->"
        var doc = Html4cj.parse(cou)
        var str = doc.select("div").first().getOrThrow()
        let sc = str.prependElement("@￥%")
        @Assert("<@￥%></@￥%>",sc.toString())
        @Assert(0,sc.childNodeSize())
    }
}
