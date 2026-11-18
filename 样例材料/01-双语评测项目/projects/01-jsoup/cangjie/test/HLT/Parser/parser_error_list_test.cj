// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*
import std.math.*

@Test
public class ParseErrorListTest {
    @TestCase
    func parseErrorListNoTracking01(): Unit {
        let errors: ParseErrorList = ParseErrorList.noTracking()
        @Assert(0, errors.size)
        var isBool: Bool = false
        try {
            errors[1]
        } catch (e: IndexOutOfBoundsException) {
            isBool = true
            @Assert(e.message, "index: 1, size: 0")
        }
        @Assert(isBool, true)
    }

    @TestCase
    func parseErrorListTracking03(): Unit {
        let errors: ParseErrorList = ParseErrorList.tracking(20)
        @Assert(0, errors.size)
        var isBool: Bool = false
        try {
            errors[0]
        } catch (e: IndexOutOfBoundsException) {
            isBool = true
            @Assert(e.message, "index: 0, size: 0")
        }
        @Assert(isBool, true)
    }

    @TestCase
    func parseErrorListTracking04(): Unit {
        let errors: ParseErrorList = ParseErrorList.tracking(Int64.Max)
        @Assert(0, errors.size)
        var isBool: Bool = false
        try {
            errors[1]
        } catch (e: IndexOutOfBoundsException) {
            isBool = true
            @Assert(e.message, "index: 1, size: 0")
        }
        @Assert(isBool, true)
    }

    @TestCase
    func parseErrorList01(): Unit {
        let html: String = "<p>One</p href='no'>\n<!DOCTYPE html>\n&arrgh;<font />&#33 &amp &#xD800;<br /></div><foo"
        let parser: Parser = Parser.htmlParser().setTrackErrors(500)
        Html4cj.parse(html, "http://example.com", parser)
        let errors: ParseErrorList = parser.getErrors()
        var iterator: Iterator<ParseError> = errors.iterator()
        @Assert(iterator.next().getOrThrow().getCursorPos(), errors[0].getCursorPos())
        @Assert(iterator.next().getOrThrow().getCursorPos(), errors[1].getCursorPos())
        @Assert(iterator.next().getOrThrow().getCursorPos(), errors[2].getCursorPos())
        @Assert(iterator.next().getOrThrow().getCursorPos(), errors[3].getCursorPos())
        @Assert(iterator.next().getOrThrow().getCursorPos(), errors[4].getCursorPos())
        @Assert(iterator.next().getOrThrow().getCursorPos(), errors[5].getCursorPos())
        @Assert(iterator.next().getOrThrow().getCursorPos(), errors[6].getCursorPos())
        @Assert(iterator.next().getOrThrow().getCursorPos(), errors[7].getCursorPos())
        @Assert(iterator.next().getOrThrow().getCursorPos(), errors[8].getCursorPos())
    }

    @TestCase
    func parseErrorList02(): Unit {
        let html: String = "<p>One</p href='no'>\n<!DOCTYPE html>\n&arrgh;<font /><br /><foo"
        let parser: Parser = Parser.htmlParser().setTrackErrors(3)
        parser.parseInput(html, "http://example.com")
        let errors: ParseErrorList = parser.getErrors()
        var iterator: Iterator<ParseError> = errors.iterator()
        @Assert(iterator.next().getOrThrow().getCursorPos(), errors[0].getCursorPos())
        @Assert(iterator.next().getOrThrow().getCursorPos(), errors[1].getCursorPos())
        @Assert(iterator.next().getOrThrow().getCursorPos(), errors[2].getCursorPos())
    }
}
