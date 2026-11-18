// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*
import std.regex.*

@Test
public class NodeTest {
    @TestCase
    func testElement_48_01(): Unit {
        let cou = "<html><span><body><div><!-- a simple comment -->One</div><b>two</b></body></span></html>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("html").first().getOrThrow()
        let sc = str.wholeText()
        @Assert(6,sc.toString().toRuneArray().size)
        @Assert(sc.toString().contains("Onetwo"),true)
    }

    @TestCase
    func testElement_48_02(): Unit {
        let cou = "<html><span><body><div><!-- a simple comment -->One</div><b>two</b></body></span></html>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("span").first().getOrThrow()
        let sc = str.wholeText()
        @Assert(6,sc.toString().toRuneArray().size)
        @Assert(sc.toString().contains("Onetwo"),true)
    }

    @TestCase
    func testElement_48_03(): Unit {
        let cou = "<html><span><body><div><!-- a simple comment -->One</div><b>two  </b></body></span></html>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("b").first().getOrThrow()
        let sc = str.wholeText()
        @Assert(5,sc.toString().toRuneArray().size)
        @Assert(sc.toString().contains("two"),true)
    }

    @TestCase
    func testElement_48_04(): Unit {
        let cou = "<html><span><body><div><!-- a simple comment -->One</div><b>two  </b></body></span></html>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("html").first().getOrThrow()
        let sc = str.wholeOwnText()
        @Assert(0,sc.toString().toRuneArray().size)
    }

    @TestCase
    func testElement_48_05(): Unit {
        let cou = "<html><span><body><div><!-- a simple comment -->One</div><b>two  </b></body></span></html>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("body").first().getOrThrow()
        let sc = str.wholeOwnText()
        @Assert(0,sc.toString().toRuneArray().size)
    }

    @TestCase
    func testElement_48_06(): Unit {
        let cou = "<html><span><body><div><!-- a simple comment -->One</div><b>two  </b></body></span></html>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("b").first().getOrThrow()
        let sc = str.wholeOwnText()
        @Assert(5,sc.toString().toRuneArray().size)
        @Assert(sc.toString().contains("two"),true)
    }

    @TestCase
    func testElement_48_07(): Unit {
        let cou = "<html><span><body><div><!-- a simple comment -->One</div><b>two  </b></body></span></html>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("html").first().getOrThrow()
        let sc = str.ownText()
        @Assert(0,sc.toString().toRuneArray().size)
    }

    @TestCase
    func testElement_48_08(): Unit {
        let cou = "<html><span><body><div><!-- a simple comment -->One</div><b>two  </b></body></span></html>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("body").first().getOrThrow()
        let sc = str.ownText()
        @Assert(0,sc.toString().toRuneArray().size)
    }

    @TestCase
    func testElement_48_09(): Unit {
        let cou = "<html><span><body><div><!-- a simple comment -->One</div><b>two  </b></body></span></html>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("b").first().getOrThrow()
        let sc = str.ownText()
        @Assert(3,sc.toString().toRuneArray().size)
        @Assert(sc.toString().contains("two"),true)
    }
}
