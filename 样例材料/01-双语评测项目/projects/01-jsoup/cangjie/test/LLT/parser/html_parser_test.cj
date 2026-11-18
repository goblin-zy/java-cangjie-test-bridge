// RESOURCES: htmltests/table-invalid-elements.html
// RESOURCES: htmltests/table-polymer-template.html
// RESOURCES: htmltests/comments.html
// RESOURCES: htmltests/character-reader-buffer.html.gz
// DEPENDENCE: text_util_test.cj
// EXEC: cjc %import-path %L %l %f text_util_test.cj -g --test
// EXEC: ./main
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.unittest.testmacro.*
import std.fs.*
import std.io.*
import std.time.*
import std.collection.*

main(): Int64 {
    // let tester = HtmlParserTest()
    // tester.execute()
    // tester.printResult()
    // tester.parsesSimpleDocument()
    // tester.parsesRoughAttributes()
    // tester.dropsDuplicateAttributes()
    // tester.retainsAttributesOfDifferentCaseIfSensitive()
    // tester.parsesQuiteRoughAttributes()
    // tester.parsesComments()
    // tester.parsesUnterminatedComments()
    // tester.allDashCommentsAreNotParseErrors()
    // tester.dropsUnterminatedTag()
    // tester.dropsUnterminatedAttribute()
    // tester.parsesUnterminatedTextarea()
    // tester.parsesUnterminatedOption()
    // tester.testSelectWithOption()
    // tester.testSpaceAfterTag()
    // tester.createsDocumentStructure()
    // tester.createsStructureFromBodySnippet()
    // tester.handlesEscapedData()
    // tester.handlesDataOnlyTags()
    // tester.handlesTextAfterData()
    // tester.handlesTextArea()
    // tester.preservesSpaceInTextArea()
    // tester.preservesSpaceInScript()
    // tester.doesNotCreateImplicitLists()
    // tester.discardsNakedTds()
    // tester.handlesNestedImplicitTable()
    // tester.handlesWhatWgExpensesTableExample()
    // tester.handlesTbodyTable()
    // tester.handlesImplicitCaptionClose()
    // tester.noTableDirectInTable()
    // tester.ignoresDupeEndTrTag()
    // tester.handlesBaseTags()
    // tester.handlesProtocolRelativeUrl()
    // tester.handlesCdata()
    // tester.roundTripsCdata()
    // tester.handlesCdataAcrossBuffer()
    // tester.handlesCdataInScript()
    // tester.handlesUnclosedCdataAtEOF()
    // tester.handleCDataInText()
    // tester.cdataNodesAreTextNodes()
    // tester.handlesInvalidStartTags()
    // tester.handlesUnknownTags()
    // tester.handlesUnknownInlineTags()
    // tester.parsesBodyFragment()
    // tester.parseBodyIsIndexNoAttributes()
    // tester.handlesUnknownNamespaceTags()
    // tester.handlesKnownEmptyBlocks()
    // tester.handlesKnownEmptyNoFrames()
    // tester.handlesKnownEmptyStyle()
    // tester.handlesKnownEmptyTitle()
    // tester.handlesKnownEmptyIframe()
    // tester.handlesSolidusAtAttributeEnd()
    // tester.handlesMultiClosingBody()
    // tester.handlesUnclosedDefinitionLists()
    // tester.handlesBlocksInDefinitions()
    // tester.handlesFrames()
    // tester.ignoresContentAfterFrameset()
    // tester.handlesJavadocFont()
    // tester.handlesBaseWithoutHref()
    // tester.normalisesDocument()
    // tester.normalisesEmptyDocument()
    // tester.normalisesHeadlessBody()
    // tester.normalisedBodyAfterContent()
    // tester.findsCharsetInMalformedMeta()
    // tester.testHgroup()
    // tester.testRelaxedTags()
    // tester.testHeaderContents()
    // tester.testSpanContents()
    // tester.testNoImagesInNoScriptInHead()
    // tester.testUnclosedNoscriptInHead()
    // tester.testAFlowContents()
    // tester.testFontFlowContents()
    // tester.handlesMisnestedTagsBI()
    // tester.handlesMisnestedTagsBP()
    // tester.handlesMisnestedAInDivs()
    // tester.handlesUnexpectedMarkupInTables()
    // tester.handlesUnclosedFormattingElements()
    // tester.handlesUnclosedAnchors()
    // tester.reconstructFormattingElements()
    // tester.reconstructFormattingElementsInTable()
    // tester.commentBeforeHtml()
    // tester.emptyTdTag()
    // tester.handlesSolidusInA()
    // tester.handlesSpanInTbody()
    // tester.handlesUnclosedTitleAtEof()
    // tester.handlesUnclosedTitle()
    // tester.handlesUnclosedScriptAtEof()
    // tester.handlesUnclosedRawtextAtEof()
    // tester.noImplicitFormForTextAreas()
    // tester.handlesEscapedScript()
    // tester.handles0CharacterAsText()
    // tester.handlesNullInData()
    // tester.handlesNullInComments()
    // tester.handlesNewlinesAndWhitespaceInTag()
    // tester.handlesWhitespaceInoDocType()
    // tester.tracksErrorsWhenRequested()
    // tester.tracksLimitedErrorsWhenRequested()
    // tester.noErrorsByDefault()
    // tester.optionalPClosersAreNotErrors()
    // tester.handlesCommentsInTable()
    // tester.handlesQuotesInCommentsInScripts()
    // tester.handleNullContextInParseFragment()
    // tester.doesNotFindShortestMatchingEntity()
    // tester.relaxedBaseEntityMatchAndStrictExtendedMatch()
    // tester.handlesXmlDeclarationAsBogusComment()
    // tester.handlesTagsInTextarea()
    // tester.createsFormElements()
    // tester.associatedFormControlsWithDisjointForms()
    // tester.handlesInputInTable()
    // tester.convertsImageToImg()
    // tester.handlesInvalidDoctypes()
    // tester.handlesManyChildren()
    // tester.testInvalidTableContents()
    // tester.testNormalisesIsIndex()
    // tester.testReinsertionModeForThCelss()
    // tester.testUsingSingleQuotesInQueries()
    // tester.testSupportsNonAsciiTags()
    // tester.testSupportsPartiallyNonAsciiTags()
    // tester.testFragment()
    // tester.testHtmlLowerCase()
    // tester.testHtmlLowerCaseAttributesOfVoidTags()
    // tester.testHtmlLowerCaseAttributesForm()
    // tester.canPreserveTagCase()
    // tester.canPreserveAttributeCase()
    // tester.canPreserveBothCase()
    // tester.handlesControlCodeInAttributeName()
    // tester.caseSensitiveParseTree()
    // tester.caseInsensitiveParseTree()
    // tester.preservedCaseLinksCantNest()
    // tester.normalizesDiscordantTags()
    // tester.selfClosingVoidIsNotAnError()
    // tester.selfClosingOnNonvoidIsError()
    // tester.testTemplateInsideTable()
    // tester.testHandlesDeepSpans()
    // tester.commentAtEnd()
    // tester.preSkipsFirstNewline()
    // tester.handlesXmlDeclAndCommentsBeforeDoctype()

    // // tester.fallbackToUtfIfCantEncode()
    // // tester.characterReaderBuffer()
    // tester.selfClosingTextAreaDoesntLeaveDroppings()
    // tester.testNoSpuriousSpace()
    // tester.pTagsGetIndented()
    // tester.indentRegardlessOfCase()
    // tester.testH20()
    // tester.testUNewlines()
    // tester.testFarsi()
    // tester.testStartOptGroup()

    // // tester.readerClosedAfterParse()
    // tester.scriptInDataNode()
    // tester.textareaValue()
    // tester.preserveWhitespaceInHead()
    // tester.handleContentAfterBody()
    // tester.preservesTabs()
    // tester.wholeTextTreatsBRasNewline()
    // tester.canDetectAutomaticallyAddedElements()
    // tester.canSetHtmlOnCreatedTableElements()
    // tester.parseFragmentOnCreatedDocument()
    // tester.nestedPFragments()
    // tester.nestedAnchorAdoption()
    // tester.tagsMustStartWithAscii()
    // tester.htmlOutputCorrectsInvalidAttributeNames()
    // tester.templateInHead()
    // tester.nestedTemplateInBody()
    // tester.canSelectIntoTemplate()
    // tester.tableRowFragment()
    // tester.templateTableRowFragment()
    // tester.templateNotInTableRowFragment()
    // tester.templateFragment()
    // tester.templateInferredForm()
    // tester.trimNormalizeElementNamesInBuilder()
    // tester.errorsBeforeHtml()
    // tester.afterHeadReAdds()
    // tester.mergeHtmlAttributesFromBody()
    // tester.mergeHtmlNoAttributesFromBody()

    0
}

/*
 * Tests for the Parser
 */
@Test
public class HtmlParserTest {
    @TestCase
    public func parsesSimpleDocument(): Unit {
        let html: String =
            "<html><head><title>First!</title></head><body><p>First post! <img src=\"foo.png\" /></p></body></html>"
        let doc: Document = Html4cj.parse(html)

        // need a better way to verify these:
        let p: Element = doc.body().child(0)
        @Assert("p", p.tagName())
        let img: Element = p.child(0)
        @Assert("foo.png", img.attr("src"))
        @Assert("img", img.tagName())
    }

    @TestCase
    public func parsesRoughAttributes(): Unit {
        let html: String =
            "<html><head><title>First!</title></head><body><p class=\"foo > bar\">First post! <img src=\"foo.png\" /></p></body></html>"
        let doc: Document = Html4cj.parse(html)

        // need a better way to verify these:
        let p: Element = doc.body().child(0)
        @Assert("p", p.tagName())
        @Assert("foo > bar", p.attr("class"))
    }

    @TestCase
    public func dropsDuplicateAttributes(): Unit {
        let html: String = "<p One=One ONE=Two Two=two one=Three One=Four two=Five>Text</p>"
        let parser: Parser = Parser.htmlParser().setTrackErrors(10)
        let doc: Document = parser.parseInput(html, "")
        let p: Element = doc.selectFirst("p").getOrThrow()
        @Assert("<p one=\"One\" two=\"two\">Text</p>", p.outerHtml()) // normalized names due to lower casing

        @Assert(1, parser.getErrors().size)
        @Assert("Dropped duplicate attribute(s) in tag [p]", parser.getErrors()[0].getErrorMessage())
    }

    @TestCase
    public func retainsAttributesOfDifferentCaseIfSensitive(): Unit {
        let html: String = "<p One=One One=Two one=Three two=Four two=Five Two=Six>Text</p>"
        let parser: Parser = Parser.htmlParser().settings(ParseSettings.preserveCase)
        let doc: Document = parser.parseInput(html, "")
        @Assert("<p One=\"One\" one=\"Three\" two=\"Four\" Two=\"Six\">Text</p>", doc.selectFirst("p").getOrThrow().outerHtml())
    }

    @TestCase
    public func parsesQuiteRoughAttributes(): Unit {
        let html: String = "<p =a>One<a <p>Something</p>Else"

        // this (used to; now gets cleaner) gets a <p> with attr '=a' and an <a tag with an attribute named '<p'; and then auto-recreated
        var doc: Document = Html4cj.parse(html)

        // NOTE: per spec this should be the test case. but impacts too many ppl
        @Assert("<p a>One<a></a></p><p><a>Something</a></p><a>Else</a>", TextUtil.stripNewlines(doc.body().html()))

        doc = Html4cj.parse("<p .....>")
        @Assert("<p .....></p>", doc.body().html())
    }

    @TestCase
    public func parsesComments(): Unit {
        let html: String =
            "<html><head></head><body><img src=foo><!-- <table><tr><td></table> --><p>Hello</p></body></html>"
        let doc: Document = Html4cj.parse(html)

        let body: Element = doc.body()
        let comment: Comment = (body.childNode(1) as Comment).getOrThrow() // comment should not be sub of img, as it's an empty tag
        @Assert(" <table><tr><td></table> ", comment.getData())
        let p: Element = body.child(1)
        let text: TextNode = (p.childNode(0) as TextNode).getOrThrow()
        @Assert("Hello", text.getWholeText())
    }

