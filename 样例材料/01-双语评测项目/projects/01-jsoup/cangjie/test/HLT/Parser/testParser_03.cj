// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*
import std.math.*

@Test
public class ParserTest {
    @TestCase
    func testParser_03_01(): Unit {
        let html = "Hello Cang!@#$%^&*()_+:<>?|jie Lang"
        var parser: Parser = Parser.htmlParser()
        parser.settings()
        let src = parser.parseInput(html, "你好仓颉！【】")
        @Assert(94,src.toString().toRuneArray().size)
    }

    @TestCase
    func testParser_03_02(): Unit {
        let html = "Hello Cang!@#$%^&*()_+:<>?|jie Lang"
        var parser = Parser.htmlParser()
        parser.settings()
        parser.parseInput(html, "")
        @Assert(false,parser.isTrackErrors())
    }

    @TestCase
    func testParser_03_03(): Unit {
        let html = "Hello Cang!@#$%^&*()_+:<>?|jie Lang"
        var parser = Parser.htmlParser().setTrackErrors(-3)
        let src = Html4cj.parse(html, "http://example.com", parser)
        @Assert(94,src.toString().toRuneArray().size)
    }

    @TestCase
    func testParser_03_04(): Unit {
        let html = "你好仓颉！【】"
        var parser = Parser.htmlParser().setTrackErrors(-1)
        let src = Html4cj.parse(html, "http://example.com", parser)
        @Assert(56,src.toString().toRuneArray().size)
    }

    @TestCase
    func testParser_03_05(): Unit {
        let html = "Hello Cang!@#$%^&*()_+:<>?|jie Lang"
        var parser = Parser.htmlParser().setTrackErrors(0)
        let src = Html4cj.parse(html, "http://example.com", parser)
        @Assert(94,src.toString().toRuneArray().size)
    }

    @TestCase
    func testParser_03_06(): Unit {
        let html = "<p>One</p href='no'>\n<!DOCTYPE html>\n&arrgh;<font />&#33 &amp &#xD800;<br /></div><foo"
        var parser = Parser.htmlParser().setTrackErrors(500)
        let src = Html4cj.parse(html, "http://example.com", parser)
        @Assert(97,src.toString().toRuneArray().size)
    }

    @TestCase
    func testParser_03_07(): Unit {
        let html = "<p>test<br/>test<br/></p>"
        var parser = Parser.htmlParser().setTrackErrors(Int64.Max)
        let src = Html4cj.parse(html, "http://example.com", parser)
        @Assert(76,src.toString().toRuneArray().size)
    }
}
