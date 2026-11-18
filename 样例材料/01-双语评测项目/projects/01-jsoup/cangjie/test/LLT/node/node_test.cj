// DEPENDENCE: text_util_test.cj
// EXEC: cjc %import-path %L %l %f text_util_test.cj -g
// EXEC: ./main
import cangjie_tpc::html4cj.*
import std.collection.ArrayList
import std.unittest.*
import std.unittest.testmacro.*

main(): Int64 {
    let nodeTest: NodeTest = NodeTest()

    nodeTest.handlesBaseUri()
    nodeTest.setBaseUriIsRecursive()
    nodeTest.handlesAbsPrefix()
    nodeTest.handlesAbsOnImage()
    nodeTest.handlesAbsPrefixOnHasAttr()

    nodeTest.literalAbsPrefix()
    nodeTest.handleAbsOnFileUris()
    nodeTest.handleAbsOnLocalhostFileUris()
    nodeTest.handlesAbsOnProtocolessAbsoluteUris()
    nodeTest.absHandlesRelativeQuery()

    nodeTest.absHandlesDotFromIndex()
    nodeTest.handlesAbsOnUnknownProtocols()
    nodeTest.testRemove()
    nodeTest.testReplace()
    nodeTest.ownerDocument()

    nodeTest.rootTest()
    nodeTest.beforeTest()
    nodeTest.afterTest()
    nodeTest.unwrap()
    nodeTest.unwrapNoChildren()

    nodeTest.traverse()
    nodeTest.orphanNodeReturnsNullForSiblingElements()
    nodeTest.nodeIsNotASiblingOfItself()
    nodeTest.childNodesCopy()
    nodeTest.supportsClone()

    nodeTest.changingAttributeValueShouldReplaceExistingAttributeCaseInsensitive()
    nodeTest.clonedNodesHaveOwnerDocsAndIndependentSettings()
    nodeTest.firstAndLastChild()
    nodeTest.nodeName()

    return 0
}

@Test
public class NodeTest {
    @TestCase
    public func handlesBaseUri(): Unit {
        // 1 
        var tag: Tag = Tag.valueOf("a")
        var attribs: Attributes = Attributes()
        attribs.put("relHref", "/foo")
        attribs.put("absHref", "http://bar/qux")
        var noBase: Element = Element(tag, "", attribs)

        // with no base, should NOT fallback to href attrib, whatever it is
        @Assert("", noBase.absUrl("relHref"))
        
        // no base but valid attrib, return attrib
        @Assert("http://bar/qux", noBase.absUrl("absHref"))
        var withBase: Element = Element(tag, "http://foo/", attribs)

        // construct abs from base + rel
        @Assert("http://foo/foo", withBase.absUrl("relHref"))

        // href is abs, so returns that
        @Assert("http://bar/qux", withBase.absUrl("absHref"))
        @Assert("", withBase.absUrl("noval"))
        var dodgyBase: Element = Element(tag, "wtf://no-such-protocol/", attribs)

        // base fails, but href good, so get that
        @Assert("http://bar/qux", dodgyBase.absUrl("absHref"))

        println("Pass1")
    }

    @TestCase
    public func setBaseUriIsRecursive(): Unit {
        // 2 
        var doc: Document = Html4cj.parse("<div><p></p></div>")
        var baseUri: String = "https://jsoup.org"
        doc.setBaseUri(baseUri)
        @Assert(baseUri, doc.baseUri())
        @Assert(baseUri, doc.select("div").first().getOrThrow().baseUri())
        @Assert(baseUri, doc.select("p").first().getOrThrow().baseUri())

        println("Pass2")
    }

    @TestCase
    public func handlesAbsPrefix(): Unit {
        // 3 
        var doc: Document = Html4cj.parse("<a href=/foo>Hello</a>", "https://jsoup.org/")
        var a: Element = doc.select("a").first().getOrThrow()
        @Assert("/foo", a.attr("href"))
        @Assert("https://jsoup.org/foo", a.attr("abs:href"))
        @Assert(a.hasAttr("abs:href"), true)

        println("Pass3")
    }

