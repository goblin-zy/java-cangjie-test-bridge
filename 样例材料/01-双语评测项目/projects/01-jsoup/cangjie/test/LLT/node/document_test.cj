// RESOURCES: htmltests/basehref.html
// DEPENDENCE: text_util_test.cj
// EXEC: cjc %import-path %L %l %f text_util_test.cj -g --test
// EXEC: ./main 
//--filter=*.testOverflowClone
import cangjie_tpc::html4cj.*
import std.collection.ArrayList
import std.fs.File
import std.unittest.*
import std.unittest.testmacro.*

main(): Int64 {
    let documentTest: DocumentTest = DocumentTest()

    documentTest.setTextPreservesDocumentStructure()
    documentTest.testTitles()
    documentTest.testOutputEncoding()
    documentTest.testXhtmlReferences()
    documentTest.testNormalisesStructure()

    documentTest.accessorsWillNormalizeStructure()
    documentTest.accessorsAreCaseInsensitive()
    documentTest.testClone()
    documentTest.testBasicIndent()
    documentTest.testClonesDeclarations()

    documentTest.testLocation()
    documentTest.testLocationFromString()
    documentTest.testHtmlAndXmlSyntax()
    documentTest.htmlParseDefaultsToHtmlOutputSyntax()
    documentTest.testHtmlAppendable()

    documentTest.testOverflowClone()
    documentTest.DocumentsWithSameContentAreEqual()
    documentTest.DocumentsWithSameContentAreVerifiable()
    documentTest.testMetaCharsetUpdateUtf8()
    documentTest.testMetaCharsetUpdateIso8859()

    documentTest.testMetaCharsetUpdateNoCharset()
    documentTest.testMetaCharsetUpdateDisabled()
    documentTest.testMetaCharsetUpdateDisabledNoChanges()
    documentTest.testMetaCharsetUpdateEnabledAfterCharsetChange()
    documentTest.testMetaCharsetUpdateCleanup()

    documentTest.testMetaCharsetUpdateXmlUtf8()
    documentTest.testMetaCharsetUpdateXmlIso8859()
    documentTest.testMetaCharsetUpdateXmlNoCharset()
    documentTest.testMetaCharsetUpdateXmlDisabled()
    documentTest.testMetaCharsetUpdateXmlDisabledNoChanges()

    documentTest.testMetaCharsetUpdatedDisabledPerDefault()
    documentTest.testShiftJisRoundtrip()
    documentTest.parseAndHtmlOnDifferentThreads()
    documentTest.testDocumentTypeGet()
    documentTest.framesetSupportsBodyMethod()

    documentTest.forms()
    documentTest.expectForm()

    let quirksModeTest = QuirksModeTest()

    quirksModeTest.initTest()

    let syntaxTest = SyntaxTest()

    syntaxTest.initTest()

    let documentOutputSettingsTest = DocumentOutputSettingsTest()

    documentOutputSettingsTest.initTest()

    return 0
}

@Test
public class DocumentTest {
    private static let charsetUtf8: String = "UTF-8"

    private static let charsetIso8859: String = "ISO-8859-1"

    @TestCase
    public func setTextPreservesDocumentStructure(): Unit {
        // 1 
        var doc: Document = Html4cj.parse("<p>Hello</p>")
        doc.text("Replaced")
        @Assert("Replaced", doc.text())
        @Assert("Replaced", doc.body().text())
        @Assert(1, doc.select("head").size)

        println("Pass1")
    }

    @TestCase
    public func testTitles(): Unit {
        // 2
        var noTitle: Document = Html4cj.parse("<p>Hello</p>")
        var withTitle: Document = Html4cj.parse("<title>First</title><title>Ignore</title><p>Hello</p>")
        @Assert("", noTitle.title())
        noTitle.title("Hello")
        @Assert("Hello", noTitle.title())
        @Assert("Hello", noTitle.select("title").first().getOrThrow().text())
        @Assert("First", withTitle.title())
        withTitle.title("Hello")
        @Assert("Hello", withTitle.title())
        @Assert("Hello", withTitle.select("title").first().getOrThrow().text())
        var normaliseTitle: Document = Html4cj.parse("<title>   Hello\nthere   \n   now   \n")
        @Assert("Hello there now", normaliseTitle.title())

        println("Pass2")
    }

