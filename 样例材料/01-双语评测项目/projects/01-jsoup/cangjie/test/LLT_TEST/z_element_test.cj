package cangjie_tpc::html4cj

@Test
public class ElementTest {
    let reference: String =
        "<div id=div1><p>Hello</p><p>Another <b>element</b></p><div id=div2><img src=foo.png></div></div>"

    private func validateScriptContents(src: String, el: Element): Unit {
        // it's not text
        @Assert("", el.text())
        @Assert("", el.ownText())
        @Assert("", el.wholeText())
        @Assert(src, el.html())
        @Assert(src, el.data())
    }

    private func validateXmlScriptContents(el: Element): Unit {
        @Assert("var foo = 5 < 2; var bar = 1 && 2;", el.text())
        @Assert("var foo = 5 < 2; var bar = 1 && 2;", el.ownText())
        @Assert("var foo = 5 < 2;\nvar bar = 1 && 2;", el.wholeText())
        @Assert("var foo = 5 &lt; 2;\nvar bar = 1 &amp;&amp; 2;", el.html())
        @Assert("", el.data())
    }

    @TestCase
    public func testId(): Unit {
        // 1
        var doc: Document = Html4cj.parse("<div id=Foo>")
        var el: Element = doc.selectFirst("div").getOrThrow()
        @Assert("Foo", el.id())

        println("Pass1")
    }

    @TestCase
    public func testSetId(): Unit {
        // 2
        var doc: Document = Html4cj.parse("<div id=Boo>")
        var el: Element = doc.selectFirst("div").getOrThrow()
        el.id("Foo")
        @Assert("Foo", el.id())

        println("Pass2")
    }

    @TestCase
    public func getElementsByTagName(): Unit {
        // 3
        var doc: Document = Html4cj.parse(reference)
        var divs: ArrayList<Element> = doc.getElementsByTag("div").elementArr
        @Assert(2, divs.size)
        @Assert("div1", divs[0].id())
        @Assert("div2", divs[1].id())
        var ps: ArrayList<Element> = doc.getElementsByTag("p").elementArr
        @Assert(2, ps.size)
        @Assert("Hello", (ps[0].childNode(0) as TextNode).getOrThrow().getWholeText())
        @Assert("Another ", (ps[1].childNode(0) as TextNode).getOrThrow().getWholeText())
        var ps2: ArrayList<Element> = doc.getElementsByTag("P").elementArr
        @Assert(ps, ps2)
        var imgs: ArrayList<Element> = doc.getElementsByTag("img").elementArr
        @Assert("foo.png", imgs[0].attr("src"))
        var empty: ArrayList<Element> = doc.getElementsByTag("wtf").elementArr
        @Assert(0, empty.size)

        println("Pass3")
    }

    @TestCase
    public func getNamespacedElementsByTag(): Unit {
        // 4
        var doc: Document = Html4cj.parse("<div><abc:def id=1>Hello</abc:def></div>")
        var els: Elements = doc.getElementsByTag("abc:def")
        @Assert(1, els.size)
        @Assert("1", els.first().getOrThrow().id())
        @Assert("abc:def", els.first().getOrThrow().tagName())

        println("Pass4")
    }

    @TestCase
    public func testGetElementById(): Unit {
        // 5
        var doc: Document = Html4cj.parse(reference)
        var div: Element = doc.getElementById("div1").getOrThrow()
        @Assert("div1", div.id())
        @Assert(doc.getElementById("none") == None, true)
        var doc2: Document = Html4cj.parse("<div id=1><div id=2><p>Hello <span id=2>world!</span></p></div></div>")
        var div2: Element = doc2.getElementById("2").getOrThrow()

        // not the span
        @Assert("div", div2.tagName())

        // called from <p> context should be span
        var span: Element = div2.child(0).getElementById("2").getOrThrow()
        @Assert("span", span.tagName())

        println("Pass5")
    }

    @TestCase
    public func testGetText(): Unit {
        // 6
        var doc: Document = Html4cj.parse(reference)
        @Assert("Hello Another element", doc.text())
        @Assert("Another element", doc.getElementsByTag("p")[1].text())

        println("Pass6")
    }

    @TestCase
    public func testGetChildText(): Unit {
        // 7
        var doc: Document = Html4cj.parse("<p>Hello <b>there</b> now")
        var p: Element = doc.select("p").first().getOrThrow()
        @Assert("Hello there now", p.text())
        @Assert("Hello now", p.ownText())

        println("Pass7")
    }

    @TestCase
    public func testNormalisesText(): Unit {
        // 8
        var h: String = "<p>Hello<p>There.</p> \n <p>Here <b>is</b> \n s<b>om</b>e text."
        var doc: Document = Html4cj.parse(h)
        var text: String = doc.text()
        @Assert("Hello There. Here is some text.", text)

        println("Pass8")
    }

    @TestCase
    public func testKeepsPreText(): Unit {
        // 9
        var h: String = "<p>Hello \n \n there.</p> <div><pre>  What's \n\n  that?</pre>"
        var doc: Document = Html4cj.parse(h)
        @Assert("Hello there.   What's \n\n  that?", doc.text())

        println("Pass9")
    }

    @TestCase
    public func testKeepsPreTextInCode(): Unit {
        // 10
        var h: String = "<pre><code>code\n\ncode</code></pre>"
        var doc: Document = Html4cj.parse(h)
        @Assert("code\n\ncode", doc.text())
        @Assert("<pre><code>code\n\ncode</code></pre>", doc.body().html())

        println("Pass10")
    }

    @TestCase
    public func testKeepsPreTextAtDepth(): Unit {
        // 11
        var h: String = "<pre><code><span><b>code\n\ncode</b></span></code></pre>"
        var doc: Document = Html4cj.parse(h)
        @Assert("code\n\ncode", doc.text())
        @Assert("<pre><code><span><b>code\n\ncode</b></span></code></pre>", doc.body().html())

        println("Pass11")
    }

    @TestCase
    public func testBrHasSpace(): Unit {
        // 12
        var doc: Document = Html4cj.parse("<p>Hello<br>there</p>")
        @Assert("Hello there", doc.text())
        @Assert("Hello there", doc.select("p").first().getOrThrow().ownText())
        doc = Html4cj.parse("<p>Hello <br> there</p>")
        @Assert("Hello there", doc.text())

        println("Pass12")
    }

    @TestCase
    public func testBrHasSpaceCaseSensitive(): Unit {
        // 13
        var doc: Document = Html4cj.parse(
            "<p>Hello<br>there<BR>now</p>",
            Parser.htmlParser().settings(ParseSettings.preserveCase)
        )
        @Assert("Hello there now", doc.text())
        @Assert("Hello there now", doc.select("p").first().getOrThrow().ownText())
        doc = Html4cj.parse("<p>Hello <br> there <BR> now</p>")
        @Assert("Hello there now", doc.text())

        println("Pass13")
    }

    @TestCase
    public func textHasSpacesAfterBlock(): Unit {
        // 14
        var doc: Document = Html4cj.parse("<div>One</div><div>Two</div><span>Three</span><p>Fou<i>r</i></p>")
        var text: String = doc.text()
        var wholeText: String = doc.wholeText()
        @Assert("One Two Three Four", text)
        @Assert("OneTwoThreeFour",wholeText)
        @Assert("OneTwo",Html4cj.parse("<span>One</span><span>Two</span>").text())

        println("Pass14")
    }

    @TestCase
    public func testWholeText(): Unit {
        // 15
        var doc: Document = Html4cj.parse("<p> Hello\nthere &nbsp;  </p>")
        @Assert(" Hello\nthere    ", doc.wholeText())
        doc = Html4cj.parse("<p>Hello  \n  there</p>")
        @Assert("Hello  \n  there", doc.wholeText())
        doc = Html4cj.parse("<p>Hello  <div>\n  there</div></p>")
        @Assert("Hello  \n  there", doc.wholeText())

        println("Pass15")
    }

    @TestCase
    public func testGetSiblings(): Unit {
        // 16
        var doc: Document = Html4cj.parse("<div><p>Hello<p id=1>there<p>this<p>is<p>an<p id=last>element</div>")
        var p: Element = doc.getElementById("1").getOrThrow()
        @Assert("there", p.text())
        @Assert("Hello", p.previousElementSibling().getOrThrow().text())
        @Assert("this", p.nextElementSibling().getOrThrow().text())
        @Assert("Hello", p.firstElementSibling().text())
        @Assert("element", p.lastElementSibling().text())

        println("Pass16")
    }

    @TestCase
    public func testGetSiblingsWithDuplicateContent(): Unit {
        // 17
        var doc: Document = Html4cj.parse("<div><p>Hello<p id=1>there<p>this<p>this<p>is<p>an<p id=last>element</div>")
        var p: Element = doc.getElementById("1").getOrThrow()
        @Assert("there", p.text())
        @Assert("Hello", p.previousElementSibling().getOrThrow().text())
        @Assert("this", p.nextElementSibling().getOrThrow().text())
        @Assert("this", p.nextElementSibling().getOrThrow().nextElementSibling().getOrThrow().text())
        @Assert("is", p.nextElementSibling().getOrThrow().nextElementSibling().getOrThrow().nextElementSibling().getOrThrow().text())
        @Assert("Hello", p.firstElementSibling().text())
        @Assert("element", p.lastElementSibling().text())

        println("Pass17")
    }

    @TestCase
    public func testFirstElementSiblingOnOrphan(): Unit {
        // 18
        var p: Element = Element("p")
        @Assert(refEq(p, p.firstElementSibling()),true)
        @Assert(refEq(p, p.lastElementSibling()),true)

        println("Pass18")
    }

    @TestCase
    public func testFirstAndLastSiblings(): Unit {
        // 19       
        var doc: Document = Html4cj.parse("<div><p>One<p>Two<p>Three")
        var div: Element = doc.selectFirst("div").getOrThrow()
        var one: Element = div.child(0)
        var two: Element = div.child(1)
        var three: Element = div.child(2)
        @Assert(refEq(one, one.firstElementSibling()), true)
        @Assert(refEq(one, two.firstElementSibling()), true)
        @Assert(refEq(three, three.lastElementSibling()), true)
        @Assert(refEq(three, two.lastElementSibling()), true)

        println("Pass19")
    }

    @TestCase
    public func testGetParents(): Unit {
        // 20
        var doc: Document = Html4cj.parse("<div><p>Hello <span>there</span></div>")
        var span: Element = doc.select("span").first().getOrThrow()
        var parents: Elements = span.parents()
        @Assert(4, parents.size)
        @Assert("p", parents[0].tagName())
        @Assert("div", parents[1].tagName())
        @Assert("body", parents[2].tagName())
        @Assert("html", parents[3].tagName())
        var orphan: Element = Element("p")
        var none: Elements = orphan.parents()
        @Assert(0, none.size)

        println("Pass20")
    }

    @TestCase
    public func testElementSiblingIndex(): Unit {
        // 21
        var doc: Document = Html4cj.parse("<div><p>One</p>...<p>Two</p>...<p>Three</p>")
        var ps: Elements = doc.select("p")
        @Assert(0, ps[0].elementSiblingIndex())
        @Assert(1, ps[1].elementSiblingIndex())
        @Assert(2, ps[2].elementSiblingIndex())

        println("Pass21")
    }

    @TestCase
    public func testElementSiblingIndexSameContent(): Unit {
        // 22       
        var doc: Document = Html4cj.parse("<div><p>One</p>...<p>One</p>...<p>One</p>")
        var ps: Elements = doc.select("p")
        @Assert(0, ps[0].elementSiblingIndex())
        @Assert(1, ps[1].elementSiblingIndex())
        @Assert(2, ps[2].elementSiblingIndex())

        println("Pass22")
    }

    @TestCase
    public func testGetElementsWithClass(): Unit {
        // 23
        var doc: Document = Html4cj.parse(
            "<div class='mellow yellow'><span class=mellow>Hello <b class='yellow'>Yellow!</b></span><p>Empty</p></div>"
        )
        var els: ArrayList<Element> = doc.getElementsByClass("mellow").elementArr
        @Assert(2, els.size)
        @Assert("div", els[0].tagName())
        @Assert("span", els[1].tagName())
        var els2: ArrayList<Element> = doc.getElementsByClass("yellow").elementArr
        @Assert(2, els2.size)
        @Assert("div", els2[0].tagName())
        @Assert("b", els2[1].tagName())
        var none: ArrayList<Element> = doc.getElementsByClass("solo").elementArr
        @Assert(0, none.size)

        println("Pass23")
    }

    @TestCase
    public func testGetElementsWithAttribute(): Unit {
        // 24
        var doc: Document = Html4cj.parse("<div style='bold'><p title=qux><p><b style></b></p></div>")
        var els: ArrayList<Element> = doc.getElementsByAttribute("style").elementArr
        @Assert(2, els.size)
        @Assert("div", els[0].tagName())
        @Assert("b", els[1].tagName())
        var none: ArrayList<Element> = doc.getElementsByAttribute("class").elementArr
        @Assert(0, none.size)

        println("Pass24")
    }

    @TestCase
    public func testGetElementsWithAttributeDash(): Unit {
        // 25
        var doc: Document = Html4cj.parse(
            "<meta http-equiv=content-type value=utf8 id=1> <meta name=foo content=bar id=2> <div http-equiv=content-type value=utf8 id=3>"
        )
        var meta: Elements = doc.select("meta[http-equiv=content-type], meta[charset]")
        @Assert(1, meta.size)
        @Assert("1", meta.first().getOrThrow().id())

        println("Pass25")
    }

    @TestCase
    public func testGetElementsWithAttributeValue(): Unit {
        // 26
        var doc: Document = Html4cj.parse("<div style='bold'><p><p><b style></b></p></div>")
        var els: ArrayList<Element> = doc.getElementsByAttributeValue("style", "bold").elementArr
        @Assert(1, els.size)
        @Assert("div", els[0].tagName())
        var none: ArrayList<Element> = doc.getElementsByAttributeValue("style", "none").elementArr
        @Assert(0, none.size)

        println("Pass26")
    }

    @TestCase
    public func testClassDomMethods(): Unit {
        // 27
        var doc: Document = Html4cj.parse("<div><span class=' mellow yellow '>Hello <b>Yellow</b></span></div>")
        var els: ArrayList<Element> = doc.getElementsByAttribute("class").elementArr
        var span: Element = els[0]
        @Assert("mellow yellow", span.className())
        @Assert(span.hasClass("mellow"), true)
        @Assert(span.hasClass("yellow"), true)
        var classes: Set<String> = span.classNames()
        @Assert(2, classes.size)
        @Assert(classes.contains("mellow"), true)
        @Assert(classes.contains("yellow"), true)
        @Assert("", doc.className())
        classes = doc.classNames()
        @Assert(0, classes.size)
        @Assert(doc.hasClass("mellow"), false)

        println("Pass27")
    }

    @TestCase
    public func testHasClassDomMethods(): Unit {
        // 28
        var tag: Tag = Tag.valueOf("a")
        var attribs: Attributes = Attributes()
        var el: Element = Element(tag, "", attribs)
        attribs.put("class", "toto")
        var hasClass: Bool = el.hasClass("toto")
        @Assert(hasClass, true)
        attribs.put("class", " toto")
        hasClass = el.hasClass("toto")
        @Assert(hasClass, true)
        attribs.put("class", "toto ")
        hasClass = el.hasClass("toto")
        @Assert(hasClass, true)
        attribs.put("class", "\ttoto ")
        hasClass = el.hasClass("toto")
        @Assert(hasClass, true)
        attribs.put("class", "  toto ")
        hasClass = el.hasClass("toto")
        @Assert(hasClass, true)
        attribs.put("class", "ab")
        hasClass = el.hasClass("toto")
        @Assert(hasClass, false)
        attribs.put("class", "     ")
        hasClass = el.hasClass("toto")
        @Assert(hasClass, false)
        attribs.put("class", "tototo")
        hasClass = el.hasClass("toto")
        @Assert(hasClass, false)
        attribs.put("class", "raulpismuth  ")
        hasClass = el.hasClass("raulpismuth")
        @Assert(hasClass, true)
        attribs.put("class", " abcd  raulpismuth efgh ")
        hasClass = el.hasClass("raulpismuth")
        @Assert(hasClass, true)
        attribs.put("class", " abcd efgh raulpismuth")
        hasClass = el.hasClass("raulpismuth")
        @Assert(hasClass, true)
        attribs.put("class", " abcd efgh raulpismuth ")
        hasClass = el.hasClass("raulpismuth")
        @Assert(hasClass, true)

        println("Pass28")
    }

