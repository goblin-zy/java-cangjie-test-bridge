package cangjie_tpc::html4cj

@Test
public class TokeniserStateTest {
    let whiteSpace: Array<Rune> = [r'\t', r'\n', r'\r', r'\f', r' ']
    let quotes: Array<Rune> = [r'\'', r'"']

    @TestCase
    public func ensureSearchArraysAreSorted(): Unit {
        let arrays: Array<Array<Rune>> = [TokeniserState.attributeNameCharsSorted, TokeniserState.attributeValueUnquoted]

        for (array in arrays) {
            let copy = array.clone()
            copy.sort()
            @Assert(array.toString(), copy.toString())
        }
    }

    @TestCase
    public func testCharacterReferenceInRcdata(): Unit {
        let body: String = "<textarea>You&I</textarea>"
        let doc: Document = Html4cj.parse(body)

        // println(doc.html())
        println("---")
        let els: Elements = doc.select("textarea")
        println("---")

        // let els = doc.body().childNode(0)
        // println(doc.body().html())
        // println(els.text())
        @Assert("You&I", els.text())
    }

    @TestCase
    public func testBeforeTagName(): Unit {
        for (c in whiteSpace) {
            let body: String = "<div${c}>test</div>"
            let doc: Document = Html4cj.parse(body)
            let els: Elements = doc.select("div")
            @Assert("test", els.text())
        }
    }

    @TestCase
    public func testEndTagOpen(): Unit {
        var body: String
        var doc: Document
        var els: Elements

        body = "<div>hello world</"
        doc = Html4cj.parse(body)

        els = doc.select("div")
        @Assert("hello world</", els.text())
        body = "<div>hello world</div>"
        doc = Html4cj.parse(body)

        els = doc.select("div")
        @Assert("hello world", els.text())
        body = "<div>fake</></div>"
        doc = Html4cj.parse(body)

        els = doc.select("div")
        @Assert("fake", els.text())
        body = "<div>fake</?</div>"
        doc = Html4cj.parse(body)
        els = doc.select("div")
        @Assert("fake", els.text())
    }

    @TestCase
    public func testRcdataLessthanSign(): Unit {
        var body: String
        var doc: Document
        var els: Elements

        body = "<textarea><fake></textarea>"
        doc = Html4cj.parse(body)

        els = doc.select("textarea")
        @Assert("<fake>", els.text())
        body = "<textarea><open"
        doc = Html4cj.parse(body)

        els = doc.select("textarea")
        @Assert("", els.text())
        body = "<textarea>hello world</?fake</textarea>"
        doc = Html4cj.parse(body)
        els = doc.select("textarea")
        @Assert("hello world</?fake", els.text())
    }

    @TestCase
    public func testRCDATAEndTagName(): Unit {
        for (c in whiteSpace) {
            let body: String = "<textarea>data</textarea${c}>"
            let doc: Document = Html4cj.parse(body)
            let els: Elements = doc.select("textarea")
            @Assert("data", els.text())
        }
    }

    @TestCase
    public func testCommentEndCoverage(): Unit {
        let html: String =
            "<html><head></head><body><img src=foo><!-- <table><tr><td></table> --! --- --><p>Hello</p></body></html>"
        let doc: Document = Html4cj.parse(html)

        let body: Element = doc.body()
        let comment: Comment = (body.childNode(1) as Comment).getOrThrow()
        @Assert(" <table><tr><td></table> --! --- ", comment.getData())
        let p: Element = body.child(1)
        let text: TextNode = (p.childNode(0) as TextNode).getOrThrow()
        @Assert("Hello", text.getWholeText())
    }

    @TestCase
    public func testCommentEndBangCoverage(): Unit {
        let html: String =
            "<html><head></head><body><img src=foo><!-- <table><tr><td></table> --!---!>--><p>Hello</p></body></html>"
        let doc: Document = Html4cj.parse(html)

        let body: Element = doc.body()
        let comment: Comment = (body.childNode(1) as Comment).getOrThrow()
        @Assert(" <table><tr><td></table> --!-", comment.getData())
        let p: Element = body.child(1)
        let text: TextNode = (p.childNode(0) as TextNode).getOrThrow()
        @Assert("Hello", text.getWholeText())
    }