    @TestCase
    public func parsesUnterminatedComments(): Unit {
        let html: String = "<p>Hello<!-- <tr><td>"
        let doc: Document = Html4cj.parse(html)
        let p: Element = doc.getElementsByTag("p")[0]
        @Assert("Hello", p.text())
        let text: TextNode = (p.childNode(0) as TextNode).getOrThrow()
        @Assert("Hello", text.getWholeText())
        let comment: Comment = (p.childNode(1) as Comment).getOrThrow()
        @Assert(" <tr><td>", comment.getData())
    }

    @TestCase
    public func allDashCommentsAreNotParseErrors(): Unit {
        // https://github.com/jhy/jsoup/issues/1667
        // <!-----> is not a parse error
        let html: String = "<!------>"
        let parser: Parser = Parser.htmlParser().setTrackErrors(10)
        let doc: Document = Html4cj.parse(html, parser)
        let comment: Comment = (doc.childNode(0) as Comment).getOrThrow()
        @Assert("--", comment.getData())
        @Assert(0, parser.getErrors().size)
    }

    @TestCase
    public func dropsUnterminatedTag(): Unit {
        // jsoup used to parse this to <p>, but whatwg, webkit will drop.
        let h1: String = "<p"
        var doc: Document = Html4cj.parse(h1)
        @Assert(0, doc.getElementsByTag("p").size)
        @Assert("", doc.text())

        let h2: String = "<div id=1<p id='2'"
        doc = Html4cj.parse(h2)
        @Assert("", doc.text())
    }

    @TestCase
    public func dropsUnterminatedAttribute(): Unit {
        // jsoup used to parse this to <p id="foo">, but whatwg, webkit will drop.
        let h1: String = "<p id=\"foo"
        let doc: Document = Html4cj.parse(h1)
        @Assert("", doc.text())
    }

    @TestCase
    public func parsesUnterminatedTextarea(): Unit {
        // don't parse right to end, but break on <p>
        let doc: Document = Html4cj.parse("<body><p><textarea>one<p>two")
        let t: Element = doc.select("textarea").first().getOrThrow()
        @Assert("one", t.text())
        @Assert("two", doc.select("p")[1].text())
    }

    @TestCase
    public func parsesUnterminatedOption(): Unit {
        // bit weird this -- browsers and spec get stuck in select until there's a </select>
        let doc: Document = Html4cj.parse("<body><p><select><option>One<option>Two</p><p>Three</p>")
        let options: Elements = doc.select("option")
        @Assert(2, options.size)
        @Assert("One", options.first().getOrThrow().text())
        @Assert("TwoThree", options.last().getOrThrow().text())
    }

    @TestCase
    public func testSelectWithOption(): Unit {
        let parser: Parser = Parser.htmlParser()
        parser.setTrackErrors(10)
        parser.parseInput("<select><option>Option 1</option></select>", "http://jsoup.org")
        @Assert(0, parser.getErrors().size)
    }

    @TestCase
    public func testSpaceAfterTag(): Unit {
        let doc: Document = Html4cj.parse("<div > <a name=\"top\"></a ><p id=1 >Hello</p></div>")
        @Assert("<div><a name=\"top\"></a><p id=\"1\">Hello</p></div>", TextUtil.stripNewlines(doc.body().html()))
    }

    @TestCase
    public func createsDocumentStructure(): Unit {
        let html: String = "<meta name=keywords /><link rel=stylesheet /><title>jsoup</title><p>Hello world</p>"
        let doc: Document = Html4cj.parse(html)
        let head: Element = doc.head()
        let body: Element = doc.body()

        @Assert(1, doc.children().size) // root node: contains html node
        @Assert(2, doc.child(0).children().size) // html node: head and body
        @Assert(3, head.children().size)
        @Assert(1, body.children().size)

        @Assert("keywords", head.getElementsByTag("meta")[0].attr("name"))
        @Assert(0, body.getElementsByTag("meta").size)
        @Assert("jsoup", doc.title())
        @Assert("Hello world", body.text())
        @Assert("Hello world", body.children()[0].text())
    }

    @TestCase
    public func createsStructureFromBodySnippet(): Unit {
        // the bar baz stuff naturally goes into the body, but the 'foo' goes into root, and the normalisation routine
        // needs to move into the start of the body
        let html: String = "foo <b>bar</b> baz"
        let doc: Document = Html4cj.parse(html)
        @Assert("foo bar baz", doc.text())
    }

    @TestCase
    public func handlesEscapedData(): Unit {
        let html: String = "<div title='Surf &amp; Turf'>Reef &amp; Beef</div>"
        let doc: Document = Html4cj.parse(html)
        let div: Element = doc.getElementsByTag("div")[0]

        @Assert("Surf & Turf", div.attr("title"))
        @Assert("Reef & Beef", div.text())
    }

    @TestCase
    public func handlesDataOnlyTags(): Unit {
        let t: String = "<style>font-family: bold</style>"
        let tels: Elements = Html4cj.parse(t).getElementsByTag("style")
        @Assert("font-family: bold", tels[0].data())
        @Assert("", tels[0].text())

        let s: String = "<p>Hello</p><script>obj.insert('<a rel=\"none\" />');\ni++;</script><p>There</p>"
        let doc: Document = Html4cj.parse(s)
        @Assert("Hello There", doc.text())
        @Assert("obj.insert('<a rel=\"none\" />');\ni++;", doc.data())
    }

    @TestCase
    public func handlesTextAfterData(): Unit {
        let h: String = "<html><body>pre <script>inner</script> aft</body></html>"
        let doc: Document = Html4cj.parse(h)
        @Assert("<html><head></head><body>pre <script>inner</script> aft</body></html>", TextUtil.stripNewlines(doc.html()))
    }

    @TestCase
    public func handlesTextArea(): Unit {
        let doc: Document = Html4cj.parse("<textarea>Hello</textarea>")
        let els: Elements = doc.select("textarea")
        @Assert("Hello", els.text())
        @Assert("Hello", els.val())
    }

    @TestCase
    public func preservesSpaceInTextArea(): Unit {
        // preserve because the tag is marked as preserve white space
        let doc: Document = Html4cj.parse("<textarea>\n\tOne\n\tTwo\n\tThree\n</textarea>")
        let expect: String = "One\n\tTwo\n\tThree" // the leading and trailing spaces are dropped as a convenience to authors
        let el: Element = doc.select("textarea").first().getOrThrow()
        @Assert(expect, el.text())
        @Assert(expect, el.val())
        @Assert(expect, el.html())
        @Assert("<textarea>\n\t" + expect + "\n</textarea>", el.outerHtml()) // but preserved in round-trip html
    }

    @TestCase
    public func preservesSpaceInScript(): Unit {
        // preserve because it's content is a data node
        let doc: Document = Html4cj.parse("<script>\nOne\n\tTwo\n\tThree\n</script>")
        let expect: String = "\nOne\n\tTwo\n\tThree\n"
        let el: Element = doc.select("script").first().getOrThrow()
        @Assert(expect, el.data())
        @Assert("One\n\tTwo\n\tThree", el.html())
        @Assert("<script>" + expect + "</script>", el.outerHtml())
    }

    @TestCase
    public func doesNotCreateImplicitLists(): Unit {
        // old jsoup used to wrap this in <ul>, but that's not to spec
        let h: String = "<li>Point one<li>Point two"
        let doc: Document = Html4cj.parse(h)
        let ol: Elements = doc.select("ul") // should NOT have created a default ul.
        @Assert(0, ol.size)
        let lis: Elements = doc.select("li")
        @Assert(2, lis.size)

        @Assert("body", lis.first().getOrThrow().parentElement().getOrThrow().tagName())

        // no fiddling with non-implicit lists
        let h2: String = "<ol><li><p>Point the first<li><p>Point the second"
        let doc2: Document = Html4cj.parse(h2)

        @Assert(0, doc2.select("ul").size)
        @Assert(1, doc2.select("ol").size)
        @Assert(2, doc2.select("ol li").size)
        @Assert(2, doc2.select("ol li p").size)
        @Assert(1, doc2.select("ol li")[0].children().size) // one p in first li
    }

    @TestCase
    public func discardsNakedTds(): Unit {
        // jsoup used to make this into an implicit table; but browsers make it into a text run
        let h: String = "<td>Hello<td><p>There<p>now"
        let doc: Document = Html4cj.parse(h)
        @Assert("Hello<p>There</p><p>now</p>", TextUtil.stripNewlines(doc.body().html()))
        // <tbody> is introduced if no implicitly creating table, but allows tr to be directly under table
    }

    @TestCase
    public func handlesNestedImplicitTable(): Unit {
        let doc: Document = Html4cj.parse(
            "<table><td>1</td></tr> <td>2</td></tr> <td> <table><td>3</td> <td>4</td></table> <tr><td>5</table>"
        )
        @Assert("<table><tbody><tr><td>1</td></tr><tr><td>2</td></tr><tr><td><table><tbody><tr><td>3</td><td>4</td></tr></tbody></table></td></tr><tr><td>5</td></tr></tbody></table>", TextUtil.stripNewlines(doc.body().html()))
    }

    @TestCase
    public func handlesWhatWgExpensesTableExample(): Unit {
        // http://www.whatwg.org/specs/web-apps/current-work/multipage/tabular-data.html#examples-0
        let doc: Document = Html4cj.parse(
            "<table> <colgroup> <col> <colgroup> <col> <col> <col> <thead> <tr> <th> <th>2008 <th>2007 <th>2006 <tbody> <tr> <th scope=rowgroup> Research and development <td> $ 1,109 <td> $ 782 <td> $ 712 <tr> <th scope=row> Percentage of net sales <td> 3.4% <td> 3.3% <td> 3.7% <tbody> <tr> <th scope=rowgroup> Selling, general, and administrative <td> $ 3,761 <td> $ 2,963 <td> $ 2,433 <tr> <th scope=row> Percentage of net sales <td> 11.6% <td> 12.3% <td> 12.6% </table>"
        )
        @Assert("<table><colgroup><col></colgroup><colgroup><col><col><col></colgroup><thead><tr><th></th><th>2008</th><th>2007</th><th>2006</th></tr></thead><tbody><tr><th scope=\"rowgroup\">Research and development</th><td>$ 1,109</td><td>$ 782</td><td>$ 712</td></tr><tr><th scope=\"row\">Percentage of net sales</th><td>3.4%</td><td>3.3%</td><td>3.7%</td></tr></tbody><tbody><tr><th scope=\"rowgroup\">Selling, general, and administrative</th><td>$ 3,761</td><td>$ 2,963</td><td>$ 2,433</td></tr><tr><th scope=\"row\">Percentage of net sales</th><td>11.6%</td><td>12.3%</td><td>12.6%</td></tr></tbody></table>", TextUtil.stripNewlines(doc.body().html()))
    }

    @TestCase
    public func handlesTbodyTable(): Unit {
        let doc: Document = Html4cj.parse(
            "<html><head></head><body><table><tbody><tr><td>aaa</td><td>bbb</td></tr></tbody></table></body></html>"
        )
        @Assert("<table><tbody><tr><td>aaa</td><td>bbb</td></tr></tbody></table>", TextUtil.stripNewlines(doc.body().html()))
    }

    @TestCase
    public func handlesImplicitCaptionClose(): Unit {
        let doc: Document = Html4cj.parse("<table><caption>A caption<td>One<td>Two")
        @Assert("<table><caption>A caption</caption><tbody><tr><td>One</td><td>Two</td></tr></tbody></table>", TextUtil.stripNewlines(doc.body().html()))
    }

    @TestCase
    public func noTableDirectInTable(): Unit {
        let doc: Document = Html4cj.parse("<table> <td>One <td><table><td>Two</table> <table><td>Three")
        @Assert("<table><tbody><tr><td>One</td><td><table><tbody><tr><td>Two</td></tr></tbody></table><table><tbody><tr><td>Three</td></tr></tbody></table></td></tr></tbody></table>",
                TextUtil.stripNewlines(doc.body().html()))
    }

