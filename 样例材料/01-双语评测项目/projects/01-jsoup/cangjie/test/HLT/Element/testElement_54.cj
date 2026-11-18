// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*
import std.regex.*

@Test
public class NodeTest {
    @TestCase
    func testElement_54_01(): Unit {
        let cou = "<div><p class='mellow yellow'></p><p class='red green'></p>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("div")
        let sc = str.addClass("ropstre")
        @Assert(86,sc.toString().toRuneArray().size)
        @Assert(sc.toString().contains("red green"),true)
    }

    @TestCase
    func testElement_54_02(): Unit {
        let cou = "<div><p class='mellow yellow'></p><p class='red green'></p>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("div")
        let sc = str.addClass("/ttt\n")
        @Assert(84,sc.toString().toRuneArray().size)
        @Assert(sc.toString().contains("<div class=\"/tt"),true)
    }

    @TestCase
    func testElement_54_03(): Unit {
        let cou = "<div><p class='mellow yellow'></p><p class='red green'></p>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("div")
        let sc = str.addClass("")
        @Assert(79,sc.toString().toRuneArray().size)
        @Assert(sc.toString().contains("mellow yellow"),true)
    }

    @TestCase
    func testElement_54_04(): Unit {
        let cou = "<div><p class='mellow yellow'></p><p class='red green'></p>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("div")
        let sc = str.addClass("你好仓颉！【】")
        @Assert(86,sc.toString().toRuneArray().size)
        @Assert(sc.toString().contains("<div class=\"你好仓颉！【】\">"),true)
    }

    @TestCase
    func testElement_54_05(): Unit {
        let cou = "<div><p class='mellow yellow'></p><p class='red green'></p>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("div")
        let sc = str.addClass("OPTIONS")
        @Assert(86,sc.toString().toRuneArray().size)
        @Assert(sc.toString().contains("<div class=\"OPTIONS\">"),true)
    }

    @TestCase
    func testElement_54_06(): Unit {
        let cou = "<div><p class='mellow yellow'></p><p class='red green'></p>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("div")
        let sc = str.addClass("data-sse")
        @Assert(87,sc.toString().toRuneArray().size)
        @Assert(sc.toString().contains("<div class=\"data-sse\">"),true)
    }
}