    @TestCase
    public func testPublicIdentifiersWithWhitespace(): Unit {
        let expectedOutput: String = "<!DOCTYPE html PUBLIC \"-//W3C//DTD HTML 4.0//EN\">"
        for (q in quotes) {
            for (ws in whiteSpace) {
                let htmls = [
                    "<!DOCTYPE html${ws}PUBLIC ${q}-//W3C//DTD HTML 4.0//EN${q}>",
                    "<!DOCTYPE html ${ws}PUBLIC ${q}-//W3C//DTD HTML 4.0//EN${q}>",
                    "<!DOCTYPE html PUBLIC${ws}${q}-//W3C//DTD HTML 4.0//EN${q}>",
                    "<!DOCTYPE html PUBLIC ${ws}${q}-//W3C//DTD HTML 4.0//EN${q}>",
                    "<!DOCTYPE html PUBLIC ${q}-//W3C//DTD HTML 4.0//EN${q}${ws}>",
                    "<!DOCTYPE html PUBLIC${q}-//W3C//DTD HTML 4.0//EN${q}${ws}>"
                ]
                for (html in htmls) {
                    let doc: Document = Html4cj.parse(html)
                    @Assert(expectedOutput, doc.childNode(0).outerHtml())
                }
            }
        }
    }

    @TestCase
    public func testSystemIdentifiersWithWhitespace(): Unit {
        let expectedOutput: String = "<!DOCTYPE html SYSTEM \"http://www.w3.org/TR/REC-html40/strict.dtd\">"
        for (q in quotes) {
            for (ws in whiteSpace) {
                let htmls = [
                    "<!DOCTYPE html${ws}SYSTEM ${q}http://www.w3.org/TR/REC-html40/strict.dtd${q}>",
                    "<!DOCTYPE html ${ws}SYSTEM ${q}http://www.w3.org/TR/REC-html40/strict.dtd${q}>",
                    "<!DOCTYPE html SYSTEM${ws}${q}http://www.w3.org/TR/REC-html40/strict.dtd${q}>",
                    "<!DOCTYPE html SYSTEM ${ws}${q}http://www.w3.org/TR/REC-html40/strict.dtd${q}>",
                    "<!DOCTYPE html SYSTEM ${q}http://www.w3.org/TR/REC-html40/strict.dtd${q}${ws}>",
                    "<!DOCTYPE html SYSTEM${q}http://www.w3.org/TR/REC-html40/strict.dtd${q}${ws}>"
                ]
                for (html in htmls) {
                    let doc: Document = Html4cj.parse(html)
                    @Assert(expectedOutput, doc.childNode(0).outerHtml())
                }
            }
        }
    }

    @TestCase
    public func testPublicAndSystemIdentifiersWithWhitespace(): Unit {
        let expectedOutput: String =
            ##"<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.0//EN" "http://www.w3.org/TR/REC-html40/strict.dtd">"##
        for (q in quotes) {
            for (ws in whiteSpace) {
                let htmls = [
                    "<!DOCTYPE html PUBLIC ${q}-//W3C//DTD HTML 4.0//EN${q}${ws}${q}http://www.w3.org/TR/REC-html40/strict.dtd${q}>",
                    "<!DOCTYPE html PUBLIC ${q}-//W3C//DTD HTML 4.0//EN${q}${q}http://www.w3.org/TR/REC-html40/strict.dtd${q}>"
                ]
                for (html in htmls) {
                    let doc: Document = Html4cj.parse(html)
                    @Assert(expectedOutput, doc.childNode(0).outerHtml())
                }
            }
        }
    }

    @TestCase
    public func handlesLessInTagThanAsNewTag(): Unit {
        // out of spec, but clear author intent
        let html: String = "<p\n<p<div id=one <span>Two"
        let doc: Document = Html4cj.parse(html)
        let a = doc.body()
        let b = a.html()
        let c = TextUtil.stripNewlines(b)
        @Assert("<p></p><p></p><div id=\"one\"><span>Two</span></div>", c)
    }

