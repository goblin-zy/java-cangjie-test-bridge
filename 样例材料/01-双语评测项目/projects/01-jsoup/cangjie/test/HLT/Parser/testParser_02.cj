// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

@Test
public class ParserTest {
    @TestCase
    func testParser_02_01(): Unit {
        let html = "<p>One</p href='no'>\n<!DOCTYPE html>\n&arrgh;<font /><br /><foo"
        let src = Parser.parseBodyFragment(html, "http://example.com")
        @Assert(88,src.toString().size)
    }

    @TestCase
    func testParser_02_02(): Unit {
        let src = Parser.parseBodyFragment("", "http://example.com")
        @Assert(44,src.toString().size)
    }

    @TestCase
    func testParser_02_03(): Unit {
        let html = "<!doctype html><html><head><title>Doctype test</title></head><body></body></html>"
        let src = Parser.parseBodyFragment(html, "")
        @Assert(76,src.toString().size)
    }

    @TestCase
    func testParser_02_04(): Unit {
        let html = "Hello Cang!@#$%^&*()_+:<>?|jie Lang"
        let src = Parser.parseBodyFragment(html, "")
        @Assert(94,src.toString().size)
    }

    @TestCase
    func testParser_02_05(): Unit {
        let html = "Hello Cang!@#$%^&*()_+:<>?|jie Lang"
        var parser: Parser = Parser.htmlParser().settings(ParseSettings.preserveCase)
        let src = parser.parseInput(html, "")
        @Assert(94,src.toString().size)
    }

    @TestCase
    func testParser_02_06(): Unit {
        let html = "Hello Cang!@#$%^&*()_+:<>?|jie Lang"
        var parser: Parser = Parser.htmlParser().settings(ParseSettings(true, true))
        let src = parser.parseInput(html, "")
        @Assert(94,src.toString().size)
    }

    @TestCase
    func testParser_02_07(): Unit {
        let html = "Hello Cang!@#$%^&*()_+:<>?|jie Lang"
        var parser: Parser = Parser.htmlParser().settings(ParseSettings(false, false))
        let src = parser.parseInput(html, "")
        @Assert(94,src.toString().size)
    }
}
