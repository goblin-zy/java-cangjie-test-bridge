// DEPENDENCE: text_util_test.cj
// EXEC: cjc %import-path %L %l %f text_util_test.cj -g
// EXEC: ./main
import cangjie_tpc::html4cj.*
import std.collection.ArrayList
import std.unittest.*
import std.unittest.testmacro.*

main(): Int64 {
    let tester = TextNodeTest()

    tester.testBlank()
    tester.testTextBean()
    tester.testSplitText()
    tester.testSplitAnEmbolden()
    tester.testSplitTextValidation()

    tester.testWithSupplementaryCharacter()
    tester.testLeadNodesHaveNoChildren()
    tester.testSpaceNormalise()
    tester.testClone()
    tester.testCloneAfterAttributesHit()

    tester.testHasTextWhenIterating()
    tester.createFromEncoded()
    tester.leafNodeAttributes()
    tester.initTest()

    return 0
}

/*
 * Test TextNodes
 */
@Test
public class TextNodeTest {
    @TestCase
    public func testBlank(): Unit {
        // 1
        let one: TextNode = TextNode("")
        let two: TextNode = TextNode("     ")
        let three: TextNode = TextNode("  \n\n   ")
        let four: TextNode = TextNode("Hello")
        let five: TextNode = TextNode("  \nHello ")
        @Assert(one.isBlank())
        @Assert(two.isBlank())
        @Assert(three.isBlank())
        @Assert(false, four.isBlank())
        @Assert(false, five.isBlank())

        println("Pass1")
    }

    @TestCase
    public func testTextBean(): Unit {
        // 2
        let doc: Document = Html4cj.parse("<p>One <span>two &amp;</span> three &amp;</p>")
        let p: Element = doc.select("p").first().getOrThrow()
        let span: Element = doc.select("span").first().getOrThrow()
        @Assert("two &", span.text())
        let spanText: TextNode = (span.childNode(0) as TextNode).getOrThrow()
        @Assert("two &", spanText.text())
        let tn: TextNode = (p.childNode(2) as TextNode).getOrThrow()
        @Assert(" three &", tn.text())
        tn.text(" POW!")
        @Assert("One <span>two &amp;</span> POW!", TextUtil.stripNewlines(p.html()))
        tn.attr(tn.nodeName(), "kablam &")
        @Assert("kablam &", tn.text())
        @Assert("One <span>two &amp;</span>kablam &amp;", TextUtil.stripNewlines(p.html()))

        println("Pass2")
    }

    @TestCase
    public func testSplitText(): Unit {
        // 3
        let doc: Document = Html4cj.parse("<div>Hello there</div>")
        let div: Element = doc.select("div").first().getOrThrow()
        let tn: TextNode = (div.childNode(0) as TextNode).getOrThrow()
        let tail: TextNode = tn.splitText(6)
        @Assert("Hello ", tn.getWholeText())
        @Assert("there", tail.getWholeText())
        tail.text("there!")
        @Assert("Hello there!", div.text())
        @Assert(refEq(tn.parent().getOrThrow(), tail.parent().getOrThrow()))

        println("Pass3")
    }

    @TestCase
    public func testSplitAnEmbolden(): Unit {
        // 4
        let doc: Document = Html4cj.parse("<div>Hello there</div>")
        let div: Element = doc.select("div").first().getOrThrow()
        let tn: TextNode = (div.childNode(0) as TextNode).getOrThrow()
        let tail: TextNode = tn.splitText(6)
        tail.wrap("<b></b>")

        // not great that we get \n<b>there there... must correct
        @Assert("Hello <b>there</b>", TextUtil.stripNewlines(div.html()))

        println("Pass4")
    }

    @TestCase
    func testSplitTextValidation(): Unit {
        // 5
        let doc: Document = Html4cj.parse("<div>Hello there</div>")
        let div: Element = doc.expectFirst("div")
        let tn: TextNode = (div.childNode(0) as TextNode).getOrThrow()
        try {
            tn.splitText(-5)
            throw Exception()
        } catch (e: ValidationException) {
            @Assert("Split offset must be not be negative", e.message)
        }
        try {
            tn.splitText(500)
            throw Exception()
        } catch (e: ValidationException) {
            @Assert("Split offset must not be greater than current text length", e.message)
        }

        println("Pass5")
    }

    @TestCase
    public func testWithSupplementaryCharacter(): Unit {
        // 6
        let doc: Document = Html4cj.parse('\u{210C1}'.toString())
        let t: TextNode = doc.body().textNodes()[0]
        @Assert('\u{210C1}'.toString(), t.outerHtml().trimAscii())

        println("Pass6")
    }

    @TestCase
    public func testLeadNodesHaveNoChildren(): Unit {
        // 7
        let doc: Document = Html4cj.parse("<div>Hello there</div>")
        let div: Element = doc.select("div").first().getOrThrow()
        let tn: TextNode = (div.childNode(0) as TextNode).getOrThrow()
        let nodes: ArrayList<Node> = tn.childNodes()
        @Assert(0, nodes.size)

        println("Pass7")
    }

