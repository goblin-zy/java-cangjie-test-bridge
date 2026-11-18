// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

@Test
public class NodeTest {
    @TestCase
    func testElement_15_01(): Unit {
        let cou = "<div><!-- a simple comment -->"
        var doc = Html4cj.parse(cou)
        var str = doc.select("div").first().getOrThrow()
        let sc = str.appendText(" there & now >")
        @Assert(60,sc.toString().size)
        @Assert(2,sc.childNodeSize())
    }

    @TestCase
    func testElement_15_02(): Unit {
        let cou = "<div><!-- a simple comment -->"
        var doc = Html4cj.parse(cou)
        var str = doc.select("div").first().getOrThrow()
        let sc = str.appendText("你好仓颉！【】")
        @Assert(sc.toString().contains("-->你好仓颉！【】"),true)
        @Assert(46,sc.toString().toRuneArray().size)
    }

    @TestCase
    func testElement_15_03(): Unit {
        let cou = "<div><!-- a simple comment -->"
        var doc = Html4cj.parse(cou)
        var str = doc.select("div").first().getOrThrow()
        let sc = str.appendText("")
        @Assert(sc.toString().contains("comment"),true)
        @Assert(39,sc.toString().toRuneArray().size)
    }

    @TestCase
    func testElement_15_04(): Unit {
        let cou = "<div><!-- a simple comment -->"
        var doc = Html4cj.parse(cou)
        var str = doc.select("div").first().getOrThrow()
        let sc = str.appendText("Hello Cang!@#$%^&*()_+:<>?|jie Lang")
        @Assert(sc.toString().contains("Cang!@#$%^&amp;*"),true)
        @Assert(84,sc.toString().toRuneArray().size)
    }
}