    @TestCase
    public func handlesAbsOnImage(): Unit {
        // 4 
        var doc: Document = Html4cj.parse("<p><img src=\"/rez/osi_logo.png\" /></p>", "https://jsoup.org/")
        var img: Element = doc.select("img").first().getOrThrow()
        @Assert("https://jsoup.org/rez/osi_logo.png", img.attr("abs:src"))
        @Assert(img.absUrl("src"), img.attr("abs:src"))

        println("Pass4")
    }

    @TestCase
    public func handlesAbsPrefixOnHasAttr(): Unit {
        // 5 
        // 1: no abs url; 2: has abs url
        var doc: Document = Html4cj.parse("<a id=1 href='/foo'>One</a> <a id=2 href='https://jsoup.org/'>Two</a>")
        var one: Element = doc.select("#1").first().getOrThrow()
        var two: Element = doc.select("#2").first().getOrThrow()

        @Assert(one.hasAttr("abs:href"), false)
        @Assert(one.hasAttr("href"), true)
        @Assert("", one.absUrl("href"))
        @Assert(two.hasAttr("abs:href"), true)
        @Assert(two.hasAttr("href"), true)
        @Assert("https://jsoup.org/", two.absUrl("href"))

        println("Pass5")
    }

    @TestCase
    public func literalAbsPrefix(): Unit {
        // 6 
        // if there is a literal attribute "abs:xxx", don't try and make absolute.
        var doc: Document = Html4cj.parse("<a abs:href='odd'>One</a>")
        var el: Element = doc.select("a").first().getOrThrow()
        @Assert(el.hasAttr("abs:href"),true)
        @Assert("odd", el.attr("abs:href"))

        println("Pass6")
    }

    @TestCase
    public func handleAbsOnFileUris(): Unit {
        // 7
        var doc: Document = Html4cj.parse("<a href='password'>One/a><a href='/var/log/messages'>Two</a>", "file:/etc/")
        doc.select("a").first().getOrThrow()
        doc.select("a").elementArr[1]

        println("Pass7")
    }

    @TestCase
    public func handleAbsOnLocalhostFileUris(): Unit {
        // 8
        var doc: Document = Html4cj.parse(
            "<a href='password'>One/a><a href='/var/log/messages'>Two</a>",
            "file://localhost/etc/"
        )
        var one: Element = doc.select("a").first().getOrThrow()
        @Assert("file://localhost/etc/password", one.absUrl("href"))

        println("Pass8")
    }

    @TestCase
    public func handlesAbsOnProtocolessAbsoluteUris(): Unit {
        // 9 
        var doc1: Document = Html4cj.parse("<a href='//example.net/foo'>One</a>", "http://example.com/")
        var doc2: Document = Html4cj.parse("<a href='//example.net/foo'>One</a>", "https://example.com/")
        var one: Element = doc1.select("a").first().getOrThrow()
        var two: Element = doc2.select("a").first().getOrThrow()
        @Assert("http://example.net/foo", one.absUrl("href"))
        @Assert("https://example.net/foo", two.absUrl("href"))
        var doc3: Document = Html4cj.parse(
            "<img src=//www.google.com/images/errors/logo_sm.gif alt=Google>",
            "https://google.com"
        )
        @Assert("https://www.google.com/images/errors/logo_sm.gif", doc3.select("img").attr("abs:src"))

        println("Pass9")
    }

    @TestCase
    public func absHandlesRelativeQuery(): Unit {
        // 10 
        var doc: Document = Html4cj.parse(
            "<a href='?foo'>One</a> <a href='bar.html?foo'>Two</a>",
            "https://jsoup.org/path/file?bar"
        )
        var a1: Element = doc.select("a").first().getOrThrow()
        @Assert("https://jsoup.org/path/file?foo", a1.absUrl("href"))
        var a2: Element = doc.select("a").elementArr[1]
        @Assert("https://jsoup.org/path/bar.html?foo", a2.absUrl("href"))

        println("Pass10")
    }

    @TestCase
    public func absHandlesDotFromIndex(): Unit {
        // 11
        var doc: Document = Html4cj.parse("<a href='./one/two.html'>One</a>", "http://example.com")
        var a1: Element = doc.select("a").first().getOrThrow()
        @Assert("http://example.com/one/two.html", a1.absUrl("href"))

        println("Pass11")
    }

