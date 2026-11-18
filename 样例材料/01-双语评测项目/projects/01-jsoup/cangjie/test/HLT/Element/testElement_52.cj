// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*
import std.regex.*

@Test
public class NodeTest {
    @TestCase
    func testElement_52_01(): Unit {
        let cou = "<div><p class='mellow yellow'></p><p class='red green'></p>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("p").first().getOrThrow()
        var dara = HashSet<String>()
        let s3 = "\"Hello Cangjie Lang\""
        let s4 = "Hello Cangjie Lang\n"
        dara.add(s3)
        dara.add(s4)
        let sc = str.classNames(dara)
        @Assert(66,sc.toString().toRuneArray().size)
        @Assert(sc.toString().contains("&quot;Hello Cangjie Lang&quot; Hello Cangjie Lang"),true)
    }

    @TestCase
    func testElement_52_02(): Unit {
        let cou = "<div><p class='mellow yellow'></p><p class='red green'></p>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("p").first().getOrThrow()
        var dara = HashSet<String>()
        let sc = str.classNames(dara)
        @Assert(7,sc.toString().toRuneArray().size)
        @Assert(sc.toString().contains("<p></p>"),true)
    }

    @TestCase
    func testElement_52_03(): Unit {
        let cou = "<div><p class='mellow yellow'></p><p class='red green'></p>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("p").first().getOrThrow()
        var dara = HashSet<String>()
        let s3 = "你好仓颉！【】"
        let s4 = "你好\n"
        dara.add(s3)
        dara.add(s4)
        let sc = str.classNames(dara)
        @Assert(27,sc.toString().toRuneArray().size)
        @Assert(sc.toString().contains("你好仓颉！【】 你好"),true)
    }

    @TestCase
    func testElement_52_04(): Unit {
        let cou = "<div><p class='mellow yellow'></p><p class='red green'></p>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("p").first().getOrThrow()
        var dara = HashSet<String>()
        let s3 = "data-se"
        let s4 = "data-opt"
        dara.add(s3)
        dara.add(s4)
        let sc = str.classNames(dara)
        @Assert(32,sc.toString().toRuneArray().size)
        @Assert(sc.toString().contains("data-se data-op"),true)
    }

    @TestCase
    func testElement_52_05(): Unit {
        let cou = "<div><p class='mellow yellow'></p><p class='red green'></p>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("p").first().getOrThrow()
        var dara = HashSet<String>()
        let s3 = "/ttt"
        let s4 = "/ttt\n"
        dara.add(s3)
        dara.add(s4)
        let sc = str.classNames(dara)
        @Assert(26,sc.toString().toRuneArray().size)
        @Assert(sc.toString().contains("/ttt /ttt"),true)
    }
}