    @TestCase
    public func ignoresDupeEndTrTag(): Unit {
        let doc: Document = Html4cj.parse(
            "<table><tr><td>One</td><td><table><tr><td>Two</td></tr></tr></table></td><td>Three</td></tr></table>"
        ) // two </tr></tr>, must ignore or will close table
        @Assert("<table><tbody><tr><td>One</td><td><table><tbody><tr><td>Two</td></tr></tbody></table></td><td>Three</td></tr></tbody></table>",
                TextUtil.stripNewlines(doc.body().html()))
    }

    @TestCase
    public func handlesBaseTags(): Unit {
        // only listen to the first base href
        let h: String = "<a href=1>#</a><base href='/2/'><a href='3'>#</a><base href='http://bar'><a href=/4>#</a>"
        let doc: Document = Html4cj.parse(h, "http://foo/")
        @Assert("http://foo/2/", doc.baseUri()) // gets set once, so doc and descendants have first only
        let anchors: Elements = doc.getElementsByTag("a")
        @Assert(3, anchors.size)
        @Assert("http://foo/2/", anchors[0].baseUri())
        @Assert("http://foo/2/", anchors[1].baseUri())
        @Assert("http://foo/2/", anchors[2].baseUri())
        @Assert("http://foo/2/1", anchors[0].absUrl("href"))
        @Assert("http://foo/2/3", anchors[1].absUrl("href"))

        @Assert("http://foo/4", anchors[2].absUrl("href"))
    }

    @TestCase
    public func handlesProtocolRelativeUrl(): Unit {
        let base: String = "https://example.com/"
        let html: String = "<img src='//example.net/img.jpg'>"
        let doc: Document = Html4cj.parse(html, base)
        let el: Element = doc.select("img").first().getOrThrow()
        @Assert("https://example.net/img.jpg", el.absUrl("src"))
    }

    @TestCase
    public func handlesCdata(): Unit {
        // todo: as this is html namespace, should actually treat as bogus comment, not cdata. keep as cdata for now
        let h: String = "<div id=1><![CDATA[<html>\n <foo><&amp;]]></div>" // the &amp; in there should remain literal
        let doc: Document = Html4cj.parse(h)
        let div: Element = doc.getElementById("1").getOrThrow()
        @Assert("<html>\n <foo><&amp;", div.text())
        @Assert(0, div.children().size)
        @Assert(1, div.childNodeSize()) // no elements, one text node
    }

    @TestCase
    public func roundTripsCdata(): Unit {
        let h: String = "<div id=1><![CDATA[\n<html>\n <foo><&amp;]]></div>"
        let doc: Document = Html4cj.parse(h)
        let div: Element = doc.getElementById("1").getOrThrow()
        @Assert("<html>\n <foo><&amp;", div.text())
        @Assert(0, div.children().size)
        @Assert(1, div.childNodeSize()) // no elements, one text node

        @Assert("<div id=\"1\"><![CDATA[\n<html>\n <foo><&amp;]]>\n</div>", div.outerHtml())

        let cdata: CDataNode = (div.textNodes()[0] as CDataNode).getOrThrow()
        @Assert("\n<html>\n <foo><&amp;", cdata.text())
    }

    @TestCase
    public func handlesCdataAcrossBuffer(): Unit {
        let sb: StringBuilder = StringBuilder()
        while (sb.size <= 1024 * 32) {
            sb.append("A suitable amount of CData.\n")
        }
        let cdata: String = sb.toString()
        let h: String = "<div><![CDATA[" + cdata + "]]></div>"
        let doc: Document = Html4cj.parse(h)
        let div: Element = doc.selectFirst("div").getOrThrow()

        let node: CDataNode = (div.textNodes()[0] as CDataNode).getOrThrow()
        @Assert(cdata, node.text())
    }

    @TestCase
    public func handlesCdataInScript(): Unit {
        let html: String = "<script type=\"text/javascript\">//<![CDATA[\n\n  foo();\n//]]></script>"
        let doc: Document = Html4cj.parse(html)

        let data: String = "//<![CDATA[\n\n  foo();\n//]]>"
        let script: Element = doc.selectFirst("script").getOrThrow()
        @Assert("", script.text()) // won't be parsed as cdata because in script data section
        @Assert(data, script.data())
        @Assert(html, script.outerHtml())

        let dataNode: DataNode = (script.childNode(0) as DataNode).getOrThrow()
        @Assert(data, dataNode.getWholeData())
        // see - not a cdata node, because in script. contrast with XmlTreeBuilder - will be cdata.
    }

    @TestCase
    public func handlesUnclosedCdataAtEOF(): Unit {
        // https://github.com/jhy/jsoup/issues/349 would crash, as character reader would try to seek past EOF
        let h: String = "<![CDATA[]]"
        let doc: Document = Html4cj.parse(h)
        @Assert(1, doc.body().childNodeSize())
    }

    @TestCase
    public func handleCDataInText(): Unit {
        let h: String = "<p>One <![CDATA[Two <&]]> Three</p>"
        let doc: Document = Html4cj.parse(h)
        let p: Element = doc.selectFirst("p").getOrThrow()

        let nodes: ArrayList<Node> = p.childNodes()
        @Assert("One ", (nodes[0] as TextNode).getOrThrow().getWholeText())
        @Assert("Two <&", (nodes[1] as TextNode).getOrThrow().getWholeText())
        @Assert("Two <&", (nodes[1] as CDataNode).getOrThrow().getWholeText())
        @Assert(" Three", (nodes[2] as TextNode).getOrThrow().getWholeText())

        @Assert(h, p.outerHtml())
    }

    @TestCase
    public func cdataNodesAreTextNodes(): Unit {
        let h: String = "<p>One <![CDATA[ Two <& ]]> Three</p>"
        let doc: Document = Html4cj.parse(h)
        let p: Element = doc.selectFirst("p").getOrThrow()

        let nodes: ArrayList<TextNode> = p.textNodes()
        @Assert("One ", nodes[0].text())
        @Assert(" Two <& ", nodes[1].text())
        @Assert(" Three", nodes[2].text())
    }

    @TestCase
    public func handlesInvalidStartTags(): Unit {
        let h: String = "<div>Hello < There <&amp;></div>" // parse to <div {#text=Hello < There <&>}>
        let doc: Document = Html4cj.parse(h)
        @Assert("Hello < There <&>", doc.select("div").first().getOrThrow().text())
    }

    @TestCase
    public func handlesUnknownTags(): Unit {
        let h: String = "<div><foo title=bar>Hello<foo title=qux>there</foo></div>"
        let doc: Document = Html4cj.parse(h)
        let foos: Elements = doc.select("foo")
        @Assert(2, foos.size)
        @Assert("bar", foos.first().getOrThrow().attr("title"))
        @Assert("qux", foos.last().getOrThrow().attr("title"))
        @Assert("there", foos.last().getOrThrow().text())
    }

    @TestCase
    public func handlesUnknownInlineTags(): Unit {
        let h: String = "<p><cust>Test</cust></p><p><cust><cust>Test</cust></cust></p>"
        let doc: Document = Html4cj.parseBodyFragment(h)
        let out: String = doc.body().html()
        @Assert(h, TextUtil.stripNewlines(out))
    }

    @TestCase
    public func parsesBodyFragment(): Unit {
        let h: String = "<!-- comment --><p><a href='foo'>One</a></p>"
        let doc: Document = Html4cj.parseBodyFragment(h, "http://example.com")
        @Assert("<body><!-- comment --><p><a href=\"foo\">One</a></p></body>", TextUtil.stripNewlines(doc.body().outerHtml()))
        @Assert("http://example.com/foo", doc.select("a").first().getOrThrow().absUrl("href"))
    }

    @TestCase
    public func parseBodyIsIndexNoAttributes(): Unit {
        // https://github.com/jhy/jsoup/issues/1404
        let expectedHtml: String =
            #"<form>
 <hr><label>This is a searchable index. Enter search keywords: <input name="isindex"></label>
 <hr>
</form>"#
        var doc: Document = Html4cj.parse("<isindex>")
        @Assert(expectedHtml, doc.body().html())

        doc = Html4cj.parseBodyFragment("<isindex>")
        @Assert(expectedHtml, doc.body().html())

        doc = Html4cj.parseBodyFragment("<table><input></table>")
        @Assert("<input>\n<table></table>", doc.body().html())
    }

    @TestCase
    public func handlesUnknownNamespaceTags(): Unit {
        // note that the first foo:bar should not really be allowed to be self closing, if parsed in html mode.
        let h: String = "<foo:bar id='1' /><abc:def id=2>Foo<p>Hello</p></abc:def><foo:bar>There</foo:bar>"
        let doc: Document = Html4cj.parse(h)
        @Assert("<foo:bar id=\"1\" /><abc:def id=\"2\">Foo<p>Hello</p></abc:def><foo:bar>There</foo:bar>", TextUtil.stripNewlines(doc.body().html()))
    }

    @TestCase
    public func handlesKnownEmptyBlocks(): Unit {
        // if a known tag, allow self closing outside of spec, but force an end tag. unknown tags can be self closing.
        let h: String =
            "<div id='1' /><script src='/foo' /><div id=2><img /><img></div><a id=3 /><i /><foo /><foo>One</foo> <hr /> hr text <hr> hr text two"
        let doc: Document = Html4cj.parse(h)
        @Assert("<div id=\"1\"></div><script src=\"/foo\"></script><div id=\"2\"><img><img></div><a id=\"3\"></a><i></i><foo /><foo>One</foo><hr> hr text <hr> hr text two", TextUtil.stripNewlines(doc.body().html()))
    }

    @TestCase
    public func handlesKnownEmptyNoFrames(): Unit {
        let h: String = "<html><head><noframes /><meta name=foo></head><body>One</body></html>"
        let doc: Document = Html4cj.parse(h)
        @Assert("<html><head><noframes></noframes><meta name=\"foo\"></head><body>One</body></html>", TextUtil.stripNewlines(doc.html()))
    }

    @TestCase
    public func handlesKnownEmptyStyle(): Unit {
        let h: String = "<html><head><style /><meta name=foo></head><body>One</body></html>"
        let doc: Document = Html4cj.parse(h)
        @Assert("<html><head><style></style><meta name=\"foo\"></head><body>One</body></html>", TextUtil.stripNewlines(doc.html()))
    }

    @TestCase
    public func handlesKnownEmptyTitle(): Unit {
        let h: String = "<html><head><title /><meta name=foo></head><body>One</body></html>"
        let doc: Document = Html4cj.parse(h)
        @Assert("<html><head><title></title><meta name=\"foo\"></head><body>One</body></html>", TextUtil.stripNewlines(doc.html()))
    }

    @TestCase
    public func handlesKnownEmptyIframe(): Unit {
        let h: String = "<p>One</p><iframe id=1 /><p>Two"
        let doc: Document = Html4cj.parse(h)
        @Assert("<html><head></head><body><p>One</p><iframe id=\"1\"></iframe><p>Two</p></body></html>", TextUtil.stripNewlines(doc.html()))
    }

    @TestCase
    public func handlesSolidusAtAttributeEnd(): Unit {
        // this test makes sure [<a href=/>link</a>] is parsed as [<a href="/">link</a>], not [<a href="" /><a>link</a>]
        let h: String = "<a href=/>link</a>"
        let doc: Document = Html4cj.parse(h)
        @Assert("<a href=\"/\">link</a>", doc.body().html())
    }

    @TestCase
    public func handlesMultiClosingBody(): Unit {
        let h: String = "<body><p>Hello</body><p>there</p></body></body></html><p>now"
        let doc: Document = Html4cj.parse(h)
        @Assert(3, doc.select("p").size)
        @Assert(3, doc.body().children().size)
    }

    @TestCase
    public func handlesUnclosedDefinitionLists(): Unit {
        // jsoup used to create a <dl>, but that's not to spec
        let h: String = "<dt>Foo<dd>Bar<dt>Qux<dd>Zug"
        let doc: Document = Html4cj.parse(h)
        @Assert(0, doc.select("dl").size) // no auto dl
        @Assert(4, doc.select("dt, dd").size)
        let dts: Elements = doc.select("dt")
        @Assert(2, dts.size)
        @Assert("Zug", dts[1].nextElementSibling().getOrThrow().text())
    }