    @TestCase
    public func handlesAbsOnUnknownProtocols(): Unit {
        // 12
        // https://github.com/jhy/jsoup/issues/1610
        // URL would throw on unknown protocol tel: as no stream handler is registered
        // mail has a handler, tel doesn't
        var urls: Array<String> = ["mailto:example@example.com", "tel:867-5309"]
        for (url in urls) {
            var attr: Attributes = Attributes().put("href", url)
            var noBase: Element = Element(Tag.valueOf("a"), None, attr)
            @Assert(url, noBase.absUrl("href"))
            var withBase: Element = Element(Tag.valueOf("a"), "http://example.com/", attr)
            @Assert(url, withBase.absUrl("href"))
        }

        println("Pass12")
    }

    @TestCase
    public func testRemove(): Unit {
        // 13
        var doc: Document = Html4cj.parse("<p>One <span>two</span> three</p>")
        var p: Element = doc.select("p").first().getOrThrow()
        p.childNode(0).remove()
        @Assert("two three", p.text())
        @Assert("<span>two</span> three", TextUtil.stripNewlines(p.html()))

        println("Pass13")
    }

    @TestCase
    public func testReplace(): Unit {
        // 14 
        var doc: Document = Html4cj.parse("<p>One <span>two</span> three</p>")
        var p: Element = doc.select("p").first().getOrThrow()
        var insert: Element = doc.createElement("em").text("foo")
        p.childNode(1).replaceWith(insert)
        @Assert("One <em>foo</em> three", p.html())

        println("Pass14")
    }

    @TestCase
    public func ownerDocument(): Unit {
        // 15 
        var doc: Document = Html4cj.parse("<p>Hello")
        var p: Element = doc.select("p").first().getOrThrow()
        @Assert(refEq(p.ownerDocument().getOrThrow(), doc), true)
        @Assert(refEq(doc.ownerDocument().getOrThrow(), doc), true)
        @Assert(doc.parent(), None)

        println("Pass15")
    }

    @TestCase
    public func rootTest(): Unit {
        // 16 
        var doc: Document = Html4cj.parse("<div><p>Hello")
        var p: Element = doc.select("p").first().getOrThrow()
        var root: Node = p.root()
        @Assert(refEq(doc, root), true)
        @Assert(root.parent(), None)
        @Assert(refEq(doc.root(), doc), true)
        @Assert(refEq(doc.root(), doc.ownerDocument().getOrThrow()), true)
        var standAlone: Element = Element(Tag.valueOf("p"), "")
        @Assert(standAlone.parent(), None)
        @Assert(refEq(standAlone.root(), standAlone), true)
        @Assert(standAlone.ownerDocument(), None)

        println("Pass16")
    }

    @TestCase
    public func beforeTest(): Unit {
        // 17 
        var doc: Document = Html4cj.parse("<p>One <b>two</b> three</p>")
        var newNode: Element = Element(Tag.valueOf("em"), "")
        newNode.appendText("four")
        doc.select("b").first().getOrThrow().before(newNode)
        @Assert("<p>One <em>four</em><b>two</b> three</p>", doc.body().html())
        doc.select("b").first().getOrThrow().before("<i>five</i>")
        @Assert("<p>One <em>four</em><i>five</i><b>two</b> three</p>", doc.body().html())

        println("Pass17")
    }

    @TestCase
    public func afterTest(): Unit {
        // 18 
        var doc: Document = Html4cj.parse("<p>One <b>two</b> three</p>")
        var newNode: Element = Element(Tag.valueOf("em"), "")
        newNode.appendText("four")
        doc.select("b").first().getOrThrow().after(newNode)
        @Assert("<p>One <b>two</b><em>four</em> three</p>", doc.body().html())
        doc.select("b").first().getOrThrow().after("<i>five</i>")
        @Assert("<p>One <b>two</b><i>five</i><em>four</em> three</p>", doc.body().html())

        println("Pass18")
    }

    @TestCase
    public func unwrap(): Unit {
        // 19 
        var doc: Document = Html4cj.parse("<div>One <span>Two <b>Three</b></span> Four</div>")
        var span: Element = doc.select("span").first().getOrThrow()
        var twoText: Node = span.childNode(0)
        var node: Node = span.unwrap().getOrThrow()
        @Assert("<div>One Two <b>Three</b> Four</div>", TextUtil.stripNewlines(doc.body().html()))
        @Assert((node is TextNode), true)
        @Assert("Two ", (node as TextNode).getOrThrow().text())
        @Assert(node, twoText)
        @Assert(node.parent().getOrThrow() == doc.select("div").first().getOrThrow(), true)

        println("Pass19")
    }

