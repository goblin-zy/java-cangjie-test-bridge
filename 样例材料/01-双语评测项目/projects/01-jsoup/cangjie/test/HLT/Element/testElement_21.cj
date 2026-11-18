// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

@Test
public class NodeTest {
    @TestCase
    func testElement_21_01(): Unit {
        let cou = "<div><!-- a simple comment -->"
        var doc = Html4cj.parse(cou)
        var str = doc.select("div").first().getOrThrow()
        let sc = str.after(" there & now >")
        @Assert(39,sc.toString().toRuneArray().size)
        @Assert(1,sc.childNodeSize())
    }

    @TestCase
    func testElement_21_02(): Unit {
        let cou = "<div><!-- a simple comment -->"
        var doc = Html4cj.parse(cou)
        var str = doc.select("div").first().getOrThrow()
        let sc = str.after("你好仓颉！【】")
        @Assert(sc.toString().contains("<!-- a simple comment -->"),true)
        @Assert(39,sc.toString().toRuneArray().size)
    }

    @TestCase
    func testElement_21_03(): Unit {
        let cou = "<div><!-- a simple comment -->"
        var doc = Html4cj.parse(cou)
        var str = doc.select("div").first().getOrThrow()
        let sc = str.after("")
        @Assert(sc.toString().contains("<!-- a simple comment -->"),true)
        @Assert(39,sc.toString().toRuneArray().size)
    }

    @TestCase
    func testElement_21_04(): Unit {
        let cou = "<div><!-- a simple comment -->"
        var doc = Html4cj.parse(cou)
        var str = doc.select("div").first().getOrThrow()
        let sc = str.after("Hello Cang!@#$%^&*()_+:<>?|jie Lang")
        @Assert(sc.toString().contains("<!-- a simple comment -->"),true)
        @Assert(39,sc.toString().toRuneArray().size)
    }

    @TestCase
    func testElement_21_05(): Unit {
        let cou = "<div><!-- a simple comment -->"
        var doc = Html4cj.parse(cou)
        var str = doc.select("div").first().getOrThrow()
        let sc = str.after("<div id=\"id1\">A</div><div>B</div><div class=\"c1 c2\">C</div>")
        @Assert(sc.toString().contains("<!-- a simple comment -->"),true)
        @Assert(39,sc.toString().toRuneArray().size)
    }
}
