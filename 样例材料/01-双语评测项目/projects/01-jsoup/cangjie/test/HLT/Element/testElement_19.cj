// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

@Test
public class NodeTest {
    @TestCase
    func testElement_19_01(): Unit {
        let cou = "<div><!-- a simple comment -->"
        var doc = Html4cj.parse(cou)
        var str = doc.select("div").first().getOrThrow()
        let sc = str.before(" there & now >")
        @Assert(39,sc.toString().toRuneArray().size)
        @Assert(1,sc.childNodeSize())
    }

    @TestCase
    func testElement_19_02(): Unit {
        let cou = "<div><!-- a simple comment -->"
        var doc = Html4cj.parse(cou)
        var str = doc.select("div").first().getOrThrow()
        let sc = str.before("你好仓颉！【】")
        @Assert(sc.toString().contains("<!-- a simple comment -->"),true)
        @Assert(39,sc.toString().toRuneArray().size)
    }

    @TestCase
    func testElement_19_03(): Unit {
        let cou = "<div><!-- a simple comment -->"
        var doc = Html4cj.parse(cou)
        var str = doc.select("div").first().getOrThrow()
        let sc = str.before("")
        @Assert(sc.toString().contains("<!-- a simple comment -->"),true)
        @Assert(39,sc.toString().toRuneArray().size)
    }

    @TestCase
    func testElement_19_04(): Unit {
        let cou = "<div><!-- a simple comment -->"
        var doc = Html4cj.parse(cou)
        var str = doc.select("div").first().getOrThrow()
        let sc = str.before("Hello Cang!@#$%^&*()_+:<>?|jie Lang")

        @Assert(sc.toString().contains("<!-- a simple comment -->"),true)
        @Assert(39,sc.toString().toRuneArray().size)
    }

    @TestCase
    func testElement_19_05(): Unit {
        let cou = "<div><!-- a simple comment -->"
        var doc = Html4cj.parse(cou)
        var str = doc.select("div").first().getOrThrow()
        let sc = str.before("id=1>Text <p>One</p> Text <p>Two</p>")

        @Assert(sc.toString().contains("<!-- a simple comment -->"),true)
        @Assert(39,sc.toString().toRuneArray().size)
    }
}
