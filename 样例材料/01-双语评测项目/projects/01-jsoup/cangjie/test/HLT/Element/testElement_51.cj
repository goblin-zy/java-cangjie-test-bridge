// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*
import std.regex.*

@Test
public class NodeTest {
    @TestCase
    func testElement_51_01(): Unit {
        let cou = "<div><p class='mellow yellow'></p><p class='red green'></p>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("p").first().getOrThrow()
        let sc = str.className()
        @Assert(13,sc.size)
    }

    @TestCase
    func testElement_51_02(): Unit {
        let cou = "<div><span class='mellow yellow'></span><p class='red green'></p>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("div").first().getOrThrow()
        let sc = str.className()
        @Assert(0,sc.size)
    }

    @TestCase
    func testElement_51_03(): Unit {
        let cou = "<div><span class='mellow yellow'></span><p class='red green'></p>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("div").first().getOrThrow()
        let sc = str.classNames()
        @Assert(0,sc.size)
    }

    @TestCase
    func testElement_51_04(): Unit {
        let cou = "<div><p class='mellow yellow'></p><p class='red green'></p>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("p").first().getOrThrow()
        let sc = str.classNames()
        @Assert(2,sc.size)
    }
}
