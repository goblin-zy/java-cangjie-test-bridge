package cangjie_tpc::html4cj

@Test
public class EntitiesTest {
    @TestCase
    public func escape(): Unit {
        // 1
        var text: String = "Hello &<> Å å π 新 there ¾ © »"
        var escapedAscii: String = Entities.escape(
            text,
            DocumentOutputSettings().charset("ascii").escapeMode(EscapeMode.base)
        )
        var escapedAsciiFull: String = Entities.escape(
            text,
            DocumentOutputSettings().charset("ascii").escapeMode(EscapeMode.extended)
        )
        var escapedAsciiXhtml: String = Entities.escape(
            text,
            DocumentOutputSettings().charset("ascii").escapeMode(EscapeMode.xhtml)
        )
        var escapedUtfFull: String = Entities.escape(
            text,
            DocumentOutputSettings().charset("UTF-8").escapeMode(EscapeMode.extended)
        )
        var escapedUtfMin: String = Entities.escape(
            text,
            DocumentOutputSettings().charset("UTF-8").escapeMode(EscapeMode.xhtml)
        )
        @Assert("Hello &amp;&lt;&gt; &Aring; &aring; &#x3c0; &#x65b0; there &frac34; &copy; &raquo;", escapedAscii)
        @Assert("Hello &amp;&lt;&gt; &angst; &aring; &pi; &#x65b0; there &frac34; &copy; &raquo;", escapedAsciiFull)
        @Assert("Hello &amp;&lt;&gt; &#xc5; &#xe5; &#x3c0; &#x65b0; there &#xbe; &#xa9; &#xbb;", escapedAsciiXhtml)
        @Assert("Hello &amp;&lt;&gt; Å å π 新 there ¾ © »", escapedUtfFull)
        @Assert("Hello &amp;&lt;&gt; Å å π 新 there ¾ © »", escapedUtfMin)

        // odd that it's defined as aring in base but angst in full
        // round trip
        @Assert(text, Entities.unescape(escapedAscii))
        @Assert(text, Entities.unescape(escapedAsciiFull))
        @Assert(text, Entities.unescape(escapedAsciiXhtml))
        @Assert(text, Entities.unescape(escapedUtfFull))
        @Assert(text, Entities.unescape(escapedUtfMin))

        println("Pass1")
    }

    @TestCase
    public func escapedSupplementary(): Unit {
        // 2
        var text: String = "${'\u{1D559}'}"
        var escapedAscii: String = Entities.escape(text, DocumentOutputSettings().charset("ascii").escapeMode(base))
        @Assert("&#x1d559;", escapedAscii)
        var escapedAsciiFull: String = Entities.escape(
            text,
            DocumentOutputSettings().charset("ascii").escapeMode(extended)
        )
        @Assert("&hopf;", escapedAsciiFull)
        var escapedUtf: String = Entities.escape(text, DocumentOutputSettings().charset("UTF-8").escapeMode(extended))
        @Assert(text, escapedUtf)

        println("Pass2")
    }

    @TestCase
    public func unescapeMultiChars(): Unit {
        // 3
        // gg is not combo, but 8811 could conflict with NestedGreaterGreater or others
        var text: String = "&NestedGreaterGreater; &nGg; &nGt; &nGtv; &Gt; &gg;"
        var un: String = "≫ ⋙̸ ≫⃒ ≫̸ ≫ ≫"
        @Assert(un, Entities.unescape(text))
        var escaped: String = Entities.escape(un, DocumentOutputSettings().charset("ascii").escapeMode(extended))
        @Assert("&Gt; &Gg;&#x338; &Gt;&#x20d2; &Gt;&#x338; &Gt; &Gt;", escaped)
        @Assert(un, Entities.unescape(escaped))

        println("Pass3")
    }

    @TestCase
    public func xhtmlTest(): Unit {
        // 4
        @Assert(38, EscapeMode.xhtml.codepointForName("amp"))
        @Assert(62, EscapeMode.xhtml.codepointForName("gt"))
        @Assert(60, EscapeMode.xhtml.codepointForName("lt"))
        @Assert(34, EscapeMode.xhtml.codepointForName("quot"))
        @Assert("amp", EscapeMode.xhtml.nameForCodepoint(38))
        @Assert("gt", EscapeMode.xhtml.nameForCodepoint(62))
        @Assert("lt", EscapeMode.xhtml.nameForCodepoint(60))
        @Assert("quot", EscapeMode.xhtml.nameForCodepoint(34))

        println("Pass4")
    }

    @TestCase
    public func getByName(): Unit {
        // 5
        @Assert("≫⃒", Entities.getByName("nGt"))
        @Assert("fj", Entities.getByName("fjlig"))
        @Assert("≫", Entities.getByName("gg"))
        @Assert("©", Entities.getByName("copy"))

        println("Pass5")
    }

    @TestCase
    public func escapeSupplementaryCharacter(): Unit {
        // 6
        var text: String = "${'\u{210C1}'}"
        var escapedAscii: String = Entities.escape(text,
            DocumentOutputSettings().charset("ascii").escapeMode(EscapeMode.base))
        @Assert("&#x210c1;", escapedAscii)
        var escapedUtf: String = Entities.escape(text,
            DocumentOutputSettings().charset("UTF-8").escapeMode(EscapeMode.base))
        @Assert(text, escapedUtf)

        println("Pass6")
    }