    @TestCase
    public func handlesBlocksInDefinitions(): Unit {
        // per the spec, dt and dd are inline, but in practise are block
        let h: String = "<dl><dt><div id=1>Term</div></dt><dd><div id=2>Def</div></dd></dl>"
        let doc: Document = Html4cj.parse(h)
        @Assert("dt", doc.select("#1").first().getOrThrow().parentElement().getOrThrow().tagName())
        @Assert("dd", doc.select("#2").first().getOrThrow().parentElement().getOrThrow().tagName())
        @Assert("<dl><dt><div id=\"1\">Term</div></dt><dd><div id=\"2\">Def</div></dd></dl>", TextUtil.stripNewlines(doc.body().html()))
    }

    @TestCase
    public func handlesFrames(): Unit {
        let h: String =
            "<html><head><script></script><noscript></noscript></head><frameset><frame src=foo></frame><frame src=foo></frameset></html>"
        let doc: Document = Html4cj.parse(h)
        @Assert("<html><head><script></script><noscript></noscript></head><frameset><frame src=\"foo\"><frame src=\"foo\"></frameset></html>",
                TextUtil.stripNewlines(doc.html()))
        // no body auto vivification
    }

    @TestCase
    public func ignoresContentAfterFrameset(): Unit {
        let h: String =
            "<html><head><title>One</title></head><frameset><frame /><frame /></frameset><table></table></html>"
        let doc: Document = Html4cj.parse(h)
        @Assert("<html><head><title>One</title></head><frameset><frame><frame></frameset></html>", TextUtil.stripNewlines(doc.html()))
        // no body, no table. No crash!
    }

    @TestCase
    public func handlesJavadocFont(): Unit {
        let h: String =
            "<TD BGCOLOR=\"#EEEEFF\" CLASS=\"NavBarCell1\">    <A HREF=\"deprecated-list.html\"><FONT CLASS=\"NavBarFont1\"><B>Deprecated</B></FONT></A>&nbsp;</TD>"
        let doc: Document = Html4cj.parse(h)
        let a: Element = doc.select("a").first().getOrThrow()
        @Assert("Deprecated", a.text())
        @Assert("font", a.child(0).tagName())
        @Assert("b", a.child(0).child(0).tagName())
    }

    @TestCase
    public func handlesBaseWithoutHref(): Unit {
        let h: String = "<head><base target='_blank'></head><body><a href=/foo>Test</a></body>"
        let doc: Document = Html4cj.parse(h, "http://example.com/")
        let a: Element = doc.select("a").first().getOrThrow()
        @Assert("/foo", a.attr("href"))
        @Assert("http://example.com/foo", a.attr("abs:href"))
    }

    @TestCase
    public func normalisesDocument(): Unit {
        let h: String = "<!doctype html>One<html>Two<head>Three<link></head>Four<body>Five </body>Six </html>Seven "
        let doc: Document = Html4cj.parse(h)
        @Assert("<!doctype html><html><head></head><body>OneTwoThree<link>FourFive Six Seven</body></html>",
                TextUtil.stripNewlines(doc.html()))
    }

    @TestCase
    public func normalisesEmptyDocument(): Unit {
        let doc: Document = Html4cj.parse("")
        @Assert("<html><head></head><body></body></html>", TextUtil.stripNewlines(doc.html()))
    }

    @TestCase
    public func normalisesHeadlessBody(): Unit {
        let doc: Document = Html4cj.parse("<html><body><span class=\"foo\">bar</span>")
        @Assert("<html><head></head><body><span class=\"foo\">bar</span></body></html>",
                TextUtil.stripNewlines(doc.html()))
    }

    @TestCase
    public func normalisedBodyAfterContent(): Unit {
        let doc: Document = Html4cj.parse("<font face=Arial><body class=name><div>One</div></body></font>")
        @Assert("<html><head></head><body class=\"name\"><font face=\"Arial\"><div>One</div></font></body></html>",
                TextUtil.stripNewlines(doc.html()))
    }

    @TestCase
    public func findsCharsetInMalformedMeta(): Unit {
        let h: String = "<meta http-equiv=Content-Type content=text/html; charset=gb2312>"

        // example cited for reason of html5's <meta charset> element
        let doc: Document = Html4cj.parse(h)
        @Assert("gb2312", doc.select("meta").attr("charset"))
    }

    @TestCase
    public func testHgroup(): Unit {
        // jsoup used to not allow hgroup in h{n}, but that's not in spec, and browsers are OK
        let doc: Document = Html4cj.parse(
            "<h1>Hello <h2>There <hgroup><h1>Another<h2>headline</hgroup> <hgroup><h1>More</h1><p>stuff</p></hgroup>"
        )
        @Assert("<h1>Hello</h1><h2>There <hgroup><h1>Another</h1><h2>headline</h2></hgroup><hgroup><h1>More</h1><p>stuff</p></hgroup></h2>", TextUtil.stripNewlines(doc.body().html()))
    }

    @TestCase
    public func testRelaxedTags(): Unit {
        let doc: Document = Html4cj.parse("<abc_def id=1>Hello</abc_def> <abc-def>There</abc-def>")
        @Assert("<abc_def id=\"1\">Hello</abc_def> <abc-def>There</abc-def>", TextUtil.stripNewlines(doc.body().html()))
    }

    @TestCase
    public func testHeaderContents(): Unit {
        // h* tags (h1 .. h9) in browsers can handle any internal content other than other h*. which is not per any
        // spec, which defines them as containing phrasing content only. so, reality over theory.
        let doc: Document = Html4cj.parse("<h1>Hello <div>There</div> now</h1> <h2>More <h3>Content</h3></h2>")
        @Assert("<h1>Hello <div>There</div> now</h1><h2>More</h2><h3>Content</h3>", TextUtil.stripNewlines(doc.body().html()))
    }

    @TestCase
    public func testSpanContents(): Unit {
        // like h1 tags, the spec says SPAN is phrasing only, but browsers and publisher treat span as a block tag
        let doc: Document = Html4cj.parse("<span>Hello <div>there</div> <span>now</span></span>")
        @Assert("<span>Hello <div>there</div><span>now</span></span>", TextUtil.stripNewlines(doc.body().html()))
    }

    @TestCase
    public func testNoImagesInNoScriptInHead(): Unit {
        // jsoup used to allow, but against spec if parsing with noscript
        let doc: Document = Html4cj.parse(
            "<html><head><noscript><img src='foo'></noscript></head><body><p>Hello</p></body></html>"
        )
        @Assert("<html><head><noscript>&lt;img src=\"foo\"&gt;</noscript></head><body><p>Hello</p></body></html>", TextUtil.stripNewlines(doc.html()))
    }

    @TestCase
    public func testUnclosedNoscriptInHead(): Unit {
        // Was getting "EOF" in html output, because the #anythingElse handler was calling an undefined toString, so used object.toString.
        let strings: Array<String> = ["<noscript>", "<noscript>One"]
        for (html in strings) {
            let doc: Document = Html4cj.parse(html)
            @Assert(html + "</noscript>", TextUtil.stripNewlines(doc.head().html()))
        }
    }

    @TestCase
    public func testAFlowContents(): Unit {
        // html5 has <a> as either phrasing or block
        let doc: Document = Html4cj.parse("<a>Hello <div>there</div> <span>now</span></a>")
        @Assert("<a>Hello <div>there</div><span>now</span></a>", TextUtil.stripNewlines(doc.body().html()))
    }

    @TestCase
    public func testFontFlowContents(): Unit {
        // html5 has no definition of <font>; often used as flow
        let doc: Document = Html4cj.parse("<font>Hello <div>there</div> <span>now</span></font>")
        @Assert("<font>Hello <div>there</div><span>now</span></font>", TextUtil.stripNewlines(doc.body().html()))
    }

    @TestCase
    public func handlesMisnestedTagsBI(): Unit {
        // whatwg: <b><i></b></i>
        let h: String = "<p>1<b>2<i>3</b>4</i>5</p>"
        let doc: Document = Html4cj.parse(h)
        @Assert("<p>1<b>2<i>3</i></b><i>4</i>5</p>", doc.body().html())
        // adoption agency on </b>, reconstruction of formatters on 4.
    }

    @TestCase
    public func handlesMisnestedTagsBP(): Unit {
        //  whatwg: <b><p></b></p>
        let h: String = "<b>1<p>2</b>3</p>"
        let doc: Document = Html4cj.parse(h)
        @Assert("<b>1</b>\n<p><b>2</b>3</p>", doc.body().html())
    }

    @TestCase
    public func handlesMisnestedAInDivs(): Unit {
        let h: String = "<a href='#1'><div><div><a href='#2'>child</a></div</div></a>"
        // let w: String =
        //     "<a href=\"#1\"></a> <div> <a href=\"#1\"></a> <div> <a href=\"#1\"></a><a href=\"#2\">child</a> </div> </div>"
        Html4cj.parse(h)
        // @Assert(
        //         StringUtil.normaliseWhitespace(w),
        //         StringUtil.normaliseWhitespace(doc.body().html()))
    }

    @TestCase
    public func handlesUnexpectedMarkupInTables(): Unit {
        // whatwg - tests markers in active formatting (if they didn't work, would get in table)
        // also tests foster parenting
        let h: String = "<table><b><tr><td>aaa</td></tr>bbb</table>ccc"
        let doc: Document = Html4cj.parse(h)
        @Assert("<b></b><b>bbb</b><table><tbody><tr><td>aaa</td></tr></tbody></table><b>ccc</b>", TextUtil.stripNewlines(doc.body().html()))
    }

    @TestCase
    public func handlesUnclosedFormattingElements(): Unit {
        // whatwg: formatting elements get collected and applied, but excess elements are thrown away
        let h: String =
            #"<!DOCTYPE html>
<p><b class=x><b class=x><b><b class=x><b class=x><b>X
<p>X
<p><b><b class=x><b>X
<p></b></b></b></b></b></b>X"#
        let doc: Document = Html4cj.parse(h)
        doc.outputSettings().indentAmount(0)
        let want: String =
            #"<!doctype html>
<html>
<head></head>
<body>
<p><b class="x"><b class="x"><b><b class="x"><b class="x"><b>X </b></b></b></b></b></b></p>
<p><b class="x"><b><b class="x"><b class="x"><b>X </b></b></b></b></b></p>
<p><b class="x"><b><b class="x"><b class="x"><b><b><b class="x"><b>X </b></b></b></b></b></b></b></b></p>
<p>X</p>
</body>
</html>"#
        @Assert(want, doc.html())
    }

    @TestCase
    public func handlesUnclosedAnchors(): Unit {
        let h: String = "<a href='http://example.com/'>Link<p>Error link</a>"
        let doc: Document = Html4cj.parse(h)
        let want: String =
            "<a href=\"http://example.com/\">Link</a>\n<p><a href=\"http://example.com/\">Error link</a></p>"
        @Assert(want, doc.body().html())
    }

    @TestCase
    public func reconstructFormattingElements(): Unit {
        // tests attributes and multi b
        let h: String = "<p><b class=one>One <i>Two <b>Three</p><p>Hello</p>"
        let doc: Document = Html4cj.parse(h)
        @Assert("<p><b class=\"one\">One <i>Two <b>Three</b></i></b></p>\n<p><b class=\"one\"><i><b>Hello</b></i></b></p>", doc.body().html())
    }

    @TestCase
    public func reconstructFormattingElementsInTable(): Unit {
        // tests that tables get formatting markers -- the <b> applies outside the table and does not leak in,
        // and the <i> inside the table and does not leak out.
        let h: String = "<p><b>One</p> <table><tr><td><p><i>Three<p>Four</i></td></tr></table> <p>Five</p>"
        let doc: Document = Html4cj.parse(h)
        let want: String =
            #"<p><b>One</b></p><b>
 <table>
  <tbody>
   <tr>
    <td><p><i>Three</i></p><p><i>Four</i></p></td>
   </tr>
  </tbody>
 </table><p>Five</p></b>"#
        @Assert(want, doc.body().html())
    }

