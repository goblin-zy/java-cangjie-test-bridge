package cangjie_tpc::html4cj

/*
 * Tests XmlTreeBuilder.
 * @author Jonathan Hedley
 */
@Test
public class XmlTreeBuilderTest {
    @TestCase
    public func testSimpleXmlParse(): Unit {
        // let xml: String = "<doc id=2 href='/bar'>Foo <br /><link>One</link><link>Two</link></doc>"
        XmlTreeBuilder()
        // let doc: Document = tb.parse(xml, "http://foo.com/")
        // @Assert("<doc id=\"2\" href=\"/bar\">Foo <br /><link>One</link><link>Two</link></doc>",TextUtil.stripNewlines(doc.html()))
        // @Assert(doc.getElementById("2").getOrThrow().absUrl("href"), "http://foo.com/bar")
    }

    @TestCase
    public func testPopToClose(): Unit {
        // test: </val> closes Two, </bar> ignored
        // let xml: String = "<doc><val>One<val>Two</val></bar>Three</doc>"
        XmlTreeBuilder()
        // let doc: Document = tb.parse(xml, "http://foo.com/")
        // @Assert("<doc><val>One<val>Two</val>Three</val></doc>",TextUtil.stripNewlines(doc.html()))
    }

    @TestCase
    public func testCommentAndDocType(): Unit {
        // let xml: String = "<!DOCTYPE HTML><!-- a comment -->One <qux />Two"
        XmlTreeBuilder()
        // let doc: Document = tb.parse(xml, "http://foo.com/")
        // @Assert("<!DOCTYPE HTML><!-- a comment -->One <qux />Two",TextUtil.stripNewlines(doc.html()))
    }

    @TestCase
    public func testSupplyParserToJsoupClass(): Unit {
        let xml: String = "<doc><val>One<val>Two</val></bar>Three</doc>"
        let doc: Document = Html4cj.parse(xml, "http://foo.com/", Parser.xmlParser())
        @Assert("<doc><val>One<val>Two</val>Three</val></doc>",
                TextUtil.stripNewlines(doc.html()))
    }

    // @TestCase
    // public func testSupplyParserToConnection(): Unit {
    //     let xmlUrl: String = "http://direct.infohound.net/tools/jsoup-xml-test.xml"
    
    //     // parse with both xml and html parser, ensure different
    //     let xmlDoc: Document = Html4cj.connect(xmlUrl).parser(Parser.xmlParser()).get()
    //     let htmlDoc: Document = Html4cj.connect(xmlUrl).parser(Parser.htmlParser()).get()
    //     let autoXmlDoc: Document = Html4cj.connect(xmlUrl).get() // check connection auto detects xml, uses xml parser
    
    //     @Assert("<doc><val>One<val>Two</val>Three</val></doc>",TextUtil.stripNewlines(xmlDoc.html()))
    //     @Assert(htmlDoc != xmlDoc)
    //     @Assert(xmlDoc, autoXmlDoc)
    //     @Assert(1, htmlDoc.select("head").size) // html parser normalises
    //     @Assert(0, xmlDoc.select("head").size) // xml parser does not
    //     @Assert(0, autoXmlDoc.select("head").size) // xml parser does not
    // }
    @TestCase
    public func testSupplyParserToDataStream(): Unit {
        let xmlFile = File.readFrom("test/htmltests/xml-test.xml")
        let content = String.fromUtf8(xmlFile)

        // let inStream: InputStream = FileInputStream(xmlFile)
        let doc: Document = Html4cj.parse(content, "http://foo.com", Parser.xmlParser())
        @Assert("<doc><val>One<val>Two</val>Three</val></doc>",TextUtil.stripNewlines(doc.html()))
    }

    @TestCase
    public func testDoesNotForceSelfClosingKnownTags(): Unit {
        // html will force "<br>one</br>" to logically "<br />One<br />". XML should be stay "<br>one</br> -- don't recognise tag.
        let htmlDoc: Document = Html4cj.parse("<br>one</br>")
        @Assert("<br>\none<br>", htmlDoc.body().html())

        let xmlDoc: Document = Html4cj.parse("<br>one</br>", "", Parser.xmlParser())
        @Assert("<br>one</br>", xmlDoc.html())
    }