    @TestCase
    public func testOutputEncoding(): Unit {
        // 3
        var doc: Document = Html4cj.parse("<p title=π>π & < > </p>")

        // default is utf-8
        @Assert("<p title=\"π\">π &amp; &lt; &gt;</p>", doc.body().html())
        @Assert("UTF-8", doc.outputSettings().charset())
        doc.outputSettings().charset("ascii")
        var escapeMode: EscapeMode = doc.outputSettings().escapeMode()
        var escapeMode1: EscapeMode = EscapeMode.base
        @Assert(escapeMode1, escapeMode)
        @Assert("<p title=\"&#x3c0;\">&#x3c0; &amp; &lt; &gt;</p>", doc.body().html())
        doc.outputSettings().escapeMode(EscapeMode.extended)
        @Assert("<p title=\"&pi;\">&pi; &amp; &lt; &gt;</p>", doc.body().html())

        println("Pass3")
    }

    @TestCase
    public func testXhtmlReferences(): Unit {
        // 4
        var doc: Document = Html4cj.parse("&lt; &gt; &amp; &quot; &apos; &times;")
        doc.outputSettings().escapeMode(EscapeMode.xhtml)
        @Assert("&lt; &gt; &amp; \" ' ×", doc.body().html())

        println("Pass4")
    }

    @TestCase
    public func testNormalisesStructure(): Unit {
        // 5
        var doc: Document = Html4cj.parse(
            "<html><head><script>one</script><noscript><p>two</p></noscript></head><body><p>three</p></body><p>four</p></html>"
        )
        @Assert("<html><head><script>one</script><noscript>&lt;p&gt;two</noscript></head><body><p>three</p><p>four</p></body></html>", TextUtil.stripNewlines(doc.html()))

        println("Pass5")
    }

    @TestCase
    public func accessorsWillNormalizeStructure(): Unit {
        // 6
        var doc: Document = Document("")
        @Assert("", doc.html())
        var body: Element = doc.body()
        @Assert("body", body.tagName())
        var head: Element = doc.head()
        @Assert("head", head.tagName())
        @Assert("<html><head></head><body></body></html>", TextUtil.stripNewlines(doc.html()))

        println("Pass6")
    }

    @TestCase
    public func accessorsAreCaseInsensitive(): Unit {
        // 7
        var parser: Parser = Parser.htmlParser().settings(ParseSettings.preserveCase)
        var doc: Document = parser.parseInput(
            "<!DOCTYPE html><HTML><HEAD><TITLE>SHOUTY</TITLE></HEAD><BODY>HELLO</BODY></HTML>", "")
        var body: Element = doc.body()
        @Assert("BODY", body.tagName())
        @Assert("body", body.normalName())
        var head: Element = doc.head()
        @Assert("HEAD", head.tagName())
        @Assert("body", body.normalName())
        var root: Element = doc.selectFirst("html").getOrThrow()
        @Assert("HTML", root.tagName())
        @Assert("html", root.normalName())
        @Assert("SHOUTY", doc.title())

        println("Pass7")
    }

    @TestCase
    public func testClone(): Unit {
        // 8
        var doc: Document = Html4cj.parse("<title>Hello</title> <p>One<p>Two")
        var clone: Document = doc.clone()
        @Assert("<html><head><title>Hello</title></head><body><p>One</p><p>Two</p></body></html>", TextUtil.stripNewlines(clone.html()))
        clone.title("Hello there")
        clone.expectFirst("p").text("One more").attr("id", "1")
        @Assert("<html><head><title>Hello there</title></head><body><p id=\"1\">One more</p><p>Two</p></body></html>", TextUtil.stripNewlines(clone.html()))
        @Assert("<html><head><title>Hello</title></head><body><p>One</p><p>Two</p></body></html>", TextUtil.stripNewlines(doc.html()))

        println("Pass8")
    }

    @TestCase
    func testBasicIndent(): Unit {
        // 9
        var doc: Document = Html4cj.parse("<title>Hello</title> <p>One<p>Two")
        var expect: String =
            "<html>\n <head>\n  <title>Hello</title>\n </head>\n <body>\n  <p>One</p>\n  <p>Two</p>\n </body>\n</html>"
        @Assert(expect, doc.html())

        println("Pass9")
    }

