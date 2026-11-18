// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

@Test
public class ParserTest {
    @TestCase
    func testHtml4cj_01_01(): Unit {
        let html = "<!-- comment --><p><a href='foo'>One</a></p>"
        var src = Html4cj.parseBodyFragment(html, "http://example.com")
        @Assert(96,src.toString().toRuneArray().size)
    }

    @TestCase
    func testHtml4cj_01_02(): Unit {
        let html = "你好仓颉！【】"
        var src = Html4cj.parseBodyFragment(html, "http://example.com")
        @Assert(56,src.toString().toRuneArray().size)
    }

    @TestCase
    func testHtml4cj_01_03(): Unit {
        var src = Html4cj.parseBodyFragment("", "http://example.com")
        @Assert(44,src.toString().toRuneArray().size)
    }

    @TestCase
    func testHtml4cj_01_04(): Unit {
        let html = "<!-- comment --><p><a href='foo'>One</a></p>"
        var src = Html4cj.parseBodyFragment(html, "你好仓颉！【】")
        @Assert(96,src.toString().toRuneArray().size)
    }

    @TestCase
    func testHtml4cj_01_05(): Unit {
        var src = Html4cj.parseBodyFragment("", "http://example.com")
        @Assert(44,src.toString().toRuneArray().size)
    }

    @TestCase
    func testHtml4cj_01_06(): Unit {
        var src = Html4cj.parseBodyFragment("", "Hello Cang!@#$%^&*()_+:<>?|jie Lang")
        @Assert(44,src.toString().toRuneArray().size)
    }
}