    @TestCase
    public func testClassUpdates(): Unit {
        // 29
        var doc: Document = Html4cj.parse("<div class='mellow yellow'></div>")
        var div: Element = doc.select("div").first().getOrThrow()
        div.addClass("green")
        @Assert("mellow yellow green", div.className())

        // noop
        div.removeClass("red")
        div.removeClass("yellow")
        @Assert("mellow green", div.className())
        div.toggleClass("green").toggleClass("red")
        @Assert("mellow red", div.className())

        println("Pass29")
    }

    @TestCase
    public func testOuterHtml(): Unit {
        // 30
        var doc: Document = Html4cj.parse("<div title='Tags &amp;c.'><img src=foo.png><p><!-- comment -->Hello<p>there")
        @Assert(
                "<html><head></head><body><div title=\"Tags &amp;c.\"><img src=\"foo.png\"><p><!-- comment -->Hello</p><p>there</p></div></body></html>",
                TextUtil.stripNewlines(doc.outerHtml())
            )

        println("Pass30")
    }

    @TestCase
    public func testInnerHtml(): Unit {
        // 31
        var doc: Document = Html4cj.parse("<div>\n <p>Hello</p> </div>")
        @Assert("<p>Hello</p>", doc.getElementsByTag("div")[0].html())

        println("Pass31")
    }

    @TestCase
    public func testFormatHtml(): Unit {
        // 32  
        var doc: Document = Html4cj.parse(
            "<title>Format test</title><div><p>Hello <span>Html4cj <span>users</span></span></p><p>Good.</p></div>")
        @Assert("<html>\n <head>\n  <title>Format test</title>\n </head>\n <body>\n  <div>\n   <p>Hello <span>Html4cj <span>users</span></span></p>\n   <p>Good.</p>\n  </div>\n </body>\n</html>", doc.html())

        println("Pass32")
    }

    @TestCase
    public func testFormatOutline(): Unit {
        // 33
        var doc: Document = Html4cj.parse(
            "<title>Format test</title><div><p>Hello <span>Html4cj <span>users</span></span></p><p>Good.</p></div>")
        doc.outputSettings().outline(true)
        @Assert(
                "<html>\n <head>\n  <title>Format test</title>\n </head>\n <body>\n  <div>\n   <p>\n    Hello \n    <span>\n     Html4cj \n     <span>users</span>\n    </span>\n   </p>\n   <p>Good.</p>\n  </div>\n </body>\n</html>",
                doc.html()
            )

        println("Pass33")
    }

    @TestCase
    public func testSetIndent(): Unit {
        // 34
        var doc: Document = Html4cj.parse("<div><p>Hello\nthere</p></div>")
        doc.outputSettings().indentAmount(0)
        @Assert("<html>\n<head></head>\n<body>\n<div>\n<p>Hello there</p>\n</div>\n</body>\n</html>", doc.html())

        println("Pass34")
    }

    @TestCase
    public func testIndentLevel(): Unit {
        // 35
        // deep to test default and extended max
        var divs: StringBuilder = StringBuilder()
        for (i in 0..40) {
            i
            divs.append("<div>")
        }
        divs.append("Foo")
        var doc: Document = Html4cj.parse(divs.toString())
        var settings: DocumentOutputSettings = doc.outputSettings()
        var defaultMax: Int64 = 30
        @Assert(defaultMax, settings.maxPaddingWidth())
        var html: String = doc.html()
        @Assert(
                html.contains(
                    "                              <div>\n" + "                              Foo\n" +
                        "                              </div>"
                ), true
            )

        settings.maxPaddingWidth(32)
        @Assert(32, settings.maxPaddingWidth())
        html = doc.html()
        @Assert(
                html.contains(
                    "                                <div>\n" + "                                Foo\n" +
                        "                                </div>"
                ), true
            )

        settings.maxPaddingWidth(-1)
        @Assert(-1, settings.maxPaddingWidth())
        html = doc.html()
        @Assert(
                html.contains(
                    "                                         <div>\n" + "                                          Foo\n" +
                        "                                         </div>"
                ), true
            )

        println("Pass35")
    }

    @TestCase
    public func testNotPretty(): Unit {
        // 36
        var doc: Document = Html4cj.parse("<div>   \n<p>Hello\n there\n</p></div>")
        doc.outputSettings().prettyPrint(false)
        @Assert("<html><head></head><body><div>   \n<p>Hello\n there\n</p></div></body></html>", doc.html())
        var div: Element = doc.select("div").first().getOrThrow()
        @Assert("   \n<p>Hello\n there\n</p>", div.html())

        println("Pass36")
    }

    @TestCase
    public func testNotPrettyWithEnDashBody(): Unit {
        // 37
        var html: String = "<div><span>1:15</span>&ndash;<span>2:15</span>&nbsp;p.m.</div>"
        var document: Document = Html4cj.parse(html)
        document.outputSettings().prettyPrint(false)
        @Assert("<div><span>1:15</span>–<span>2:15</span>&nbsp;p.m.</div>", document.body().html())

        println("Pass37")
    }

    @TestCase
    public func testPrettyWithEnDashBody(): Unit {
        // 38
        var html: String = "<div><span>1:15</span>&ndash;<span>2:15</span>&nbsp;p.m.</div>"
        var document: Document = Html4cj.parse(html)
        @Assert("<div>\n <span>1:15</span>–<span>2:15</span>&nbsp;p.m.\n</div>", document.body().html())

        println("Pass38")
    }

    @TestCase
    public func testPrettyAndOutlineWithEnDashBody(): Unit {
        // 39
        var html: String = "<div><span>1:15</span>&ndash;<span>2:15</span>&nbsp;p.m.</div>"
        var document: Document = Html4cj.parse(html)
        document.outputSettings().outline(true)
        @Assert("<div>\n <span>1:15</span>\n –\n <span>2:15</span>\n &nbsp;p.m.\n</div>", document.body().html())

        println("Pass39")
    }

    @TestCase
    public func testBasicFormats(): Unit {
        // 40
        var html: String =
            "<span>0</span>.<div><span>1</span>-<span>2</span><p><span>3</span>-<span>4</span><div>5</div>"
        var doc: Document = Html4cj.parse(html)
        @Assert(
                "<span>0</span>.\n" +
                    "<div>\n" +
                    " <span>1</span>-<span>2</span>\n" +
                    " <p><span>3</span>-<span>4</span></p>\n" +
                    " <div>\n" +
                    "  5\n" +
                    " </div>\n" +
                    "</div>", doc.body().html())

        println("Pass40")
    }

    @TestCase
    public func testEmptyElementFormatHtml(): Unit {
        // 41
        // don't put newlines into empty blocks
        var doc: Document = Html4cj.parse("<section><div></div></section>")
        @Assert("<section>\n <div></div>\n</section>", doc.select("section").first().getOrThrow().outerHtml())

        println("Pass41")
    }

    @TestCase
    public func testNoIndentOnScriptAndStyle(): Unit {
        // 42
        // don't newline+indent closing </script> and </style> tags
        var doc: Document = Html4cj.parse("<script>one\ntwo</script>\n<style>three\nfour</style>")
        @Assert("<script>one\ntwo</script>\n<style>three\nfour</style>", doc.head().html())

        println("Pass42")
    }

    @TestCase
    public func testContainerOutput(): Unit {
        // 43
        var doc: Document = Html4cj.parse(
            "<title>Hello there</title> <div><p>Hello</p><p>there</p></div> <div>Another</div>")
        @Assert("<title>Hello there</title>", doc.select("title").first().getOrThrow().outerHtml())
        @Assert("<div>\n <p>Hello</p>\n <p>there</p>\n</div>", doc.select("div").first().getOrThrow().outerHtml())
        @Assert("<div>\n <p>Hello</p>\n <p>there</p>\n</div>\n<div>\n Another\n</div>", doc.select("body").first().getOrThrow().html())

        println("Pass43")
    }

    @TestCase
    public func testSetText(): Unit {
        // 44
        var h: String = "<div id=1>Hello <p>there <b>now</b></p></div>"
        var doc: Document = Html4cj.parse(h)

        // need to sort out node whitespace
        @Assert("Hello there now", doc.text())
        @Assert("there now", doc.select("p")[0].text())
        var div: Element = doc.getElementById("1").getOrThrow().text("Gone")
        @Assert("Gone", div.text())
        @Assert(0, doc.select("p").size)

        println("Pass44")
    }

    @TestCase
    public func testAddNewElement(): Unit {
        // 45
        var doc: Document = Html4cj.parse("<div id=1><p>Hello</p></div>")
        var div: Element = doc.getElementById("1").getOrThrow()
        div.appendElement("p").text("there")
        div.appendElement("P").attr("CLASS", "second").text("now")

        // manually specifying tag and attributes should maintain case based on parser settings
        @Assert(
                "<html><head></head><body><div id=\"1\"><p>Hello</p><p>there</p><p class=\"second\">now</p></div></body></html>",
                TextUtil.stripNewlines(doc.html())
            )

        // check sibling index (with short circuit on reindexChildren):
        var ps: Elements = doc.select("p")
        for (i in 0..ps.size) {
            @Assert(i, ps[i].siblingIndex())
        }

        println("Pass45")
    }

    @TestCase
    public func testAddBooleanAttribute(): Unit {
        // 46
        var div: Element = Element(Tag.valueOf("div"), "")
        div.attr("true", true)
        div.attr("false", "value")
        div.attr("false", false)
        @Assert(div.hasAttr("true"), true)
        @Assert("", div.attr("true"))
        var attributes: ArrayList<Attribute> = div.attributes().asList()
        @Assert(1, attributes.size)
        @Assert(div.hasAttr("false"), false)
        @Assert("<div true></div>", div.outerHtml())

        println("Pass46")
    }

    @TestCase
    public func testAppendRowToTable(): Unit {
        // 47
        var doc: Document = Html4cj.parse("<table><tr><td>1</td></tr></table>")
        var table: Element = doc.select("tbody").first().getOrThrow()
        table.append("<tr><td>2</td></tr>")
        @Assert("<table><tbody><tr><td>1</td></tr><tr><td>2</td></tr></tbody></table>", TextUtil.stripNewlines(doc.body().html()))

        println("Pass47")
    }

    @TestCase
    public func testPrependRowToTable(): Unit {
        // 48
        var doc: Document = Html4cj.parse("<table><tr><td>1</td></tr></table>")
        var table: Element = doc.select("tbody").first().getOrThrow()
        table.prepend("<tr><td>2</td></tr>")
        @Assert("<table><tbody><tr><td>2</td></tr><tr><td>1</td></tr></tbody></table>", TextUtil.stripNewlines(doc.body().html()))

        // check sibling index (reindexChildren):
        var ps: Elements = doc.select("tr")
        for (i in 0..ps.size) {
            @Assert(i, ps[i].siblingIndex())
        }

        println("Pass48")
    }

    @TestCase
    public func testPrependElement(): Unit {
        // 49
        var doc: Document = Html4cj.parse("<div id=1><p>Hello</p></div>")
        var div: Element = doc.getElementById("1").getOrThrow()
        div.prependElement("p").text("Before")
        @Assert("Before", div.child(0).text())
        @Assert("Hello", div.child(1).text())

        println("Pass49")
    }

    @TestCase
    public func testAddNewText(): Unit {
        // 50
        var doc: Document = Html4cj.parse("<div id=1><p>Hello</p></div>")
        var div: Element = doc.getElementById("1").getOrThrow()
        div.appendText(" there & now >")
        @Assert("Hello there & now >", div.text())
        @Assert("<p>Hello</p> there &amp; now &gt;", TextUtil.stripNewlines(div.html()))

        println("Pass50")
    }

    @TestCase
    public func testPrependText(): Unit {
        // 51
        var doc: Document = Html4cj.parse("<div id=1><p>Hello</p></div>")
        var div: Element = doc.getElementById("1").getOrThrow()
        div.prependText("there & now > ")
        @Assert("there & now > Hello", div.text())
        @Assert("there &amp; now &gt; <p>Hello</p>", TextUtil.stripNewlines(div.html()))

        println("Pass51")
    }

    @TestCase
    public func testThrowsOnAddNullText(): Unit {
        // 52
        // TODO
        println("Pass52")
    }

    @TestCase
    public func testThrowsOnPrependNullText(): Unit {
        // 53
        // TODO
        println("Pass53")
    }

    @TestCase
    public func testAddNewHtml(): Unit {
        // 54
        var doc: Document = Html4cj.parse("<div id=1><p>Hello</p></div>")
        var div: Element = doc.getElementById("1").getOrThrow()
        div.append("<p>there</p><p>now</p>")
        @Assert("<p>Hello</p><p>there</p><p>now</p>", TextUtil.stripNewlines(div.html()))

        // check sibling index (no reindexChildren):
        var ps: Elements = doc.select("p")
        for (i in 0..ps.size) {
            @Assert(i, ps[i].siblingIndex())
        }

        println("Pass54")
    }

    @TestCase
    public func testPrependNewHtml(): Unit {
        // 55
        var doc: Document = Html4cj.parse("<div id=1><p>Hello</p></div>")
        var div: Element = doc.getElementById("1").getOrThrow()
        div.prepend("<p>there</p><p>now</p>")
        @Assert("<p>there</p><p>now</p><p>Hello</p>", TextUtil.stripNewlines(div.html()))

        // check sibling index (reindexChildren):
        var ps: Elements = doc.select("p")
        for (i in 0..ps.size) {
            @Assert(i, ps[i].siblingIndex())
        }

        println("Pass55")
    }

    @TestCase
    public func testSetHtml(): Unit {
        // 56
        var doc: Document = Html4cj.parse("<div id=1><p>Hello</p></div>")
        var div: Element = doc.getElementById("1").getOrThrow()
        div.html("<p>there</p><p>now</p>")
        @Assert("<p>there</p><p>now</p>", TextUtil.stripNewlines(div.html()))

        println("Pass56")
    }

    @TestCase
    public func testSetHtmlTitle(): Unit {
        // 57
        var doc: Document = Html4cj.parse("<html><head id=2><title id=1></title></head></html>")
        var title: Element = doc.getElementById("1").getOrThrow()
        title.html("good")
        @Assert("good", title.html())
        title.html("<i>bad</i>")
        @Assert("&lt;i&gt;bad&lt;/i&gt;", title.html())
        var head: Element = doc.getElementById("2").getOrThrow()
        head.html("<title><i>bad</i></title>")
        @Assert("<title>&lt;i&gt;bad&lt;/i&gt;</title>", head.html())

        println("Pass57")
    }

    @TestCase
    public func testWrap(): Unit {
        // 58
        var doc: Document = Html4cj.parse("<div><p>Hello</p><p>There</p></div>")
        var p: Element = doc.select("p").first().getOrThrow()
        p.wrap("<div class='head'></div>")
        @Assert("<div><div class=\"head\"><p>Hello</p></div><p>There</p></div>", TextUtil.stripNewlines(doc.body().html()))
        var ret: Element = p.wrap("<div><div class=foo></div><p>What?</p></div>")
        @Assert("<div><div class=\"head\"><div><div class=\"foo\"><p>Hello</p></div><p>What?</p></div></div><p>There</p></div>",
                    TextUtil.stripNewlines(doc.body().html()))
        @Assert(ret, p)

        println("Pass58")
    }

