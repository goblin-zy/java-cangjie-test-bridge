package cangjie_tpc::html4cj

@Test
public class TokeniserTest {
    let maxBufferLen = CharacterReader.maxBufferLen
    @TestCase
    public func bufferUpInAttributeVal(): Unit {
        // check each double, singlem, unquoted impls
        let quotes: Array<String> = ["\"", "'", ""]
        for (quot in quotes) {
            let preamble: String = "<img src=" + quot
            let tail: String = "bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb"
            let sb: StringBuilder = StringBuilder(preamble)

            let charsToFillBuffer: Int64 = maxBufferLen - preamble.size
            for (i in 0..charsToFillBuffer) {
                i
                sb.append(r'a')
            }

            sb.append(r'X')

            // First character to cross character buffer boundary
            sb.append(tail)
            sb.append(quot)
            sb.append(">\n")

            let html: String = sb.toString()
            let doc: Document = Html4cj.parse(html)
            let src: String = doc.select("img").attr("src")

            @Assert(src.contains("X"))
            @Assert(src.contains(tail))
        }
    }

    @TestCase
    public func handleSuperLargeTagNames(): Unit {
        // unlikely, but valid. so who knows.
        let sb: StringBuilder = StringBuilder()
        do {
            sb.append("LargeTagName")
        } while (sb.size < maxBufferLen)
        let tag: String = sb.toString()
        let html: String = "<" + tag + ">One</" + tag + ">"

        let doc: Document = Parser.htmlParser().settings(ParseSettings.preserveCase).parseInput(html, "")
        let els: Elements = doc.select(tag)
        @Assert(1, els.elementArr.size)
        let el: Element = els.first().getOrThrow()

        // assertNotNull(el)
        @Assert("One", el.text())
        @Assert(tag, el.tagName())
    }

    @TestCase
    public func handleSuperLargeAttributeName(): Unit {
        let sb: StringBuilder = StringBuilder()
        do {
            sb.append("LargAttributeName")
        } while (sb.size < maxBufferLen)
        let attrName: String = sb.toString()
        let html: String = "<p " + attrName + "=foo>One</p>"

        let doc: Document = Html4cj.parse(html)
        let els: Elements = doc.getElementsByAttribute(attrName)
        @Assert(1, els.elementArr.size)
        let el: Element = els.first().getOrThrow()

        // assertNotNull(el)
        @Assert("One", el.text())
        let attribute: Attribute = el.attributes().asList()[0]
        @Assert(attrName.toAsciiLower(), attribute.getKey())
        @Assert("foo", attribute.getValue())
    }

    @TestCase
    public func handleLargeText(): Unit {
        let sb: StringBuilder = StringBuilder()
        do {
            sb.append("A Large Amount of Text")
        } while (sb.size < maxBufferLen)
        let text: String = sb.toString()
        let html: String = "<p>" + text + "</p>"

        let doc: Document = Html4cj.parse(html)
        let els: Elements = doc.select("p")
        @Assert(1, els.elementArr.size)
        let el: Element = els.first().getOrThrow()

        // assertNotNull(el)
        @Assert(text, el.text())
    }

    @TestCase
    public func handleLargeComment(): Unit {
        let sb: StringBuilder = StringBuilder()
        do {
            sb.append("Quite a comment ")
        } while (sb.size < maxBufferLen)
        let comment: String = sb.toString()
        let html: String = "<p><!-- " + comment + " --></p>"

        let doc: Document = Html4cj.parse(html)
        let els: Elements = doc.select("p")
        @Assert(1, els.elementArr.size)
        let el: Element = els.first().getOrThrow()

        // assertNotNull(el)
        let child: Comment = (el.childNode(0) as Comment).getOrThrow()
        @Assert(" " + comment + " ", child.getData())
    }

