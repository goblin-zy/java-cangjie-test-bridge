// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

@Test
public class NodeTest {
    @TestCase
    func testElement_31_01(): Unit {
        let cou =
            "<div class='mellow yellow'><span class=mellow>Hello <b class='yellow'>Yellow!</b></span><p>Empty</p></div>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("div").first().getOrThrow()
        let sc = str.getElementsByClass("mellow")
        @Assert(sc.toString().contains("<span class="),true)
        @Assert(177,sc.toString().toRuneArray().size)
    }

    @TestCase
    func testElement_31_02(): Unit {
        let cou =
            "<div class='mellow yellow'><span class=MAXES>Hello <b class='yellow'>Yellow!</b></span><p>Empty</p></div>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("span").first().getOrThrow()
        let sc = str.getElementsByClass("MAXES")
        @Assert(sc.toString().contains("Hello"),true)
        @Assert(62,sc.toString().toRuneArray().size)
    }

    @TestCase
    func testElement_31_03(): Unit {
        let cou =
            "<div class='mellow yellow'><span class=你好>Hello <b class='yellow'>Yellow!</b></span><p>Empty</p></div>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("span").first().getOrThrow()
        let sc = str.getElementsByClass("你好")
        @Assert(sc.toString().contains("<span class=\"你好\">Hello "),true)
        @Assert(59,sc.toString().toRuneArray().size)
    }

    @TestCase
    func testElement_31_04(): Unit {
        let cou =
            "<div class='mellow yellow'><span class=see>Hello <b class='yellow'>Yellow!</b></span><p>Empty</p></div>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("span").first().getOrThrow()
        var returntag = -1
        try {
            str.getElementsByClass("")
        } catch (e: ValidationException) {
            @Assert(e.toString().contains("String must not be empty"), true)
            returntag = 1
        }
        @Assert(1,returntag)
    }

    @TestCase
    func testElement_31_05(): Unit {
        let cou =
            "<div class='mellow yellow'><span class=@#>Hello <b class='yellow'>Yellow!</b></span><p>Empty</p></div>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("span").first().getOrThrow()
        let sc = str.getElementsByClass("@#")
        @Assert(sc.toString().contains("<span class=\"@#\">Hello <b class=\"yellow\""),true)
        @Assert(59,sc.toString().toRuneArray().size)
    }
}
