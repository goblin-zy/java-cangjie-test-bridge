// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

@Test
public class ParseErrorGetCursorPosTest {
    @TestCase
    func parseErrorGetCursorPos01(): Unit {
        let html: String = "<p>One</p href='no'>\n<!DOCTYPE html>\n&arrgh;<font />&#33 &amp &#xD800;<br /></div><foo"
        let parser: Parser = Parser.htmlParser().setTrackErrors(500)
        Html4cj.parse(html, "http://example.com", parser)
        let errors: ParseErrorList = parser.getErrors()
        @Assert(9, errors.size)
        @Assert("1:21", errors[0].getCursorPos())
        @Assert("2:16", errors[1].getCursorPos())
        @Assert("3:2", errors[2].getCursorPos())
        @Assert("3:16", errors[3].getCursorPos())
        @Assert("3:20", errors[4].getCursorPos())
        @Assert("3:25", errors[5].getCursorPos())
        @Assert("3:34", errors[6].getCursorPos())
        @Assert("3:46", errors[7].getCursorPos())
        @Assert("3:51", errors[8].getCursorPos())
    }

    @TestCase
    func parseErrorGetCursorPos02(): Unit {
        let html: String = "<p>One</p href='no'>\n<!DOCTYPE html>\n&arrgh;<font /><br /><foo"
        let parser: Parser = Parser.htmlParser().setTrackErrors(3)
        parser.parseInput(html, "http://example.com")
        let errors: ParseErrorList = parser.getErrors()
        @Assert(3, errors.size)
        @Assert("1:21", errors[0].getCursorPos())
        @Assert("2:16", errors[1].getCursorPos())
        @Assert("3:2", errors[2].getCursorPos())
    }

    @TestCase
    func parseErrorGetCursorPos03(): Unit {
        let html: String = "<p>One</p href='no'>&arrgh;<font /><br /><foo"
        let parser: Parser = Parser.htmlParser()
        Html4cj.parse(html, "http://example.com", parser)
        let errors: ParseErrorList = parser.getErrors()
        @Assert(0, errors.size)
    }
}
