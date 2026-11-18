// RESOURCES: htmltests/large.html
// RESOURCES: htmltests/test-rss.xml
// EXEC: cjc %import-path %L %l %f -g
// EXEC: ./main
import cangjie_tpc::html4cj.*
import std.collection.ArrayList
import std.unittest.*
import std.unittest.testmacro.*
import std.fs.*

main(): Int64 {
    let srcRangeTest: SrcRangeTest = SrcRangeTest()
    
    srcRangeTest.initTest()

    let tester = PositionTest()

    tester.parserTrackDefaults()
    tester.tracksPosition()
    tester.tracksMarkup()
    tester.tracksDataNodes()
    tester.tracksXml()

    tester.tracksFromFetch()
    tester.tracksFromXmlFetch()
    tester.initTest()
    tester.posTest()
    tester.lineNumberTest()

    tester.columnNumberTest()
    tester.isTrackedTest()

    return 0
}

@Test
public class SrcRangeTest {
    @TestCase
    public func initTest(): Unit {
        // 1
        var srcPosition: SrcPosition = SrcPosition(10, 1, 1)
        var srcPosition1: SrcPosition = SrcPosition(20, 2, 2)
        var srcRange: SrcRange = SrcRange(srcPosition, srcPosition1)
        println(srcRange.hashCode())
        @Assert(srcRange.start(), srcPosition)
        @Assert(srcRange.end(), srcPosition1)
        @Assert(srcRange.isTracked(), true)
        @Assert(srcRange.toString(), "1,1:10-2,2:20")
        @Assert(srcRange != srcRange, false)
        @Assert(srcRange == srcRange, true)
        var attributes: Attributes = Attributes()
        attributes.put("data-id", "1")
        attributes.put("data-class", "html")
        let p1: Tag = Tag.valueOf("P")
        var element: Element = Element(p1, "", attributes)
        srcRange.track(element, false)

        println("Pass1")
    }
}

/*
 * Functional tests for the Position tracking behavior (across nodes, treebuilder, etc.)
 */
@Test
public class PositionTest {
    let TrackingParser: Parser = Parser.htmlParser().setTrackPosition(true)

    @TestCase
    func parserTrackDefaults(): Unit {
        // 1 
        let htmlParser: Parser = Parser.htmlParser()
        @Assert(!htmlParser.isTrackPosition())
        htmlParser.setTrackPosition(true)
        @Assert(htmlParser.isTrackPosition())
        let xmlParser: Parser = Parser.htmlParser()
        @Assert(!xmlParser.isTrackPosition())
        xmlParser.setTrackPosition(true)
        @Assert(xmlParser.isTrackPosition())

        println("Pass1")
    }

    @TestCase
    func tracksPosition(): Unit {
        // 2
        let html: String = "<p id=1\n class=foo>\n<span>Hello\n &reg;\n there &copy.</span> now.\n <!-- comment --> "
        let doc: Document = Html4cj.parse(html, TrackingParser)
        let body: Element = doc.expectFirst("body")
        let p: Element = doc.expectFirst("p")
        let span: Element = doc.expectFirst("span")
        let text: TextNode = (span.firstChild().getOrThrow() as TextNode).getOrThrow()
        let now: TextNode = (span.nextSibling().getOrThrow() as TextNode).getOrThrow()
        let comment: Comment = (now.nextSibling().getOrThrow() as Comment).getOrThrow()
        @Assert(body.sourceRange().isTracked(), false)
        let pRange: SrcRange = p.sourceRange()
        @Assert("1,1:0-2,12:19", pRange.toString())

        // no explicit P closer
        let pEndRange: SrcRange = p.endSourceRange()
        @Assert(!pEndRange.isTracked())
        let pStart: SrcPosition = pRange.start()
        @Assert(pStart.isTracked())
        @Assert(0, pStart.pos())
        @Assert(1, pStart.columnNumber())
        @Assert(1, pStart.lineNumber())
        @Assert("1,1:0", pStart.toString())
        let pEnd: SrcPosition = pRange.end()
        @Assert(pStart.isTracked())
        @Assert(19, pEnd.pos())
        @Assert(12, pEnd.columnNumber())
        @Assert(2, pEnd.lineNumber())
        @Assert("2,12:19", pEnd.toString())
        @Assert("3,1:20", span.sourceRange().start().toString())
        @Assert("3,7:26", span.sourceRange().end().toString())

        // span end tag
        let spanEnd: SrcRange = span.endSourceRange()
        @Assert(spanEnd.isTracked())
        @Assert("5,14:52-5,21:59", spanEnd.toString())
        let wholeText: String = text.getWholeText()
        @Assert("Hello\n ®\n there ©.", wholeText)
        let textOrig: String = "Hello\n &reg;\n there &copy."
        let textRange: SrcRange = text.sourceRange()
        @Assert(textRange.end().pos() -  textRange.start().pos(), textOrig.size)
        @Assert("3,7:26", textRange.start().toString())
        @Assert("5,14:52", textRange.end().toString())
        @Assert("6,2:66", comment.sourceRange().start().toString())
        @Assert("6,18:82", comment.sourceRange().end().toString())

        println("Pass2")
    }