    @TestCase
    public func testWrapNoop(): Unit {
        // 59
        var doc: Document = Html4cj.parse("<div><p>Hello</p></div>")
        var p: Node = doc.select("p").first().getOrThrow()
        var wrapped: Node = p.wrap("Some junk")
        @Assert(p, wrapped)
        @Assert("<div><p>Hello</p></div>", TextUtil.stripNewlines(doc.body().html()))

        // should be a NOOP
        println("Pass59")
    }

    @TestCase
    public func testWrapOnOrphan(): Unit {
        // 60
        var orphan: Element = Element("span").text("Hello!")
        @Assert(orphan.hasParent(), false)
        var wrapped: Element = orphan.wrap("<div></div> There!")
        @Assert(orphan, wrapped)

        // should now be in the DIV
        @Assert(orphan.hasParent(), true)
        @Assert(orphan.parentElement()!= None, true)
        @Assert("div", orphan.parentElement().getOrThrow().tagName())
        @Assert("<div>\n <span>Hello!</span>\n</div>", orphan.parentElement().getOrThrow().outerHtml())

        println("Pass60")
    }

    @TestCase
    public func testWrapArtificialStructure(): Unit {
        // 61
        // div normally couldn't get into a p, but explicitly want to wrap
        var doc: Document = Html4cj.parse("<p>Hello <i>there</i> now.")
        var i: Element = doc.selectFirst("i").getOrThrow()
        i.wrap("<div id=id1></div> quite")
        @Assert("div", i.parentElement().getOrThrow().tagName())
        @Assert("<p>Hello <div id=\"id1\"><i>there</i></div> quite now.</p>", TextUtil.stripNewlines(doc.body().html()))
        println("Pass61")
    }

    @TestCase
    public func beforeTest(): Unit {
        // 62
        var doc: Document = Html4cj.parse("<div><p>Hello</p><p>There</p></div>")
        var p1: Element = doc.select("p").first().getOrThrow()
        p1.before("<div>one</div><div>two</div>")
        @Assert("<div><div>one</div><div>two</div><p>Hello</p><p>There</p></div>", TextUtil.stripNewlines(doc.body().html()))
        doc.select("p").last().getOrThrow().before("<p>Three</p><!-- four -->")
        @Assert("<div><div>one</div><div>two</div><p>Hello</p><p>Three</p><!-- four --><p>There</p></div>", TextUtil.stripNewlines(doc.body().html()))

        println("Pass62")
    }

    @TestCase
    public func afterTest(): Unit {
        // 63
        var doc: Document = Html4cj.parse("<div><p>Hello</p><p>There</p></div>")
        var p1: Element = doc.select("p").first().getOrThrow()
        p1.after("<div>one</div><div>two</div>")
        @Assert("<div><p>Hello</p><div>one</div><div>two</div><p>There</p></div>", TextUtil.stripNewlines(doc.body().html()))
        doc.select("p").last().getOrThrow().after("<p>Three</p><!-- four -->")
        @Assert("<div><p>Hello</p><div>one</div><div>two</div><p>There</p><p>Three</p><!-- four --></div>", TextUtil.stripNewlines(doc.body().html()))

        println("Pass63")
    }

    @TestCase
    public func testWrapWithRemainder(): Unit {
        //  64
        var doc: Document = Html4cj.parse("<div><p>Hello</p></div>")
        var p: Element = doc.select("p").first().getOrThrow()
        p.wrap("<div class='head'></div><p>There!</p>")
        @Assert("<div><div class=\"head\"><p>Hello</p></div><p>There!</p></div>", TextUtil.stripNewlines(doc.body().html()))

        println("Pass64")
    }

    @TestCase
    public func testWrapWithSimpleRemainder(): Unit {
        // 65
        var doc: Document = Html4cj.parse("<p>Hello")
        var p: Element = doc.selectFirst("p").getOrThrow()
        var body: ?Element = p.parentElement()
        @Assert(body != None, true)
        @Assert("body", body.getOrThrow().tagName())
        p.wrap("<div></div> There")
        var div: ?Element = p.parentElement()
        @Assert(div != None, true)
        @Assert("div", div.getOrThrow().tagName())
        @Assert(div.getOrThrow() == p.parentElement().getOrThrow(), true)
        @Assert(body.getOrThrow() == div.getOrThrow().parentElement().getOrThrow(), true)
        @Assert("<div><p>Hello</p></div> There", TextUtil.stripNewlines(doc.body().html()))

        println("Pass65")
    }

    @TestCase
    public func testHasText(): Unit {
        // 66
        var doc: Document = Html4cj.parse("<div><p>Hello</p><p></p></div>")
        var div: Element = doc.select("div").first().getOrThrow()
        var ps: Elements = doc.select("p")
        @Assert(div.hasText(), true)
        @Assert(ps.first().getOrThrow().hasText(), true)
        @Assert(ps.last().getOrThrow().hasText(), false)

        println("Pass66")
    }

    @TestCase
    public func datasetTest(): Unit {
        // 67
        var doc: Document = Html4cj.parse(
            "<div id=1 data-name=jsoup class=new data-package=jar>Hello</div><p id=2>Hello</p>")
        var div: Element = doc.select("div").first().getOrThrow()
        var attributes: Attributes = div.attributes()

        // size, get, set, add, remove
        @Assert(2, attributes.dataSize)
        @Assert("jsoup", attributes.getData("name").getOrThrow())
        @Assert("jar", attributes.getData("package").getOrThrow())
        attributes.putData("name", "jsoup updated")
        attributes.putData("language", "java")
        attributes.removeData("package")
        @Assert(2, attributes.dataSize)
        @Assert(4, attributes.size)
        @Assert("jsoup updated", attributes.get("data-name"))
        @Assert("jsoup updated", attributes.getData("name").getOrThrow())
        @Assert("java", attributes.get("data-language"))
        @Assert("java", attributes.getData("language").getOrThrow())
        attributes.put("data-food", "bacon")
        @Assert(3, attributes.dataSize)
        @Assert("bacon", attributes.getData("food").getOrThrow())
        attributes.put("data-", "empty")

        // data- is not a data attribute
        @Assert(attributes.getData("") == None, true)
        var p: Element = doc.select("p").first().getOrThrow()
        @Assert(true, isEmpty(p.dataset()))

        println("Pass67")
    }

    @TestCase
    public func parentlessToString(): Unit {
        // 68
        var doc: Document = Html4cj.parse("<img src='foo'>")
        var img: Element = doc.select("img").first().getOrThrow()
        @Assert("<img src=\"foo\">", img.toString())

        // lost its parent
        img.remove()
        @Assert("<img src=\"foo\">", img.toString())

        println("Pass68")
    }

    @TestCase
    public func orphanDivToString(): Unit {
        // 69
        var orphan: Element = Element("div").id("foo").text("Hello")
        @Assert("<div id=\"foo\">\n Hello\n</div>", orphan.toString())

        println("Pass69")
    }

    @TestCase
    public func testClone(): Unit {
        // 70
        var doc: Document = Html4cj.parse("<div><p>One<p><span>Two</div>")
        var p: Element = doc.select("p")[1]
        var clone: Element = p.clone()

        // should be a cloned document just containing this clone
        @Assert(clone.parent() != None, true)
        @Assert(1, clone.parent().getOrThrow().childNodeSize())
        @Assert(clone.ownerDocument().getOrThrow() == clone.parent().getOrThrow(), true)
        @Assert(0, clone.siblingIndex())
        @Assert(1, p.siblingIndex())
        @Assert(p.parentElement() != None, true)
        clone.append("<span>Three")
        @Assert("<p><span>Two</span><span>Three</span></p>", TextUtil.stripNewlines(clone.outerHtml()))

        // not modified
        @Assert("<div><p>One</p><p><span>Two</span></p></div>", TextUtil.stripNewlines(doc.body().html()))

        // adopt
        doc.body().appendChild(clone)
        @Assert(clone.parentElement() != None, true)
        @Assert("<div><p>One</p><p><span>Two</span></p></div><p><span>Two</span><span>Three</span></p>", TextUtil.stripNewlines(doc.body().html()))

        println("Pass70")
    }

    @TestCase
    public func testClonesClassnames(): Unit {
        // 71
        var doc: Document = Html4cj.parse("<div class='one two'></div>")
        var div: Element = doc.select("div").first().getOrThrow()
        var classes: Set<String> = div.classNames()
        @Assert(2, classes.size)
        @Assert(classes.contains("one"), true)
        @Assert(classes.contains("two"), true)
        var copy: Element = div.clone()
        var copyClasses: Set<String> = copy.classNames()
        @Assert(2, copyClasses.size)
        @Assert(copyClasses.contains("one"), true)
        @Assert(copyClasses.contains("two"), true)
        copyClasses.put("three")
        copyClasses.remove("one")
        @Assert(classes.contains("one"), true)
        @Assert(classes.contains("three"), false)
        @Assert(copyClasses.contains("one"), false)
        @Assert(copyClasses.contains("three"), true)
        @Assert("", div.html())
        @Assert("", copy.html())

        println("Pass71")
    }

    @TestCase
    public func testShallowClone(): Unit {
        // 72
        var base: String = "http://example.com/"
        var doc: Document = Html4cj.parse("<div id=1 class=one><p id=2 class=two>One", base)
        var d: Element = doc.selectFirst("div").getOrThrow()
        var p: Element = doc.selectFirst("p").getOrThrow()
        var t: TextNode = p.textNodes()[0]
        var d2: Element = d.shallowClone()
        var p2: Element = p.shallowClone()
        var t2: TextNode = (t.shallowClone() as TextNode).getOrThrow()
        @Assert(1, d.childNodeSize())
        @Assert(0, d2.childNodeSize())
        @Assert(1, p.childNodeSize())
        @Assert(0, p2.childNodeSize())
        @Assert("", p2.text())
        @Assert("One", t2.text())
        @Assert("two", p2.className())
        p2.removeClass("two")
        @Assert("two", p.className())
        d2.append("<p id=3>Three")
        @Assert(1, d2.childNodeSize())
        @Assert("Three", d2.text())
        @Assert("One", d.text())
        @Assert(base, d2.baseUri())

        println("Pass72")
    }

    @TestCase
    public func testTagNameSet(): Unit {
        // 73
        var doc: Document = Html4cj.parse("<div><i>Hello</i>")
        doc.select("i").first().getOrThrow().tagName("em")
        @Assert(0, doc.select("i").size)
        @Assert(1, doc.select("em").size)
        @Assert("<em>Hello</em>", doc.select("div").first().getOrThrow().html())

        println("Pass73")
    }

    @TestCase
    public func testHtmlContainsOuter(): Unit {
        // 74
        var doc: Document = Html4cj.parse("<title>Check</title> <div>Hello there</div>")
        doc.outputSettings().indentAmount(0)
        @Assert(doc.html().contains(doc.select("title").outerHtml()), true)
        @Assert(doc.html().contains(doc.select("div").outerHtml()), true)

        println("Pass74")
    }

    @TestCase
    public func testGetTextNodes(): Unit {
        // 75
        var doc: Document = Html4cj.parse("<p>One <span>Two</span> Three <br> Four</p>")
        var textNodes: ArrayList<TextNode> = doc.select("p").first().getOrThrow().textNodes()
        @Assert(3, textNodes.size)
        @Assert("One ", textNodes[0].text())
        @Assert(" Three ", textNodes[1].text())
        @Assert(" Four", textNodes[2].text())
        @Assert(0, doc.select("br").first().getOrThrow().textNodes().size)

        println("Pass75")
    }

    @TestCase
    public func testManipulateTextNodes(): Unit {
        // 76
        var doc: Document = Html4cj.parse("<p>One <span>Two</span> Three <br> Four</p>")
        var p: Element = doc.select("p").first().getOrThrow()
        var textNodes: ArrayList<TextNode> = p.textNodes()
        textNodes[1].text(" three-more ")
        textNodes[2].splitText(3).text("-ur")
        @Assert("One Two three-more Fo-ur", p.text())
        @Assert("One three-more Fo-ur", p.ownText())

        // grew because of split
        @Assert(4, p.textNodes().size)

        println("Pass76")
    }

    @TestCase
    public func testGetDataNodes(): Unit {
        // 77
        var doc: Document = Html4cj.parse("<script>One Two</script> <style>Three Four</style> <p>Fix Six</p>")
        var script: Element = doc.select("script").first().getOrThrow()
        var style: Element = doc.select("style").first().getOrThrow()
        var p: Element = doc.select("p").first().getOrThrow()
        var scriptData: ArrayList<DataNode> = script.dataNodes()
        @Assert(1, scriptData.size)
        @Assert("One Two", scriptData[0].getWholeData())
        var styleData: ArrayList<DataNode> = style.dataNodes()
        @Assert(1, styleData.size)
        @Assert("Three Four", styleData[0].getWholeData())
        var pData: ArrayList<DataNode> = p.dataNodes()
        @Assert(0, pData.size)

        println("Pass77")
    }

    @TestCase
    public func elementIsNotASiblingOfItself(): Unit {
        // 78
        var doc: Document = Html4cj.parse("<div><p>One<p>Two<p>Three</div>")
        var p2: Element = doc.select("p")[1]
        @Assert("Two", p2.text())
        var els: Elements = p2.siblingElements()
        @Assert(2, els.size)
        @Assert("<p>One</p>", els[0].outerHtml())
        @Assert("<p>Three</p>", els[1].outerHtml())

        println("Pass78")
    }

    @TestCase
    public func testChildThrowsIndexOutOfBoundsOnMissing(): Unit {
        // 79
        var doc: Document = Html4cj.parse("<div><p>One</p><p>Two</p></div>")
        var div: Element = doc.select("div").first().getOrThrow()
        @Assert(2, div.children().size)
        @Assert("One", div.child(0).text())
        try {
            div.child(3)
        } catch (e: IndexOutOfBoundsException) {}

        println("Pass79")
    }

    @TestCase
    public func moveByAppend(): Unit {
        // 80
        // test for https://github.com/jhy/jsoup/issues/239
        // can empty an element and append its children to another element
        var doc: Document = Html4cj.parse("<div id=1>Text <p>One</p> Text <p>Two</p></div><div id=2></div>")
        var div1: Element = doc.select("div")[0]
        var div2: Element = doc.select("div")[1]
        @Assert(4, div1.childNodeSize())
        var children: ArrayList<Node> = div1.childNodes()
        @Assert(4, children.size)
        div2.insertChildren(0, children)

        // children is NOT backed by div1.childNodes but a wrapper, so should still be 4 (but re-parented)
        @Assert(4, children.size)
        @Assert(0, div1.childNodeSize())
        @Assert(4, div2.childNodeSize())
        @Assert("<div id=\"1\"></div>\n<div id=\"2\">\n Text \n <p>One</p> Text \n <p>Two</p>\n</div>",
                    doc.body().html())

        println("Pass80")
    }

    @TestCase
    public func insertChildrenArgumentValidation(): Unit {
        // 81
        var doc: Document = Html4cj.parse("<div id=1>Text <p>One</p> Text <p>Two</p></div><div id=2></div>")
        var div1: Element = doc.select("div")[0]
        var div2: Element = doc.select("div")[1]
        var children: ArrayList<Node> = div1.childNodes()
        try {
            div2.insertChildren(6, children)
        } catch (e: Exception) {}
        try {
            div2.insertChildren(-5, children)
        } catch (e: Exception) {}

        println("Pass81")
    }