    @TestCase
    public func unwrapNoChildren(): Unit {
        // 20 
        var doc: Document = Html4cj.parse("<div>One <span></span> Two</div>")
        var span: Element = doc.select("span").first().getOrThrow()
        var node: ?Node = span.unwrap()
        @Assert("<div>One  Two</div>", TextUtil.stripNewlines(doc.body().html()))
        @Assert(node, None)

        println("Pass20")
    }

    @TestCase
    public func traverse(): Unit {
        // 21 
        var doc: Document = Html4cj.parse("<div><p>Hello</p></div><div>There</div>")
        var accum: StringBuilder = StringBuilder()
        doc.select("div").first().getOrThrow().traverse(TrestNodeVisitor(accum))
        @Assert("<div><p><#text></#text></p></div>", accum.toString())

        println("Pass21")
    }

    @TestCase
    public func orphanNodeReturnsNullForSiblingElements(): Unit {
        // 22 
        var node: Node = Element(Tag.valueOf("p"), "")
        var el: Element = Element(Tag.valueOf("p"), "")
        @Assert(0, node.siblingIndex())
        @Assert(0, node.siblingNodes().size)
        @Assert(node.previousSibling(), None)
        @Assert(node.nextSibling(), None)
        @Assert(0, el.siblingElements().elementArr.size)
        @Assert(el.previousElementSibling(), None)
        @Assert(el.nextElementSibling(), None)

        println("Pass22")
    }

    @TestCase
    public func nodeIsNotASiblingOfItself(): Unit {
        // 23        
        var doc: Document = Html4cj.parse("<div><p>One<p>Two<p>Three</div>")
        var p2: Element = doc.select("p").elementArr[1]
        @Assert("Two", p2.text())
        var nodes: ArrayList<Node> = p2.siblingNodes()
        @Assert(2, nodes.size)
        @Assert("<p>One</p>", nodes[0].outerHtml())
        @Assert("<p>Three</p>", nodes[1].outerHtml())

        println("Pass23")
    }

    @TestCase
    public func childNodesCopy(): Unit {
        // 24 
        var doc: Document = Html4cj.parse("<div id=1>Text 1 <p>One</p> Text 2 <p>Two<p>Three</div><div id=2>")
        var div1: Element = doc.select("#1").first().getOrThrow()
        var div2: Element = doc.select("#2").first().getOrThrow()
        var divChildren: ArrayList<Node> = div1.childNodesCopy()
        @Assert(5, divChildren.size)
        var tn1: TextNode = (div1.childNode(0) as TextNode).getOrThrow()
        var tn2: TextNode = (divChildren[0] as TextNode).getOrThrow()
        tn2.text("Text 1 updated")

        @Assert("Text 1 ", tn1.text())
        div2.insertChildren(-1, divChildren)

        @Assert("<div id=\"1\">Text 1 <p>One</p> Text 2 <p>Two</p><p>Three</p></div><div id=\"2\">Text 1 updated<p>One</p> Text 2 <p>Two</p><p>Three</p></div>", 
            TextUtil.stripNewlines(doc.body().html()))
        println("Pass24")
    }

    @TestCase
    public func supportsClone(): Unit {
        // 25
        var doc: Document = Html4cj.parse("<div class=foo>Text</div>")
        var elements: Elements = doc.select("div")
        var el: Element = elements.first().getOrThrow()
        @Assert(el.hasClass("foo"), true)
        var docClone: Document = doc.clone()
        var elementsClone: Elements = docClone.select("div")
        var elClone: Element = elementsClone.first().getOrThrow()
        @Assert(elClone.hasClass("foo"), true)
        @Assert("Text", elClone.text())
        el.removeClass("foo")
        el.text("None")
        @Assert(el.hasClass("foo"), false)
        @Assert("None", el.text())
        @Assert(elClone.hasClass("foo"), true)
        @Assert("Text", elClone.text())

        println("Pass25")
    }

    @TestCase
    public func changingAttributeValueShouldReplaceExistingAttributeCaseInsensitive(): Unit {
        // 26 
        var document: Document = Html4cj.parse("<INPUT id=\"foo\" NAME=\"foo\" VALUE=\"\">")
        var inputElement: Element = document.select("#foo").first().getOrThrow()
        inputElement.attr("value", "bar")
        @Assert(singletonAttributes(), getAttributesCaseInsensitive(inputElement))

        println("Pass26")
    }

