// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

@Test
public class NodeTest {
    @TestCase
    func testElement_23_01(): Unit {
        let cou = "<div><!-- a simple comment -->"
        var doc = Html4cj.parse(cou)
        var str = doc.select("div").first().getOrThrow()
        let sc = str.wrap(" there & now >")
        @Assert(39,sc.toString().toRuneArray().size)
        @Assert(1,sc.childNodeSize())
    }

    @TestCase
    func testElement_23_02(): Unit {
        let cou = "<div><!-- a simple comment -->"
        var doc = Html4cj.parse(cou)
        var str = doc.select("div").first().getOrThrow()
        let sc = str.wrap("你好仓颉！【】")
        @Assert(sc.toString().contains("<!-- a simple comment -->"),true)
        @Assert(39,sc.toString().toRuneArray().size)
    }

    @TestCase
    func testElement_23_03(): Unit {
        let cou = "<div><!-- a simple comment -->"
        var doc = Html4cj.parse(cou)
        var str = doc.select("div").first().getOrThrow()
        var returntag = -1
        try {
            str.wrap("")
        } catch (e: ValidationException) {
            @Assert(e.toString().contains("String must not be empty"), true)
            returntag = 1
        }
        @Assert(1,returntag)
    }

    @TestCase
    func testElement_23_04(): Unit {
        let cou = "<div><!-- a simple comment -->"
        var doc = Html4cj.parse(cou)
        var str = doc.select("div").first().getOrThrow()
        let sc = str.wrap("Hello Cang!@#$%^&*()_+:<>?|jie Lang")
        @Assert(sc.toString().contains("<!-- a simple comment -->"),true)
        @Assert(39,sc.toString().toRuneArray().size)
    }

    @TestCase
    func testElement_23_05(): Unit {
        let cou = "<div><!-- a simple comment -->"
        var doc = Html4cj.parse(cou)
        var str = doc.select("div").first().getOrThrow()
        let sc = str.wrap("id=1>Text <p>One</p> Text <p>Two</p>")
        @Assert(sc.toString().contains("<!-- a simple comment -->"),true)
        @Assert(39,sc.toString().toRuneArray().size)
    }

    @TestCase
    func testElement_23_06(): Unit {
        let cou = "<div><!-- a simple comment -->"
        var doc = Html4cj.parse(cou)
        var str = doc.select("div").first().getOrThrow()
        let sc = str.cssSelector()
        @Assert("html > body > div",sc.toString())
    }
}