    @TestCase
    func tracksMarkup(): Unit {
        // 3
        let html: String = "<!doctype\nhtml>\n<title>jsoup &copy;\n2022</title><body>\n<![CDATA[\n<jsoup>\n]]>"
        let doc: Document = Html4cj.parse(html, TrackingParser)
        let doctype: DocumentType = doc.documentType().getOrThrow()
        @Assert("html", doctype.name())
        @Assert("1,1:0-2,6:15", doctype.sourceRange().toString())
        let title: Element = doc.expectFirst("title")
        let titleText: TextNode = (title.firstChild().getOrThrow() as TextNode).getOrThrow()
        @Assert("jsoup ©\n2022", title.text())
        @Assert(titleText.getWholeText(), title.text())
        @Assert("3,1:16-3,8:23", title.sourceRange().toString())
        @Assert("3,8:23-4,5:40", titleText.sourceRange().toString())
        let cdata: CDataNode = (doc.body().childNode(1) as CDataNode).getOrThrow()
        @Assert("\n<jsoup>\n", cdata.text())
        @Assert("5,1:55-7,4:76", cdata.sourceRange().toString())

        println("Pass3")
    }

    @TestCase
    public func tracksDataNodes(): Unit {
        // 4
        let html: String = "<head>\n<script>foo;\nbar()\n5 <= 4;</script>"
        let doc: Document = Html4cj.parse(html, TrackingParser)
        let script: Element = doc.expectFirst("script")
        @Assert("2,1:7-2,9:15", script.sourceRange().toString())
        let data: DataNode = (script.firstChild().getOrThrow() as DataNode).getOrThrow()
        @Assert("2,9:15-4,8:33", data.sourceRange().toString())

        println("Pass4")
    }

    @TestCase
    func tracksXml(): Unit {
        // 5
        let xml: String =
            "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n<!doctype html>\n<rss url=foo>\nXML\n</rss>\n<!-- comment -->"
        let doc: Document = Html4cj.parse(xml, Parser.xmlParser().setTrackPosition(true))
        let decl: XmlDeclaration = (doc.childNode(0) as XmlDeclaration).getOrThrow()
        @Assert("1,1:0-1,39:38", decl.sourceRange().toString())
        let doctype: DocumentType = (doc.childNode(2) as DocumentType).getOrThrow()
        @Assert("2,1:39-2,16:54", doctype.sourceRange().toString())
        let rss: Element = doc.firstElementChild().getOrThrow()
        @Assert("3,1:55-3,14:68", rss.sourceRange().toString())
        @Assert("5,1:73-5,7:79", rss.endSourceRange().toString())
        let text: TextNode = (rss.firstChild().getOrThrow() as TextNode).getOrThrow()
        @Assert("3,14:68-5,1:73", text.sourceRange().toString())
        let comment: Comment = (rss.nextSibling().getOrThrow().nextSibling().getOrThrow() as Comment).getOrThrow()
        @Assert("6,1:80-6,17:96", comment.sourceRange().toString())

        println("Pass5")
    }

    @TestCase
    func tracksFromFetch(): Unit {
        // 6
        let inFile = File.readFrom("large.html")
        let content = String.fromUtf8(inFile).replace("\r\n","\n")
        let doc = Parser.htmlParser().setTrackPosition(true).parseInput(content, "")
        let firstP: Element = doc.expectFirst("p")
        println("6.1 ${firstP.sourceRange()}")
        @Assert("4,1:53-4,4:56", firstP.sourceRange().toString())
        let p: Element = doc.expectFirst("#xy")
        @Assert("1000,1:279646-1000,10:279655", p.sourceRange().toString())
        @Assert("1000,567:280212-1000,571:280216", p.endSourceRange().toString())
        let text: TextNode = (p.firstChild().getOrThrow() as TextNode).getOrThrow()
        @Assert("1000,10:279655-1000,357:280002", text.sourceRange().toString())

        println("Pass6")
    }

    @TestCase
    func tracksFromXmlFetch(): Unit {
        // 7
        let content: String = String.fromUtf8(File.readFrom("test-rss.xml")).replace("\r\n","\n")
        let doc: Document = Html4cj.parse(content, Parser.xmlParser().setTrackPosition(true))
        let item: Element = doc.expectFirst("item + item")
        @Assert("13,5:496-13,11:502", item.sourceRange().toString())
        @Assert("17,5:779-17,12:786", item.endSourceRange().toString())

        println("Pass7")
    }

    @TestCase
    public func initTest(): Unit {
        // 8
        var srcPosition: SrcPosition = SrcPosition(10, 1, 1)
        var srcPosition1: SrcPosition = SrcPosition(20, 2, 2)
        @Assert(srcPosition != srcPosition1, true)

        println("Pass8")
    }

    @TestCase
    public func posTest(): Unit {
        // 9
        var srcPosition: SrcPosition = SrcPosition(10, 1, 1)
        @Assert(srcPosition.pos(), 10)

        println("Pass9")
    }

    @TestCase
    public func lineNumberTest(): Unit {
        // 10
        var srcPosition: SrcPosition = SrcPosition(10, 1, 1)
        @Assert(srcPosition.lineNumber(),1)

        println("Pass10")
    }

    @TestCase
    public func columnNumberTest(): Unit {
        // 11
        var srcPosition: SrcPosition = SrcPosition(10, 1, 1)
        @Assert(srcPosition.columnNumber(),1)

        println("Pass11")
    }

    @TestCase
    public func isTrackedTest(): Unit {
        // 12
        var srcPosition: SrcPosition = SrcPosition(10, 1, 1)
        @Assert(srcPosition.isTracked(), true)

        println("Pass12")
    }
}