    private func getAttributesCaseInsensitive(element: Element): Attributes {
        var matches: Attributes = Attributes()
        for (attribute in element.attributes()) {
            if (attribute.getKey().toAsciiLower() == "value") {
                matches.put(attribute)
            }
        }
        return matches
    }

    private func singletonAttributes(): Attributes {
        var attributes: Attributes = Attributes()
        attributes.put("value", "bar")
        return attributes
    }

    @TestCase
    public func clonedNodesHaveOwnerDocsAndIndependentSettings(): Unit {
        // 27 
        // https://github.com/jhy/jsoup/issues/763
        var doc: Document = Html4cj.parse("<div>Text</div><div>Two</div>")
        doc.outputSettings().prettyPrint(false)
        var div: ?Element = doc.selectFirst("div")
        @Assert(div != None, true)
        var text: ?TextNode = div.getOrThrow().childNode(0) as TextNode
        match (text) {
            case Some(v: TextNode) => (v)
            case _ => @Assert(false, true)
        }
        var textClone: TextNode = text.getOrThrow().clone()
        var docClone: ?Document = textClone.ownerDocument()
        @Assert(docClone != None, true)
        @Assert(docClone.getOrThrow().outputSettings().prettyPrint(), false)
        @Assert(refEq(doc, docClone.getOrThrow()), false)
        doc.outputSettings().prettyPrint(true)
        @Assert(doc.outputSettings().prettyPrint(), true)
        @Assert(docClone.getOrThrow().outputSettings().prettyPrint(), false)

        // check did not get the second div as the owner's children
        @Assert(docClone.getOrThrow().childNodes().size, 1)

        // note not the head or the body -- not normalized
        @Assert(refEq(textClone, docClone.getOrThrow().childNode(0)), true)

        println("Pass27")
    }

    @TestCase
    public func firstAndLastChild(): Unit {
        // 28
        var html: String = "<div>One <span>Two</span> <a href></a> Three</div>"
        var doc: Document = Html4cj.parse(html)
        var div: ?Element = doc.selectFirst("div")
        var a: ?Element = doc.selectFirst("a")
        @Assert(div != None, true)
        @Assert(a != None, true)

        // nodes
        var first: ?TextNode = (div.getOrThrow().firstChild().getOrThrow() as TextNode)
        @Assert("One ", first.getOrThrow().text())
        var last: ?TextNode = (div.getOrThrow().lastChild().getOrThrow() as TextNode)
        @Assert(" Three", last.getOrThrow().text())
        @Assert(a.getOrThrow().firstChild() == None, true)
        @Assert(a.getOrThrow().lastChild() == None, true)

        // elements
        var firstEl: ?Element = div.getOrThrow().firstElementChild()
        @Assert("span", firstEl.getOrThrow().tagName())
        var lastEl: ?Element = div.getOrThrow().lastElementChild()
        @Assert("a", lastEl.getOrThrow().tagName())
        @Assert(a.getOrThrow().firstElementChild() == None, true)
        @Assert(a.getOrThrow().lastElementChild() == None, true)
        @Assert(firstEl.getOrThrow().firstElementChild() == None, true)
        @Assert(firstEl.getOrThrow().lastElementChild() == None, true)

        println("Pass28")
    }

    @TestCase
    public func nodeName(): Unit {
        // 29
        var div: Element = Element("DIV")
        @Assert("DIV", div.tagName())
        @Assert("DIV", div.nodeName())
        @Assert("div", div.normalName())
        var text: TextNode = TextNode("Some Text")
        @Assert("#text", text.nodeName())
        @Assert("#text", text.normalName())

        println("Pass29")
    }
}

class TrestNodeVisitor <: NodeVisitor {
    var accum: StringBuilder
    init(accum: StringBuilder) {
        this.accum = accum
    }
    public override func head(node: Node, deptT: Int64): Unit {
        deptT
        accum.append("<")
        accum.append(node.nodeName())
        accum.append(">")
    }
    public override func tail(node: Node, deptT: Int64): Unit {
        deptT
        accum.append("</")
        accum.append(node.nodeName())
        accum.append(">")
    }
}
