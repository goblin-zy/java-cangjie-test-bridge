package cangjie_tpc::html4cj

@Test
public class CovTest {
    @TestCase
    public func testEvaluatorToString(): Unit {
        @Assert(EvaluatorTag("evaluatortag").toString(), "evaluatortag")
        @Assert(EvaluatorTagEndsWith("evaluatortagendswith").toString(), "evaluatortagendswith")
        @Assert(EvaluatorId("evaluatorid").toString(), "#evaluatorid")
        @Assert(EvaluatorClass("evaluatorclass").toString(), ".evaluatorclass")
        @Assert(EvaluatorAttribute("evaluatorattribute").toString(), "[evaluatorattribute]")
        @Assert(EvaluatorAttributeStarting("evaluatorattributestarting").toString(), "[^evaluatorattributestarting]")
        @Assert(EvaluatorAttributeWithValue("k", "v").toString(), "[k=v]")
        @Assert(EvaluatorAttributeWithValueNot("k", "v").toString(), "[k!=v]")
        @Assert(EvaluatorAttributeWithValueStarting("k", "v").toString(), "[k^=v]")
        @Assert(EvaluatorAttributeWithValueEnding("k", "v").toString(), "[k$=v]")
        @Assert(EvaluatorAttributeWithValueContaining("k", "v").toString(), "[k*=v]")
        @Assert(EvaluatorAttributeWithValueMatching("k", Regex("v")).toString(), "[k~=v]")
        @Assert(EvaluatorAllElements().toString(), "*")
        @Assert(EvaluatorIndexLessThan(1).toString(), ":lt(1)")
        @Assert(EvaluatorIndexGreaterThan(1).toString(), ":gt(1)")
        @Assert(EvaluatorIndexEquals(1).toString(), ":eq(1)")
        @Assert(EvaluatorIsLastChild().toString(), ":last-child")
        @Assert(EvaluatorIsFirstOfType().toString(), ":first-of-type")
        @Assert(EvaluatorIsLastOfType().toString(), ":last-of-type")
        @Assert(EvaluatorIsNthChild(0,1).toString(), ":nth-child(1)")
        @Assert(EvaluatorIsNthLastChild(1,0).toString(), ":nth-last-child(1n)")
        @Assert(EvaluatorIsNthOfType(1,2).toString(), ":nth-of-type(1n+2)")
        @Assert(EvaluatorIsNthLastOfType(-1,-2).toString(), ":nth-last-of-type(-1n-2)")
        @Assert(EvaluatorIsFirstChild().toString(), ":first-child")
        @Assert(EvaluatorIsRoot().toString(), ":root")
        @Assert(EvaluatorIsOnlyChild().toString(), ":only-child")
        @Assert(EvaluatorIsOnlyOfType().toString(), ":only-of-type")
        @Assert(EvaluatorIsEmpty().toString(), ":empty")
        @Assert(EvaluatorContainsText("evaluatorcontainstext").toString(), ":contains(evaluatorcontainstext)")
        @Assert(EvaluatorContainsWholeText("evaluatorcontainswholetext").toString(), ":containsWholeText(evaluatorcontainswholetext)")
        @Assert(EvaluatorContainsWholeOwnText("evaluatorcontainswholeowntext").toString(), ":containsWholeOwnText(evaluatorcontainswholeowntext)")
        @Assert(EvaluatorContainsData("evaluatorcontainsdata").toString(), ":containsData(evaluatorcontainsdata)")
        @Assert(EvaluatorContainsOwnText("evaluatorcontainsowntext").toString(), ":containsOwn(evaluatorcontainsowntext)")
        @Assert(EvaluatorMatches(Regex("evaluatormatches")).toString(), ":matches(evaluatormatches)")
        @Assert(EvaluatorMatchesOwn(Regex("evaluatormatchesown")).toString(), ":matchesOwn(evaluatormatchesown)")
        @Assert(EvaluatorMatchesWholeText(Regex("evaluatormatcheswholetext")).toString(), ":matchesWholeText(evaluatormatcheswholetext)")
        @Assert(EvaluatorMatchesWholeOwnText(Regex("evaluatormatcheswholeowntext")).toString(), ":matchesWholeOwnText(evaluatormatcheswholeowntext)")
        @Assert(EvaluatorMatchText().toString(), ":matchText")
    }

    @TestCase
    public func testParseError(): Unit {
        let err = ParseError(1, "some error")
        @Assert(err.getCursorPos(), "1")
    }

