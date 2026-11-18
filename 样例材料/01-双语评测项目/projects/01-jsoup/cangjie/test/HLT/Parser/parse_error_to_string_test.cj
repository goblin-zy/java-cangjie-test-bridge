// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

@Test
public class ParseErrorToStringTest {
    @TestCase
    func parseErrorToString01(): Unit {
        let html: String = "<p>One</p href='no'>\n<!DOCTYPE html>\n&arrgh;<font />&#33 &amp &#xD800;<br /></div><foo"
        let parser: Parser = Parser.htmlParser().setTrackErrors(500)
        Html4cj.parse(html, "http://example.com", parser)
        let errors: ParseErrorList = parser.getErrors()
        @Assert(9, errors.size)
        @Assert("<1:21>: Attributes incorrectly present on end tag [/p]", errors[0].toString())
        @Assert("<2:16>: Unexpected Doctype token [<!doctype html>] when in state [InBody]", errors[1].toString())
        @Assert("<3:2>: Invalid character reference: invalid named reference [arrgh]", errors[2].toString())
        @Assert("<3:16>: Tag [font] cannot be self closing; not a void tag", errors[3].toString())
        @Assert("<3:20>: Invalid character reference: missing semicolon on [&#33]", errors[4].toString())
        @Assert("<3:25>: Invalid character reference: missing semicolon on [&amp]", errors[5].toString())
        @Assert("<3:34>: Invalid character reference: character [55296] outside of valid range", errors[6].toString())
        @Assert("<3:46>: Unexpected EndTag token [</div>] when in state [InBody]", errors[7].toString())
        @Assert("<3:51>: Unexpectedly reached end of file (EOF) in input state [TagName]", errors[8].toString())
    }

    @TestCase
    func parseErrorToString02(): Unit {
        let html: String = "<p>One</p href='no'>\n<!DOCTYPE html>\n&arrgh;<font /><br /><foo"
        let parser: Parser = Parser.htmlParser().setTrackErrors(3)
        parser.parseInput(html, "http://example.com")
        let errors: ParseErrorList = parser.getErrors()
        @Assert(3, errors.size)
        @Assert("<1:21>: Attributes incorrectly present on end tag [/p]", errors[0].toString())
        @Assert("<2:16>: Unexpected Doctype token [<!doctype html>] when in state [InBody]", errors[1].toString())
        @Assert("<3:2>: Invalid character reference: invalid named reference [arrgh]", errors[2].toString())
    }

    @TestCase
    func parseErrorToString03(): Unit {
        let html: String = "<p>One</p href='no'>&arrgh;<font /><br /><foo"
        let parser: Parser = Parser.htmlParser()
        Html4cj.parse(html, "http://example.com", parser)
        let errors: ParseErrorList = parser.getErrors()
        @Assert(0, errors.size)
    }
}
