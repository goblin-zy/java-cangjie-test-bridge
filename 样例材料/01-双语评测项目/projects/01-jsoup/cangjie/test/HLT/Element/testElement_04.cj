// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

@Test
public class NodeTest {
    @TestCase
    func testElement_04_01(): Unit {
        let cou = "<html> <head></head><body><div><!-- a simple comment --><div></body></html>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("html").first().getOrThrow()
        let sc = str.parents()
        @Assert("",sc.toString())
    }

    @TestCase
    func testElement_04_02(): Unit {
        let cou = "<html> <head></head><body><div><!-- a simple comment --><div></body></html>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("body").first().getOrThrow()
        let sc = str.parents()
        @Assert(sc.toString().contains("<div></div>"),true)
        @Assert(107,sc.toString().toRuneArray().size)
    }

    @TestCase
    func testElement_04_03(): Unit {
        let cou = "<html> <head></head><body><div><!-- a simple comment --><div></body></html>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("div").first().getOrThrow()
        let sc = str.parents()
        @Assert(sc.toString().contains("</html>"),true)
        @Assert(179,sc.toString().toRuneArray().size)
    }
}