    @TestCase
    public func testClonesDeclarations(): Unit {
        // 10
        var doc: Document = Html4cj.parse("<!DOCTYPE html><html><head><title>Doctype test")
        var clone: Document = doc.clone()
        @Assert(doc.html(), clone.html())
        @Assert("<!doctype html><html><head><title>Doctype test</title></head><body></body></html>",
                TextUtil.stripNewlines(clone.html()))

        println("Pass10")
    }

    @TestCase
    public func testLocation(): Unit {
        // 11
        // tests location vs base href
        let str: String = String.fromUtf8(File.readFrom("basehref.html"))
        var doc: Document = Html4cj.parse(str, "http://example.com/")
        let location: String = doc.location()
        let baseUri: String = doc.baseUri()
        @Assert("http://example.com/", location)
        @Assert("https://example.com/path/file.html?query", baseUri)
        @Assert("./anotherfile.html", doc.expectFirst("a").attr("href"))
        @Assert("https://example.com/path/anotherfile.html", doc.expectFirst("a").attr("abs:href"))

        println("Pass11")
    }

    @TestCase
    public func testLocationFromString(): Unit {
        // 12
        var doc: Document = Html4cj.parse("<p>Hello")
        @Assert("", doc.location())

        println("Pass12")
    }

    @TestCase
    public func testHtmlAndXmlSyntax(): Unit {
        // 13
        var h: String = "<!DOCTYPE html><body><img async checked='checked' src='&<>\"'>&lt;&gt;&amp;&quot;<foo />bar"
        var doc: Document = Html4cj.parse(h)
        doc.outputSettings().syntax(Syntax.htmlSyntax)
        @Assert("<!doctype html>\n" +
                "<html>\n" +
                " <head></head>\n" +
                " <body>\n" +
                "  <img async checked src=\"&amp;<>&quot;\">&lt;&gt;&amp;\"<foo />bar\n" +
                " </body>\n" +
                "</html>", doc.html())
        doc.outputSettings().syntax(Syntax.xmlSyntax)
        @Assert("<!DOCTYPE html>\n" +
                "<html>\n" +
                " <head></head>\n" +
                " <body>\n" +
                "  <img async=\"\" checked=\"checked\" src=\"&amp;&lt;>&quot;\" />&lt;&gt;&amp;\"<foo />bar\n" +
                " </body>\n" +
                "</html>", doc.html())

        println("Pass13")
    }

    @TestCase
    public func htmlParseDefaultsToHtmlOutputSyntax(): Unit {
        // 14
        var doc: Document = Html4cj.parse("x")
        @Assert(Syntax.htmlSyntax, doc.outputSettings().syntax())

        println("Pass14")
    }

    @TestCase
    public func testHtmlAppendable(): Unit {
        // 15
        var htmlContent: String = "<html><head><title>Hello</title></head><body><p>One</p><p>Two</p></body></html>"
        var document: Document = Html4cj.parse(htmlContent)
        var outputSettings: DocumentOutputSettings = DocumentOutputSettings()
        outputSettings.prettyPrint(false)
        document.outputSettings(outputSettings)
        @Assert(htmlContent, document.html(StringBuilder()).toString())

        println("Pass15")
    }

    @TestCase
    public func testOverflowClone(): Unit {
        // 16
        var sb: StringBuilder = StringBuilder()
        sb.append("<head><base href='https://Html4cj.org/'>")
        for (i in 0..100) {
            i
            sb.append("<div>")
        }
        sb.append("<p>Hello <a href='/example.html'>there</a>")

        var doc: Document = Html4cj.parse(sb.toString())
        // println(doc)
        println(Attributes.internalKey("baseUri"))
        println(doc.baseUri())
        for(t in doc.attributes()){
            println("attributes: ${t}")
            // println("${t[0]} ${t[1]}")
        }
        println(doc.head())
        println(doc.attributes())
        println(doc.attributes().dataSize)
        println(doc.attributes().size)
        println(doc.attributes().get("/baseUri"))

        // url schema/host 大小写不敏感 (实际大多转成小写)
        // url path 大小写敏感 
        // 此处由于 std URL 设计差异 统一转成小写对比
        var expectedLink: String = "https://Html4cj.org/example.html".toAsciiLower()
        @Assert(expectedLink, doc.selectFirst("a").getOrThrow().attr("abs:href").toAsciiLower())
        var clone: Document = doc.clone()
        doc.hasSameValue(clone)
        @Assert(expectedLink, clone.selectFirst("a").getOrThrow().attr("abs:href").toAsciiLower())

        println("Pass16")
    }

