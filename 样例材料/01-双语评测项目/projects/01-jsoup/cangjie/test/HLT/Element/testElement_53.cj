// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*
import std.regex.*

@Test
public class NodeTest {
    @TestCase
    func testElement_53_01(): Unit {
        let cou = "<div><p class='mellow yellow'></p><p class='red green'></p>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("p")
        let sc = str.hasClass("red")
        @Assert(true,sc)
    }

    @TestCase
    func testElement_53_02(): Unit {
        let cou = "<div><p class='mellow yellow'></p><p class='/ttn green'></p>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("p")
        let sc = str.hasClass("/ttn")
        @Assert(true,sc)
    }

    @TestCase
    func testElement_53_03(): Unit {
        let cou = "<div><p class='mellow yellow'></p><p class='/ttn green'></p>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("p")
        let sc = str.hasClass("")
        @Assert(false,sc)
    }

    @TestCase
    func testElement_53_04(): Unit {
        let cou = "<div><p class='mellow yellow'></p><p class='你好仓颉！【】 green'></p>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("p")
        let sc = str.hasClass("你好")
        @Assert(false,sc)
    }

    @TestCase
    func testElement_53_05(): Unit {
        let cou = "<div><p class='mellow yellow'></p><p class='/ttn green'></p>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("p")
        let sc = str.hasClass("pppss")
        @Assert(false,sc)
    }

    @TestCase
    func testElement_53_06(): Unit {
        let cou = "<div><p class='mellow yellow'></p><p class='data-s green'></p>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("p")
        let sc = str.hasClass("data-s")
        @Assert(true,sc)
    }
}