    @TestCase
    public func insertChildrenAtPosition(): Unit {
        // 82
        var doc: Document = Html4cj.parse(
            "<div id=1>Text1 <p>One</p> Text2 <p>Two</p></div><div id=2>Text3 <p>Three</p></div>")
        var div1: Element = doc.select("div")[0]
        var p1s: Elements = div1.select("p")
        var div2: Element = doc.select("div")[1]
        @Assert(2, div2.childNodeSize())
        var listNode: ArrayList<Node> = ArrayList<Node>()
        for (i in 0..p1s.size) {
            listNode.append((p1s[i] as Node).getOrThrow())
        }
        div2.insertChildren(-1, listNode)

        // moved two out
        @Assert(2, div1.childNodeSize())
        @Assert(4, div2.childNodeSize())

        // should be last
        @Assert(3, p1s[1].siblingIndex())
        var els: ArrayList<Node> = ArrayList<Node>()
        var el1: Element = Element(Tag.valueOf("span"), "").text("Span1")
        var el2: Element = Element(Tag.valueOf("span"), "").text("Span2")
        var tn1: TextNode = TextNode("Text4")
        els.append(el1)
        els.append(el2)
        els.append(tn1)
        @Assert(el1.parent() == None, true)
        div2.insertChildren(-2, els)
        @Assert(div2, el1.parent())
        @Assert(7, div2.childNodeSize())
        @Assert(3, el1.siblingIndex())
        @Assert(4, el2.siblingIndex())
        @Assert(5, tn1.siblingIndex())

        println("Pass82")
    }

    @TestCase
    public func insertChildrenAsCopy(): Unit {
        // 83
        var doc: Document = Html4cj.parse("<div id=1>Text <p>One</p> Text <p>Two</p></div><div id=2></div>")
        var div1: Element = doc.select("div")[0]
        var div2: Element = doc.select("div")[1]
        var ps: Elements = doc.select("p").clone()
        ps.first().getOrThrow().text("One cloned")
        var listNode: ArrayList<Node> = ArrayList<Node>()
        for (i in 0..ps.size) {
            listNode.append((ps[i] as Node).getOrThrow())
        }
        div2.insertChildren(-1, listNode)

        // not moved -- cloned
        @Assert(4, div1.childNodeSize())
        @Assert(2, div2.childNodeSize())
        @Assert("<div id=\"1\">Text <p>One</p> Text <p>Two</p></div><div id=\"2\"><p>One cloned</p><p>Two</p></div>",
                    TextUtil.stripNewlines(doc.body().html()))

        println("Pass83")
    }

    @TestCase
    public func testCssPath(): Unit {
        // 83
        var doc: Document = Html4cj.parse("<div id=\"id1\">A</div><div>B</div><div class=\"c1 c2\">C</div>")
        var divA: Element = doc.select("div")[0]
        var divB: Element = doc.select("div")[1]
        var divC: Element = doc.select("div")[2]
        @Assert(divA.cssSelector(), "#id1")
        @Assert(divB.cssSelector(), "html > body > div:nth-child(2)")
        @Assert(divC.cssSelector(), "html > body > div.c1.c2")
        @Assert(refEq(divA, doc.select(divA.cssSelector()).first().getOrThrow()), true)
        @Assert(refEq(divB, doc.select(divB.cssSelector()).first().getOrThrow()), true)
        @Assert(refEq(divC, doc.select(divC.cssSelector()).first().getOrThrow()), true)

        println("Pass84")
    }

    @TestCase
    public func testCssPathDuplicateIds(): Unit {
        // 85
        // https://github.com/jhy/jsoup/issues/1147 - multiple elements with same ID, use the non-ID form
        var doc: Document = Html4cj.parse("<article><div id=dupe>A</div><div id=dupe>B</div><div id=dupe class=c1>")
        var divA: Element = doc.select("div")[0]
        var divB: Element = doc.select("div")[1]
        var divC: Element = doc.select("div")[2]
        @Assert(divA.cssSelector(), "html > body > article > div:nth-child(1)")
        @Assert(divB.cssSelector(), "html > body > article > div:nth-child(2)")
        @Assert(divC.cssSelector(), "html > body > article > div.c1")
        @Assert(refEq(divA, doc.select(divA.cssSelector()).first().getOrThrow()), true)
        @Assert(refEq(divB, doc.select(divB.cssSelector()).first().getOrThrow()), true)
        @Assert(refEq(divC, doc.select(divC.cssSelector()).first().getOrThrow()), true)

        println("Pass85")
    }

    @TestCase
    public func cssSelectorEscaped(): Unit {
        // 86
        // https://github.com/jhy/jsoup/issues/1742
        var doc: Document = Html4cj.parse(
            "<p\\p>One</p\\p> <p id='one.two'>Two</p> <p class='one.two:three/four'>Three</p>")
        var one: Element = doc.expectFirst("p\\\\p")
        var ps: Elements = doc.select("p")
        var two: Element = ps[0]
        var three: Element = ps[1]
        var oneSelect: String = one.cssSelector()
        @Assert("html > body > p\\\\p", oneSelect)
        @Assert(one, doc.expectFirst(oneSelect))
        var twoSelect: String = two.cssSelector()
        @Assert("#one\\.two", twoSelect)
        @Assert(two, doc.expectFirst(twoSelect))
        var threeSelect: String = three.cssSelector()
        @Assert("html > body > p.one\\.two\\:three\\/four", threeSelect)
        @Assert(three, doc.expectFirst(threeSelect))

        println("Pass86")
    }

    @TestCase
    public func cssEscapedAmp(): Unit {
        // 87
        var doc: Document = Html4cj.parse("<p class='\\&'>One</p>")

        // tested matches js querySelector
        var one: Element = doc.expectFirst(".\\\\\\&")
        @Assert("One", one.text())
        var q: String = one.cssSelector()
        @Assert("html > body > p.\\\\\\&", q)
        @Assert(one, doc.expectFirst(q))

        println("Pass87")
    }

    @TestCase
    public func cssSelectorEscapedClass(): Unit {
        // 88
        // example in https://github.com/jhy/jsoup/issues/838
        var html: String = "<div class='B\\&W\\?'><div class=test>Text</div></div>"
        var parse: Document = Html4cj.parse(html)
        var el: Element = parse.expectFirst(".test")
        @Assert("Text", el.text())
        var q: String = el.cssSelector()
        @Assert("html > body > div.B\\\\\\&W\\\\\\? > div.test", q)
        var found: Element = parse.expectFirst(q)
        @Assert(found, el)

        println("Pass88")
    }

    @TestCase
    public func testClassNames(): Unit {
        // 89
        var doc: Document = Html4cj.parse("<div class=\"c1 c2\">C</div>")
        var div: Element = doc.select("div")[0]
        @Assert("c1 c2", div.className())
        var set1: Set<String> = div.classNames()
        var arr1: Array<String> = set1.toArray()
        @Assert(2, arr1.size)
        @Assert("c1", arr1[0])
        @Assert("c2", arr1[1])

        // Changes to the set should not be reflected in the Elements getters
        set1.put("c3")
        @Assert(2, div.classNames().size)
        @Assert("c1 c2", div.className())

        // Update the class names to a fresh set
        var newSet: Set<String> = HashSet<String>(3)
        newSet.putAll(set1)
        newSet.put("c3")
        div.classNames(newSet)
        @Assert("c1 c2 c3", div.className())
        var set2: Set<String> = div.classNames()
        var arr2: Array<String> = set2.toArray()
        @Assert(3, arr2.size)
        @Assert("c1", arr2[0])
        @Assert("c2", arr2[1])
        @Assert("c3", arr2[2])

        println("Pass89")
    }

    @TestCase
    public func testHashAndEqualsAndValue(): Unit {
        // 90
        // .equals and hashcode are identity. value is content.
        var doc1: String =
            "<div id=1><p class=one>One</p><p class=one>One</p><p class=one>Two</p><p class=two>One</p></div>" +
            "<div id=2><p class=one>One</p><p class=one>One</p><p class=one>Two</p><p class=two>One</p></div>"
        var doc: Document = Html4cj.parse(doc1)
        var els: Elements = doc.select("p")

        /*
           for(el in els){
               System.out.println(el.hashCode() + " - " + el.outerHtml())
           }
           0 1534787905 - <p class="one">One</p>
           1 1534787905 - <p class="one">One</p>
           2 1539683239 - <p class="one">Two</p>
           3 1535455211 - <p class="two">One</p>
           4 1534787905 - <p class="one">One</p>
           5 1534787905 - <p class="one">One</p>
           6 1539683239 - <p class="one">Two</p>
           7 1535455211 - <p class="two">One</p>
         */
        @Assert(8, els.size)
        var e0: Element = els[0]
        var e1: Element = els[1]
        var e2: Element = els[2]
        var e3: Element = els[3]
        var e4: Element = els[4]
        var e5: Element = els[5]
        var e6: Element = els[6]
        var e7: Element = els[7]
        @Assert(e0, e0)
        @Assert(e0.hasSameValue(e1), true)
        @Assert(e0.hasSameValue(e4), true)
        @Assert(e0.hasSameValue(e5), true)
        @Assert((e0 !=  e2), true)
        @Assert(false, e0.hasSameValue(e2))
        @Assert(false, e0.hasSameValue(e3))
        @Assert(false, e0.hasSameValue(e6))
        @Assert(false, e0.hasSameValue(e7))
        @Assert(e0.hashCode(), e0.hashCode())
        @Assert((e0.hashCode() !=  (e2.hashCode())), true)
        @Assert((e0.hashCode() !=  (e3).hashCode()), true)
        @Assert((e0.hashCode() !=  (e6).hashCode()), true)
        @Assert((e0.hashCode() !=  (e7).hashCode()), true)

        println("Pass90")
    }

    @TestCase
    public func testRelativeUrls(): Unit {
        // 91
        var html: String =
            "<body><a href='./one.html'>One</a> <a href='two.html'>two</a> <a href='../three.html'>Three</a> <a href='//example2.com/four/'>Four</a> <a href='https://example2.com/five/'>Five</a> <a>Six</a> <a href=''>Seven</a>"
        var doc: Document = Html4cj.parse(html, "http://example.com/bar/")
        var els: Elements = doc.select("a")
        @Assert("http://example.com/bar/one.html", els[0].absUrl("href"))
        @Assert("http://example.com/bar/two.html", els[1].absUrl("href"))
        @Assert("http://example.com/three.html", els[2].absUrl("href"))
        @Assert("http://example2.com/four/", els[3].absUrl("href"))
        @Assert("https://example2.com/five/", els[4].absUrl("href"))
        @Assert("", els[5].absUrl("href"))
        @Assert("http://example.com/bar/", els[6].absUrl("href"))

        println("Pass91")
    }

    @TestCase
    public func testRelativeIdnUrls(): Unit {
        // 92
        var idn: String = "https://www.测试.测试/"
        var idnFoo: String = idn + "foo.html?bar"
        var doc: Document = Html4cj.parse("<a href=''>One</a><a href='/bar.html?qux'>Two</a>", idnFoo)
        var els: Elements = doc.select("a")
        var one: Element = els[0]
        var two: Element = els[1]
        var hrefOne: String = one.absUrl("href")
        var hrefTwo: String = two.absUrl("href")

        // @Assert(idnFoo, hrefOne)
        @Assert("https://www.%E6%B5%8B%E8%AF%95.%E6%B5%8B%E8%AF%95/foo.html?bar", hrefOne)

        // @Assert("https://www.测试.测试/bar.html?qux", hrefTwo)
        @Assert("https://www.%E6%B5%8B%E8%AF%95.%E6%B5%8B%E8%AF%95/bar.html?qux", hrefTwo)

        println("Pass92")
    }

    @TestCase
    public func appendMustCorrectlyMoveChildrenInsideOneParentElement(): Unit {
        // 93
        var doc: Document = Document("")
        var body: Element = doc.appendElement("body")
        body.appendElement("div1")
        body.appendElement("div2")
        var div3: Element = body.appendElement("div3")
        div3.text("Check")
        var div4: Element = body.appendElement("div4")
        var toMove: ArrayList<Element> = ArrayList<Element>()
        toMove.append(div3)
        toMove.append(div4)
        var listNode: ArrayList<Node> = ArrayList<Node>()
        for (i in 0..toMove.size) {
            listNode.append((toMove[i] as Node).getOrThrow())
        }
        body.insertChildren(0, listNode)

        // var result:String  = doc.toString().replaceAll("\\s+", "")
        // @Assert("<body><div3>Check</div3><div4></div4><div1></div1><div2></div2></body>", result)
        var result: String = doc.toString()
        var str: String = "<body>\n" + " <div3>\n" + "  Check\n" + " </div3><div4></div4><div1></div1><div2></div2>\n" +
            "</body>"
        @Assert(str, result)

        println("Pass93")
    }

    @TestCase
    public func testHashcodeIsStableWithContentChanges(): Unit {
        // 94
        var root: Element = Element(Tag.valueOf("root"), "")
        var set: HashSet<Element> = HashSet<Element>()

        // Add root node:
        set.put(root)
        root.appendChild(Element(Tag.valueOf("a"), ""))

        // @Assert(set.contains(root), true)
        var itset = set.iterator()
        var value = itset.next().getOrThrow()
        @Assert(value, root)
        @Assert(refEq(value,root), true)

        println("Pass94")
    }

    @TestCase
    public func testNamespacedElements(): Unit {
        // 95
        // Namespaces with ns:tag in HTML must be translated to ns|tag in CSS.
        var html: String = "<html><body><fb:comments /></body></html>"
        var doc: Document = Html4cj.parse(html, "http://example.com/bar/")
        var els: Elements = doc.select("fb|comments")
        @Assert(1, els.size)
        @Assert("html > body > fb|comments", els[0].cssSelector())

        println("Pass95")
    }

    @TestCase
    public func testChainedRemoveAttributes(): Unit {
        // 96
        var html: String = "<a one two three four>Text</a>"
        var doc: Document = Html4cj.parse(html)
        var a: Element = doc.select("a").first().getOrThrow()
        a.removeAttr("zero").removeAttr("one").removeAttr("two").removeAttr("three").removeAttr("four").removeAttr(
            "five")
        @Assert("<a>Text</a>", a.outerHtml())

        println("Pass96")
    }

    @TestCase
    public func testLoopedRemoveAttributes(): Unit {
        // 97
        var html: String = "<a one two three four>Text</a><p foo>Two</p>"
        var doc: Document = Html4cj.parse(html)
        for (el in doc.getAllElements().elementArr) {
            el.clearAttributes()
        }
        @Assert("<a>Text</a>\n<p>Two</p>", doc.body().html())

        println("Pass97")
    }

    @TestCase
    public func testIs(): Unit {
        // 98
        var html: String = "<div><p>One <a class=big>Two</a> Three</p><p>Another</p>"
        var doc: Document = Html4cj.parse(html)
        var p: Element = doc.select("p").first().getOrThrow()
        @Assert(p.check("p"), true)
        @Assert(false, p.check("div"))
        @Assert(p.check("p:has(a)"), true)

        // does not descend
        @Assert(false, p.check("a"))
        @Assert(p.check("p:first-child"), true)
        @Assert(false, p.check("p:last-child"))
        @Assert(p.check("*"), true)
        @Assert(p.check("div p"), true)
        var q: Element = doc.select("p").last().getOrThrow()
        @Assert(q.check("p"), true)
        @Assert(q.check("p ~ p"), true)
        @Assert(q.check("p + p"), true)
        @Assert(q.check("p:last-child"), true)
        @Assert(false, q.check("p a"))
        @Assert(false, q.check("a"))

        println("Pass98")
    }