    @TestCase
    public func handlesXmlDeclarationAsDeclaration(): Unit {
        let html: String = "<?xml encoding='UTF-8' ?><body>One</body><!-- comment -->"
        let doc: Document = Html4cj.parse(html, "", Parser.xmlParser())
        @Assert("<?xml encoding=\"UTF-8\"?><body>One</body><!-- comment -->",doc.outerHtml())
        @Assert("#declaration", doc.childNode(0).nodeName())
        @Assert("#comment", doc.childNode(2).nodeName())
    }

    @TestCase
    public func xmlFragment(): Unit {
        let xml: String = "<one src='/foo/' />Two<three><four /></three>"
        let nodes: ArrayList<Node> = Parser.parseXmlFragment(xml, "http://example.com/")
        @Assert(3, nodes.size)
        let str = "http://example.com/foo/"
        @Assert(str, nodes[0].absUrl("src"))
        @Assert("one", nodes[0].nodeName())
        @Assert("Two", ((nodes[1] as TextNode).getOrThrow()).text())
    }

    @TestCase
    public func xmlParseDefaultsToHtmlOutputSyntax(): Unit {
        let doc: Document = Html4cj.parse("x", "", Parser.xmlParser())
        @Assert(Syntax.xmlSyntax, doc.outputSettings().syntax())
    }

    @TestCase
    public func testDoesHandleEOFInTag(): Unit {
        let html: String = "<img src=asdf onerror=\"alert(1)\" x="
        let xmlDoc: Document = Html4cj.parse(html, "", Parser.xmlParser())
        @Assert("<img src=\"asdf\" onerror=\"alert(1)\" x=\"\" />", xmlDoc.html())
    }

    // @TestCase
    // public func testDetectCharsetEncodingDeclaration(): Unit {
    //     // let xmlFile: File = File(XmlTreeBuilder.class.getResource("/htmltests/xml-charset.xml").toURI())
    //     // let inStream: InputStream = FileInputStream(xmlFile)
    //     // let doc: Document =  Html4cj.parse(inStream, null, "http://example.com/", Parser.xmlParser())
    //     let xmlFile: Array<Byte> = File.readFrom("test/htmltests/xml-charset.xml")
    //     let content = String.fromUtf8(xmlFile)
    //     let doc: Document = Html4cj.parse(content, "http://example.com/", Parser.xmlParser())
    //     @Assert("ISO-8859-1", doc.charset())
    //     @Assert("<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?><data>äöåéü</data>",TextUtil.stripNewlines(doc.html()))
    // }
    @TestCase
    public func testParseDeclarationAttributes(): Unit {
        let xml: String = "<?xml version='1' encoding='UTF-8' something='else'?><val>One</val>"
        let doc: Document = Html4cj.parse(xml, "", Parser.xmlParser())
        let decl: XmlDeclaration = (doc.childNode(0) as XmlDeclaration).getOrThrow()
        @Assert("1", decl.attr("version"))
        @Assert("UTF-8", decl.attr("encoding"))
        @Assert("else", decl.attr("something"))
        @Assert("version=\"1\" encoding=\"UTF-8\" something=\"else\"", decl.getWholeDeclaration())
        @Assert("<?xml version=\"1\" encoding=\"UTF-8\" something=\"else\"?>", decl.outerHtml())
    }

    @TestCase
    public func testParseDeclarationWithoutAttributes(): Unit {
        let xml: String =
            "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n<?myProcessingInstruction My Processing instruction.?>"
        let doc: Document = Html4cj.parse(xml, "", Parser.xmlParser())
        let decl: XmlDeclaration = (doc.childNode(2) as XmlDeclaration).getOrThrow()
        @Assert("myProcessingInstruction", decl.name())
        @Assert(decl.hasAttr("My"))
        @Assert("<?myProcessingInstruction My Processing instruction.?>", decl.outerHtml())
    }