    @TestCase
    public func DocumentsWithSameContentAreEqual(): Unit {
        // 17
        var docA: Document = Html4cj.parse("<div/>One")
        var docB: Document = Html4cj.parse("<div/>One")
        Html4cj.parse("<div/>Two")
        @Assert(refEq(docA, docB), false)
        @Assert(docA, docA)
        @Assert(docA.hashCode(), docA.hashCode())

        println("Pass17")
    }

    @TestCase
    public func DocumentsWithSameContentAreVerifiable(): Unit {
        // 18
        var docA: Document = Html4cj.parse("<div/>One")
        var docB: Document = Html4cj.parse("<div/>One")
        var docC: Document = Html4cj.parse("<div/>Two")
        @Assert(docA.hasSameValue(docB), true)
        @Assert(false, docA.hasSameValue(docC))

        println("Pass18")
    }

    @TestCase
    public func testMetaCharsetUpdateUtf8(): Unit {
        // 19
        var doc: Document = createHtmlDocument("changeThis")
        doc.updateMetaCharsetElement(true)
        doc.charset(charsetUtf8)
        var htmlCharsetUTF8: String =
            "<html>\n" + " <head>\n" + "  <meta charset=\"" + charsetUtf8 + "\">\n" + " </head>\n" + " <body></body>\n" +
            "</html>"
        @Assert(htmlCharsetUTF8, doc.toString())
        var selectedElement: Element = doc.select("meta[charset]").first().getOrThrow()
        @Assert(charsetUtf8, doc.charset())
        @Assert(charsetUtf8, selectedElement.attr("charset"))
        @Assert(doc.charset(), doc.outputSettings().charset())

        println("Pass19")
    }

    @TestCase
    public func testMetaCharsetUpdateIso8859(): Unit {
        // 20
        var doc: Document = createHtmlDocument("changeThis")
        doc.updateMetaCharsetElement(true)
        doc.charset(charsetIso8859)
        doc.select("meta[charset]").first().getOrThrow()
        @Assert(doc.charset(), doc.outputSettings().charset())

        println("Pass20")
    }

    @TestCase
    public func testMetaCharsetUpdateNoCharset(): Unit {
        // 21
        var docNoCharset: Document = Document.createShell("")
        docNoCharset.updateMetaCharsetElement(true)
        docNoCharset.charset(charsetUtf8)
        @Assert(charsetUtf8, docNoCharset.select("meta[charset]").first().getOrThrow().attr("charset"))
        var htmlCharsetUTF8: String =
            "<html>\n" + " <head>\n" + "  <meta charset=\"" + charsetUtf8 + "\">\n" + " </head>\n" + " <body></body>\n" +
            "</html>"
        @Assert(htmlCharsetUTF8, docNoCharset.toString())

        println("Pass21")
    }

    @TestCase
    public func testMetaCharsetUpdateDisabled(): Unit {
        // 22
        var docDisabled: Document = Document.createShell("")
        var htmlNoCharset: String = "<html>\n" + " <head></head>\n" + " <body></body>\n" + "</html>"
        @Assert(htmlNoCharset, docDisabled.toString())
        @Assert(docDisabled.select("meta[charset]").first() == None, true)

        println("Pass22")
    }

    @TestCase
    public func testMetaCharsetUpdateDisabledNoChanges(): Unit {
        // 23
        var doc: Document = createHtmlDocument("dontTouch")
        var htmlCharset: String =
            "<html>\n" + " <head>\n" + "  <meta charset=\"dontTouch\">\n" +
            "  <meta name=\"charset\" content=\"dontTouch\">\n" + " </head>\n" + " <body></body>\n" + "</html>"
        @Assert(htmlCharset, doc.toString())
        var selectedElement: Element = doc.select("meta[charset]").first().getOrThrow()
        @Assert("dontTouch", selectedElement.attr("charset"))
        selectedElement = doc.select("meta[name=charset]").first().getOrThrow()
        @Assert("dontTouch", selectedElement.attr("content"))

        println("Pass23")
    }