    @TestCase
    public func testEvalMethods(): Unit {
        // 99
        var doc: Document = Html4cj.parse("<div><p>One <a class=big>Two</a> Three</p><p>Another</p>")
        var p: Element = doc.selectFirst(QueryParser.parse(("p"))).getOrThrow()
        @Assert("One Three", p.ownText())
        @Assert(p.check(QueryParser.parse("p")), true)
        var aEval: Evaluator = QueryParser.parse("a")
        @Assert(false, p.check(aEval))
        var a: Element = p.selectFirst(aEval).getOrThrow()
        @Assert("div", a.closest(QueryParser.parse("div:has( > p)")).getOrThrow().tagName())
        var body: Element = p.closest(QueryParser.parse("body")).getOrThrow()
        @Assert("body", body.nodeName())

        println("Pass99")
    }

    @TestCase
    public func testClosest(): Unit {
        // 100
        var html: String =
            "<article>\n" + "  <div id=div-01>Here is div-01\n" + "    <div id=div-02>Here is div-02\n" +
            "      <div id=div-03>Here is div-03</div>\n" + "    </div>\n" + "  </div>\n" + "</article>"
        var doc: Document = Html4cj.parse(html)
        var el: Element = doc.selectFirst("#div-03").getOrThrow()
        @Assert("Here is div-03", el.text())
        @Assert("div-03", el.id())
        @Assert("div-02", el.closest("#div-02").getOrThrow().id())
        @Assert(el, el.closest("div div").getOrThrow()) // closest div in a div is itself
        @Assert("div-01", el.closest("article > div").getOrThrow().id())
        @Assert("article", el.closest(":not(div)").getOrThrow().tagName())
        @Assert(el.closest("p") == None, true)

        println("Pass100")
    }

    @TestCase
    public func elementByTagName(): Unit {
        // 101
        var a: Element = Element("P")
        @Assert("P", a.tagName())

        println("Pass101")
    }

    @TestCase
    public func testChildrenElements(): Unit {
        // 102
        var html: String = "<div><p><a>One</a></p><p><a>Two</a></p>Three</div><span>Four</span><foo></foo><img>"
        var doc: Document = Html4cj.parse(html)
        var div: Element = doc.select("div").first().getOrThrow()
        var p: Element = doc.select("p").first().getOrThrow()
        var span: Element = doc.select("span").first().getOrThrow()
        var foo: Element = doc.select("foo").first().getOrThrow()
        var img: Element = doc.select("img").first().getOrThrow()
        var docChildren: Elements = div.children()
        @Assert(2, docChildren.size)
        @Assert("<p><a>One</a></p>", docChildren[0].outerHtml())
        @Assert("<p><a>Two</a></p>", docChildren[1].outerHtml())
        @Assert(3, div.childNodes().size)
        @Assert("Three", div.childNodes()[2].outerHtml())
        @Assert(1, p.children().size)
        @Assert("One", p.children().text())
        @Assert(0, span.children().size)
        @Assert(1, span.childNodes().size)
        @Assert("Four", span.childNodes()[0].outerHtml())
        @Assert(0, foo.children().size)
        @Assert(0, foo.childNodes().size)
        @Assert(0, img.children().size)
        @Assert(0, img.childNodes().size)

        println("Pass102")
    }

    @TestCase
    public func testShadowElementsAreUpdated(): Unit {
        // 103
        var html: String = "<div><p><a>One</a></p><p><a>Two</a></p>Three</div><span>Four</span><foo></foo><img>"
        var doc: Document = Html4cj.parse(html)
        var div: Element = doc.select("div").first().getOrThrow()
        var els: Elements = div.children()
        var nodes: ArrayList<Node> = div.childNodes()

        // the two Ps
        @Assert(2, els.size)

        // the "Three" textnode
        @Assert(3, nodes.size)
        var p3: Element = Element("p").text("P3")
        var p4: Element = Element("p").text("P4")
        div.insertChildren(1, p3)
        div.insertChildren(3, p4)
        var els2: Elements = div.children()

        // first els should not have changed
        @Assert(2, els.size)
        @Assert(4, els2.size)
        @Assert("<p><a>One</a></p>\n" +
                    "<p>P3</p>\n" +
                    "<p><a>Two</a></p>\n" +
                    "<p>P4</p>Three", div.html())
        @Assert("P3", els2[1].text())
        @Assert("P4", els2[3].text())
        p3.after("<span>Another</span")
        var els3: Elements = div.children()
        @Assert(5, els3.size)
        @Assert("span", els3[2].tagName())
        @Assert("Another", els3[2].text())
        @Assert("<p><a>One</a></p>\n" +
                    "<p>P3</p><span>Another</span>\n" +
                    "<p><a>Two</a></p>\n" +
                    "<p>P4</p>Three", div.html())

        println("Pass103")
    }

    @TestCase
    public func classNamesAndAttributeNameIsCaseInsensitive(): Unit {
        // 104
        var html: String = "<p Class='SomeText AnotherText'>One</p>"
        var doc: Document = Html4cj.parse(html)
        var p: Element = doc.select("p").first().getOrThrow()
        @Assert("SomeText AnotherText", p.className())
        @Assert(p.classNames().contains("SomeText"), true)
        @Assert(p.classNames().contains("AnotherText"), true)
        @Assert(p.hasClass("SomeText"), true)
        @Assert(p.hasClass("sometext"), true)
        @Assert(p.hasClass("AnotherText"), true)
        @Assert(p.hasClass("anothertext"), true)
        var p1: Element = doc.select(".SomeText").first().getOrThrow()
        var p2: Element = doc.select(".sometext").first().getOrThrow()
        var p3: Element = doc.select("[class=SomeText AnotherText]").first().getOrThrow()
        var p4: Element = doc.select("[Class=SomeText AnotherText]").first().getOrThrow()
        var p5: Element = doc.select("[class=sometext anothertext]").first().getOrThrow()
        var p6: Element = doc.select("[class=SomeText AnotherText]").first().getOrThrow()
        var p7: Element = doc.select("[class^=sometext]").first().getOrThrow()
        var p8: Element = doc.select("[class$=nothertext]").first().getOrThrow()
        var p9: Element = doc.select("[class^=sometext]").first().getOrThrow()
        var p10: Element = doc.select("[class$=AnotherText]").first().getOrThrow()
        @Assert("One", p1.text())
        @Assert(p1, p2)
        @Assert(p1, p3)
        @Assert(p1, p4)
        @Assert(p1, p5)
        @Assert(p1, p6)
        @Assert(p1, p7)
        @Assert(p1, p8)
        @Assert(p1, p9)
        @Assert(p1, p10)

        println("Pass104")
    }

    @TestCase
    public func testAppendTo(): Unit {
        // 105
        var parentHtml: String = "<div class='a'></div>"
        var childHtml: String = "<div class='b'></div><p>Two</p>"
        var parentDoc: Document = Html4cj.parse(parentHtml)
        var parent: Element = parentDoc.body()
        var childDoc: Document = Html4cj.parse(childHtml)
        var div: Element = childDoc.select("div").first().getOrThrow()
        var p: Element = childDoc.select("p").first().getOrThrow()
        var appendTo1: Element = div.appendTo(parent)
        @Assert(div, appendTo1)
        var appendTo2: Element = p.appendTo(div)
        @Assert(p, appendTo2)
        var str: String = #"<div class="a"></div>
<div class="b">
 <p>Two</p>
</div>"#
        println(parentDoc.body().html())
        @Assert(str, parentDoc.body().html())

        // got moved out
        @Assert("", childDoc.body().html())

        println("Pass105")
    }

    @TestCase
    public func testNormalizesNbspInText(): Unit {
        // 106
        var escaped: String = "You can't always get what you&nbsp;want."

        // there is an nbsp char in there
        var withNbsp: String = "You can't always get what you want."
        var doc: Document = Html4cj.parse("<p>" + escaped)
        var p: Element = doc.select("p").first().getOrThrow()

        // text is normalized
        @Assert("You can't always get what you want.", p.text())

        // html / whole text keeps &nbsp
        @Assert("<p>" + escaped + "</p>", p.outerHtml())
        @Assert(withNbsp, p.textNodes()[0].getWholeText())
        var matched: Element = doc.select("p:contains(get what you want)").first().getOrThrow()
        @Assert("p", matched.nodeName())
        @Assert(matched.check(":containsOwn(get what you want)"), true)

        println("Pass106")
    }

    @TestCase
    public func testNormalizesInvisiblesInText(): Unit {
        // 107
        var escaped: String = "This&shy;is&#x200b;one&shy;long&shy;word"

        // browser would not display those soft hyphens / other chars, so we don't want them in the text
        var decoded: String = "This\u{00AD}is\u{200B}one\u{00AD}long\u{00AD}word"
        var doc: Document = Html4cj.parse("<p>" + escaped)
        var p: Element = doc.select("p").first().getOrThrow()

        // so that the outer html is easier to see with escaped invisibles
        doc.outputSettings().charset("ascii")

        // text is normalized 
        @Assert("Thisisonelongword", p.text())

        // html / whole text keeps &shy etc
        @Assert("<p>" + escaped + "</p>", p.outerHtml())
        @Assert(decoded, p.textNodes()[0].getWholeText())

        // really just oneloneword, no invisibles
        var matched: Element = doc.select("p:contains(Thisisonelongword)").first().getOrThrow()
        @Assert("p", matched.nodeName())
        @Assert(matched.check(":containsOwn(Thisisonelongword)"), true)

        println("Pass107")
    }

    @TestCase
    public func testRemoveBeforeIndex(): Unit {
        // 108
        var doc: Document = Html4cj.parse(
            "<html><body><div><p>before1</p><p>before2</p><p>XXX</p><p>after1</p><p>after2</p></div></body></html>",
            ""
        )
        var body: Element = doc.select("body").first().getOrThrow()
        var elems: Elements = body.select("p:matchesOwn(XXX)")
        var xElem: Element = elems.first().getOrThrow()
        var beforeX: Elements = xElem.parentElement().getOrThrow().getElementsByIndexLessThan(
            xElem.elementSiblingIndex())
        for (p in beforeX) {
            p.remove()
        }
        @Assert("<body><div><p>XXX</p><p>after1</p><p>after2</p></div></body>", TextUtil.stripNewlines(body.outerHtml()))

        println("Pass108")
    }

    @TestCase
    public func testRemoveAfterIndex(): Unit {
        // 109
        var doc2: Document = Html4cj.parse(
            "<html><body><div><p>before1</p><p>before2</p><p>XXX</p><p>after1</p><p>after2</p></div></body></html>",
            ""
        )
        var body: Element = doc2.select("body").first().getOrThrow()
        var elems: Elements = body.select("p:matchesOwn(XXX)")
        var xElem: Element = elems.first().getOrThrow()
        var afterX: Elements = xElem.parentElement().getOrThrow().getElementsByIndexGreaterThan(
            xElem.elementSiblingIndex())
        for (p in afterX) {
            p.remove()
        }
        @Assert("<body><div><p>before1</p><p>before2</p><p>XXX</p></div></body>", TextUtil.stripNewlines(body.outerHtml()))

        println("Pass109")
    }

    @TestCase
    public func whiteSpaceClassElement(): Unit {
        // 110
        var tag: Tag = Tag.valueOf("a")
        var attribs: Attributes = Attributes()
        var el: Element = Element(tag, "", attribs)
        attribs.put("class", "abc ")
        var hasClass: Bool = el.hasClass("ab")
        @Assert(false, hasClass)

        println("Pass110")
    }

    @TestCase
    public func testNextElementSiblingAfterClone(): Unit {
        // 111
        // via https://github.com/jhy/jsoup/issues/951
        var html: String = "<!DOCTYPE html><html lang=\"en\"><head></head><body><div>Initial element</div></body></html>"
        var expectedText: String = "New element"
        var cloneExpect: String = "New element in clone"
        var original: Document = Html4cj.parse(html)
        var clone: Document = original.clone()
        var originalElement: Element = original.body().child(0)
        originalElement.after("<div>" + expectedText + "</div>")
        var originalNextElementSibling: Element = originalElement.nextElementSibling().getOrThrow()
        var originalNextSibling: Element = (originalElement.nextSibling().getOrThrow() as Element).getOrThrow()
        @Assert(expectedText, originalNextElementSibling.text())
        @Assert(expectedText, originalNextSibling.text())
        var cloneElement: Element = clone.body().child(0)
        cloneElement.after("<div>" + cloneExpect + "</div>")
        var cloneNextElementSibling: Element = cloneElement.nextElementSibling().getOrThrow()
        var cloneNextSibling: Element = (cloneElement.nextSibling().getOrThrow() as Element).getOrThrow()
        @Assert(cloneExpect, cloneNextElementSibling.text())
        @Assert(cloneExpect, cloneNextSibling.text())

        println("Pass111")
    }

    @TestCase
    public func testRemovingEmptyClassAttributeWhenLastClassRemoved(): Unit {
        // 112
        // https://github.com/jhy/jsoup/issues/947
        var doc: Document = Html4cj.parse("<img class=\"one two\" />")
        var img: Element = doc.select("img").first().getOrThrow()
        img.removeClass("one")
        img.removeClass("two")
        @Assert(false, doc.body().html().contains("class=\"\""))

        println("Pass112")
    }

    @TestCase
    public func boolAttributeOutput(): Unit {
        // 113
        var doc: Document = Html4cj.parse("<img src=foo noshade='' nohref async=async autofocus=false>")
        var img: Element = doc.selectFirst("img").getOrThrow()
        @Assert("<img src=\"foo\" noshade nohref async autofocus=\"false\">", img.outerHtml())

        println("Pass113")
    }

    @TestCase
    public func textHasSpaceAfterBlockTags(): Unit {
        // 114
        var doc: Document = Html4cj.parse("<div>One</div>Two")
        @Assert("One Two", doc.text())

        println("Pass114")
    }

    @TestCase
    public func textHasSpaceBetweenDivAndCenterTags(): Unit {
        // 115
        var doc: Document = Html4cj.parse("<div>One</div><div>Two</div><center>Three</center><center>Four</center>")
        @Assert("One Two Three Four", doc.text())

        println("Pass115")
    }

    @TestCase
    public func testNextElementSiblings(): Unit {
        // 116
        var doc: Document = Html4cj.parse(
            "<ul id='ul'>" + "<li id='a'>a</li>" + "<li id='b'>b</li>" + "<li id='c'>c</li>" +
                "</ul> Not An Element but a node" + "<div id='div'>" + "<li id='d'>d</li>" + "</div>"
        )
        var element: Element = doc.getElementById("a").getOrThrow()
        var elementSiblings: Elements = element.nextElementSiblings()
        @Assert(2, elementSiblings.size)
        @Assert("b", elementSiblings[0].id())
        @Assert("c", elementSiblings[1].id())
        var element1: Element = doc.getElementById("b").getOrThrow()
        var elementSiblings1: ArrayList<Element> = element1.nextElementSiblings().elementArr
        @Assert(1, elementSiblings1.size)
        @Assert("c", elementSiblings1[0].id())
        var element2: Element = doc.getElementById("c").getOrThrow()
        var elementSiblings2: ArrayList<Element> = element2.nextElementSiblings().elementArr
        @Assert(0, elementSiblings2.size)
        var ul: Element = doc.getElementById("ul").getOrThrow()
        var elementSiblings3: ArrayList<Element> = ul.nextElementSiblings().elementArr
        @Assert(1, elementSiblings3.size)
        @Assert("div", elementSiblings3[0].id())
        var div: Element = doc.getElementById("div").getOrThrow()
        var elementSiblings4: ArrayList<Element> = div.nextElementSiblings().elementArr
        @Assert(0, elementSiblings4.size)

        println("Pass116")
    }