    @TestCase
    public func testParseErrorList(): Unit {
        let errList = ParseErrorList(1, 2)
        errList.add(ParseError(18, "some error"))
        for (err in errList) {
            @Assert(err.toString(), "<18>: some error")
        }
        let errList2 = errList.clone()
        @Assert(refEq(errList[0], errList2[0]))
    }

    @TestCase
    public func testHtmlTreeBuilderStateToString(): Unit {
        @Assert(HtmlTreeBuilderState.Initial.toString(), "Initial")
        @Assert(HtmlTreeBuilderState.BeforeHtml.toString(), "BeforeHtml")
        @Assert(HtmlTreeBuilderState.BeforeHead.toString(), "BeforeHead")
        @Assert(HtmlTreeBuilderState.InHead.toString(), "InHead")
        @Assert(HtmlTreeBuilderState.InHeadNoscript.toString(), "InHeadNoscript")
        @Assert(HtmlTreeBuilderState.AfterHead.toString(), "AfterHead")
        @Assert(HtmlTreeBuilderState.InBody.toString(), "InBody")
        @Assert(HtmlTreeBuilderState.Text.toString(), "Text")
        @Assert(HtmlTreeBuilderState.InTable.toString(), "InTable")
        @Assert(HtmlTreeBuilderState.InTableText.toString(), "InTableText")
        @Assert(HtmlTreeBuilderState.InCaption.toString(), "InCaption")
        @Assert(HtmlTreeBuilderState.InColumnGroup.toString(), "InColumnGroup")
        @Assert(HtmlTreeBuilderState.InTableBody.toString(), "InTableBody")
        @Assert(HtmlTreeBuilderState.InRow.toString(), "InRow")
        @Assert(HtmlTreeBuilderState.InCell.toString(), "InCell")
        @Assert(HtmlTreeBuilderState.InSelect.toString(), "InSelect")
        @Assert(HtmlTreeBuilderState.InSelectInTable.toString(), "InSelectInTable")
        @Assert(HtmlTreeBuilderState.InTemplate.toString(), "InTemplate")
        @Assert(HtmlTreeBuilderState.AfterBody.toString(), "AfterBody")
        @Assert(HtmlTreeBuilderState.InFrameset.toString(), "InFrameset")
        @Assert(HtmlTreeBuilderState.AfterFrameset.toString(), "AfterFrameset")
        @Assert(HtmlTreeBuilderState.AfterAfterBody.toString(), "AfterAfterBody")
        @Assert(HtmlTreeBuilderState.AfterAfterFrameset.toString(), "AfterAfterFrameset")
        @Assert(HtmlTreeBuilderState.ForeignContent.toString(), "ForeignContent")
    }

    @TestCase
    public func testUtil(): Unit {
        @Assert(None<Object>.refEq(None<Object>))
        let obj = Object()
        @Assert(Some(obj).refEq(obj))
        @Assert(Some(obj).refEq(None), false)
    }

    @TestCase
    public func testTokeniserToString(): Unit {
        @Assert(TokeniserState.BogusComment.toString(), "BogusComment")
        @Assert(TokeniserState.MarkupDeclarationOpen.toString(), "MarkupDeclarationOpen")
        @Assert(TokeniserState.CommentStart.toString(), "CommentStart")
        @Assert(TokeniserState.CommentStartDash.toString(), "CommentStartDash")
        @Assert(TokeniserState.CommentState.toString(), "CommentState")
        @Assert(TokeniserState.CommentEndDash.toString(), "CommentEndDash")
        @Assert(TokeniserState.CommentEnd.toString(), "CommentEnd")
        @Assert(TokeniserState.CommentEndBang.toString(), "CommentEndBang")
        @Assert(TokeniserState.Doctype.toString(), "Doctype")
        @Assert(TokeniserState.BeforeDoctypeName.toString(), "BeforeDoctypeName")
        @Assert(TokeniserState.DoctypeName.toString(), "DoctypeName")
        @Assert(TokeniserState.AfterDoctypeName.toString(), "AfterDoctypeName")
        @Assert(TokeniserState.AfterDoctypePublicKeyword.toString(), "AfterDoctypePublicKeyword")
        @Assert(TokeniserState.BeforeDoctypePublicIdentifier.toString(), "BeforeDoctypePublicIdentifier")
        @Assert(TokeniserState.DoctypePublicIdentifier_doubleQuoted.toString(), "DoctypePublicIdentifier_doubleQuoted")
        @Assert(TokeniserState.DoctypePublicIdentifier_singleQuoted.toString(), "DoctypePublicIdentifier_singleQuoted")
        @Assert(TokeniserState.AfterDoctypePublicIdentifier.toString(), "AfterDoctypePublicIdentifier")
        @Assert(TokeniserState.BetweenDoctypePublicAndSystemIdentifiers.toString(), "BetweenDoctypePublicAndSystemIdentifiers")
        @Assert(TokeniserState.AfterDoctypeSystemKeyword.toString(), "AfterDoctypeSystemKeyword")
        @Assert(TokeniserState.BeforeDoctypeSystemIdentifier.toString(), "BeforeDoctypeSystemIdentifier")
        @Assert(TokeniserState.DoctypeSystemIdentifier_doubleQuoted.toString(), "DoctypeSystemIdentifier_doubleQuoted")
        @Assert(TokeniserState.DoctypeSystemIdentifier_singleQuoted.toString(), "DoctypeSystemIdentifier_singleQuoted")
        @Assert(TokeniserState.AfterDoctypeSystemIdentifier.toString(), "AfterDoctypeSystemIdentifier")
        @Assert(TokeniserState.BogusDoctype.toString(), "BogusDoctype")
        @Assert(TokeniserState.CdataSection.toString(), "CdataSection")
    }

