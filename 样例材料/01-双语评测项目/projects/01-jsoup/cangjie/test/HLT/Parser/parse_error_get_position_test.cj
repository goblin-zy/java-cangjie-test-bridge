// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

@Test
public class ParseErrorGetPositionTest {
    @TestCase
    func parseErrorGetPosition01(): Unit {
        let html: String = "<p>One</p href='no'>\n<!DOCTYPE html>\n&arrgh;<font />&#33 &amp &#xD800;<br /></div><foo"
        let parser: Parser = Parser.htmlParser().setTrackErrors(500)
        Html4cj.parse(html, "http://example.com", parser)
        let errors: ParseErrorList = parser.getErrors()
        @Assert(9, errors.size)
        @Assert(20, errors[0].getPosition())
        @Assert(36, errors[1].getPosition())
        @Assert(38, errors[2].getPosition())
        @Assert(52, errors[3].getPosition())
        @Assert(56, errors[4].getPosition())
        @Assert(61, errors[5].getPosition())
        @Assert(70, errors[6].getPosition())
        @Assert(82, errors[7].getPosition())
        @Assert(87, errors[8].getPosition())
    }

    @TestCase
    func parseErrorGetPosition02(): Unit {
        let html: String = "<p>One</p href='no'>\n<!DOCTYPE html>\n&arrgh;<font /><br /><foo"
        let parser: Parser = Parser.htmlParser().setTrackErrors(3)
        parser.parseInput(html, "http://example.com")
        let errors: ParseErrorList = parser.getErrors()
        @Assert(3, errors.size)
        @Assert(20, errors[0].getPosition())
        @Assert(36, errors[1].getPosition())
        @Assert(38, errors[2].getPosition())
    }

    @TestCase
    func parseErrorGetPosition03(): Unit {
        let html: String = "<p>One</p href='no'>&arrgh;<font /><br /><foo"
        let parser: Parser = Parser.htmlParser()
        Html4cj.parse(html, "http://example.com", parser)
        let errors: ParseErrorList = parser.getErrors()
        @Assert(0, errors.size)
    }
}