    @TestCase
    public func testPreviousElementSiblings(): Unit {
        // 117
        var doc: Document = Html4cj.parse(
            "<ul id='ul'>" + "<li id='a'>a</li>" + "<li id='b'>b</li>" + "<li id='c'>c</li>" + "</ul>" + "<div id='div'>"+
                "<li id='d'>d</li>" + "</div>"
        )
        var element: Element = doc.getElementById("b").getOrThrow()
        var elementSiblings: Elements = element.previousElementSiblings()
        @Assert(1, elementSiblings.size)
        @Assert("a", elementSiblings[0].id())
        var element1: Element = doc.getElementById("a").getOrThrow()
        var elementSiblings1: ArrayList<Element> = element1.previousElementSiblings().elementArr
        @Assert(0, elementSiblings1.size)
        var element2: Element = doc.getElementById("c").getOrThrow()
        var elementSiblings2: ArrayList<Element> = element2.previousElementSiblings().elementArr
        @Assert(2, elementSiblings2.size)
        @Assert("b", elementSiblings2[0].id())
        @Assert("a", elementSiblings2[1].id())
        var ul: Element = doc.getElementById("ul").getOrThrow()
        var elementSiblings3: ArrayList<Element> = ul.previousElementSiblings().elementArr
        @Assert(0, elementSiblings3.size)

        println("Pass117")
    }

    @TestCase
    public func testClearAttributes(): Unit {
        // 118
        var el: Element = Element("a").attr("href", "http://example.com").text("Hello")
        @Assert("<a href=\"http://example.com\">Hello</a>", el.outerHtml())

        // really just force testing the return type is Element
        var el2: Element = el.clearAttributes()
        @Assert(refEq(el, el2), true)
        @Assert("<a>Hello</a>", el2.outerHtml())

        println("Pass118")
    }

    @TestCase
    public func testRemoveAttr(): Unit {
        // 119
        var el: Element = Element("a").attr("href", "http://example.com").attr("id", "1").text("Hello")
        @Assert("<a href=\"http://example.com\" id=\"1\">Hello</a>", el.outerHtml())

        // really just force testing the return type is Element
        var el2: Element = el.removeAttr("href")
        @Assert(refEq(el, el2), true)
        @Assert("<a id=\"1\">Hello</a>", el2.outerHtml())

        println("Pass119")
    }

    @TestCase
    public func testRoot(): Unit {
        // 120
        var el: Element = Element("a")
        el.append("<span>Hello</span>")
        @Assert("<a><span>Hello</span></a>", el.outerHtml())
        var span: Element = el.selectFirst("span").getOrThrow()
        var el2: Element = span.root()
        @Assert(refEq(el, el2))
        var doc: Document = Html4cj.parse("<div><p>One<p>Two<p>Three")
        var div: Element = doc.selectFirst("div").getOrThrow()
        @Assert(refEq(doc, div.root()))
        @Assert(refEq(doc, div.ownerDocument().getOrThrow()))

        println("Pass120")
    }

    @TestCase
    public func testTraverse(): Unit {
        // 121
        var doc: Document = Html4cj.parse("<div><p>One<p>Two<p>Three")
        var div: Element = doc.selectFirst("div").getOrThrow()
        var counter: ArrayList<Int64> = ArrayList<Int64>()
        var div2: Element = div.traverse(TestNodeVisitor(counter))
        @Assert(7, counter.size)
        @Assert(div2, div)

        println("Pass121")
    }

    @TestCase
    public func testTraverseLambda(): Unit {
        // 122
        var doc: Document = Html4cj.parse("<div><p>One<p>Two<p>Three")
        var div: Element = doc.selectFirst("div").getOrThrow()
        var counter: ArrayList<Int64> = ArrayList<Int64>()
        var div2: Element = div.traverse(TestNodeVisitor(counter))
        @Assert(7, counter.size)
        @Assert(div2, div)

        println("Pass122")
    }

    @TestCase
    public func testFilterCallReturnsElement(): Unit {
        // 123
        // doesn't actually test the filter so much as the return type for Element. See node.nodeFilter for an actual test
        var doc: Document = Html4cj.parse("<div><p>One<p>Two<p>Three")
        var div: Element = doc.selectFirst("div").getOrThrow()
        var div2: Element = div.filter(Test2NodeVisitor())
        @Assert(refEq(div, div2), true)

        println("Pass123")
    }

    @TestCase
    public func testFilterAsLambda(): Unit {
        // 124
        var doc: Document = Html4cj.parse("<div><p>One<p id=2>Two<p>Three")
        doc.filter(Test3NodeVisitor())
        @Assert("<div><p>One</p><p>Three</p></div>", TextUtil.stripNewlines(doc.body().html()))

        println("Pass124")
    }

    @TestCase
    public func testForEach(): Unit {
        // 125
        // TODO
        println("Pass125")
    }

    @TestCase
    public func doesntDeleteZWJWhenNormalizingText(): Unit {
        // 126
        // TODO
        var text: String =
            "${'\u{1f469}'}${'\u{200D}'}${'\u{1f4bb}'}${'\u{1f926}'}${'\u{1f3fb}'}${'\u{200D}'}${'\u{2642}'}${'\u{FE0F}'}"
        var doc: Document = Html4cj.parse("<p>" + text + "</p><div>One&zwj;Two</div>")
        var p: Element = doc.selectFirst("p").getOrThrow()
        var d: Element = doc.selectFirst("div").getOrThrow()
        @Assert(text.size, p.text().size)
        @Assert(text, p.text())
        @Assert(7, d.text().size)
        @Assert("One${'\u{200D}'}Two", d.text())
        var found: Element = doc.selectFirst("div:contains(One${'\u{200D}'}Two)").getOrThrow()
        @Assert(found.hasSameValue(d), true)

        println("Pass126")
    }

    @TestCase
    public func testReparentSeperateNodes(): Unit {
        // 127
        var html: String = "<div><p>One<p>Two"
        var doc: Document = Html4cj.parse(html)
        var new1: Element = Element("p").text("Three")
        var new2: Element = Element("p").text("Four")
        doc.body().insertChildren(-1, new1, new2)
        @Assert("<div><p>One</p><p>Two</p></div><p>Three</p><p>Four</p>", TextUtil.stripNewlines(doc.body().html()))

        // note that these get moved from the above - as not copied
        doc.body().insertChildren(0, new1, new2)
        @Assert("<p>Three</p><p>Four</p><div><p>One</p><p>Two</p></div>", TextUtil.stripNewlines(doc.body().html()))
        doc.body().insertChildren(0, new2.clone(), new1.clone())
        @Assert("<p>Four</p><p>Three</p><p>Three</p><p>Four</p><div><p>One</p><p>Two</p></div>", TextUtil.stripNewlines(doc.body().html()))

        // shifted to end
        doc.body().appendChild(new1)
        @Assert("<p>Four</p><p>Three</p><p>Four</p><div><p>One</p><p>Two</p></div><p>Three</p>", TextUtil.stripNewlines(doc.body().html()))

        println("Pass127")
    }

    @TestCase
    public func testNotActuallyAReparent(): Unit {
        // 128
        // prep
        var html: String = "<div>"
        var doc: Document = Html4cj.parse(html)
        var div: Element = doc.selectFirst("div").getOrThrow()
        var new1: Element = Element("p").text("One")
        var new2: Element = Element("p").text("Two")
        div.addChildren(new1, new2)
        @Assert("<div><p>One</p><p>Two</p></div>", TextUtil.stripNewlines(div.outerHtml()))

        // and the issue setup:
        var new3: Element = Element("p").text("Three")
        var wrap: Element = Element("nav")
        wrap.addChildren(0, new1, new3)
        @Assert("<nav><p>One</p><p>Three</p></nav>", TextUtil.stripNewlines(wrap.outerHtml()))
        div.addChildren(wrap)

        // now should be that One moved into wrap, leaving Two in div.
        @Assert("<div><p>Two</p><nav><p>One</p><p>Three</p></nav></div>", TextUtil.stripNewlines(div.outerHtml()))
        @Assert("<div><p>Two</p><nav><p>One</p><p>Three</p></nav></div>", TextUtil.stripNewlines(div.outerHtml()))

        println("Pass128")
    }

    @TestCase
    public func testChildSizeWithMixedContent(): Unit {
        // 129
        var doc: Document = Html4cj.parse(
            "<table><tbody>\n<tr>\n<td>15:00</td>\n<td>sport</td>\n</tr>\n</tbody></table>")
        var row: Element = doc.selectFirst("table tbody tr").getOrThrow()
        @Assert(2, row.childrenSize())
        @Assert(5, row.childNodeSize())

        println("Pass129")
    }

    @TestCase
    public func isBlock(): Unit {
        // 130
        var html: String = "<div><p><span>Hello</span>"
        var doc: Document = Html4cj.parse(html)
        @Assert(doc.selectFirst("div").getOrThrow().isBlock(), true)
        @Assert(doc.selectFirst("p").getOrThrow().isBlock(), true)
        @Assert(false, doc.selectFirst("span").getOrThrow().isBlock())

        println("Pass130")
    }

    @TestCase
    public func testScriptTextHtmlSetAsData(): Unit {
        // 131
        var src: String = "var foo = 5 < 2;\nvar bar = 1 && 2;"
        var html: String = "<script>" + src + "</script>"
        var doc: Document = Html4cj.parse(html)
        var el: Element = doc.selectFirst("script").getOrThrow()
        validateScriptContents(src, el)
        src = "var foo = 4 < 2;\nvar bar > 1 && 2;"
        el.html(src)
        validateScriptContents(src, el)

        // special case for .text (in HTML; in XML will just be regular text)
        el.text(src)
        validateScriptContents(src, el)

        // XML, no special treatment, get escaped correctly
        var xml: Document = Parser.xmlParser().parseInput(html, "")
        var xEl: Element = xml.selectFirst("script").getOrThrow()
        src = "var foo = 5 < 2;\nvar bar = 1 && 2;"
        var escaped: String = "var foo = 5 &lt; 2;\nvar bar = 1 &amp;&amp; 2;"
        validateXmlScriptContents(xEl)
        xEl.text(src)
        validateXmlScriptContents(xEl)
        xEl.html(src)
        validateXmlScriptContents(xEl)
        @Assert("<script>var foo = 4 < 2;\nvar bar > 1 && 2;</script>", el.outerHtml())

        // escaped in xml as no special treatment
        @Assert("<script>" + escaped + "</script>", xEl.outerHtml())

        println("Pass131")
    }

    @TestCase
    public func testShallowCloneToString(): Unit {
        // 132
        // https://github.com/jhy/jsoup/issues/1410
        var doc: Document = Html4cj.parse("<p><i>Hello</i></p>")
        var p: Element = doc.selectFirst("p").getOrThrow()
        var i: Element = doc.selectFirst("i").getOrThrow()
        var pH: String = p.shallowClone().toString()
        var iH: String = i.shallowClone().toString()

        // shallow, so no I
        @Assert("<p></p>", pH)
        @Assert("<i></i>", iH)
        @Assert(p.outerHtml(), p.toString())
        @Assert(i.outerHtml(), i.toString())

        println("Pass132")
    }

    @TestCase
    public func styleHtmlRoundTrips(): Unit {
        // 133
        var styleContents: String = "foo < bar > qux {color:white;}"
        var html: String = "<head><style>" + styleContents + "</style></head>"
        var doc: Document = Html4cj.parse(html)
        var head: Element = doc.head()
        var style: Element = head.selectFirst("style").getOrThrow()
        @Assert(styleContents, style.html())
        style.html(styleContents)
        @Assert(styleContents, style.html())
        @Assert("", style.text())

        // pushes the HTML, not the Text
        style.text(styleContents)
        @Assert("", style.text())
        @Assert(styleContents, style.html())

        println("Pass133")
    }

    @TestCase
    public func moveChildren(): Unit {
        // 134
        var doc: Document = Html4cj.parse("<div><p>One<p>Two<p>Three</div><div></div>")
        var divs: Elements = doc.select("div")
        var a: Element = divs[0]
        var b: Element = divs[1]
        b.insertChildren(-1, a.childNodes())
        @Assert("<div></div>\n<div>\n <p>One</p>\n <p>Two</p>\n <p>Three</p>\n</div>",
                doc.body().html())

        println("Pass134")
    }

    @TestCase
    public func moveChildrenToOuter(): Unit {
        // 135
        var doc: Document = Html4cj.parse("<div><p>One<p>Two<p>Three</div><div></div>")
        var divs: Elements = doc.select("div")
        var a: Element = divs[0]
        var b: Element = doc.body()
        b.insertChildren(-1, a.childNodes())
        @Assert("<div></div>\n<div></div>\n<p>One</p>\n<p>Two</p>\n<p>Three</p>",
                doc.body().html())

        println("Pass135")
    }

    @TestCase
    public func appendChildren(): Unit {
        // 136
        var doc: Document = Html4cj.parse("<div><p>One<p>Two<p>Three</div><div><p>Four</div>")
        var divs: Elements = doc.select("div")
        var a: Element = divs[0]
        var b: Element = divs[1]
        b.appendChildren(a.childNodes())
        @Assert("<div></div>\n<div>\n <p>Four</p>\n <p>One</p>\n <p>Two</p>\n <p>Three</p>\n</div>",
                doc.body().html())

        println("Pass136")
    }

    @TestCase
    public func prependChildren(): Unit {
        // 137
        var doc: Document = Html4cj.parse("<div><p>One<p>Two<p>Three</div><div><p>Four</div>")
        var divs: Elements = doc.select("div")
        var a: Element = divs[0]
        var b: Element = divs[1]
        b.prependChildren(a.childNodes())
        @Assert("<div></div>\n<div>\n <p>One</p>\n <p>Two</p>\n <p>Three</p>\n <p>Four</p>\n</div>",
                doc.body().html())

        println("Pass137")
    }

    @TestCase
    public func loopMoveChildren(): Unit {
        // 138
        var doc: Document = Html4cj.parse("<div><p>One<p>Two<p>Three</div><div><p>Four</div>")
        var divs: Elements = doc.select("div")
        var a: Element = divs[0]
        var b: Element = divs[1]
        var outer: Element = b.parentElement().getOrThrow()
        for (node in a.childNodes()) {
            outer.appendChild(node)
        }
        @Assert("<div></div>\n<div>\n <p>Four</p>\n</div>\n<p>One</p>\n<p>Two</p>\n<p>Three</p>",
                doc.body().html())

        println("Pass138")
    }

    @TestCase
    public func accessorsDoNotVivifyAttributes(): Unit {
        // 139
        // internally, we don't want to create empty Attribute objects unless actually used for something
        var doc: Document = Html4cj.parse("<div><p><a href=foo>One</a>")
        var div: Element = doc.selectFirst("div").getOrThrow()
        var p: Element = doc.selectFirst("p").getOrThrow()
        var a: Element = doc.selectFirst("a").getOrThrow()

        // should not create attributes
        @Assert("", div.attr("href"))
        p.removeAttr("href")
        var hrefs: Elements = doc.select("[href]")
        @Assert(1, hrefs.size)
        @Assert(false, div.hasAttributes())
        @Assert(false, p.hasAttributes())
        @Assert(a.hasAttributes(), true)

        println("Pass139")
    }

    @TestCase
    public func childNodesAccessorDoesNotVivify(): Unit {
        // 140
        var doc: Document = Html4cj.parse("<p></p>")
        var p: Element = doc.selectFirst("p").getOrThrow()
        @Assert(false, p.hasChildNodes())
        @Assert(0, p.childNodeSize())
        @Assert(0, p.childrenSize())
        var childNodes: ArrayList<Node> = p.childNodes()
        @Assert(0, childNodes.size)
        var children: Elements = p.children()
        @Assert(0, children.size)
        @Assert(false, p.hasChildNodes())

        println("Pass140")
    }