    @TestCase
    public func testSpaceNormalise(): Unit {
        // 8
        // https://github.com/jhy/jsoup/issues/1309
        let whole: String = "Two  spaces"
        let norm: String = "Two spaces"

        // there are 2 spaces between the words
        let tn: TextNode = TextNode(whole)
        @Assert(whole, tn.getWholeText())
        @Assert(norm, tn.text())
        @Assert(norm, tn.outerHtml())
        @Assert(norm, tn.toString())
        let el: Element = Element("p")

        // this used to change the context
        el.appendChild(tn)

        // set any parent 
        @Assert(whole, tn.getWholeText())
        @Assert(norm, tn.text())
        @Assert(norm, tn.outerHtml())
        @Assert(norm, tn.toString())
        @Assert("<p>" + norm + "</p>", el.outerHtml())
        @Assert(norm, el.html())
        @Assert(whole, el.wholeText())

        println("Pass8")
    }

    @TestCase
    public func testClone(): Unit {
        // 9
        // https://github.com/jhy/jsoup/issues/1176
        let x: TextNode = TextNode("zzz")
        let y: TextNode = x.clone()
        @Assert(false, refEq(x, y))
        @Assert(x.outerHtml(), y.outerHtml())
        y.text("yyy")
        @Assert(x.outerHtml() != y.outerHtml())
        @Assert("zzz", x.text())

        // already cloned so no impact
        x.attributes()
        y.text("xxx")
        @Assert("zzz", x.text())
        @Assert("xxx", y.text())

        println("Pass9")
    }

    @TestCase
    public func testCloneAfterAttributesHit(): Unit {
        // 10
        // https://github.com/jhy/jsoup/issues/1176
        let x: TextNode = TextNode("zzz")

        // moves content from leafnode value to attributes, which were missed in clone
        x.attributes()
        let y: TextNode = x.clone()
        y.text("xxx")
        @Assert("zzz", x.text())
        @Assert("xxx", y.text())

        println("Pass10")
    }

    @TestCase
    public func testHasTextWhenIterating(): Unit {
        // 11
        // https://github.com/jhy/jsoup/issues/1170
        let doc: Document = Html4cj.parse("<div>One <p>Two <p>Three")
        var foundFirst: Bool = false
        for (el in doc.getAllElements()) {
            for (node in el.childNodes()) {
                if (node is TextNode) {
                    let textNode: TextNode = (node as TextNode).getOrThrow()
                    if (!foundFirst) {
                        foundFirst = true
                        @Assert("One ", textNode.text())
                        @Assert("One ", textNode.getWholeText())
                    }
                }
            }
        }
        @Assert(foundFirst)

        println("Pass11")
    }

    @TestCase
    func createFromEncoded(): Unit {
        // 12
        let tn: TextNode = TextNode.createFromEncoded("&lt;One&gt;")
        @Assert("<One>", tn.text())

        println("Pass12")
    }

    // Lead Node tests
    @TestCase
    func leafNodeAttributes(): Unit {
        // 13
        let t: TextNode = TextNode("First")

        // will hit the !hasAttributes flow
        t.attr(t.nodeName(), "One")
        @Assert("One", t.attr(t.nodeName()))
        let attr: Attributes = t.attributes()

        // vivifies 'One' as an attribute
        @Assert(1, attr.asList().size)
        @Assert("One", attr.get(t.nodeName()))

        // arbitrary attributes
        @Assert(false, t.hasAttr("foo"))
        t.attr("foo", "bar")
        @Assert(t.hasAttr("foo"))
        t.removeAttr("foo")
        @Assert(false, t.hasAttr("foo"))
        @Assert("", t.baseUri())
        t.attr("href", "/foo.html")

        // cannot abs
        @Assert("", t.absUrl("href"))
        let p: Element = Element("p")
        p.appendChild(t)
        @Assert(0, t.childNodeSize())
        @Assert(refEq(t, t.empty()))
        let clone: TextNode = t.clone()
        @Assert(t.hasSameValue(clone))
        @Assert("/foo.html", clone.attr("href"))

        println("Pass13")
    }

    @TestCase
    public func initTest(): Unit {
        // 14
        var textNode1: TextNode = TextNode("这是一个文本")
        @Assert(textNode1.nodeName(), "#text")
        @Assert(textNode1.text(), "这是一个文本")
        textNode1.text("新文本")
        @Assert(textNode1.text(), "新文本")
        @Assert(textNode1.isBlank(), false)
        @Assert(textNode1.getWholeText(), "新文本")
        @Assert(textNode1.toString(), "新文本")
        textNode1.text("")
        @Assert(textNode1.isBlank(), true)
        textNode1.text("this is text")
        var textNode2: TextNode = textNode1.splitText(4)
        @Assert(textNode1.text(), "this")
        @Assert(textNode2.text(), " is text")
        var textNode3: TextNode = textNode1.clone()
        @Assert(textNode1 == textNode3, false)
        @Assert(refEq(textNode1, textNode3), false)
        var textNode4: TextNode = TextNode.createFromEncoded("textNode")
        @Assert(textNode4.text(), "textNode")

        println("Pass14")
    }
}
