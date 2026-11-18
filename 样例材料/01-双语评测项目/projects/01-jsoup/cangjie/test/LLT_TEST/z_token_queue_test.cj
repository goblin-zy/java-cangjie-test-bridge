package cangjie_tpc::html4cj

/*
 * Token queue tests.
 */
@Test
public class TokenQueueTest {
    @TestCase
    public func chompBalanced(): Unit {
        let tq = TokenQueue(":contains(one (two) three) four")
        let pre = tq.consumeTo("(")
        let guts = tq.chompBalanced(r'(', r')')
        let remainder = tq.remainder()

        @Assert(":contains", pre)
        @Assert("one (two) three", guts)
        @Assert(" four", remainder)
    }

    @TestCase
    public func chompEscapedBalanced(): Unit {
        let tq = TokenQueue(":contains(one (two) \\( \\) \\) three) four")
        let pre = tq.consumeTo("(")
        let guts = tq.chompBalanced(r'(', r')')
        let remainder = tq.remainder()

        @Assert(":contains", pre)
        @Assert("one (two) \\( \\) \\) three", guts)
        @Assert("one (two) ( ) ) three", TokenQueue.unescape(guts))
        @Assert(" four", remainder)
    }

    @TestCase
    public func chompBalancedMatchesAsMuchAsPossible(): Unit {
        let tq = TokenQueue("unbalanced(something(or another)) else")
        tq.consumeTo("(")
        let matched = tq.chompBalanced(r'(', r')')
        @Assert("something(or another)", matched)
    }

    @TestCase
    public func unescape(): Unit {
        @Assert("one ( ) \\", TokenQueue.unescape("one \\( \\) \\\\"))
    }

    @TestCase
    public func unescape_2(): Unit {
        @Assert("\\&", TokenQueue.unescape("\\\\\\&"))
    }

    @TestCase
    public func escapeCssIdentifier(): Unit {
        @Assert("one\\#two\\.three\\/four\\\\five", TokenQueue.escapeCssIdentifier("one#two.three/four\\five"))
    }

    @TestCase
    public func chompToIgnoreCase(): Unit {
        let t = "<textarea>one < two </TEXTarea>"
        var tq = TokenQueue(t)
        var data = tq.chompToIgnoreCase("</textarea")
        @Assert("<textarea>one < two ", data)

        tq = TokenQueue("<textarea> one two < three </oops>")
        data = tq.chompToIgnoreCase("</textarea")
        @Assert("<textarea> one two < three </oops>", data)
    }

    @TestCase
    public func addFirst(): Unit {
        let tq = TokenQueue("One Two")
        tq.consumeWord()
        tq.addFirst("Three")
        @Assert("Three Two", tq.remainder())
    }

    @TestCase
    public func consumeToIgnoreSecondCallTest(): Unit {
        let t = "<textarea>one < two </TEXTarea> third </TEXTarea>"
        let tq = TokenQueue(t)
        var data = tq.chompToIgnoreCase("</textarea>")
        @Assert("<textarea>one < two ", data)

        data = tq.chompToIgnoreCase("</textarea>")
        @Assert(" third ", data)
    }

    @TestCase
    public func testNestedQuotes(): Unit {
        validateNestedQuotes(
            "<html><body><a id=\"identifier\" onclick=\"func('arg')\" /></body></html>",
            "a[onclick*=\"('arg\"]"
        )
        validateNestedQuotes(
            "<html><body><a id=\"identifier\" onclick=func('arg') /></body></html>",
            "a[onclick*=\"('arg\"]"
        )
        validateNestedQuotes(
            "<html><body><a id=\"identifier\" onclick='func(\"arg\")' /></body></html>",
            "a[onclick*='(\"arg']"
        )
        validateNestedQuotes(
            "<html><body><a id=\"identifier\" onclick=func(\"arg\") /></body></html>",
            "a[onclick*='(\"arg']"
        )
    }

    private static func validateNestedQuotes(html: String, selector: String) {
        @Assert("#identifier", Html4cj.parse(html).select(selector).first().getOrThrow().cssSelector())
    }

    @TestCase
    public func chompBalancedThrowIllegalArgumentException(): Unit {
        try {
            let tq = TokenQueue("unbalanced(something(or another)) else")
            tq.consumeTo("(")
            tq.chompBalanced(r'(', r'+')
            throw Exception("should have thrown IllegalArgumentException")
        } catch (expected: ValidationException) {
            @Assert("Did not find balanced marker at 'something(or another)) else'", expected.message)
        }
    }

    @TestCase
    public func testQuotedPattern(): Unit {
        let doc = Html4cj.parse(#"<div>\) foo1</div><div>( foo2</div><div>1) foo3</div>"#)
        let s1 = doc.select(#"div:matches(\\\))"#)[0].childNode(0).toString()
        @Assert("\n\\) foo1", s1)
        let s2 = doc.select(#"div:matches(\()"#)[0].childNode(0).toString()
        @Assert("\n( foo2", s2)
        let s3 = doc.select(#"div:matches(1\))"#)[0].childNode(0).toString()
        @Assert("\n1) foo3", s3)
    }

    @TestCase
    public func consumeEscapedTag(): Unit {
        let q = TokenQueue("p\\\\p p\\.p p\\:p p\\!p")

        @Assert("p\\p", q.consumeElementSelector())
        @Assert(q.consumeWhitespace())

        @Assert("p.p", q.consumeElementSelector())
        @Assert(q.consumeWhitespace())

        @Assert("p:p", q.consumeElementSelector())
        @Assert(q.consumeWhitespace())

        @Assert("p!p", q.consumeElementSelector())
        @Assert(q.isEmpty())
    }

    @TestCase
    public func consumeEscapedId(): Unit {
        let q = TokenQueue("i\\.d i\\\\d")

        @Assert("i.d", q.consumeCssIdentifier())
        @Assert(q.consumeWhitespace())

        @Assert("i\\d", q.consumeCssIdentifier())
        @Assert(q.isEmpty())
    }
}
