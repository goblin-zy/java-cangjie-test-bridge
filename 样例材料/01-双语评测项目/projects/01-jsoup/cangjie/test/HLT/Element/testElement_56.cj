// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*
import std.regex.*

@Test
public class NodeTest {
    @TestCase
    func testElement_56_01(): Unit {
        let cou = "<div><p class='mellow yellow'></p><p class='red green'></p>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("div")
        let sc = str.toggleClass("ropstre")
        @Assert(86,sc.toString().toRuneArray().size)
        @Assert(sc.toString().contains("<div class=\"ropstre\">"),true)
    }

    @TestCase
    func testElement_56_02(): Unit {
        let cou = "<div><p class='mellow yellow'></p><p class='red green'></p>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("div")
        let sc = str.toggleClass("/ttt\n")
        @Assert(84,sc.toString().toRuneArray().size)
        @Assert(sc.toString().contains("<div class=\"/ttt"),true)
    }

    @TestCase
    func testElement_56_03(): Unit {
        let cou = "<div><p class='mellow yellow'></p><p class='red green'></p>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("div")
        let sc = str.toggleClass("")
        @Assert(79,sc.toString().toRuneArray().size)
        @Assert(sc.toString().contains("<div class=\"\">"),true)
    }

    @TestCase
    func testElement_56_04(): Unit {
        let cou = "<div><p class='mellow yellow'></p><p class='red green'></p>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("div")
        let sc = str.toggleClass("你好仓颉！【】")
        @Assert(86,sc.toString().toRuneArray().size)
        @Assert(sc.toString().contains("<div class=\"你好仓颉！【】\">"),true)
    }

    @TestCase
    func testElement_56_05(): Unit {
        let cou = "<div><p class='mellow yellow'></p><p class='red green'></p>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("div")
        let sc = str.toggleClass("OPTIONS")
        @Assert(86,sc.toString().toRuneArray().size)
        @Assert(sc.toString().contains("<div class=\"OPTIONS\">"),true)
    }

    @TestCase
    func testElement_56_06(): Unit {
        let cou = "<div><p class='mellow yellow'></p><p class='red green'></p>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("div")
        let sc = str.toggleClass("data-sse")
        @Assert(87,sc.toString().toRuneArray().size)
        @Assert(sc.toString().contains("<div class=\"data-sse\">"),true)
    }
}