    @TestCase
    public func emptyChildrenElementsIsModifiable(): Unit {
        // 141
        // using unmodifiable empty in childElementList as short circuit, but people may be modifying Elements.
        var p: Element = Element("p")
        var els: Elements = p.children()
        @Assert(0, els.size)
        els.elementArr.append(Element("a"))
        @Assert(1, els.size)

        println("Pass141")
    }

    @TestCase
    public func attributeSizeDoesNotAutoVivify(): Unit {
        // 142
        var doc: Document = Html4cj.parse("<p></p>")
        var p: Element = doc.selectFirst("p").getOrThrow()
        @Assert(false, p.hasAttributes())
        @Assert(0, p.attributesSize())
        @Assert(false, p.hasAttributes())
        p.attr("foo", "bar")
        @Assert(1, p.attributesSize())
        @Assert(p.hasAttributes(), true)
        p.removeAttr("foo")
        @Assert(0, p.attributesSize())

        println("Pass142")
    }

    @TestCase
    public func clonedElementsHaveOwnerDocsAndIndependentSettings(): Unit {
        // 143
        // https://github.com/jhy/jsoup/issues/763
        var doc: Document = Html4cj.parse("<div>Text</div><div>Two</div>")
        doc.outputSettings().prettyPrint(false)
        var div: Element = doc.selectFirst("div").getOrThrow()
        div.childNode(0)
        var divClone: Element = div.clone()
        var docClone: Document = divClone.ownerDocument().getOrThrow()
        @Assert(false, docClone.outputSettings().prettyPrint())
        @Assert(refEq(doc, docClone), false)
        @Assert(refEq(docClone, divClone.childNode(0).ownerDocument().getOrThrow()), true)

        // the cloned text has same owner doc as the cloned div
        doc.outputSettings().prettyPrint(true)
        @Assert(doc.outputSettings().prettyPrint(), true)
        @Assert(false, docClone.outputSettings().prettyPrint())

        // check did not get the second div as the owner's children
        @Assert(1, docClone.children().size)

        // note not the head or the body -- not normalized
        @Assert(divClone, docClone.child(0))

        println("Pass143")
    }

    @TestCase
    public func testOutputSettings(): Unit {
        // 144
        var list: ArrayList<DocumentOutputSettings> = ArrayList<DocumentOutputSettings>(
            DocumentOutputSettings().prettyPrint(true).indentAmount(4),
            DocumentOutputSettings().prettyPrint(true).indentAmount(1),
            DocumentOutputSettings().prettyPrint(true).indentAmount(4).outline(true),
            DocumentOutputSettings().prettyPrint(false)
        )
        for (i in 0..list.size) {
            prettySerializationRoundTrips(list[i])
        }

        println("Pass144")
    }

    private func prettySerializationRoundTrips(settings: DocumentOutputSettings): Unit {
        // https://github.com/jhy/jsoup/issues/1688
        // tests that repeated html() and parse() does not accumulate errant spaces / newlines
        var doc: Document = Html4cj.parse("<div>\nFoo\n<p>\nBar\nqux</p></div>\n<script>\n alert('Hello!');\n</script>")
        doc.outputSettings(settings)
        var html: String = doc.html()
        var doc2: Document = Html4cj.parse(html)
        doc2.outputSettings(settings)
        var html2: String = doc2.html()
        @Assert(html, html2)
    }

    @TestCase
    public func prettyPrintScriptsDoesNotGrowOnRepeat(): Unit {
        // 145
        var doc: Document = Html4cj.parse("<div>\nFoo\n<p>\nBar\nqux</p></div>\n<script>\n alert('Hello!');\n</script>")
        var settings: DocumentOutputSettings = doc.outputSettings()
        settings.prettyPrint(true).outline(true).indentAmount(4)
        var html: String = doc.html()
        var doc2: Document = Html4cj.parse(html)
        doc2.outputSettings(settings)
        var html2: String = doc2.html()
        @Assert(html, html2)

        println("Pass145")
    }

    @TestCase
    public func elementBrText(): Unit {
        // 146
        // testcase for https://github.com/jhy/jsoup/issues/1437
        var html: String = "<p>Hello<br>World</p>"
        var doc: Document = Html4cj.parse(html)

        // otherwise html serializes as Hello<br>\n World.
        doc.outputSettings().prettyPrint(false)
        var p: Element = doc.select("p").first().getOrThrow()
        @Assert(html, p.outerHtml())
        @Assert("Hello World", p.text())
        @Assert("Hello\nWorld", p.wholeText())

        println("Pass146")
    }

    @TestCase
    public func wrapTextAfterBr(): Unit {
        // 147
        // https://github.com/jhy/jsoup/issues/1858
        var html: String = "<p>Hello<br>there<br>now.</p>"
        var doc: Document = Html4cj.parse(html)
        @Assert("<p>Hello<br>\n there<br>\n now.</p>", doc.body().html())

        println("Pass147")
    }

    @TestCase
    public func prettyprintBrInBlock(): Unit {
        // 148
        var html: String = "<div><br> </div>"
        var doc: Document = Html4cj.parse(html)

        // not div\n br\n \n/div
        @Assert("<div>\n <br>\n</div>", doc.body().html())

        println("Pass148")
    }

    @TestCase
    public func preformatFlowsToChildTextNodes(): Unit {
        // 149
        // https://github.com/jhy/jsoup/issues/1776
        var html: String =
            "<div><pre>One\n<span>\nTwo</span>\n <span>  \nThree</span>\n <span>Four <span>Five</span>\n  Six\n</pre>"
        var doc: Document = Html4cj.parse(html)
        doc.outputSettings().indentAmount(2).prettyPrint(true)
        var div: Element = doc.selectFirst("div").getOrThrow()
        var actual: String = div.outerHtml()
        var expect: String =
            "<div>\n" + "  <pre>One\n" + "<span>\n" + "Two</span>\n" + " <span>  \n" + "Three</span>\n" +
            " <span>Four <span>Five</span>\n" + "  Six\n" + "</span></pre>\n" + "</div>"
        @Assert(expect, actual)
        var expectText: String = "One\n" + "\n" + "Two\n" + "   \n" + "Three\n" + " Four Five\n" + "  Six\n"
        @Assert(expectText, div.wholeText())
        var expectOwn: String = "One\n" + "\n" + " \n" + " "
        @Assert(expectOwn, div.child(0).wholeOwnText())

        println("Pass149")
    }

    @TestCase
    public func testExpectFirst(): Unit {
        // 150
        var doc: Document = Html4cj.parse("<p>One</p><p>Two <span>Three</span> <span>Four</span>")
        var span: Element = doc.expectFirst("span")
        @Assert("Three", span.text())
        @Assert(doc.selectFirst("div") == None, true)
        var threw: Bool = false
        try {
            doc.expectFirst("div")
        } catch (e: Exception) {
            threw = true
        }
        @Assert(threw, true)

        println("Pass150")
    }

    @TestCase
    public func testExpectFirstMessage(): Unit {
        // 151
        var doc: Document = Html4cj.parse("<p>One</p><p>Two <span>Three</span> <span>Four</span>")
        var threw: Bool = false
        var p: Element = doc.expectFirst("P")
        try {
            p.expectFirst("span.doesNotExist")
        } catch (e: Exception) {
            threw = true
            @Assert("No elements matched the query 'span.doesNotExist' on element 'p'.", e.message)
        }
        @Assert(threw, true)

        println("Pass151")
    }

    @TestCase
    public func testExpectFirstMessageDoc(): Unit {
        // 152
        var doc: Document = Html4cj.parse("<p>One</p><p>Two <span>Three</span> <span>Four</span>")
        var threw: Bool = false
        doc.expectFirst("P")
        try {
            doc.expectFirst("span.doesNotExist")
        } catch (e: Exception) {
            threw = true
            @Assert("No elements matched the query 'span.doesNotExist' in the document.", e.message)
        }
        @Assert(threw, true)

        println("Pass152")
    }

    @TestCase
    public func spanRunsMaintainSpace(): Unit {
        // 153
        // https://github.com/jhy/jsoup/issues/1787
        var doc: Document = Html4cj.parse("<p><span>One</span>\n<span>Two</span>\n<span>Three</span></p>")
        var text: String = "One Two Three"
        var body: Element = doc.body()
        @Assert(text, body.text())
        var p: Element = doc.expectFirst("p")
        var html: String = p.html()
        p.html(html)
        @Assert(text, body.text())
        @Assert("<p><span>One</span> <span>Two</span> <span>Three</span></p>", body.html())

        println("Pass153")
    }

    @TestCase
    public func doctypeIsPrettyPrinted(): Unit {
        // 154
        // resolves underlying issue raised in https://github.com/jhy/jsoup/pull/1664
        var doc1: Document = Html4cj.parse("<!--\nlicense\n-->\n \n<!doctype html>\n<html>")
        var doc2: Document = Html4cj.parse("\n  <!doctype html><html>")
        var doc3: Document = Html4cj.parse("<!doctype html>\n<html>")
        var doc4: Document = Html4cj.parse("\n<!doctype html>\n<html>")
        var doc5: Document = Html4cj.parse("\n<!--\n comment \n -->  <!doctype html>\n<html>")
        var doc6: Document = Html4cj.parse("<!--\n comment \n -->  <!doctype html>\n<html>")
        @Assert("<!--\nlicense\n-->\n<!doctype html>\n<html>\n <head></head>\n <body></body>\n</html>", doc1.html())
        doc1.outputSettings().prettyPrint(false)
        @Assert("<!--\nlicense\n--><!doctype html>\n<html><head></head><body></body></html>", doc1.html())

        // note that the whitespace between the comment and the doctype is not retained, in Initial state
        @Assert("<!doctype html>\n<html>\n <head></head>\n <body></body>\n</html>", doc2.html())
        @Assert("<!doctype html>\n<html>\n <head></head>\n <body></body>\n</html>", doc3.html())
        @Assert("<!doctype html>\n<html>\n <head></head>\n <body></body>\n</html>", doc4.html())
        @Assert("<!--\n comment \n -->\n<!doctype html>\n<html>\n <head></head>\n <body></body>\n</html>", doc5.html())
        @Assert("<!--\n comment \n -->\n<!doctype html>\n<html>\n <head></head>\n <body></body>\n</html>", doc6.html())

        println("Pass154")
    }

    @TestCase
    public func textnodeInBlockIndent(): Unit {
        // 155
        var html: String = "<div>\n{{ msg }} \n </div>\n<div>\n{{ msg }} \n </div>"
        var doc: Document = Html4cj.parse(html)
        @Assert("<div>\n {{ msg }}\n</div>\n<div>\n {{ msg }}\n</div>", doc.body().html())

        println("Pass155")
    }

    @TestCase
    public func stripTrailing(): Unit {
        // 156
        var html: String = "<p> This <span>is </span>fine. </p>"
        var doc: Document = Html4cj.parse(html)
        @Assert("<p>This <span>is </span>fine.</p>", doc.body().html())

        println("Pass156")
    }

    @TestCase
    public func elementIndentAndSpaceTrims(): Unit {
        // 157
        var html: String = "<body><div> <p> One Two </p> <a>  Hello </a><p>\nSome text \n</p>\n </div>"
        var doc: Document = Html4cj.parse(html)
        @Assert("<div>\n" +
                " <p>One Two</p><a> Hello </a>\n" +
                " <p>Some text</p>\n" +
                "</div>", doc.body().html())

        println("Pass157")
    }

    @TestCase
    public func divAInlineable(): Unit {
        // 158
        var html: String = "<body><div> <a>Text</a>"
        var doc: Document = Html4cj.parse(html)
        @Assert("<div><a>Text</a>\n</div>", doc.body().html())

        println("Pass158")
    }

    @TestCase
    public func noDanglingSpaceAfterCustomElement(): Unit {
        // 159
        // https://github.com/jhy/jsoup/issues/1852
        var html: String = "<bar><p/>\n</bar>"
        var doc: Document = Html4cj.parse(html)
        @Assert("<bar>\n <p></p>\n</bar>", doc.body().html())
        html = "<foo>\n  <bar />\n</foo>"
        doc = Html4cj.parse(html)
        @Assert("<foo>\n <bar />\n</foo>", doc.body().html())

        println("Pass159")
    }

    @TestCase
    public func spanInBlockTrims(): Unit {
        // 160
        var html: String = "<p>Lorem ipsum</p>\n<span>Thanks</span>"
        var doc: Document = Html4cj.parse(html)
        var outHtml: String = doc.body().html()
        @Assert("<p>Lorem ipsum</p><span>Thanks</span>", outHtml)

        println("Pass160")
    }

    @TestCase
    public func replaceWithSelf(): Unit {
        // 161
        // https://github.com/jhy/jsoup/issues/1843
        var doc: Document = Html4cj.parse("<p>One<p>Two")
        var ps: Elements = doc.select("p")
        var first: Element = ps.first().getOrThrow()
        first.replaceWith(first)
        @Assert(ps[1], first.nextSibling())
        @Assert("<p>One</p>\n<p>Two</p>", first.parentElement().getOrThrow().html())

        println("Pass161")
    }

    @TestCase
    public func select(): Unit {
        // 162
        var eval: Evaluator = QueryParser.parse("div")
        var doc: Document = Html4cj.parse(reference)
        var els: Elements = doc.select("div")
        var els2: Elements = doc.select(eval)
        @Assert(els, els2)

        println("Pass162")
    }

    @TestCase
    public func insertChildrenValidation(): Unit {
        // 163
        var doc: Document = Html4cj.parse(reference)
        var div: Element = doc.expectFirst("div")
        var threw: Bool = false
        try {
            div.insertChildren(20, Element("div"))
        } catch (e: Exception) {
            threw = true
            @Assert("Insert position out of bounds.", e.message)
        }
        @Assert(threw, true)

        println("Pass163")
    }

    @TestCase
    public func cssSelectorNoDoc(): Unit {
        // 164
        var el: Element = Element("div")
        el.id("one")
        @Assert("#one", el.cssSelector())

        println("Pass164")
    }

    @TestCase
    public func cssSelectorNoParent(): Unit {
        // 165
        var el: Element = Element("div")
        @Assert("div", el.cssSelector())

        println("Pass165")
    }

    @TestCase
    public func orphanSiblings(): Unit {
        // 166
        var el: Element = Element("div")
        @Assert(0, el.siblingElements().size)
        @Assert(0, el.nextElementSiblings().size)
        @Assert(0, el.previousElementSiblings().size)
        @Assert(el.nextElementSibling() == None, true)
        @Assert(el.previousElementSibling() == None, true)

        println("Pass166")
    }

    @TestCase
    public func getElementsByAttributeStarting(): Unit {
        // 167
        var doc: Document = Html4cj.parse("<div data-one=1 data-two=2 id=1><p data-one=3 id=2>Text</div><div>")
        var els: Elements = doc.getElementsByAttributeStarting(" data- ")
        @Assert(2, els.size)
        @Assert("1", els[0].id())
        @Assert("2", els[1].id())
        @Assert(0, doc.getElementsByAttributeStarting("not-data").size)

        println("Pass167")
    }

    @TestCase
    public func getElementsByAttributeValueNot(): Unit {
        // 168
        var doc: Document = Html4cj.parse("<div data-one=1 data-two=2 id=1><p data-one=3 id=2>Text</div><div id=3>")
        var els: Elements = doc.body().getElementsByAttributeValueNot("data-one", "1")

        // the body, p, and last div
        @Assert(3, els.size)
        @Assert("body", els[0].normalName())
        @Assert("2", els[1].id())
        @Assert("3", els[2].id())

        println("Pass168")
    }

