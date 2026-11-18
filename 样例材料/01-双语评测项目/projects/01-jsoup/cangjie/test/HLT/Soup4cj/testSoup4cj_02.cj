// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

@Test
public class ParserTest {
    @TestCase
    func testHtml4cj_02_01(): Unit {
        let html = "<!-- comment --><p><a href='foo'>One</a></p>"
        var src = Html4cj.parseBodyFragment(html)
        @Assert(96,src.toString().toRuneArray().size)
    }

    @TestCase
    func testHtml4cj_02_02(): Unit {
        let html = "你好仓颉！【】"
        var src = Html4cj.parseBodyFragment(html)
        @Assert(56,src.toString().toRuneArray().size)
    }

    @TestCase
    func testHtml4cj_02_03(): Unit {
        var src = Html4cj.parseBodyFragment("")
        @Assert(44,src.toString().toRuneArray().size)
    }

    @TestCase
    func testHtml4cj_02_04(): Unit {
        let html = "Hello Cang!@#$%^&*()_+:<>?|jie Lang"
        var src = Html4cj.parseBodyFragment(html)
        @Assert(94,src.toString().toRuneArray().size)
    }

    @TestCase
    func testHtml4cj_02_05(): Unit {
        let html = "<html><head><title>Doctype test</title></head><body></body></html>"
        var src = Html4cj.parseBodyFragment(html)
        @Assert(76,src.toString().toRuneArray().size)
    }
}