    @TestCase
    public func commentBeforeHtml(): Unit {
        let h: String = "<!-- comment --><!-- comment 2 --><p>One</p>"
        let doc: Document = Html4cj.parse(h)
        @Assert("<!-- comment --><!-- comment 2 --><html><head></head><body><p>One</p></body></html>", TextUtil.stripNewlines(doc.html()))
    }

    @TestCase
    public func emptyTdTag(): Unit {
        let h: String = "<table><tr><td>One</td><td id='2' /></tr></table>"
        let doc: Document = Html4cj.parse(h)
        @Assert("<td>One</td>\n<td id=\"2\"></td>", doc.select("tr").first().getOrThrow().html())
    }

    @TestCase
    public func handlesSolidusInA(): Unit {
        // test for bug #66
        let h: String = "<a class=lp href=/lib/14160711/>link text</a>"
        let doc: Document = Html4cj.parse(h)
        let a: Element = doc.select("a").first().getOrThrow()
        @Assert("link text", a.text())
        @Assert("/lib/14160711/", a.attr("href"))
    }

    @TestCase
    public func handlesSpanInTbody(): Unit {
        // test for bug 64
        let h: String = "<table><tbody><span class='1'><tr><td>One</td></tr><tr><td>Two</td></tr></span></tbody></table>"
        let doc: Document = Html4cj.parse(h)
        @Assert(doc.select("span").first().getOrThrow().children().size, 0) // the span gets closed
        @Assert(doc.select("table").size, 1) // only one table
    }

    @TestCase
    public func handlesUnclosedTitleAtEof(): Unit {
        @Assert("Data", Html4cj.parse("<title>Data").title())
        @Assert("Data<", Html4cj.parse("<title>Data<").title())
        @Assert("Data</", Html4cj.parse("<title>Data</").title())
        @Assert("Data</t", Html4cj.parse("<title>Data</t").title())
        @Assert("Data</ti", Html4cj.parse("<title>Data</ti").title())
        @Assert("Data", Html4cj.parse("<title>Data</title>").title())
        @Assert("Data", Html4cj.parse("<title>Data</title >").title())
    }

    @TestCase
    public func handlesUnclosedTitle(): Unit {
        let one: Document = Html4cj.parse("<title>One <b>Two <b>Three</TITLE><p>Test</p>") // has title, so <b> is plain text
        @Assert("One <b>Two <b>Three", one.title())
        @Assert("Test", one.select("p").first().getOrThrow().text())

        let two: Document = Html4cj.parse("<title>One<b>Two <p>Test</p>") // no title, so <b> causes </title> breakout
        @Assert("One", two.title())
        @Assert("<b>Two <p>Test</p></b>", two.body().html())
    }

    @TestCase
    public func handlesUnclosedScriptAtEof(): Unit {
        @Assert("Data", Html4cj.parse("<script>Data").select("script").first().getOrThrow().data())
        @Assert("Data<", Html4cj.parse("<script>Data<").select("script").first().getOrThrow().data())
        @Assert("Data</sc", Html4cj.parse("<script>Data</sc").select("script").first().getOrThrow().data())
        @Assert("Data</-sc", Html4cj.parse("<script>Data</-sc").select("script").first().getOrThrow().data())
        @Assert("Data</sc-", Html4cj.parse("<script>Data</sc-").select("script").first().getOrThrow().data())
        @Assert("Data</sc--", Html4cj.parse("<script>Data</sc--").select("script").first().getOrThrow().data())
        @Assert("Data", Html4cj.parse("<script>Data</script>").select("script").first().getOrThrow().data())
        @Assert("Data</script", Html4cj.parse("<script>Data</script").select("script").first().getOrThrow().data())
        @Assert("Data", Html4cj.parse("<script>Data</script ").select("script").first().getOrThrow().data())
        @Assert("Data", Html4cj.parse("<script>Data</script n").select("script").first().getOrThrow().data())
        @Assert("Data", Html4cj.parse("<script>Data</script n=").select("script").first().getOrThrow().data())
        @Assert("Data", Html4cj.parse("<script>Data</script n=\"").select("script").first().getOrThrow().data())
        @Assert("Data", Html4cj.parse("<script>Data</script n=\"p").select("script").first().getOrThrow().data())
    }

    @TestCase
    public func handlesUnclosedRawtextAtEof(): Unit {
        @Assert("Data", Html4cj.parse("<style>Data").select("style").first().getOrThrow().data())
        @Assert("Data</st", Html4cj.parse("<style>Data</st").select("style").first().getOrThrow().data())
        @Assert("Data", Html4cj.parse("<style>Data</style>").select("style").first().getOrThrow().data())
        @Assert("Data</style", Html4cj.parse("<style>Data</style").select("style").first().getOrThrow().data())
        @Assert("Data</-style", Html4cj.parse("<style>Data</-style").select("style").first().getOrThrow().data())
        @Assert("Data</style-", Html4cj.parse("<style>Data</style-").select("style").first().getOrThrow().data())
        @Assert("Data</style--", Html4cj.parse("<style>Data</style--").select("style").first().getOrThrow().data())
    }

    @TestCase
    public func noImplicitFormForTextAreas(): Unit {
        // old jsoup parser would create implicit forms for form children like <textarea>, but no more
        let doc: Document = Html4cj.parse("<textarea>One</textarea>")
        @Assert("<textarea>One</textarea>", doc.body().html())
    }

    @TestCase
    public func handlesEscapedScript(): Unit {
        let doc: Document = Html4cj.parse("<script><!-- one <script>Blah</script> --></script>")
        @Assert("<!-- one <script>Blah</script> -->", doc.select("script").first().getOrThrow().data())
    }

    @TestCase
    public func handles0CharacterAsText(): Unit {
        let doc: Document = Html4cj.parse("0<p>0</p>")
        @Assert("0\n<p>0</p>", doc.body().html())
    }

    @TestCase
    public func handlesNullInData(): Unit {
        let doc: Document = Html4cj.parse("<p id=\u{0000}>Blah \u{0000}</p>")
        @Assert("<p id=\"${'\u{FFFD}'}\">Blah &#x0;</p>", doc.body().html()) // replaced in attr, NOT replaced in data (but is escaped as control char <0x20)
    }

    @TestCase
    public func handlesNullInComments(): Unit {
        let doc: Document = Html4cj.parse("<body><!-- \u{0000} \u{0000} -->")
        @Assert("<!-- ${'\u{FFFD}'} ${'\u{FFFD}'} -->", doc.body().html())
    }

    @TestCase
    public func handlesNewlinesAndWhitespaceInTag(): Unit {
        let doc: Document = Html4cj.parse("<a \n href=\"one\" \r\n id=\"two\" \f >")
        @Assert("<a href=\"one\" id=\"two\"></a>", doc.body().html())
    }