    @TestCase
    public func caseSensitiveDeclaration(): Unit {
        let xml: String = "<?XML version='1' encoding='UTF-8' something='else'?>"
        let doc: Document = Html4cj.parse(xml, "", Parser.xmlParser())
        @Assert("<?XML version=\"1\" encoding=\"UTF-8\" something=\"else\"?>", doc.outerHtml())
    }

    @TestCase
    public func testCreatesValidProlog(): Unit {
        let document: Document = Document.createShell("")
        document.outputSettings().syntax(Syntax.xmlSyntax)

        // document.charset(StandardCharsets.UTF_8)
        document.charset("UTF-8")
        let str = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n" + "<html>\n" + " <head></head>\n" + " <body></body>\n" +
            "</html>"
        @Assert(str, document.outerHtml())
    }

    @TestCase
    public func preservesCaseByDefault(): Unit {
        let xml: String = "<CHECK>One</CHECK><TEST ID=1>Check</TEST>"
        let doc: Document = Html4cj.parse(xml, "", Parser.xmlParser())
        @Assert("<CHECK>One</CHECK><TEST ID=\"1\">Check</TEST>", TextUtil.stripNewlines(doc.html()))
    }

    @TestCase
    public func appendPreservesCaseByDefault(): Unit {
        let xml: String = "<One>One</One>"
        let doc: Document = Html4cj.parse(xml, "", Parser.xmlParser())
        let one: Elements = doc.select("One")
        one.append("<Two ID=2>Two</Two>")
        @Assert("<One>One<Two ID=\"2\">Two</Two></One>", TextUtil.stripNewlines(doc.html()))
    }

    @TestCase
    public func disablesPrettyPrintingByDefault(): Unit {
        let xml: String = "\n\n<div><one>One</one><one>\n Two</one>\n</div>\n "
        let doc: Document = Html4cj.parse(xml, "", Parser.xmlParser())
        @Assert(xml, doc.html())
    }

    @TestCase
    public func canNormalizeCase(): Unit {
        let xml: String = "<TEST ID=1>Check</TEST>"
        let doc: Document = Html4cj.parse(xml, "", Parser.xmlParser().settings(ParseSettings.htmlDefault))
        @Assert("<test id=\"1\">Check</test>", TextUtil.stripNewlines(doc.html()))
    }

    @TestCase
    public func normalizesDiscordantTags(): Unit {
        let parser: Parser = Parser.xmlParser().settings(ParseSettings.htmlDefault)
        let document: Document = Html4cj.parse("<div>test</DIV><p></p>", "", parser)
        @Assert("<div>test</div><p></p>", document.html())
        // was failing -> toString() = "<div>\n test\n <p></p>\n</div>"
    }

    @TestCase
    public func roundTripsCdata(): Unit {
        let xml: String = "<div id=1><![CDATA[\n<html>\n <foo><&amp;]]></div>"
        let doc: Document = Html4cj.parse(xml, "", Parser.xmlParser())

        let div: Element = doc.getElementById("1").getOrThrow()
        @Assert("<html>\n <foo><&amp;", div.text())
        @Assert(0, div.children().size)
        @Assert(1, div.childNodeSize()) // no elements, one text node

        @Assert("<div id=\"1\"><![CDATA[\n<html>\n <foo><&amp;]]></div>", div.outerHtml())

        let cdata: CDataNode = (div.textNodes()[0] as CDataNode).getOrThrow()
        @Assert("\n<html>\n <foo><&amp;", cdata.text())
    }

    @TestCase
    public func cdataPreservesWhiteSpace(): Unit {
        let xml: String = "<script type=\"text/javascript\">//<![CDATA[\n\n  foo();\n//]]></script>"
        let doc: Document = Html4cj.parse(xml, "", Parser.xmlParser())
        @Assert(xml, doc.outerHtml())

        @Assert("//\n\n  foo();\n//", doc.selectFirst("script").getOrThrow().text())
    }