    @TestCase
    public func testDoctype(): Unit {
        var str = #"<!DOCTYPE html>"#
        @Assert(Html4cj.parse(str).firstChild().getOrThrow().toString(), str.replace("DOCTYPE html", "doctype html"))

        str = #"<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">"#
        @Assert(Html4cj.parse(str).firstChild().getOrThrow().toString(), str.replace("DOCTYPE HTML", "DOCTYPE html"))

        str = str.replace("\"", "'").replace("PUBLIC", "SYSTEM")
        println(Html4cj.parse(str).firstChild().getOrThrow().toString())

        str = #"<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">"#
        @Assert(Html4cj.parse(str).firstChild().getOrThrow().toString(), str.replace("DOCTYPE HTML", "DOCTYPE html"))

        str = str.replace("\"", "'").replace("PUBLIC", "SYSTEM")
        println(Html4cj.parse(str).firstChild().getOrThrow().toString())

        str = #"<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">"#
        @Assert(Html4cj.parse(str).firstChild().getOrThrow().toString(), str.replace("DOCTYPE HTML", "DOCTYPE html"))

        str = str.replace("\"", "'").replace("PUBLIC", "SYSTEM")
        println(Html4cj.parse(str).firstChild().getOrThrow().toString())

        str = #"<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">"#
        @Assert(Html4cj.parse(str).firstChild().getOrThrow().toString(), str)

        str = str.replace("\"", "'").replace("PUBLIC", "SYSTEM")
        println(Html4cj.parse(str).firstChild().getOrThrow().toString())

        str = #"<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">"#
        @Assert(Html4cj.parse(str).firstChild().getOrThrow().toString(), str)

        str = str.replace("\"", "'").replace("PUBLIC", "SYSTEM")
        println(Html4cj.parse(str).firstChild().getOrThrow().toString())

        str = #"<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Frameset//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-frameset.dtd">"#
        @Assert(Html4cj.parse(str).firstChild().getOrThrow().toString(), str)

        str = str.replace("\"", "'").replace("PUBLIC", "SYSTEM")
        println(Html4cj.parse(str).firstChild().getOrThrow().toString())

        str = #"<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">"#
        @Assert(Html4cj.parse(str).firstChild().getOrThrow().toString(), str)

        str = str.replace("\"", "'").replace("PUBLIC", "SYSTEM")
        println(Html4cj.parse(str).firstChild().getOrThrow().toString())

        str = #"<!DOCTYPE _ PUBLIC SYSTEM "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">"#
        println(Html4cj.parse(str).firstChild().getOrThrow().toString())
        println(Html4cj.parse(str.replace("_", ">")).firstChild().getOrThrow().toString())
        println(Html4cj.parse(str.replace("_", "\u{FFFF}")).firstChild().getOrThrow().toString())
        println(Html4cj.parse(str.replace("_", "\u{0000}")).firstChild().getOrThrow().toString())
        println(Html4cj.parse(str.replace("\"", "'")).firstChild().getOrThrow().toString())
        println(Html4cj.parse(str.replace("SYSTEM", "PUBLIC")).firstChild().getOrThrow().toString())
        println(Html4cj.parse(str.replace("\"SYSTEM\"", "'PUBLIC'")).firstChild().getOrThrow().toString())
        println(Html4cj.parse(str.replace("\"", "")).firstChild().getOrThrow().toString())

        str = #"<!DOCTYPE html "SYSTEM" "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd"_"#
        println(Html4cj.parse(str).firstChild().getOrThrow().toString())
        println(Html4cj.parse(str.replace("_", ">")).firstChild().getOrThrow().toString())
        println(Html4cj.parse(str.replace("_", "\u{FFFF}")).firstChild().getOrThrow().toString())
        println(Html4cj.parse(str.replace("_", "\u{0000}")).firstChild().getOrThrow().toString())
        println(Html4cj.parse(str.replace("\"", "'")).firstChild().getOrThrow().toString())
        println(Html4cj.parse(str.replace("SYSTEM", "PUBLIC")).firstChild().getOrThrow().toString())
        println(Html4cj.parse(str.replace("\"SYSTEM\"", "'PUBLIC'")).firstChild().getOrThrow().toString())
        println(Html4cj.parse(str.replace("\"", "")).firstChild().getOrThrow().toString())

        str = #"<!DOCTYPE html "SYSTEM"_ "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">"#
        println(Html4cj.parse(str).firstChild().getOrThrow().toString())
        println(Html4cj.parse(str.replace("_", ">")).firstChild().getOrThrow().toString())
        println(Html4cj.parse(str.replace("_", "\u{FFFF}")).firstChild().getOrThrow().toString())
        println(Html4cj.parse(str.replace("_", "\u{0000}")).firstChild().getOrThrow().toString())
        println(Html4cj.parse(str.replace("\"", "'")).firstChild().getOrThrow().toString())
        println(Html4cj.parse(str.replace("SYSTEM", "PUBLIC")).firstChild().getOrThrow().toString())
        println(Html4cj.parse(str.replace("\"SYSTEM\"", "'PUBLIC'")).firstChild().getOrThrow().toString())
        println(Html4cj.parse(str.replace("\"", "")).firstChild().getOrThrow().toString())

        str = #"<!DOCTYPE html _"SYSTEM"  "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">"#
        println(Html4cj.parse(str).firstChild().getOrThrow().toString())
        println(Html4cj.parse(str.replace("_", ">")).firstChild().getOrThrow().toString())
        println(Html4cj.parse(str.replace("_", "\u{FFFF}")).firstChild().getOrThrow().toString())
        println(Html4cj.parse(str.replace("_", "\u{0000}")).firstChild().getOrThrow().toString())
        println(Html4cj.parse(str.replace("\"", "'")).firstChild().getOrThrow().toString())
        println(Html4cj.parse(str.replace("SYSTEM", "PUBLIC")).firstChild().getOrThrow().toString())
        println(Html4cj.parse(str.replace("\"SYSTEM\"", "'PUBLIC'")).firstChild().getOrThrow().toString())
        println(Html4cj.parse(str.replace("\"", "")).firstChild().getOrThrow().toString())

        str = #"<!DOCTYPE html "SYSTEM" "-//W3C//DTD XHTML 1.1//EN" _ "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">"#
        println(Html4cj.parse(str).firstChild().getOrThrow().toString())
        println(Html4cj.parse(str.replace("_", ">")).firstChild().getOrThrow().toString())
        println(Html4cj.parse(str.replace("_", "\u{FFFF}")).firstChild().getOrThrow().toString())
        println(Html4cj.parse(str.replace("_", "\u{0000}")).firstChild().getOrThrow().toString())
        println(Html4cj.parse(str.replace("\"", "'")).firstChild().getOrThrow().toString())
        println(Html4cj.parse(str.replace("SYSTEM", "PUBLIC")).firstChild().getOrThrow().toString())
        println(Html4cj.parse(str.replace("\"SYSTEM\"", "'PUBLIC'")).firstChild().getOrThrow().toString())
        println(Html4cj.parse(str.replace("\"", "")).firstChild().getOrThrow().toString())

        str = #"<!DOCTYPE html "SYSTEM" "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd" _>"#
        println(Html4cj.parse(str).firstChild().getOrThrow().toString())
        println(Html4cj.parse(str.replace("_", ">")).firstChild().getOrThrow().toString())
        println(Html4cj.parse(str.replace("_", "\u{FFFF}")).firstChild().getOrThrow().toString())
        println(Html4cj.parse(str.replace("_", "\u{0000}")).firstChild().getOrThrow().toString())
        println(Html4cj.parse(str.replace("\"", "'")).firstChild().getOrThrow().toString())
        println(Html4cj.parse(str.replace("SYSTEM", "PUBLIC")).firstChild().getOrThrow().toString())
        println(Html4cj.parse(str.replace("\"SYSTEM\"", "'PUBLIC'")).firstChild().getOrThrow().toString())
        println(Html4cj.parse(str.replace("\"", "")).firstChild().getOrThrow().toString())

        str = #"<!DOCTYPE html >"SYSTEM" "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">"#
        println(Html4cj.parse(str).firstChild().getOrThrow().toString())
        println(Html4cj.parse(str.replace("_", ">")).firstChild().getOrThrow().toString())
        println(Html4cj.parse(str.replace("_", "\u{FFFF}")).firstChild().getOrThrow().toString())
        println(Html4cj.parse(str.replace("_", "\u{0000}")).firstChild().getOrThrow().toString())
        println(Html4cj.parse(str.replace("\"", "'")).firstChild().getOrThrow().toString())
        println(Html4cj.parse(str.replace("SYSTEM", "PUBLIC")).firstChild().getOrThrow().toString())
        println(Html4cj.parse(str.replace("\"SYSTEM\"", "'PUBLIC'")).firstChild().getOrThrow().toString())
        println(Html4cj.parse(str.replace("\"", "")).firstChild().getOrThrow().toString())

        str = #"<!DOCTYPE html "SYSTEM"> "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">"#
        println(Html4cj.parse(str).firstChild().getOrThrow().toString())
        println(Html4cj.parse(str.replace("_", ">")).firstChild().getOrThrow().toString())
        println(Html4cj.parse(str.replace("_", "\u{FFFF}")).firstChild().getOrThrow().toString())
        println(Html4cj.parse(str.replace("_", "\u{0000}")).firstChild().getOrThrow().toString())
        println(Html4cj.parse(str.replace("\"", "'")).firstChild().getOrThrow().toString())
        println(Html4cj.parse(str.replace("SYSTEM", "PUBLIC")).firstChild().getOrThrow().toString())
        println(Html4cj.parse(str.replace("\"SYSTEM\"", "'PUBLIC'")).firstChild().getOrThrow().toString())
        println(Html4cj.parse(str.replace("\"", "")).firstChild().getOrThrow().toString())

        str = #"<!DOCTYPE html "SYSTEM" asd>"#
        println(Html4cj.parse(str).firstChild().getOrThrow().toString())
        println(Html4cj.parse(str.replace("\"", "")).firstChild().getOrThrow().toString())
        println(Html4cj.parse(str.replace("\"", "'")).firstChild().getOrThrow().toString())
        str = str.replace("SYSTEM", "PUBLIC")
        println(Html4cj.parse(str).firstChild().getOrThrow().toString())
        println(Html4cj.parse(str.replace("\"", "")).firstChild().getOrThrow().toString())
        println(Html4cj.parse(str.replace("\"", "'")).firstChild().getOrThrow().toString())
        str = #"<!DOCTYPE "SYSTEM\u{0000}">"#
        println(Html4cj.parse(str).firstChild().getOrThrow().toString())
        println(Html4cj.parse(str.replace("\"", "")).firstChild().getOrThrow().toString())
        println(Html4cj.parse(str.replace("\"", "'")).firstChild().getOrThrow().toString())
        str = str.replace("SYSTEM", "PUBLIC")
        println(Html4cj.parse(str).firstChild().getOrThrow().toString())
        println(Html4cj.parse(str.replace("\"", "")).firstChild().getOrThrow().toString())
        println(Html4cj.parse(str.replace("\"", "'")).firstChild().getOrThrow().toString())
        str = #"<!DOCTYPE "SYSTEM\u{FFFF}">"#
        println(Html4cj.parse(str).firstChild().getOrThrow().toString())
        println(Html4cj.parse(str.replace("\"", "")).firstChild().getOrThrow().toString())
        println(Html4cj.parse(str.replace("\"", "'")).firstChild().getOrThrow().toString())
        str = str.replace("SYSTEM", "PUBLIC")
        println(Html4cj.parse(str).firstChild().getOrThrow().toString())
        println(Html4cj.parse(str.replace("\"", "")).firstChild().getOrThrow().toString())
        println(Html4cj.parse(str.replace("\"", "'")).firstChild().getOrThrow().toString())
        str = #"<!DOCTYPE "SYSTEM>">"#
        println(Html4cj.parse(str).firstChild().getOrThrow().toString())
        println(Html4cj.parse(str.replace("\"", "")).firstChild().getOrThrow().toString())
        println(Html4cj.parse(str.replace("\"", "'")).firstChild().getOrThrow().toString())
        str = str.replace("SYSTEM", "PUBLIC")
        println(Html4cj.parse(str).firstChild().getOrThrow().toString())
        println(Html4cj.parse(str.replace("\"", "")).firstChild().getOrThrow().toString())
        println(Html4cj.parse(str.replace("\"", "'")).firstChild().getOrThrow().toString())
        str = #"<!DOCTYPE "SYSTEM<">"#
        println(Html4cj.parse(str).firstChild().getOrThrow().toString())
        println(Html4cj.parse(str.replace("\"", "")).firstChild().getOrThrow().toString())
        println(Html4cj.parse(str.replace("\"", "'")).firstChild().getOrThrow().toString())
        str = str.replace("SYSTEM", "PUBLIC")
        println(Html4cj.parse(str).firstChild().getOrThrow().toString())
        println(Html4cj.parse(str.replace("\"", "")).firstChild().getOrThrow().toString())
        println(Html4cj.parse(str.replace("\"", "'")).firstChild().getOrThrow().toString())

        let indenArr = ["SYSTEM", "PUBLIC"]

        for (q in ["'", "\"", ""]) {
            for (ws in ['\u{0}', '\u{FFFF}', '>', '<', '"', '\'', '_', '&']) {
                let arr = [
                    "${q}${indenArr[0]}${q}",
                    "${q}${indenArr[1]}${q}",
                    "${q}${indenArr[0]}${q} ${q}${indenArr[1]}${q}",
                    "${q}${indenArr[1]}${q} ${q}${indenArr[0]}${q}"
                ]
                for (i in arr) {
                    let htmls = [
                        "<!DOCTYPE html${ws}${i} ${q}http://www.w3.org/TR/REC-html40/strict.dtd${q}>",
                        "<!DOCTYPE html ${ws}${i} ${q}http://www.w3.org/TR/REC-html40/strict.dtd${q}>",
                        "<!DOCTYPE html ${i}${ws}${q}http://www.w3.org/TR/REC-html40/strict.dtd${q}>",
                        "<!DOCTYPE html ${i} ${ws}${q}http://www.w3.org/TR/REC-html40/strict.dtd${q}>",
                        "<!DOCTYPE html ${i} ${q}http://www.w3.org/TR/REC-html40/strict.dtd${q}${ws}>",
                        "<!DOCTYPE html ${i}${q}http://www.w3.org/TR/REC-html40/strict.dtd${q}${ws}>"
                    ]
                    for (html in htmls) {
                        let doc: Document = Html4cj.parse(html)
                        println(doc.childNode(0).outerHtml())
                    }
                }
            }
        }

        var doc: Document = Html4cj.parse("<!DOCTYPE>")
        @Assert("<!doctype><html> <head></head> <body></body></html>",doc.outerHtml().replace("\n",""))

        doc = Html4cj.parse("<!DOCTYPE><html><p>Foo</p></html>")
        @Assert("<!doctype><html> <head></head> <body>  <p>Foo</p> </body></html>",doc.outerHtml().replace("\n",""))

        doc = Html4cj.parse("<!DOCTYPE \u{0000}>")
        @Assert("<!doctype ${'\u{FFFD}'}><html> <head></head> <body></body></html>",doc.outerHtml().replace("\n",""))
    }

    @TestCase
    public func testParser(): Unit {
        // let parser = Parser.htmlParser()
        // var doc = parser.parseInput(StringReader("<_/><div>asd</div>"), "url1")
        // @Assert(doc.body().html().replace("\n",""), "&lt;_/&gt;<div> asd</div>")
        // parser.setTreeBuilder(XmlTreeBuilder())
        // parser.setTrackErrors(0)
        // let builder = (parser.newInstance().getTreeBuilder() as XmlTreeBuilder).getOrThrow()
        // var doc = builder.parse(StringReader("<_/><div>asd</div>"), "url2")
        // builder.insertNode(doc.lastChild().getOrThrow().clone().wrap("<wrap123/>"))
        // @Assert(doc.toString(), "&lt;_/&gt;<div>asd</div>")
    }
}
