// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

@Test
public class NodeTest {
    @TestCase
    func testElement_49_01(): Unit {
        let cou = "<span><body><div><!-- a simple comment -->One</div><b>two  </b></body></span>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("div").first().getOrThrow()
        let s3 = "\"Hello Cangjie Lang\""
        let sc = str.text(s3)
        @Assert(34,sc.toString().toRuneArray().size)
        @Assert(sc.toString().contains("Hello Cangjie Lang"),true)
    }

    @TestCase
    func testElement_49_02(): Unit {
        let cou = "<span><body><div><!-- a simple comment -->One</div><b>two  </b></body></span>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("div").first().getOrThrow()
        let sc = str.text("你好仓颉！【】")
        @Assert(21,sc.toString().toRuneArray().size)
        @Assert(sc.toString().contains("你好仓颉！【】"),true)
    }

    @TestCase
    func testElement_49_03(): Unit {
        let cou = "<span><body><div><!-- a simple comment -->One</div><b>two  </b></body></span>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("div").first().getOrThrow()
        let sc = str.text("")
        @Assert(12,sc.toString().toRuneArray().size)
        @Assert(sc.toString().contains("</div>"),true)
    }

    @TestCase
    func testElement_49_04(): Unit {
        let cou = "<span><body><div><!-- a simple comment -->One</div><b>two  </b></body></span>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("div").first().getOrThrow()
        let sc = str.text("STYLE")
        @Assert(19,sc.toString().toRuneArray().size)
        @Assert(sc.toString().contains("STYLE"),true)
    }

    @TestCase
    func testElement_49_05(): Unit {
        let cou = "<span><body><div><!-- a simple comment -->One</div><b>two  </b></body></span>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("div").first().getOrThrow()
        let sc = str.text("data-option")
        @Assert(25,sc.toString().toRuneArray().size)
        @Assert(sc.toString().contains("data-option"),true)
    }

    @TestCase
    func testElement_49_06(): Unit {
        let cou = "<span><body><div><!-- a simple comment -->One</div><b>two  </b></body></span>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("div").first().getOrThrow()
        let sc = str.text("/tt/n")
        @Assert(19,sc.toString().toRuneArray().size)
        @Assert(sc.toString().contains("/tt/n"),true)
    }
}
