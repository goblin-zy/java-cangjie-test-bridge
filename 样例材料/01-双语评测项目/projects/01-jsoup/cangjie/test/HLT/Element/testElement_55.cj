// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*
import std.regex.*

@Test
public class NodeTest {
    @TestCase
    func testElement_55_01(): Unit {
        let cou = "<div class='ropstre'><p class='mellow yellow'></p><p class='red green'></p>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("div")
        let sc = str.removeClass("ropstre")
        @Assert(70,sc.toString().toRuneArray().size)
        @Assert(sc.toString().contains("<p class=\"red green\"></p>"),true)
    }

    @TestCase
    func testElement_55_02(): Unit {
        let cou = "<div class='/ttt'><p class='mellow yellow'></p><p class='red green'></p>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("div")
        let sc = str.removeClass("/ttt")
        @Assert(70,sc.toString().toRuneArray().size)
        @Assert(sc.toString().contains("<p class=\"mellow yellow\"></p>"),true)
    }

    @TestCase
    func testElement_55_03(): Unit {
        let cou = "<div class='/ttt'><p class='mellow yellow'></p><p class='red green'></p>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("div")
        let sc = str.removeClass("")
        @Assert(83,sc.toString().toRuneArray().size)
        @Assert(sc.toString().contains("<div class=\"/ttt\">"),true)
    }

    @TestCase
    func testElement_55_04(): Unit {
        let cou = "<div class='你好仓颉！【】'><p class='mellow yellow'></p><p class='red green'></p>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("div")
        let sc = str.removeClass("你好仓颉！【】")
        @Assert(70,sc.toString().toRuneArray().size)
        @Assert(sc.toString().contains("p class=\"red green\"></p>"),true)
    }

    @TestCase
    func testElement_55_05(): Unit {
        let cou = "<div class='sse'><p class='mellow yellow'></p><p class='red green'></p>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("div")
        let sc = str.removeClass("op")
        @Assert(82,sc.toString().toRuneArray().size)
        @Assert(sc.toString().contains("<p class=\"mellow yellow\"></p>"),true)
    }

    @TestCase
    func testElement_55_06(): Unit {
        let cou = "<div class='data-sse'><p class='mellow yellow'></p><p class='red green'></p>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("div")
        let sc = str.removeClass("data-sse")
        @Assert(70,sc.toString().toRuneArray().size)
        @Assert(sc.toString().contains("<p class=\"mellow yellow\"></p>"),true)
    }
}