    @TestCase
    public func testMetaCharsetUpdateEnabledAfterCharsetChange(): Unit {
        // 24
        var doc: Document = createHtmlDocument("dontTouch")
        doc.charset(charsetUtf8)
        var selectedElement: Element = doc.select("meta[charset]").first().getOrThrow()
        @Assert(charsetUtf8, selectedElement.attr("charset"))
        @Assert(doc.select("meta[name=charset]").elementArr.isEmpty(), true)

        println("Pass24")
    }

    @TestCase
    public func testMetaCharsetUpdateCleanup(): Unit {
        // 25
        var doc: Document = createHtmlDocument("dontTouch")
        doc.updateMetaCharsetElement(true)
        doc.charset(charsetUtf8)
        var htmlCharsetUTF8: String =
            "<html>\n" + " <head>\n" + "  <meta charset=\"" + charsetUtf8 + "\">\n" + " </head>\n" + " <body></body>\n" +
            "</html>"
        @Assert(htmlCharsetUTF8, doc.toString())

        println("Pass25")
    }

    @TestCase
    public func testMetaCharsetUpdateXmlUtf8(): Unit {
        // 26
        var doc: Document = createXmlDocument("1.0", "changeThis", true)
        doc.updateMetaCharsetElement(true)
        doc.charset(charsetUtf8)
        var xmlCharsetUTF8: String = "<?xml version=\"1.0\" encoding=\"" + charsetUtf8 + "\"?>\n" + "<root>\n" +
            " node\n" + "</root>"
        @Assert(xmlCharsetUTF8, doc.toString())
        var selectedNode: XmlDeclaration = (doc.childNode(0) as XmlDeclaration).getOrThrow()
        @Assert(charsetUtf8, doc.charset())
        @Assert(charsetUtf8, selectedNode.attr("encoding"))
        @Assert(doc.charset(), doc.outputSettings().charset())

        println("Pass26")
    }

    @TestCase
    public func testMetaCharsetUpdateXmlIso8859(): Unit {
        // 27
        var doc: Document = createXmlDocument("1.0", "changeThis", true)
        doc.updateMetaCharsetElement(true)
        doc.charset(charsetIso8859)
        (doc.childNode(0) as XmlDeclaration).getOrThrow()
        @Assert(doc.charset(), doc.outputSettings().charset())

        println("Pass27")
    }

    @TestCase
    public func testMetaCharsetUpdateXmlNoCharset(): Unit {
        // 28
        var doc: Document = createXmlDocument("1.0", "none", false)
        doc.updateMetaCharsetElement(true)
        doc.charset(charsetUtf8)
        var xmlCharsetUTF8: String = "<?xml version=\"1.0\" encoding=\"" + charsetUtf8 + "\"?>\n" + "<root>\n" +
            " node\n" + "</root>"
        @Assert(xmlCharsetUTF8, doc.toString())
        var selectedNode: XmlDeclaration = (doc.childNode(0) as XmlDeclaration).getOrThrow()
        @Assert(charsetUtf8, selectedNode.attr("encoding"))

        println("Pass28")
    }

    @TestCase
    public func testMetaCharsetUpdateXmlDisabled(): Unit {
        // 29
        var doc: Document = createXmlDocument("none", "none", false)
        var xmlNoCharset: String = "<root>\n" + " node\n" + "</root>"
        @Assert(xmlNoCharset, doc.toString())

        println("Pass29")
    }

    @TestCase
    public func testMetaCharsetUpdateXmlDisabledNoChanges(): Unit {
        // 30
        var doc: Document = createXmlDocument("dontTouch", "dontTouch", true)
        var xmlCharset: String = "<?xml version=\"dontTouch\" encoding=\"dontTouch\"?>\n" + "<root>\n" + " node\n" +
            "</root>"
        @Assert(xmlCharset, doc.toString())
        var selectedNode: XmlDeclaration = (doc.childNode(0) as XmlDeclaration).getOrThrow()
        @Assert("dontTouch", selectedNode.attr("encoding"))
        @Assert("dontTouch", selectedNode.attr("version"))

        println("Pass30")
    }

