// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

@Test
public class ParserTest {
    @TestCase
    func testParser_04_01(): Unit {
        let html = "Hello Cang!@#$%^&*()_+:<>?|jie Lang"
        var parser: Parser = Parser.htmlParser().setTrackErrors(10)
        parser.parseInput(html, "")
        @Assert(1,parser.getErrors().size)
    }

    @TestCase
    func testParser_04_02(): Unit {
        let html = "<p>One</p href='no'>\n<!DOCTYPE html>\n&arrgh;<font />&#33 &amp &#xD800;<br /></div><foo"
        var parser = Parser.htmlParser()
        parser.parseInput(html, "")
        @Assert(false,parser.isTrackPosition())
    }

    @TestCase
    func testParser_04_03(): Unit {
        let html = "<p>One</p href='no'>\n<!DOCTYPE html>\n&arrgh;<font />&#33 &amp &#xD800;<br /></div><foo"
        var parser = Parser.htmlParser()
        parser.setTrackPosition(true)
        let src = parser.parseInput(html, "")
        @Assert(97,src.toString().toRuneArray().size)
    }

    @TestCase
    func testParser_04_04(): Unit {
        let html = "你好仓颉！【】"
        var parser = Parser.htmlParser()
        parser.setTrackPosition(false)
        let src = parser.parseInput(html, "")
        @Assert(56,src.toString().toRuneArray().size)
    }

    @TestCase
    func testParser_04_05(): Unit {
        let html = "你好仓颉！【】"
        var parser = Parser.htmlParser()
        parser.setTrackPosition(true)
        let src = parser.parseInput(html, "")
        @Assert(56,src.toString().toRuneArray().size)
    }
}