    @TestCase
    public func getElementsByAttributeValueStarting(): Unit {
        // 169
        var doc: Document = Html4cj.parse("<a href=one1></a><a href=one2></a><a href=else</a>")
        var els: Elements = doc.getElementsByAttributeValueStarting("href", "one")
        @Assert(2, els.size)
        @Assert("one1", els[0].attr("href"))
        @Assert("one2", els[1].attr("href"))

        println("Pass169")
    }

    @TestCase
    public func getElementsByAttributeValueEnding(): Unit {
        // 170
        var doc: Document = Html4cj.parse("<a href=1one></a><a href=2one></a><a href=else</a>")
        var els: Elements = doc.getElementsByAttributeValueEnding("href", "one")
        @Assert(2, els.size)
        @Assert("1one", els[0].attr("href"))
        @Assert("2one", els[1].attr("href"))

        println("Pass170")
    }

    @TestCase
    public func getElementsByAttributeValueContaining(): Unit {
        // 171
        var doc: Document = Html4cj.parse("<a href=1one></a><a href=2one></a><a href=else</a>")
        var els: Elements = doc.getElementsByAttributeValueContaining("href", "on")
        @Assert(2, els.size)
        @Assert("1one", els[0].attr("href"))
        @Assert("2one", els[1].attr("href"))

        println("Pass171")
    }

    @TestCase
    public func getElementsByAttributeValueMatchingPattern(): Unit {
        // 172
        var doc: Document = Html4cj.parse("<a href=1one></a><a href=2one></a><a href=else</a>")
        var els: Elements = doc.getElementsByAttributeValueMatching("href", Regex("^\\d\\w+"))
        @Assert(2, els.size)
        @Assert("1one", els[0].attr("href"))
        @Assert("2one", els[1].attr("href"))

        println("Pass172")
    }

    @TestCase
    public func getElementsByAttributeValueMatching(): Unit {
        // 173
        var doc: Document = Html4cj.parse("<a href=1one></a><a href=2one></a><a href=else</a>")
        var els: Elements = doc.getElementsByAttributeValueMatching("href", "^\\d\\w+")
        @Assert(2, els.size)
        @Assert("1one", els[0].attr("href"))
        @Assert("2one", els[1].attr("href"))

        println("Pass173")
    }

    @TestCase
    public func getElementsByAttributeValueMatchingValidation(): Unit {
        // 174
        var doc: Document = Html4cj.parse(reference)
        var threw: Bool = false
        try {
            doc.getElementsByAttributeValueMatching("key", "")
        } catch (e: Exception) {
            threw = true
            @Assert("Pattern syntax error: \\x", e.message)
        }
        @Assert(threw, false)

        println("Pass174")
    }

    @TestCase
    public func getElementsByIndexEquals(): Unit {
        // 175
        var doc: Document = Html4cj.parse("<a href=1one></a><a href=2one></a><a href=else</a>")
        var els: Elements = doc.body().getElementsByIndexEquals(1)
        @Assert(2, els.size)
        @Assert("body", els[0].normalName())
        @Assert("2one", els[1].attr("href"))

        println("Pass175")
    }

    @TestCase
    public func getElementsContainingText(): Unit {
        // 176
        var doc: Document = Html4cj.parse("<div id=1>One</div><div>Two</div>")
        var els: Elements = doc.body().getElementsContainingText("one")
        @Assert(2, els.size)
        @Assert("body", els[0].normalName())
        @Assert("1", els[1].id())

        println("Pass176")
    }

    @TestCase
    public func getElementsContainingOwnText(): Unit {
        // 177
        var doc: Document = Html4cj.parse("<div id=1>One</div><div>Two</div>")
        var els: Elements = doc.body().getElementsContainingOwnText("one")
        @Assert(1, els.size)
        @Assert("1", els[0].id())

        println("Pass177")
    }

    @TestCase
    public func getElementsMatchingTextValidation(): Unit {
        // 178
        var doc: Document = Html4cj.parse(reference)
        var threw: Bool = false
        try {
            doc.getElementsMatchingText("")
        } catch (e: Exception) {
            threw = true
            @Assert("Pattern syntax error: \\x", e.message)
        }
        @Assert(threw, false)

        println("Pass178")
    }

    @TestCase
    public func getElementsMatchingText(): Unit {
        // 179
        var doc: Document = Html4cj.parse("<div id=1>One</div><div>Two</div>")
        var els: Elements = doc.body().getElementsMatchingText("O\\w+")
        @Assert(2, els.size)
        @Assert("body", els[0].normalName())
        @Assert("1", els[1].id())

        println("Pass179")
    }

    @TestCase
    public func getElementsMatchingOwnText(): Unit {
        // 180
        var doc: Document = Html4cj.parse("<div id=1>One</div><div>Two</div>")
        var els: Elements = doc.body().getElementsMatchingOwnText("O\\w+")
        @Assert(1, els.size)
        @Assert("1", els[0].id())

        println("Pass180")
    }

    @TestCase
    public func getElementsMatchingOwnTextValidation(): Unit {
        // 181
        var doc: Document = Html4cj.parse(reference)
        var threw: Bool = false
        try {
            doc.getElementsMatchingOwnText("")
        } catch (e: Exception) {
            threw = true
            @Assert("Pattern syntax error: \\x", e.message)
        }
        @Assert(threw, false)

        println("Pass181")
    }

    @TestCase
    public func hasText(): Unit {
        // 182
        var doc: Document = Html4cj.parse(
            "<div id=1><p><i>One</i></p></div><div id=2>Two</div><div id=3><script>data</script> </div>")
        @Assert(doc.getElementById("1").getOrThrow().hasText(), true)
        @Assert(doc.getElementById("2").getOrThrow().hasText(), true)
        @Assert(false, doc.getElementById("3").getOrThrow().hasText())

        println("Pass182")
    }

    @TestCase
    public func dataInCdataNode(): Unit {
        // 183
        var el: Element = Element("div")
        var cdata: CDataNode = CDataNode("Some CData")
        el.appendChild(cdata)
        @Assert("Some CData", el.data())
        var parse: Document = Html4cj.parse("One <![CDATA[Hello]]>")
        @Assert("Hello", parse.data())

        println("Pass183")
    }

    @TestCase
    public func outerHtmlAppendable(): Unit {
        // 184
        // tests not string builder flow
        var doc: Document = Html4cj.parse("<div>One</div>")
        var builder: StringBuilder = StringBuilder()
        doc.body().outerHtml(builder)
        @Assert("<body>\n <div>\n  One\n </div>\n</body>", builder.toString())

        println("Pass184")
    }

    @TestCase
    public func initTest(): Unit {
        // 185
        let p1: Tag = Tag.valueOf("P")
        var element1: Element = Element(p1, "")
        @Assert(element1.hasChildNodes(), false)

        println("Pass185")
    }

    @TestCase
    public func ensureChildNodesTest(): Unit {
        // 186
        var element: Element = Element("html")
        var list: ArrayList<Node> = element.ensureChildNodes()
        @Assert(list.size, 0)

        println("Pass186")
    }

    @TestCase
    public func hasAttributesTest(): Unit {
        // 187
        var element: Element = Element("html")
        @Assert(element.hasAttributes(), true)

        println("Pass187")
    }

    @TestCase
    public func attributesTest(): Unit {
        // 188
        var attributes: Attributes = Attributes()
        attributes.put("id", "1")
        attributes.put("class", "html")
        let p1: Tag = Tag.valueOf("P")
        var element: Element = Element(p1, "", attributes)
        @Assert(element.attributes(), attributes)

        println("Pass188")
    }

    @TestCase
    public func baseUriTest(): Unit {
        // 189
        var attributes: Attributes = Attributes()
        attributes.put("id", "1")
        attributes.put("class", "html")
        let p1: Tag = Tag.valueOf("P")
        var element: Element = Element(p1, "", attributes)
        @Assert(element.baseUri(), "")
        element.doSetBaseUri("https://www.baidu.com/")
        @Assert(element.baseUri(), "https://www.baidu.com/")

        println("Pass189")
    }

    @TestCase
    public func childNodeSizeTest(): Unit {
        // 190
        var attributes: Attributes = Attributes()
        attributes.put("id", "1")
        attributes.put("class", "html")
        let p1: Tag = Tag.valueOf("P")
        var element: Element = Element(p1, "", attributes)
        @Assert(element.childNodeSize(), 0)

        println("Pass190")
    }

    @TestCase
    public func nodeNameTest(): Unit {
        // 191
        var attributes: Attributes = Attributes()
        attributes.put("id", "1")
        attributes.put("class", "html")
        let p1: Tag = Tag.valueOf("P")
        var element: Element = Element(p1, "", attributes)
        @Assert(element.nodeName(), "P")

        println("Pass191")
    }

    @TestCase
    public func tagTest(): Unit {
        // 192
        var attributes: Attributes = Attributes()
        attributes.put("id", "1")
        attributes.put("class", "html")
        let p1: Tag = Tag.valueOf("P")
        var element: Element = Element(p1, "", attributes)
        @Assert(element.tag(), p1)
        @Assert(element.tagName(), "P")

        println("Pass192")
    }

    @TestCase
    public func isBlockTest(): Unit {
        // 193
        var attributes: Attributes = Attributes()
        attributes.put("id", "1")
        attributes.put("class", "html")
        let p1: Tag = Tag.valueOf("P")
        var element: Element = Element(p1, "", attributes)
        @Assert(element.isBlock(), true)

        println("Pass193")
    }

    @TestCase
    public func idTest(): Unit {
        // 194
        var attributes: Attributes = Attributes()
        attributes.put("id", "1")
        attributes.put("class", "html")
        let p1: Tag = Tag.valueOf("P")
        var element: Element = Element(p1, "", attributes)
        @Assert(element.id(), "1")

        println("Pass194")
    }

    @TestCase
    public func idSetTest(): Unit {
        // 195
        var attributes: Attributes = Attributes()
        attributes.put("id", "1")
        attributes.put("class", "html")
        let p1: Tag = Tag.valueOf("P")
        var element: Element = Element(p1, "", attributes)
        @Assert(element.id(), "1")
        element.id("2")
        @Assert(element.id(), "2")

        println("Pass195")
    }

    @TestCase
    public func attrTest(): Unit {
        // 196
        var attributes: Attributes = Attributes()
        attributes.put("id", "1")
        attributes.put("class", "html")
        let p1: Tag = Tag.valueOf("P")
        var element: Element = Element(p1, "", attributes)
        @Assert(element.attributes().size,3)
        element.attr("class", false)
        @Assert(element.attributes().size,2)
        element.removeAttr("id")
        @Assert(element.attributes().size,1)
        element.clearAttributes()
        @Assert(element.attributes().size,0)

        println("Pass196")
    }

    @TestCase
    public func dataset1Test(): Unit {
        // 197
        var attributes: Attributes = Attributes()
        attributes.put("data-id", "1")
        attributes.put("data-class", "html")
        let p1: Tag = Tag.valueOf("P")
        var element: Element = Element(p1, "", attributes)
        var data: Iterator<(String, ?String)> = element.dataset()
        @Assert(data.next().getOrThrow()[0],"data-id")
        @Assert(data.next().getOrThrow()[0],"data-class")

        println("Pass197")
    }

    @TestCase
    public func parentElementTest(): Unit {
        // 198
        var attributes: Attributes = Attributes()
        attributes.put("data-id", "1")
        attributes.put("data-class", "html")
        let p1: Tag = Tag.valueOf("P")
        var element: Element = Element(p1, "", attributes)
        @Assert(element.parentElement(), None)
        @Assert(element.childrenSize(), 0)

        println("Pass198")
    }

    @TestCase
    public func children1Test(): Unit {
        // 199
        var element1: Element = Element("html")
        var element2: Element = Element("body")
        var element3: Element = Element("p")
        element2.appendChild(element3)
        element1.appendChild(element2)
        @Assert(element3.root() == element1, true)
        @Assert(element3.root() != element2, true)
        @Assert(element1.childrenSize(), 1)

        println("Pass199")
    }

    @TestCase
    public func children2Test(): Unit {
        // 200
        var element1: Element = Element("html")
        var element2: Element = Element("body")
        var element3: Element = Element("p")
        element2.prependChild(element3)
        element1.prependChild(element2)
        @Assert(element3.root() == element1, true)
        @Assert(element3.root() != element2, true)
        @Assert(element1.childrenSize(), 1)
        @Assert(element1.child(0) == element2, true)
        element1.empty()
        @Assert(element1.childrenSize(), 0)

        println("Pass200")
    }

    @TestCase
    public func children3Test(): Unit {
        // 201
        var element1: Element = Element("html")
        var element2: Element = Element("body")
        var element3: Element = Element("p")
        var element4: Element = Element("p1")
        var element5: Element = Element("p2")
        var list: Array<Node> = [element3, element4, element5]
        element2.appendChildren(list)
        element1.appendChild(element2)
        @Assert(element3.root() == element1, true)
        @Assert(element3.root() != element2, true)
        @Assert(element1.childrenSize(), 1)
        @Assert(element2.childrenSize(), 3)
        @Assert(element1.child(0) == element2, true)
        element1.empty()
        @Assert(element1.childrenSize(), 0)

        println("Pass201")
    }

    @TestCase
    public func children4Test(): Unit {
        // 202
        var element1: Element = Element("html")
        var element2: Element = Element("body")
        var element3: Element = Element("p")
        var element4: Element = Element("p1")
        var element5: Element = Element("p2")
        var list: Array<Node> = [element3, element4, element5]
        element2.prependChildren(list)
        element1.prependChild(element2)
        @Assert(element3.root() == element1, true)
        @Assert(element3.root() != element2, true)
        @Assert(element1.childrenSize(), 1)
        @Assert(element2.childrenSize(), 3)
        @Assert(element1.child(0) == element2, true)
        element1.empty()
        @Assert(element1.childrenSize(), 0)
        element3.appendTo(element1)
        @Assert(element1.childrenSize(), 1)
        element1.insertChildren(0, element4, element5)
        @Assert(element1.childrenSize(), 3)

        println("Pass202")
    }

    @TestCase
    public func children5Test(): Unit {
        // 203
        var element1: Element = Element("body")
        var element2: Element = Element("p0")
        var element3: Element = Element("p1")
        var element4: Element = Element("p2")
        var element5: Element = Element("p3")
        var element6: Element = Element("p4")
        element1.appendChild(element2)
        element1.appendChild(element3)
        element1.prependChild(element4)
        println(element2.hasParent())
        @Assert(element1.childrenSize(), 3)
        element2.before(element5)
        element2.after(element6)
        @Assert(element1.childrenSize(), 5)

        println("Pass203")
    }
}

class TestNodeVisitor <: NodeVisitor {
    var counter: ArrayList<Int64>

    public init(counter: ArrayList<Int64>) {
        this.counter = counter
    }
    public override func head(node: Node, depth: Int64): Unit {
        (node, depth)
        counter.append(0)
    }

    public override func tail(node: Node, depth: Int64): Unit {
        (node, depth)
    }
}

class Test1NodeVisitor <: NodeVisitor {
    var counter: ArrayList<Int64>

    public init(counter: ArrayList<Int64>) {
        this.counter = counter
    }

    public override func head(node: Node, depth: Int64): Unit {
        (node, depth)
        counter.append(0)
    }
}

class Test2NodeVisitor <: NodeFilter {
    public override func head(node: Node, depth: Int64): FilterResult {
        (node, depth)
        return FilterResult.CONTINUE
    }

    public override func tail(node: Node, depth: Int64): FilterResult {
        (node, depth)
        return FilterResult.CONTINUE
    }
}

class Test3NodeVisitor <: NodeFilter {
    public override func head(node: Node, depth: Int64): FilterResult {
        (depth)
        node.attr("id")==("2")
        return if (node.attr("id")==("2")) {
            return FilterResult.REMOVE
        } else {
            return FilterResult.CONTINUE
        }
    }
}