    @TestCase
    public func testMetaCharsetUpdatedDisabledPerDefault(): Unit {
        // 31
        var doc: Document = createHtmlDocument("none")
        @Assert(false, doc.updateMetaCharsetElement())

        println("Pass31")
    }

    private func createHtmlDocument(charset: String): Document {
        var doc: Document = Document.createShell("")
        doc.head().appendElement("meta").attr("charset", charset)
        doc.head().appendElement("meta").attr("name", "charset").attr("content", charset)
        return doc
    }

    private func createXmlDocument(version: String, charset: String, addDecl: Bool): Document {
        var doc: Document = Document("")
        doc.appendElement("root").text("node")
        doc.outputSettings().syntax(Syntax.xmlSyntax)
        if (addDecl) {
            var decl: XmlDeclaration = XmlDeclaration("xml", false)
            decl.attr("version", version)
            decl.attr("encoding", charset)
            doc.prependChild(decl)
        }
        return doc
    }

    @TestCase
    public func testShiftJisRoundtrip(): Unit {
        // 32
        var input: String =
            "<html><head><meta http-equiv=\"content-type\" content=\"text/html; charset=Shift_JIS\" /></head><body>before&nbsp;after</body></html>"
        var doc: Document = Html4cj.parse(input, "http://example.com")
        doc.outputSettings().escapeMode(EscapeMode.xhtml)
        @Assert(doc.html().contains("?"), false)
        @Assert(doc.html().contains("&#xa0;") || doc.html().contains("&nbsp;"), true)

        println("Pass32")
    }

    @TestCase
    public func parseAndHtmlOnDifferentThreads(): Unit {
        // 33
        var html: String = "<p>Alrighty then it's not \u{1f4a9}. <span>Next</span></p>" // 💩
        var asci: String = "<p>Alrighty then it's not &#x1f4a9;. <span>Next</span></p>"
        var doc: Document = Html4cj.parse(html)
        var out: Array<String> = Array<String>(1, repeat: "")
        var p: Elements = doc.select("p")
        @Assert(html, p.outerHtml())
        out[0] = p.outerHtml()
        doc.outputSettings().charset("ASCII")
        @Assert(html, out[0])
        @Assert("ASCII", doc.outputSettings().charset())
        @Assert(asci, p.outerHtml())

        println("Pass33")
    }

    @TestCase
    public func testDocumentTypeGet(): Unit {
        // 34
        var html: String = "\n\n<!-- comment -->  <!doctype html><p>One</p>"
        var doc: Document = Html4cj.parse(html)
        var documentType: DocumentType = doc.documentType().getOrThrow()
        @Assert("html", documentType.name())

        println("Pass34")
    }

    @TestCase
    public func framesetSupportsBodyMethod(): Unit {
        // 35
        var html: String = "<html><head><title>Frame Test</title></head><frameset id=id><frame src=foo.html></frameset>"
        var doc: Document = Html4cj.parse(html)
        doc.head()
        @Assert("Frame Test", doc.title())

        // Frameset docs per html5 spec have no body element - but instead a frameset elelemt
        @Assert(doc.selectFirst("body") == None, true)
        var frameset: Element = doc.selectFirst("frameset").getOrThrow()

        // the body() method returns body or frameset and does not otherwise modify the document
        // doing it in body() vs parse keeps the html close to original for round-trip option
        var body: Element = doc.body()
        @Assert(frameset, body)
        @Assert("frame", body.child(0).tagName())

        // did not vivify a body element
        @Assert(doc.selectFirst("body") == None, true)
        var expected: String =
            "<html>\n" + " <head>\n" + "  <title>Frame Test</title>\n" + " </head>\n" + " <frameset id=\"id\">\n" +
            "  <frame src=\"foo.html\">\n" + " </frameset>\n" + "</html>"
        @Assert(expected, doc.html())

        println("Pass35")
    }