    @TestCase
    public func testUnconsumeAtBufferBoundary(): Unit {
        let triggeringSnippet: String = "<a href=\"\"foo"

        // The "foo" part must be just at the limit.
        // let padding: Array<Rune> = Array(CharacterReader.readAheadLimit - triggeringSnippet.size + 2, repeat: r' ')
        // let paddedSnippet: String = String(padding) + triggeringSnippet
        let paddedSnippet: String = " ".repeat(CharacterReader.readAheadLimit - triggeringSnippet.size + 2) +
            triggeringSnippet
        let errorList: ParseErrorList = ParseErrorList.tracking(1)

        Parser.parseFragment(paddedSnippet, None, "", errorList)

        @Assert(CharacterReader.readAheadLimit - 1, errorList[0].getPosition())
    }

    @TestCase
    public func testUnconsumeAfterBufferUp(): Unit {
        // test for after consume() a bufferUp occurs (look-forward) but then attempts to unconsume. Would throw a "No buffer left to unconsume"
        let triggeringSnippet: String = "<title>One <span>Two"

        // The "<span" part must be just at the limit. The "containsIgnoreCase" scan does a bufferUp, losing the unconsume
        let padding: Array<Rune> = Array(CharacterReader.readAheadLimit - triggeringSnippet.size + 8, repeat: r' ')
        let paddedSnippet: String = String(padding) + triggeringSnippet
        let errorList: ParseErrorList = ParseErrorList.tracking(1)
        Parser.parseFragment(paddedSnippet, None, "", errorList)
        // just asserting we don't get a WTF on unconsume
    }

    @TestCase
    public func testOpeningAngleBracketInsteadOfAttribute(): Unit {
        let triggeringSnippet: String = "<html <"
        let errorList: ParseErrorList = ParseErrorList.tracking(1)

        Parser.parseFragment(triggeringSnippet, None, "", errorList)

        @Assert(6, errorList[0].getPosition())
    }

    @TestCase
    public func testMalformedSelfClosingTag(): Unit {
        let triggeringSnippet: String = "<html /ouch"
        let errorList: ParseErrorList = ParseErrorList.tracking(1)

        Parser.parseFragment(triggeringSnippet, None, "", errorList)

        @Assert(7, errorList[0].getPosition())
    }

    @TestCase
    public func testOpeningAngleBracketInTagName(): Unit {
        let triggeringSnippet: String = "<html<"
        let errorList: ParseErrorList = ParseErrorList.tracking(1)

        Parser.parseFragment(triggeringSnippet, None, "", errorList)

        @Assert(5, errorList[0].getPosition())
    }

    @TestCase
    public func rcData(): Unit {
        let doc: Document = Html4cj.parse("<title>One \0Two</title>")
        println(doc.title())
        @Assert("One ${'\u{FFFD}'}Two", doc.title())
    }

    @TestCase
    public func plaintext(): Unit {
        let doc: Document = Html4cj.parse("<div>One<plaintext><div>Two</plaintext>\0no < Return")
        println(TextUtil.stripNewlines(doc.html()))
        println(
            "<html><head></head><body><div>One<plaintext>&lt;div&gt;Two&lt;/plaintext&gt;${'\u{FFFD}'}no &lt; Return</plaintext></div></body></html>"
        )
        println(doc.html().replace("\n", ""))
        @Assert("<html> <head></head> <body>  <div>   One   <plaintext>&lt;div&gt;Two&lt;/plaintext&gt;${'\u{FFFD}'}no &lt; Return   </plaintext>  </div> </body></html>", doc.html().replace("\n",""))
    }

    @TestCase
    public func nullInTag(): Unit {
        let doc: Document = Html4cj.parse("<di\0v>One</di\0v>Two")
        println(doc.body().html())
        @Assert("<di${'\u{FFFD}'}v>\n One\n</di${'\u{FFFD}'}v>Two", doc.body().html())
    }

    @TestCase
    public func attributeValUnquoted(): Unit {
        var doc: Document = Html4cj.parse("<p name=foo&lt;bar>")

        let p: Element = doc.selectFirst("p").getOrThrow()
        println(p.attr("name"))
        println(doc.body().html())
        @Assert("foo<bar", p.attr("name"))
        doc = Html4cj.parse("<p foo=")
        @Assert("<p foo></p>", doc.body().html())
    }
}