    @TestCase
    public func handlesDodgyXmlDecl(): Unit {
        let xml: String = "<?xml version='1.0'><val>One</val>"
        let doc: Document = Html4cj.parse(xml, "", Parser.xmlParser())
        @Assert("One", doc.select("val").text())
    }

    @TestCase
    public func handlesLTinScript(): Unit {
        // https://github.com/jhy/jsoup/issues/1139
        let html: String = "<script> var a=\"<?\"; var b=\"?>\"; </script>"
        let doc: Document = Html4cj.parse(html, "", Parser.xmlParser())
        @Assert("<script> var a=\"<!--?\"; var b=\"?-->\"; </script>", doc.html()) // converted from pseudo xmldecl to comment
    }

    @TestCase
    public func dropsDuplicateAttributes(): Unit {
        // case sensitive, so should drop Four and Five
        let html: String = "<p One=One ONE=Two one=Three One=Four ONE=Five two=Six two=Seven Two=Eight>Text</p>"
        let parser: Parser = Parser.xmlParser().setTrackErrors(10)
        let doc: Document = parser.parseInput(html, "")

        @Assert("<p One=\"One\" ONE=\"Two\" one=\"Three\" two=\"Six\" Two=\"Eight\">Text</p>", doc.selectFirst("p").getOrThrow().outerHtml())
    }

    @TestCase
    public func readerClosedAfterParse(): Unit {
        let doc: Document = Html4cj.parse("Hello", "", Parser.xmlParser())
        let treeBuilder: TreeBuilder = doc.parser().getTreeBuilder()
        @Assert(treeBuilder.reader.isNone())
        @Assert(treeBuilder.tokeniser.isNone())
    }

    @TestCase
    public func xmlParserEnablesXmlOutputAndEscapes(): Unit {
        // Test that when using the XML parser, the output mode and escape mode default to XHTML entities
        // https://github.com/jhy/jsoup/issues/1420
        let doc: Document = Html4cj.parse("<p one='&lt;two&gt;&copy'>Three</p>", "", Parser.xmlParser())
        @Assert(doc.outputSettings().syntax(), Syntax.xmlSyntax)
        @Assert(doc.outputSettings().escapeMode(), EscapeMode.xhtml)
        @Assert("<p one=\"&lt;two>©\">Three</p>", doc.html()) // only the < should be escaped
    }

    @TestCase
    public func xmlSyntaxEscapesLtInAttributes(): Unit {
        // Regardless of the entity escape mode, make sure < is escaped in attributes when in XML
        let doc: Document = Html4cj.parse("<p one='&lt;two&gt;&copy'>Three</p>", "", Parser.xmlParser())
        doc.outputSettings().escapeMode(EscapeMode.extended)
        doc.outputSettings().charset("ascii") // to make sure &copy; is output
        @Assert(doc.outputSettings().syntax(), Syntax.xmlSyntax)
        @Assert("<p one=\"&lt;two>&copy;\">Three</p>", doc.html())
    }

    @TestCase
    func xmlOutputCorrectsInvalidAttributeNames(): Unit {
        let xml: String = "<body style=\"color: red\" \" name\"><div =\"\"></div></body>"
        let doc: Document = Html4cj.parse(xml, Parser.xmlParser())
        @Assert(Syntax.xmlSyntax, doc.outputSettings().syntax())

        let out: String = doc.html()
        @Assert("<body style=\"color: red\" name=\"\"><div></div></body>", out)
    }

    @TestCase
    func customTagsAreFlyweights(): Unit {
        let xml: String = "<foo>Foo</foo><foo>Foo</foo><FOO>FOO</FOO><FOO>FOO</FOO>"
        let doc: Document = Html4cj.parse(xml, Parser.xmlParser())
        let els: Elements = doc.children()

        let t1: Tag = els[0].tag()
        let t2: Tag = els[1].tag()
        let t3: Tag = els[2].tag()
        let t4: Tag = els[3].tag()
        @Assert("foo", t1.getName())
        @Assert("FOO", t3.getName())
        @Assert(refEq(t1, t2))
        @Assert(refEq(t3, t4))
    }
}