    @TestCase
    public func forms(): Unit {
        // 36
        var html: String = "<body><form id=1><input name=foo></form><form id=2><input name=bar>"
        var doc: Document = Html4cj.parse(html)
        var forms: ArrayList<FormElement> = doc.forms()
        @Assert(2, forms.size)
        var form: FormElement = forms[1]
        @Assert(1, form.elements().size)
        @Assert("bar", form.elements().first().getOrThrow().attr("name"))
        var emptyHtml: String = "<body>"
        var emptyDoc: Document = Html4cj.parse(emptyHtml)
        @Assert(0, emptyDoc.forms().size)

        println("Pass36")
    }

    @TestCase
    public func expectForm(): Unit {
        // 37
        var html: String =
            "<body><div name=form></div><form id=1 name=form><input name=foo></form><form id=2><input name=bar>"
        var doc: Document = Html4cj.parse(html)

        // test finds first <form>
        var formEl1: FormElement = doc.expectForm("[name=form]").getOrThrow()
        @Assert("1", formEl1.id())

        // and not the div
        var formEl2: FormElement = doc.expectForm("form").getOrThrow()
        @Assert("1", formEl2.id())
        var formEl3: FormElement = doc.expectForm("form:has([name=bar])").getOrThrow()
        @Assert("2", formEl3.id())
        var threw: Bool = false
        try {
            doc.expectForm("div").getOrThrow()
        } catch (e: Exception) {
            threw = true
        }
        @Assert(threw, true)

        println("Pass37")
    }
}

@Test
public class QuirksModeTest {
    @TestCase
    public func initTest(): Unit {
        // 1
        var quirksMode1: QuirksMode = QuirksMode.noQuirks
        var quirksMode2: QuirksMode = QuirksMode.quirks
        var quirksMode3: QuirksMode = QuirksMode.limitedQuirks
        @Assert("noQuirks", quirksMode1.toString())
        @Assert("quirks", quirksMode2.toString())
        @Assert("limitedQuirks", quirksMode3.toString())
        @Assert(true, quirksMode1 != quirksMode2)
        @Assert(true, quirksMode1 != quirksMode3)
        @Assert(true, quirksMode2 != quirksMode3)
        @Assert(false, quirksMode3 == quirksMode2)
        @Assert(false, quirksMode3 == quirksMode1)
        @Assert(false, quirksMode2 == quirksMode1)

        println("Pass1")
    }
}

@Test
public class SyntaxTest {
    @TestCase
    public func initTest(): Unit {
        // 1
        var syntax1: Syntax = Syntax.htmlSyntax
        var syntax2: Syntax = Syntax.xmlSyntax
        @Assert("htmlSyntax", syntax1.toString())
        @Assert("xmlSyntax", syntax2.toString())
        @Assert(true, syntax1 != syntax2)
        @Assert(false, syntax2 == syntax1)

        println("Pass1")
    }
}

@Test
public class DocumentOutputSettingsTest {
    @TestCase
    public func initTest(): Unit {
        // 1
        var documentOutputSettings: DocumentOutputSettings = DocumentOutputSettings()
        @Assert(EscapeMode.base == documentOutputSettings.escapeMode(), true)
        documentOutputSettings.escapeMode(EscapeMode.xhtml)
        @Assert(EscapeMode.xhtml == documentOutputSettings.escapeMode(), true)
        @Assert("UTF-8", documentOutputSettings.charset())
        documentOutputSettings.charset("ASCII")
        @Assert("ASCII", documentOutputSettings.charset())
        @Assert(Syntax.htmlSyntax, documentOutputSettings.syntax())
        documentOutputSettings.syntax(Syntax.xmlSyntax)
        @Assert(Syntax.xmlSyntax, documentOutputSettings.syntax())
        @Assert(true, documentOutputSettings.prettyPrint())
        documentOutputSettings.prettyPrint(false)
        @Assert(false, documentOutputSettings.prettyPrint())
        @Assert(false, documentOutputSettings.outline())
        documentOutputSettings.outline(true)
        @Assert(true, documentOutputSettings.outline())
        @Assert(1, documentOutputSettings.indentAmount())
        documentOutputSettings.indentAmount(10)
        @Assert(10, documentOutputSettings.indentAmount())
        @Assert(30, documentOutputSettings.maxPaddingWidth())
        documentOutputSettings.maxPaddingWidth(10)
        @Assert(10, documentOutputSettings.maxPaddingWidth())
        documentOutputSettings.clone()

        println("Pass1")
    }
}
