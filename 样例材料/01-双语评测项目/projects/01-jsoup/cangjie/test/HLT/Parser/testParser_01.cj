// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

@Test
public class ParserTest {
    @TestCase
    func testParser_01_01(): Unit {
        var doc = Parser.htmlParser()
        let html = "<p>One</p href='no'>\n<!DOCTYPE html>\n&arrgh;<font /><br /><foo"
        let src = doc.parseInput(html, "http://example.com")
        @Assert(88,src.toString().size)
    }

    @TestCase
    func testParser_01_02(): Unit {
        var doc = Parser.htmlParser()
        let src = doc.parseInput("", "http://example.com")
        @Assert(44,src.toString().size)
    }

    @TestCase
    func testParser_01_03(): Unit {
        var doc = Parser.htmlParser()
        let html = "<p>One</p href='no'>\n<!DOCTYPE html>\n&arrgh;<font /><br /><foo"
        let src = doc.parseInput(html, "")
        @Assert(88,src.toString().size)
    }

    @TestCase
    func testParser_01_04(): Unit {
        var doc = Parser.htmlParser()
        let html = "<!doctype html><html><head><title>Doctype test</title></head><body></body></html>"
        let src = doc.parseInput(html, "你好仓颉！【】")
        @Assert(92,src.toString().size)
    }

    @TestCase
    func testParser_01_05(): Unit {
        var doc = Parser.htmlParser()
        let html = "Hello Cang!@#$%^&*()_+:<>?|jie Lang"
        let src = doc.parseInput(html, "你好仓颉！【】")
        @Assert(94,src.toString().size)
    }
}