    @TestCase
    public func notMissingMultis(): Unit {
        // 7
        var text: String = "&nparsl;"
        var un: String = "${'\u{2AFD}'}${'\u{20E5}'}"
        @Assert(un, Entities.unescape(text))

        println("Pass7")
    }

    @TestCase
    public func notMissingSupplementals(): Unit {
        // 8
        var text: String = "&npolint; &qfr;"
        var un: String = "⨔ ${'\u{1D52E}'}"
        @Assert(un, Entities.unescape(text))

        println("Pass8")
    }

    @TestCase
    public func unescape(): Unit {
        // 9
        var text: String =
            "Hello &AElig; &amp;&LT&gt; &reg &angst; &angst &#960; &#960 &#x65B0; there &! &frac34; &copy; &COPY;"
        @Assert("Hello Æ &<> ® Å &angst π π 新 there &! ¾ © ©", Entities.unescape(text))
        @Assert("&0987654321; &unknown", Entities.unescape("&0987654321; &unknown"))

        println("Pass9")
    }

    @TestCase
    public func strictUnescape(): Unit {
        // 10
        // for attributes, enforce strict unescaping (must look like &#xxx; , not just &#xxx)
        var text: String = "Hello &amp= &amp;"
        @Assert("Hello &amp= &", Entities.unescape(text, true))
        @Assert("Hello &= &", Entities.unescape(text))
        @Assert("Hello &= &", Entities.unescape(text, false))

        println("Pass10")
    }

    @TestCase
    public func caseSensitive(): Unit {
        // 11
        var unescaped: String = "Ü ü & &"
        @Assert("&Uuml; &uuml; &amp; &amp;",
                Entities.escape(unescaped, DocumentOutputSettings().charset("ascii").escapeMode(extended)))
        var escaped: String = "&Uuml; &uuml; &amp; &AMP"
        @Assert("Ü ü & &", Entities.unescape(escaped))

        println("Pass11")
    }

    @TestCase
    public func quoteReplacements(): Unit {
        // 12
        var escaped: String = "&#92; &#36;"
        var unescaped: String = "\\ $"
        @Assert(unescaped, Entities.unescape(escaped))

        println("Pass12")
    }

    @TestCase
    public func letterDigitEntities(): Unit {
        // 13
        var html: String = "<p>&sup1;&sup2;&sup3;&frac14;&frac12;&frac34;</p>"
        var doc: Document = Html4cj.parse(html)
        doc.outputSettings().charset("ascii")
        var p: Element = doc.select("p").first().getOrThrow()
        @Assert("&sup1;&sup2;&sup3;&frac14;&frac12;&frac34;", p.html())
        @Assert("¹²³¼½¾", p.text())
        doc.outputSettings().charset("UTF-8")
        @Assert("¹²³¼½¾", p.html())

        println("Pass13")
    }

    @TestCase
    public func noSpuriousDecodes(): Unit {
        // 14
        var string: String = "http://www.foo.com?a=1&num_rooms=1&children=0&int=VA&b=2"
        @Assert(string, Entities.unescape(string))

        println("Pass14")
    }

    @TestCase
    public func escapesGtInXmlAttributesButNotInHtml(): Unit {
        // 15
        // https://github.com/jhy/jsoup/issues/528 - < is OK in HTML attribute values, but not in XML
        var docHtml: String = "<a title='<p>One</p>'>One</a>"
        var doc: Document = Html4cj.parse(docHtml)
        var element: Element = doc.select("a").first().getOrThrow()
        doc.outputSettings().escapeMode(base)
        @Assert("<a title=\"<p>One</p>\">One</a>", element.outerHtml())
        doc.outputSettings().escapeMode(xhtml)
        @Assert("<a title=\"&lt;p>One&lt;/p>\">One</a>", element.outerHtml())

        println("Pass15")
    }

    @TestCase
    public func controlCharactersAreEscaped(): Unit {
        // 16
        // https://github.com/jhy/jsoup/issues/1556
        // we escape ascii control characters in both HTML and XML for compatibility. Required in XML and probably
        // easier to read in HTML
        var input: String = "<a foo=\"&#x1b;esc&#x7;bell\">Text &#x1b; &#x7;</a>"
        var doc: Document = Html4cj.parse(input)
        @Assert(input, doc.body().html())
        var xml: Document = Html4cj.parse(input, "", Parser.xmlParser())
        @Assert(input, xml.html())

        println("Pass16")
    }
}

@Test
public class EscapeModeTest {
    @TestCase
    public func initTest(): Unit {
        // 1
        var escapeMode1: EscapeMode = EscapeMode.xhtml
        var escapeMode2: EscapeMode = EscapeMode.base
        var escapeMode3: EscapeMode = EscapeMode.extended
        @Assert("xhtml", escapeMode1.toString())
        @Assert("base", escapeMode2.toString())
        @Assert("extended", escapeMode3.toString())
        @Assert(true, escapeMode1 != escapeMode2)
        @Assert(true, escapeMode1 != escapeMode3)
        @Assert(true, escapeMode2 != escapeMode3)
        @Assert(false, escapeMode3 == escapeMode2)
        @Assert(false, escapeMode3 == escapeMode1)
        @Assert(false, escapeMode2 == escapeMode1)

        println("Pass1")
    }
}