    @TestCase
    public func handlesWhitespaceInoDocType(): Unit {
        let html: String =
            "<!DOCTYPE html\r\n      PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\"\r\n      \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">"
        let doc: Document = Html4cj.parse(html)
        @Assert("<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">", doc.childNode(0).outerHtml())
    }

    @TestCase
    public func tracksErrorsWhenRequested(): Unit {
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
    public func tracksLimitedErrorsWhenRequested(): Unit {
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
    public func noErrorsByDefault(): Unit {
        let html: String = "<p>One</p href='no'>&arrgh;<font /><br /><foo"
        let parser: Parser = Parser.htmlParser()
        Html4cj.parse(html, "http://example.com", parser)

        let errors: ParseErrorList = parser.getErrors()
        @Assert(0, errors.size)
    }

    @TestCase
    public func optionalPClosersAreNotErrors(): Unit {
        let html: String = "<body><div><p>One<p>Two</div></body>"
        let parser: Parser = Parser.htmlParser().setTrackErrors(128)
        Html4cj.parse(html, "", parser)
        let errors: ParseErrorList = parser.getErrors()
        @Assert(0, errors.size)
    }

    @TestCase
    public func handlesCommentsInTable(): Unit {
        let html: String = "<table><tr><td>text</td><!-- Comment --></tr></table>"
        let node: Document = Html4cj.parseBodyFragment(html)
        @Assert("<html><head></head><body><table><tbody><tr><td>text</td><!-- Comment --></tr></tbody></table></body></html>", TextUtil.stripNewlines(node.outerHtml()))
    }

    @TestCase
    public func handlesQuotesInCommentsInScripts(): Unit {
        let html: String = "<script>\n" + "  <!--\n" + "    document.write('</scr' + 'ipt>');\n" + "  // -->\n" +
            "</script>"
        let node: Document = Html4cj.parseBodyFragment(html)
        @Assert("<script>\n" +
            "  <!--\n" +
            "    document.write('</scr' + 'ipt>');\n" +
            "  // -->\n" +
            "</script>", node.body().html())
    }

    @TestCase
    public func handleNullContextInParseFragment(): Unit {
        let html: String = "<ol><li>One</li></ol><p>Two</p>"
        let nodes: ArrayList<Node> = Parser.parseFragment(html, None, "http://example.com/")
        @Assert(1, nodes.size) // returns <html> node (not document) -- no context means doc gets created
        @Assert("html", nodes[0].nodeName())
        //  @Assert("<html> <head></head> <body> <ol> <li>One</li> </ol> <p>Two</p> </body> </html>", StringUtil.normaliseWhitespace(nodes[0].outerHtml()))
    }

    @TestCase
    public func doesNotFindShortestMatchingEntity(): Unit {
        // previous behaviour was to identify a possible entity, then chomp down the string until a match was found.
        // (as defined in html5.) However in practise that lead to spurious matches against the author's intent.
        let html: String = "One &clubsuite; &clubsuit;"
        Html4cj.parse(html)
        //@Assert(StringUtil.normaliseWhitespace("One &amp;clubsuite; ♣"), doc.body().html())
    }

    @TestCase
    public func relaxedBaseEntityMatchAndStrictExtendedMatch(): Unit {
        // extended entities need a ; at the end to match, base does not
        let html: String = "&amp &quot &reg &icy &hopf &icy; &hopf;"
        let doc: Document = Html4cj.parse(html)
        doc.outputSettings().escapeMode(EscapeMode.extended).charset("ascii") // modifies output only to clarify test
        @Assert("&amp; \" &reg; &amp;icy &amp;hopf &icy; &hopf;", doc.body().html())
    }

    @TestCase
    public func handlesXmlDeclarationAsBogusComment(): Unit {
        let html: String = "<?xml encoding='UTF-8' ?><body>One</body>"
        Html4cj.parse(html)
        // @Assert("<!--?xml encoding='UTF-8' ?--> <html> <head></head> <body> One </body> </html>", StringUtil.normaliseWhitespace(doc.outerHtml()))
    }

    @TestCase
    public func handlesTagsInTextarea(): Unit {
        let html: String = "<textarea><p>Jsoup</p></textarea>"
        let doc: Document = Html4cj.parse(html)
        @Assert("<textarea>&lt;p&gt;Jsoup&lt;/p&gt;</textarea>", doc.body().html())
    }

    // form tests
    @TestCase
    public func createsFormElements(): Unit {
        let html: String = "<body><form><input id=1><input id=2></form></body>"
        let doc: Document = Html4cj.parse(html)
        let el: Element = doc.select("form").first().getOrThrow()

        @Assert(el is FormElement) // "Is form element"
        let form: FormElement = (el as FormElement).getOrThrow()
        let controls: Elements = form.elements()
        @Assert(2, controls.size)
        @Assert("1", controls[0].id())
        @Assert("2", controls[1].id())
    }

    @TestCase
    public func associatedFormControlsWithDisjointForms(): Unit {
        // form gets closed, isn't parent of controls
        let html: String = "<table><tr><form><input type=hidden id=1><td><input type=text id=2></td><tr></table>"
        let doc: Document = Html4cj.parse(html)
        let el: Element = doc.select("form").first().getOrThrow()

        @Assert(el is FormElement) // "Is form element"
        let form: FormElement = (el as FormElement).getOrThrow()
        let controls: Elements = form.elements()
        @Assert(2, controls.size)
        @Assert("1", controls[0].id())
        @Assert("2", controls[1].id())

        @Assert("<table><tbody><tr><form></form><input type=\"hidden\" id=\"1\"><td><input type=\"text\" id=\"2\"></td></tr><tr></tr></tbody></table>", TextUtil.stripNewlines(doc.body().html()))
    }

    @TestCase
    public func handlesInputInTable(): Unit {
        let h: String =
            #"<body>
    <input type="hidden" name="a" value="">
    <table>
    <input type="hidden" name="b" value="" />
    </table>
    </body>"#
        let doc: Document = Html4cj.parse(h)
        @Assert(1, doc.select("table input").size)
        @Assert(2, doc.select("input").size)
    }

    @TestCase
    public func convertsImageToImg(): Unit {
        // image to img, unless in a svg. old html cruft.
        let h: String = "<body><image><svg><image /></svg></body>"
        let doc: Document = Html4cj.parse(h)
        @Assert("<img>\n<svg>\n <image />\n</svg>", doc.body().html())
    }

    @TestCase
    public func handlesInvalidDoctypes(): Unit {
        // would previously throw invalid name exception on empty doctype
        var doc: Document = Html4cj.parse("<!DOCTYPE>")

        // @Assert(
        //     "<!doctype> <html> <head></head> <body></body> </html>",
        //     StringUtil.normaliseWhitespace(doc.outerHtml()))
        doc = Html4cj.parse("<!DOCTYPE><html><p>Foo</p></html>")

        // @Assert(
        //     "<!doctype> <html> <head></head> <body> <p>Foo</p> </body> </html>",
        //     StringUtil.normaliseWhitespace(doc.outerHtml()))
        doc = Html4cj.parse("<!DOCTYPE \u{0000}>")
        // @Assert(
        //     "<!doctype ${'\u{FFFD}'}> <html> <head></head> <body></body> </html>",
        //     StringUtil.normaliseWhitespace(doc.outerHtml()))
    }

    @TestCase
    public func handlesManyChildren(): Unit {
        // Arrange
        let longBody: StringBuilder = StringBuilder()
        for (i in 0..25000) {
            longBody.append(i)
            longBody.append("<br>")
        }

        // Act
        let start: DateTime = DateTime.now()
        let doc: Document = Parser.parseBodyFragment(longBody.toString(), "")

        // Assert
        @Assert(50000, doc.body().childNodeSize())
        @Assert(DateTime.now() - start < Duration.millisecond*1000)
    }

    @TestCase
    public func testInvalidTableContents(): Unit {
        // let inFile: File = ParseTest.getFile("test/LLT/htmltests/table-invalid-elements.html")
        // let doc: Document = Html4cj.parse(inFile, "UTF-8")
        let inFile = File.readFrom("table-invalid-elements.html")
        let content = String.fromUtf8(inFile)
        let doc: Document = Html4cj.parse(content, "UTF-8")
        doc.outputSettings().prettyPrint(true)
        let rendered: String = doc.toString()
        let endOfEmail: Int64 = rendered.indexOf("Comment").getOrThrow()
        let guarantee: Int64 = rendered.indexOf("Why am I here?").getOrThrow()
        @Assert(endOfEmail > -1) // "Comment not found"
        @Assert(guarantee > -1) // "Search text not found"
        @Assert(guarantee > endOfEmail) // "Search text did not come after comment"
    }

    @TestCase
    public func testNormalisesIsIndex(): Unit {
        let doc: Document = Html4cj.parse("<body><isindex action='/submit'></body>")
        doc.outerHtml()
        // @Assert("<form action=\"/submit\"> <hr><label>This is a searchable index. Enter search keywords: <input name=\"isindex\"></label> <hr> </form>",
        //     StringUtil.normaliseWhitespace(doc.body().html()))
    }

    @TestCase
    public func testReinsertionModeForThCelss(): Unit {
        let body: String =
            "<body> <table> <tr> <th> <table><tr><td></td></tr></table> <div> <table><tr><td></td></tr></table> </div> <div></div> <div></div> <div></div> </th> </tr> </table> </body>"
        let doc: Document = Html4cj.parse(body)
        @Assert(1, doc.body().children().size)
    }

    @TestCase
    public func testUsingSingleQuotesInQueries(): Unit {
        let body: String = "<body> <div class='main'>hello</div></body>"
        let doc: Document = Html4cj.parse(body)
        let mainRes: Elements = doc.select("div[class='main']")
        @Assert("hello", mainRes.text())
    }

    @TestCase
    public func testSupportsNonAsciiTags(): Unit {
        let body: String =
            "<a進捗推移グラフ>Yes</a進捗推移グラフ><bрусский-тэг>Correct</<bрусский-тэг>"
        let doc: Document = Html4cj.parse(body)
        var els: Elements = doc.select("a進捗推移グラフ")
        @Assert("Yes", els.text())
        els = doc.select("bрусский-тэг")
        @Assert("Correct", els.text())
    }

    @TestCase
    public func testSupportsPartiallyNonAsciiTags(): Unit {
        let body: String = "<div>Check</divá>"
        let doc: Document = Html4cj.parse(body)
        let els: Elements = doc.select("div")
        @Assert("Check", els.text())
    }

    @TestCase
    public func testFragment(): Unit {
        // make sure when parsing a body fragment, a script tag at start goes into the body
        let html: String = "<script type=\"text/javascript\">console.log('foo');</script>\n" +
            "<div id=\"somecontent\">some content</div>\n" +
            "<script type=\"text/javascript\">console.log('bar');</script>"

        let body: Document = Html4cj.parseBodyFragment(html)
        @Assert("<script type=\"text/javascript\">console.log('foo');</script>\n" +
            "<div id=\"somecontent\">\n" +
            " some content\n" +
            "</div>\n" +
            "<script type=\"text/javascript\">console.log('bar');</script>", body.body().html())
    }

    @TestCase
    public func testHtmlLowerCase(): Unit {
        let html: String = "<!doctype HTML><DIV ID=1>One</DIV>"
        let doc: Document = Html4cj.parse(html)
        //@Assert("<!doctype html> <html> <head></head> <body> <div id=\"1\"> One </div> </body> </html>", StringUtil.normaliseWhitespace(doc.outerHtml()))
        let div: Element = doc.selectFirst("#1").getOrThrow()
        div.after("<TaG>One</TaG>")
        @Assert("<tag>One</tag>", TextUtil.stripNewlines(div.nextElementSibling().getOrThrow().outerHtml()))
    }

    @TestCase
    public func testHtmlLowerCaseAttributesOfVoidTags(): Unit {
        let html: String = "<!doctype HTML><IMG ALT=One></DIV>"
        Html4cj.parse(html)
        //@Assert("<!doctype html> <html> <head></head> <body> <img alt=\"One\"> </body> </html>", StringUtil.normaliseWhitespace(doc.outerHtml()))
    }

    @TestCase
    public func testHtmlLowerCaseAttributesForm(): Unit {
        let html: String = "<form NAME=one>"
        Html4cj.parse(html)
        //@Assert("<form name=\"one\"></form>", StringUtil.normaliseWhitespace(doc.body().html()))
    }

    @TestCase
    public func canPreserveTagCase(): Unit {
        let parser: Parser = Parser.htmlParser()
        parser.settings(ParseSettings(true, false))
        let doc: Document = parser.parseInput("<div id=1><SPAN ID=2>", "")

        //@Assert("<html> <head></head> <body> <div id=\"1\"> <SPAN id=\"2\"></SPAN> </div> </body> </html>", StringUtil.normaliseWhitespace(doc.outerHtml()))
        let div: Element = doc.selectFirst("#1").getOrThrow()
        div.after("<TaG ID=one>One</TaG>")
        @Assert("<TaG id=\"one\">One</TaG>", TextUtil.stripNewlines(div.nextElementSibling().getOrThrow().outerHtml()))
    }

    @TestCase
    public func canPreserveAttributeCase(): Unit {
        let parser: Parser = Parser.htmlParser()
        parser.settings(ParseSettings(false, true))
        let doc: Document = parser.parseInput("<div id=1><SPAN ID=2>", "")

        //@Assert("<html> <head></head> <body> <div id=\"1\"> <span ID=\"2\"></span> </div> </body> </html>", StringUtil.normaliseWhitespace(doc.outerHtml()))
        let div: Element = doc.selectFirst("#1").getOrThrow()
        div.after("<TaG ID=one>One</TaG>")
        @Assert("<tag ID=\"one\">One</tag>", TextUtil.stripNewlines(div.nextElementSibling().getOrThrow().outerHtml()))
    }

    @TestCase
    public func canPreserveBothCase(): Unit {
        let parser: Parser = Parser.htmlParser()
        parser.settings(ParseSettings(true, true))
        let doc: Document = parser.parseInput("<div id=1><SPAN ID=2>", "")

        //@Assert("<html> <head></head> <body> <div id=\"1\"> <SPAN ID=\"2\"></SPAN> </div> </body> </html>", StringUtil.normaliseWhitespace(doc.outerHtml()))
        let div: Element = doc.selectFirst("#1").getOrThrow()
        div.after("<TaG ID=one>One</TaG>")
        @Assert("<TaG ID=\"one\">One</TaG>", TextUtil.stripNewlines(div.nextElementSibling().getOrThrow().outerHtml()))
    }

    @TestCase
    public func handlesControlCodeInAttributeName(): Unit {
        let doc: Document = Html4cj.parse("<p><a \u{6}=foo>One</a><a/\u{6}=bar><a foo\u{6}=bar>Two</a></p>")
        @Assert("<p><a>One</a><a></a><a foo=\"bar\">Two</a></p>", doc.body().html())
    }

    @TestCase
    public func caseSensitiveParseTree(): Unit {
        let html: String = "<r><X>A</X><y>B</y></r>"
        let parser: Parser = Parser.htmlParser()
        parser.settings(ParseSettings.preserveCase)
        parser.parseInput(html, "")
        //@Assert("<r> <X> A </X> <y> B </y> </r>", StringUtil.normaliseWhitespace(doc.body().html()))
    }

    @TestCase
    public func caseInsensitiveParseTree(): Unit {
        let html: String = "<r><X>A</X><y>B</y></r>"
        let parser: Parser = Parser.htmlParser()
        parser.parseInput(html, "")
        //@Assert("<r> <x> A </x> <y> B </y> </r>", StringUtil.normaliseWhitespace(doc.body().html()))
    }

    @TestCase
    public func preservedCaseLinksCantNest(): Unit {
        let html: String = "<A>ONE <A>Two</A></A>"
        let doc: Document = Parser.htmlParser().settings(ParseSettings.preserveCase).parseInput(html, "")

        //@Assert("<A>ONE </A><A>Two</A>", StringUtil.normaliseWhitespace(doc.body().html()))
        @Assert("<A>ONE </A><A>Two</A>", doc.body().html())
    }

    @TestCase
    public func normalizesDiscordantTags(): Unit {
        let document: Document = Html4cj.parse("<div>test</DIV><p></p>")
        @Assert("<div>\n test\n</div>\n<p></p>", document.body().html())
    }

    @TestCase
    public func selfClosingVoidIsNotAnError(): Unit {
        let html: String = "<p>test<br/>test<br/></p>"
        let parser: Parser = Parser.htmlParser().setTrackErrors(5)
        parser.parseInput(html, "")
        @Assert(0, parser.getErrors().size)
        // todo
        // @Assert(Jsoup.isValid(html, Safelist.basic()))
        // let clean: String = Jsoup.clean(html, Safelist.basic())
        // @Assert("<p>test<br>\n test<br></p>", clean)
    }

    @TestCase
    public func selfClosingOnNonvoidIsError(): Unit {
        let html: String = "<p>test</p>\n\n<div /><div>Two</div>"
        let parser: Parser = Parser.htmlParser().setTrackErrors(5)
        parser.parseInput(html, "")
        @Assert(1, parser.getErrors().size)
        @Assert("<3:8>: Tag [div] cannot be self closing; not a void tag", parser.getErrors()[0].toString())
        // todo
        // @Assert(false, Jsoup.isValid(html, Safelist.relaxed()))
        // let clean: String = Jsoup.clean(html, Safelist.relaxed())
        // @Assert("<p>test</p> <div></div> <div> Two </div>", StringUtil.normaliseWhitespace(clean))
    }

    @TestCase
    public func testTemplateInsideTable(): Unit {
        let inFile = File.readFrom("table-polymer-template.html")
        let content = String.fromUtf8(inFile)
        let doc: Document = Html4cj.parse(content, "UTF-8")
        doc.outputSettings().prettyPrint(true)

        let templates: Elements = doc.body().getElementsByTag("template")
        for (template in templates) {
            @Assert(template.childNodes().size > 1)
        }
    }

    @TestCase
    public func testHandlesDeepSpans(): Unit {
        let sb: StringBuilder = StringBuilder()
        for (i in 0..200) {
            (i)
            sb.append("<span>")
        }

        sb.append("<p>One</p>")

        let doc: Document = Html4cj.parse(sb.toString())
        @Assert(200, doc.select("span").size)
        @Assert(1, doc.select("p").size)
    }

    @TestCase
    public func commentAtEnd(): Unit {
        let doc: Document = Html4cj.parse("<!")
        @Assert(doc.childNode(0) is Comment)
    }

    @TestCase
    public func preSkipsFirstNewline(): Unit {
        let doc: Document = Html4cj.parse("<pre>\n\nOne\nTwo\n</pre>")
        let pre: Element = doc.selectFirst("pre").getOrThrow()
        @Assert("One\nTwo", pre.text())
        @Assert("\nOne\nTwo\n", pre.wholeText())
    }

    @TestCase
    public func handlesXmlDeclAndCommentsBeforeDoctype(): Unit {
        let inFile = File.readFrom("comments.html")
        println(1.1)
        let content = String.fromUtf8(inFile).toRuneArray()
        println("1.2 ${content[..content.size].size}")
        let doc: Document = Html4cj.parse(String(content[1..content.size]), "UTF-8")
        // let doc: Document = Html4cj.parse(content[..], "UTF-8")
        println(1.3)

        // @Assert("<!--?xml version=\"1.0\" encoding=\"utf-8\"?--><!-- so --> <!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\"><!-- what --> <html xml:lang=\"en\" lang=\"en\" xmlns=\"http://www.w3.org/1999/xhtml\"><!-- now --> <head><!-- then --> <meta http-equiv=\"Content-type\" content=\"text/html; charset=utf-8\"> <title>A Certain Kind of Test</title> </head> <body> <h1>Hello</h1>h1&gt; (There is a UTF8 hidden BOM at the top of this file.) </body> </html>",
        //     StringUtil.normaliseWhitespace(doc.html()))
        @Assert("A Certain Kind of Test", doc.head().select("title").text())
    }

    // @Skip
    // @TestCase
    // public func fallbackToUtfIfCantEncode(): Unit {
    //     // todo
    //     // that charset can't be encoded, so make sure we flip to utf
    //     let inStr: String = "<html><meta charset=\"ISO-2022-CN\"/>One</html>"
    //     let input = ByteArrayStream()
    //     input.write(inStr.toUtf8Array())
    //     let doc: Document = Html4cj.parse(input, None, "")
    
    //     @Assert("UTF-8", doc.charset())
    //     @Assert("One", doc.text())
    
    //     let html: String = doc.outerHtml()
    //     @Assert("<html><head><meta charset=\"UTF-8\"></head><body>One</body></html>", TextUtil.stripNewlines(html))
    // }
    
    // @Skip
    // @TestCase
    // public func characterReaderBuffer(): Unit {
    //     let inFile = File.readFrom("character-reader-buffer.html.gz")
    //     let content = String.fromUtf8(inFile)
    //     let doc: Document = Html4cj.parse(content, "UTF-8")
    
    //     let expectedHref: String = "http://www.domain.com/path?param_one=value&param_two=value"
    
    //     let links: Elements = doc.select("a")
    //     @Assert(2, links.size)
    //     @Assert(expectedHref, links[0].attr("href")) // passes
    //     @Assert(expectedHref, links[1].attr("href")) // fails, "but was:<...ath?param_one=value&[]_two-value>"
    // }
    @TestCase
    public func selfClosingTextAreaDoesntLeaveDroppings(): Unit {
        // https://github.com/jhy/jsoup/issues/1220
        let doc: Document = Html4cj.parse("<div><div><textarea/></div></div>")
        @Assert(false, doc.body().html().contains("&lt;"))
        @Assert(false, doc.body().html().contains("&gt;"))
        @Assert("<div><div><textarea></textarea></div></div>", TextUtil.stripNewlines(doc.body().html()))
    }

    @TestCase
    public func testNoSpuriousSpace(): Unit {
        let doc: Document = Html4cj.parse("Just<a>One</a><a>Two</a>")
        @Assert("Just<a>One</a><a>Two</a>", doc.body().html())
        @Assert("JustOneTwo", doc.body().text())
    }

    @TestCase
    public func pTagsGetIndented(): Unit {
        let html: String = "<div><p><a href=one>One</a><p><a href=two>Two</a></p></div>"
        let doc: Document = Html4cj.parse(html)
        @Assert("<div>\n" +
            " <p><a href=\"one\">One</a></p>\n" +
            " <p><a href=\"two\">Two</a></p>\n" +
            "</div>", doc.body().html())
    }

    @TestCase
    public func indentRegardlessOfCase(): Unit {
        let html: String = "<p>1</p><P>2</P>"
        let doc: Document = Html4cj.parse(html)
        @Assert(
            "<body>\n" +
            " <p>1</p>\n" +
            " <p>2</p>\n" +
            "</body>", doc.body().outerHtml())

        let caseDoc: Document = Html4cj.parse(html, "", Parser.htmlParser().settings(ParseSettings.preserveCase))
        @Assert(
            "<body>\n" +
            " <p>1</p>\n" +
            " <P>2</P>\n" +
            "</body>", caseDoc.body().outerHtml())
    }

    @TestCase
    public func testH20(): Unit {
        // https://github.com/jhy/jsoup/issues/731
        let html: String = "H<sub>2</sub>O"

        // todo
        // let clean: String = Jsoup.clean(html, Safelist.basic())
        // @Assert("H<sub>2</sub>O", clean)
        let doc: Document = Html4cj.parse(html)
        @Assert("H2O", doc.text())
    }

    @TestCase
    public func testUNewlines(): Unit {
        // https://github.com/jhy/jsoup/issues/851
        let html: String = "t<u>es</u>t <b>on</b> <i>f</i><u>ir</u>e"

        // todo
        // let clean: String = Jsoup.clean(html, Safelist.basic())
        // @Assert("t<u>es</u>t <b>on</b> <i>f</i><u>ir</u>e", clean)
        let doc: Document = Html4cj.parse(html)
        @Assert("test on fire", doc.text())
    }

    @TestCase
    public func testFarsi(): Unit {
        // https://github.com/jhy/jsoup/issues/1227
        let text: String = "نیمه\u{200C}شب"
        let doc: Document = Html4cj.parse("<p>" + text)
        @Assert(text, doc.text())
    }

    @TestCase
    public func testStartOptGroup(): Unit {
        // https://github.com/jhy/jsoup/issues/1313
        let html: String =
            #"<select>
  <optgroup label="a">
  <option>one
  <option>two
  <option>three
  <optgroup label="b">
  <option>four
  <option>fix
  <option>six
</select>"#
        let doc: Document = Html4cj.parse(html)
        let select: Element = doc.selectFirst("select").getOrThrow()
        @Assert(2, select.childrenSize())
        let expect =
            #"<optgroup label="a"> <option>one </option><option>two </option><option>three </option></optgroup><optgroup label="b"> <option>four </option><option>fix </option><option>six </option></optgroup>"#
        @Assert(expect, select.html())
    }

    // @TestCase
    // public func readerClosedAfterParse(): Unit {
    //     let doc: Document = Html4cj.parse("Hello")
    //     let treeBuilder: TreeBuilder = doc.parser().getTreeBuilder()
    //     @Assert(treeBuilder.reader.isNone())
    //     @Assert(treeBuilder.tokeniser.isNone())
    // }
    @TestCase
    public func scriptInDataNode(): Unit {
        var doc: Document = Html4cj.parse("<script>Hello</script><style>There</style>")
        @Assert(doc.selectFirst("script").getOrThrow().childNode(0) is DataNode)
        @Assert(doc.selectFirst("style").getOrThrow().childNode(0) is DataNode)

        doc = Html4cj.parse(
            "<SCRIPT>Hello</SCRIPT><STYLE>There</STYLE>",
            "",
            Parser.htmlParser().settings(ParseSettings.preserveCase)
        )
        @Assert(doc.selectFirst("script").getOrThrow().childNode(0) is DataNode)
        @Assert(doc.selectFirst("style").getOrThrow().childNode(0) is DataNode)
    }

    @TestCase
    public func textareaValue(): Unit {
        let html: String = "<TEXTAREA>YES YES</TEXTAREA>"
        var doc: Document = Html4cj.parse(html)
        @Assert("YES YES", doc.selectFirst("textarea").getOrThrow().val())

        doc = Html4cj.parse(html, "", Parser.htmlParser().settings(ParseSettings.preserveCase))
        @Assert("YES YES", doc.selectFirst("textarea").getOrThrow().val())
    }

    @TestCase
    public func preserveWhitespaceInHead(): Unit {
        let html: String =
            "\n<!doctype html>\n<html>\n<head>\n<title>Hello</title>\n</head>\n<body>\n<p>One</p>\n</body>\n</html>\n"
        let doc: Document = Html4cj.parse(html)
        doc.outputSettings().prettyPrint(false)
        @Assert("<!doctype html>\n<html>\n<head>\n<title>Hello</title>\n</head>\n<body>\n<p>One</p>\n</body>\n</html>\n", doc.outerHtml())
    }

    @TestCase
    public func handleContentAfterBody(): Unit {
        let html: String = "<body>One</body>  <p>Hello!</p></html> <p>There</p>"
        let doc: Document = Html4cj.parse(html)
        doc.outputSettings().prettyPrint(false)
        @Assert("<html><head></head><body>One<p>Hello!</p><p>There</p></body>  </html> ", doc.outerHtml())
    }

    @TestCase
    public func preservesTabs(): Unit {
        // testcase to demonstrate tab retention - https://github.com/jhy/jsoup/issues/1240
        let html: String = "<pre>One\tTwo</pre><span>\tThree\tFour</span>"
        let doc: Document = Html4cj.parse(html)

        let pre: Element = doc.selectFirst("pre").getOrThrow()
        let span: Element = doc.selectFirst("span").getOrThrow()

        @Assert("One\tTwo", pre.text())
        @Assert("Three Four", span.text()) // normalized, including overall trim
        @Assert("\tThree\tFour", span.wholeText()) // text normalizes, wholeText retains original spaces incl tabs
        @Assert("One\tTwo Three Four", doc.body().text())

        @Assert("<pre>One\tTwo</pre><span> Three Four</span>", doc.body().html()) // html output provides normalized space, incl tab in pre but not in span

        doc.outputSettings().prettyPrint(false)
        @Assert(html, doc.body().html()) // disabling pretty-printing - round-trips the tab throughout, as no normalization occurs
    }

    @TestCase
    public func wholeTextTreatsBRasNewline(): Unit {
        let html: String = "<div>\nOne<br>Two <p>Three<br>Four</div>"
        let doc: Document = Html4cj.parse(html)
        let div: Element = doc.selectFirst("div").getOrThrow()

        // assertNotNull(div)
        @Assert("\nOne\nTwo Three\nFour", div.wholeText())
        @Assert("\nOne\nTwo ", div.wholeOwnText())
    }

    @TestCase
    public func canDetectAutomaticallyAddedElements(): Unit {
        let bare: String = "<script>One</script>"
        let full: String = "<html><head><title>Check</title></head><body><p>One</p></body></html>"

        @Assert(didAddElements(bare))
        @Assert(false, didAddElements(full))
    }
    private func didAddElements(input: String): Bool {
        // two passes, one as XML and one as HTML. XML does not vivify missing/optional tags
        let html: Document = Html4cj.parse(input)
        let xml: Document = Html4cj.parse(input, "", Parser.xmlParser())

        let htmlElementCount: Int64 = html.getAllElements().size
        let xmlElementCount: Int64 = xml.getAllElements().size
        return htmlElementCount > xmlElementCount
    }

    @TestCase
    public func canSetHtmlOnCreatedTableElements(): Unit {
        // https://github.com/jhy/jsoup/issues/1603
        let element: Element = Element("tr")
        element.html("<tr><td>One</td></tr>")
        @Assert("<tr>\n <tr>\n  <td>One</td>\n </tr>\n</tr>", element.outerHtml())
    }

    @TestCase
    public func parseFragmentOnCreatedDocument(): Unit {
        // https://github.com/jhy/jsoup/issues/1601
        let bareFragment: String = "<h2>text</h2>"
        let nodes: ArrayList<Node> = Document("").parser().parseFragmentInput(bareFragment, Element("p"), "")
        @Assert(1, nodes.size)
        let node: Node = nodes[0]
        @Assert("h2", node.nodeName())
        @Assert("<p><h2>text</h2></p>", node.parent().getOrThrow().outerHtml())
    }

    @TestCase
    public func nestedPFragments(): Unit {
        // https://github.com/jhy/jsoup/issues/1602
        let bareFragment: String = "<p></p><a></a>"
        let nodes: ArrayList<Node> = Document("").parser().parseFragmentInput(bareFragment, Element("p"), "")
        @Assert(2, nodes.size)
        let node: Node = nodes[0]
        @Assert("<p><p></p><a></a></p>", node.parent().getOrThrow().outerHtml()) // mis-nested because fragment forced into the element, OK
    }

    @TestCase
    public func nestedAnchorAdoption(): Unit {
        // https://github.com/jhy/jsoup/issues/1608
        let html: String = "<a>\n<b>\n<div>\n<a>test</a>\n</div>\n</b>\n</a>"
        let doc: Document = Html4cj.parse(html)

        // assertNotNull(doc)
        @Assert("<a> <b> </b></a><b><div><a> </a><a>test</a></div></b>", TextUtil.stripNewlines(doc.body().html()))
    }

    @TestCase
    public func tagsMustStartWithAscii(): Unit {
        // https://github.com/jhy/jsoup/issues/1006
        let valid: Array<String> = ["a一", "a会员挂单金额5", "table(╯°□°)╯"]
        let invalid: Array<String> = ["一", "会员挂单金额5", "(╯°□°)╯"]

        for (tag in valid) {
            let doc: Document = Html4cj.parse("<" + tag + ">Text</" + tag + ">")
            let els: Elements = doc.getElementsByTag(tag)
            @Assert(1, els.size)
            @Assert(tag, els[0].tagName())
            @Assert("Text", els[0].text())
        }

        for (tag in invalid) {
            let doc: Document = Html4cj.parse("<" + tag + ">Text</" + tag + ">")
            let els: Elements = doc.getElementsByTag(tag)
            @Assert(0, els.size)
            @Assert("&lt;" + tag + "&gt;Text<!--/" + tag + "-->", doc.body().html())
        }
    }

    @TestCase
    func htmlOutputCorrectsInvalidAttributeNames(): Unit {
        let html: String = "<body style=\"color: red\" \" name\"><div =\"\"></div></body>"
        let doc: Document = Html4cj.parse(html)
        @Assert(Syntax.htmlSyntax == doc.outputSettings().syntax())

        let out: String = doc.body().outerHtml()
        @Assert("<body style=\"color: red\" name>\n <div></div>\n</body>", out)
    }

    @TestCase
    func templateInHead(): Unit {
        // https://try.jsoup.org/~EGp3UZxQe503TJDHQEQEzm8IeUc
        let html: String =
            "<head><template id=1><meta name=tmpl></template><title>Test</title><style>One</style></head><body><p>Two</p>"
        let doc: Document = Html4cj.parse(html)

        var want: String =
            "<html><head><template id=\"1\"><meta name=\"tmpl\"></template><title>Test</title><style>One</style></head><body><p>Two</p></body></html>"
        @Assert(want, TextUtil.stripNewlines(doc.html()))

        let template: Elements = doc.select("template#1")
        template.select("meta").attr("content", "Yes")
        template.unwrap()

        want = "<html><head><meta name=\"tmpl\" content=\"Yes\"><title>Test</title><style>One</style></head><body><p>Two</p></body></html>"
        @Assert(want, TextUtil.stripNewlines(doc.html()))
    }

    @TestCase
    func nestedTemplateInBody(): Unit {
        let html: String =
            "<body><template id=1><table><tr><template id=2><td>One</td><td>Two</td></template></tr></template></body>"
        let doc: Document = Html4cj.parse(html)

        var want: String =
            "<html><head></head><body><template id=\"1\"><table><tbody><tr><template id=\"2\"><td>One</td><td>Two</td></template></tr></tbody></table></template></body></html>"
        @Assert(want, TextUtil.stripNewlines(doc.html()))

        // todo - will be nice to add some simpler template element handling like clone children etc?
        doc.selectFirst("template#1").getOrThrow()
        let tmplRow: Element = doc.selectFirst("template#2").getOrThrow()

        // assertNotNull(tmplTbl)
        // assertNotNull(tmplRow)
        tmplRow.appendChild(tmplRow.clone())
        doc.select("template").unwrap()

        want = "<html><head></head><body><table><tbody><tr><td>One</td><td>Two</td><td>One</td><td>Two</td></tr></tbody></table></body></html>"
        @Assert(want, TextUtil.stripNewlines(doc.html()))
    }

    @TestCase
    func canSelectIntoTemplate(): Unit {
        let html: String = "<body><div><template><p>Hello</p>"
        let doc: Document = Html4cj.parse(html)
        let want: String = "<html><head></head><body><div><template><p>Hello</p></template></div></body></html>"
        @Assert(want, TextUtil.stripNewlines(doc.html()))

        let p: Element = doc.selectFirst("div p").getOrThrow()
        let p1: Element = doc.selectFirst("template :containsOwn(Hello)").getOrThrow()
        @Assert("p", p.normalName())
        @Assert(p, p1)
    }

    @TestCase
    func tableRowFragment(): Unit {
        let doc: Document = Html4cj.parse("<body><table></table></body")
        let html: String = "<tr><td><img></td></tr>"
        let table: Element = doc.selectFirst("table").getOrThrow()
        table.html(html) // invokes the fragment parser with table as context
        var want: String = "<tbody><tr><td><img></td></tr></tbody>"
        @Assert(want, TextUtil.stripNewlines(table.html()))
        want = "<table><tbody><tr><td><img></td></tr></tbody></table>"
        @Assert(want, TextUtil.stripNewlines(doc.body().html()))
    }

    @TestCase
    func templateTableRowFragment(): Unit {
        // https://github.com/jhy/jsoup/issues/1409 (per the fragment <tr> use case)
        let doc: Document = Html4cj.parse("<body><table><template></template></table></body")
        let html: String = "<tr><td><img></td></tr>"
        let tmpl: Element = doc.selectFirst("template").getOrThrow()
        tmpl.html(html) // invokes the fragment parser with template as context
        var want: String = "<tr><td><img></td></tr>"
        @Assert(want, TextUtil.stripNewlines(tmpl.html()))
        tmpl.unwrap()

        want = "<html><head></head><body><table><tr><td><img></td></tr></table></body></html>"
        @Assert(want, TextUtil.stripNewlines(doc.html()))
    }

    @TestCase
    func templateNotInTableRowFragment(): Unit {
        // https://github.com/jhy/jsoup/issues/1409 (per the fragment <tr> use case)
        let doc: Document = Html4cj.parse("<body><template></template></body")
        let html: String = "<tr><td><img></td></tr>"
        let tmpl: Element = doc.selectFirst("template").getOrThrow()
        tmpl.html(html) // invokes the fragment parser with template as context
        var want: String = "<tr><td><img></td></tr>"
        @Assert(want, TextUtil.stripNewlines(tmpl.html()))
        tmpl.unwrap()

        want = "<html><head></head><body><tr><td><img></td></tr></body></html>"
        @Assert(want, TextUtil.stripNewlines(doc.html()))
    }

    @TestCase
    func templateFragment(): Unit {
        // https://github.com/jhy/jsoup/issues/1315
        let html: String = "<template id=\"lorem-ipsum\"><tr><td>Lorem</td><td>Ipsum</td></tr></template>"
        let frag: Document = Html4cj.parseBodyFragment(html)
        let want: String = "<template id=\"lorem-ipsum\"><tr><td>Lorem</td><td>Ipsum</td></tr></template>"
        @Assert(want, TextUtil.stripNewlines(frag.body().html()))
    }

    @TestCase
    func templateInferredForm(): Unit {
        // https://github.com/jhy/jsoup/issues/1637 | https://bugs.chromium.org/p/oss-fuzz/issues/detail?id=38987
        let doc: Document = Html4cj.parse("<template><isindex action>")

        // assertNotNull(doc)
        @Assert("<template><form><hr><label>This is a searchable index. Enter search keywords: <input name=\"isindex\"></label><hr></form></template>",
            TextUtil.stripNewlines(doc.head().html()))
    }

    @TestCase
    func trimNormalizeElementNamesInBuilder(): Unit {
        // https://github.com/jhy/jsoup/issues/1637 | https://bugs.chromium.org/p/oss-fuzz/issues/detail?id=38983
        // This is interesting - in TB state, the element name was "template\u001E", so no name checks matched. Then,
        // when the Element is created, the name got normalized to "template" and so looked like there should be a
        // template on the stack during resetInsertionMode for the select.
        // The issue was that the normalization in Tag.valueOf did a trim which the Token.Tag did not
        let doc: Document = Html4cj.parse("<template\u{001E}<select<input<")

        // assertNotNull(doc)
        println(doc.head().html())
        @Assert("<template><select></select><input>&lt;</template>",
            TextUtil.stripNewlines(doc.head().html()))
    }

    @TestCase
    func errorsBeforeHtml(): Unit {
        let parser: Parser = Parser.htmlParser()
        parser.setTrackErrors(10)
        let doc: Document = Html4cj.parse("<!doctype html><!doctype something></div>", parser)
        let errors: ParseErrorList = parser.getErrors()
        @Assert(2, errors.size)
        @Assert("<1:36>: Unexpected Doctype token [<!doctype something>] when in state [BeforeHtml]", errors[0].toString())
        @Assert("<1:42>: Unexpected EndTag token [</div>] when in state [BeforeHtml]", errors[1].toString())
        @Assert("<!doctype html><html><head></head><body></body></html>", TextUtil.stripNewlines(doc.html()))
    }

    @TestCase
    func afterHeadReAdds(): Unit {
        let parser: Parser = Parser.htmlParser()
        parser.setTrackErrors(10)
        let doc: Document = Html4cj.parse("<head></head><meta charset=UTF8><p>Hello", parser)
        let errors: ParseErrorList = parser.getErrors()
        @Assert(1, errors.size)
        @Assert("<1:33>: Unexpected StartTag token [<meta  charset=\"UTF8\">] when in state [AfterHead]", errors[0].toString())
        @Assert("<html><head><meta charset=\"UTF8\"></head><body><p>Hello</p></body></html>", TextUtil.stripNewlines(doc.html()))
        // meta gets added back into head
    }

    @TestCase
    func mergeHtmlAttributesFromBody(): Unit {
        let doc: Document = Html4cj.parse("<html id=1 class=foo><body><html class=bar data=x><p>One")
        @Assert("<html id=\"1\" class=\"foo\" data=\"x\"><head></head><body><p>One</p></body></html>", TextUtil.stripNewlines(doc.html()))
    }

    @TestCase
    func mergeHtmlNoAttributesFromBody(): Unit {
        let doc: Document = Html4cj.parse("<html id=1 class=foo><body><html><p>One")
        @Assert("<html id=\"1\" class=\"foo\"><head></head><body><p>One</p></body></html>", TextUtil.stripNewlines(doc.html()))
    }
}