    @TestCase
    public func handleLargeCdata(): Unit {
        let sb: StringBuilder = StringBuilder()
        do {
            sb.append("Quite a lot of CDATA <><><><>")
        } while (sb.size < maxBufferLen)
        let cdata: String = sb.toString()
        let html: String = "<p><![CDATA[" + cdata + "]]></p>"

        let doc: Document = Html4cj.parse(html)
        let els: Elements = doc.select("p")
        @Assert(1, els.elementArr.size)
        let el: Element = els.first().getOrThrow()

        // assertNotNull(el)
        let child: TextNode = (el.childNode(0) as TextNode).getOrThrow()
        @Assert(cdata, el.text())
        @Assert(cdata, child.getWholeText())
    }

    @TestCase
    public func handleLargeTitle(): Unit {
        let sb: StringBuilder = StringBuilder()
        do {
            sb.append("Quite a long title")
        } while (sb.size < maxBufferLen)
        let title: String = sb.toString()
        let html: String = "<title>" + title + "</title>"

        let doc: Document = Html4cj.parse(html)
        let els: Elements = doc.select("title")
        @Assert(1, els.elementArr.size)
        let el: Element = els.first().getOrThrow()

        // assertNotNull(el)
        let child: TextNode = (el.childNode(0) as TextNode).getOrThrow()
        @Assert(title, el.text())
        @Assert(title, child.getWholeText())
        @Assert(title, doc.title())
    }

    @TestCase
    public func cp1252Entities(): Unit {
        println(Html4cj.parse("&#0128;").text())
        println(Html4cj.parse("&#0130;").text())
        println(Html4cj.parse("&#x80;").text())
        @Assert("\u{20ac}", Html4cj.parse("&#0128;").text())
        @Assert("\u{201a}", Html4cj.parse("&#0130;").text())
        @Assert("\u{20ac}", Html4cj.parse("&#x80;").text())
    }

    @TestCase
    public func cp1252EntitiesProduceError(): Unit {
        let parser: Parser = Parser(HtmlTreeBuilder())
        parser.setTrackErrors(10)
        @Assert("\u{20ac}", parser.parseInput("<html><body>&#0128;</body></html>", "").text())
        @Assert(1, parser.getErrors().size)
    }

    @TestCase
    public func cp1252SubstitutionTable(): Unit {
        // for (i in 0..Tokeniser.win1252Extensions.length) {
        //     let s:Rune = Rune.parse(i + Tokeniser.win1252ExtensionsStart), Charset.forName("Windows-1252"))
        //     @Assert(1, Rune.utf8Size(s))
        
        //     // some of these characters are illegal
        //     if (s == '\u{fffd}') { continue }
        
        //     @Assert(s, Tokeniser.win1252Extensions[i])
        // }
    }

    @TestCase
    public func canParseVeryLongBogusComment(): Unit {
        let commentData: StringBuilder = StringBuilder()
        do {
            commentData.append("blah blah blah blah ")
        } while (commentData.size < maxBufferLen)
        let expectedCommentData: String = commentData.toString()
        let testMarkup: String = "<html><body><!" + expectedCommentData + "></body></html>"
        let parser: Parser = Parser(HtmlTreeBuilder())

        let doc: Document = parser.parseInput(testMarkup, "")

        let commentNode: Node = doc.body().childNode(0)
        @Assert(commentNode is Comment)
        @Assert(expectedCommentData, (commentNode as Comment).getOrThrow().getData())
    }

    @TestCase
    public func canParseCdataEndingAtEdgeOfBuffer(): Unit {
        let cdataStart: String = "<![CDATA["
        let cdataEnd: String = "]]>"
        let bufLen: Int64 = maxBufferLen - cdataStart.size - 1 // also breaks with -2, but not with -3 or 0
        let cdataContentsArray: Array<Rune> = Array<Rune>(bufLen, repeat: r'x')
        let cdataContents: String = String(cdataContentsArray)
        let testMarkup: String = cdataStart + cdataContents + cdataEnd
        let parser: Parser = Parser(HtmlTreeBuilder())

        let doc: Document = parser.parseInput(testMarkup, "")

        let cdataNode: Node = doc.body().childNode(0)
        @Assert(cdataNode is CDataNode)
        @Assert(cdataContents, (cdataNode as CDataNode).getOrThrow().text())
    }
}
