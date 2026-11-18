package cangjie_tpc::html4cj

/*
 * Tests for ElementList.
 */
@Test
public class ElementsTest {
    @TestCase
    public func filter(): Unit {
        let h: String =
            "<p>Excl</p><div class=headline><p>Hello</p><p>There</p></div><div class=headline><h1>Headline</h1></div>"
        let doc: Document = Html4cj.parse(h)
        let els: Elements = doc.select(".headline").select("p")
        @Assert(2, els.size)
        @Assert("Hello", els[0].text())
        @Assert("There", els[1].text())
    }

    @TestCase
    public func attributes(): Unit {
        let h: String = "<p title=foo><p title=bar><p class=foo><p class=bar>"
        let doc: Document = Html4cj.parse(h)
        let withTitle: Elements = doc.select("p[title]")
        @Assert(2, withTitle.size)
        @Assert(withTitle.hasAttr("title"))
        @Assert(false,withTitle.hasAttr("class"))
        @Assert("foo", withTitle.attr("title"))
        withTitle.removeAttr("title")

        // existing Elements are not reevaluated
        @Assert(2, withTitle.size)
        @Assert(0, doc.select("p[title]").size)
        let ps: Elements = doc.select("p").attr("style", "classy")
        @Assert(4, ps.size)
        @Assert("classy", ps.last().getOrThrow().attr("style"))
        @Assert("bar", ps.last().getOrThrow().attr("class"))
    }

    @TestCase
    public func hasAttr(): Unit {
        let doc: Document = Html4cj.parse("<p title=foo><p title=bar><p class=foo><p class=bar>")
        let ps: Elements = doc.select("p")
        @Assert(ps.hasAttr("class"))
        @Assert(false,ps.hasAttr("style"))
    }

    @TestCase
    public func hasAbsAttr(): Unit {
        let doc: Document = Html4cj.parse("<a id=1 href='/foo'>One</a> <a id=2 href='https://jsoup.org'>Two</a>")
        let one: Elements = doc.select("#1")
        let two: Elements = doc.select("#2")
        let both: Elements = doc.select("a")

        @Assert(false,one.hasAttr("abs:href"))
        @Assert(two.hasAttr("abs:href"))

        // hits on #2
        @Assert(both.hasAttr("abs:href"))
    }

    @TestCase
    public func attr(): Unit {
        let doc: Document = Html4cj.parse("<p title=foo><p title=bar><p class=foo><p class=bar>")
        let classVal: String = doc.select("p").attr("class")
        @Assert("foo", classVal)
    }

    @TestCase
    public func absAttr(): Unit {
        let doc: Document = Html4cj.parse("<a id=1 href='/foo'>One</a> <a id=2 href='https://jsoup.org'>Two</a>")
        let one: Elements = doc.select("#1")
        let two: Elements = doc.select("#2")
        let both: Elements = doc.select("a")

        @Assert("", one.attr("abs:href"))
        @Assert("https://jsoup.org", two.attr("abs:href"))
        @Assert("https://jsoup.org", both.attr("abs:href"))
    }

    @TestCase
    public func classes(): Unit {
        let doc: Document = Html4cj.parse("<div><p class='mellow yellow'></p><p class='red green'></p>")
        let els: Elements = doc.select("p")
        @Assert(els.hasClass("red"))
        @Assert(false,els.hasClass("blue"))
        els.addClass("blue")
        els.removeClass("yellow")
        els.toggleClass("mellow")
        @Assert("blue", els[0].className())
        @Assert("red green blue mellow", els[1].className())
    }

    @TestCase
    public func hasClassCaseInsensitive(): Unit {
        let els: Elements = Html4cj.parse("<p Class=One>One <p class=Two>Two <p CLASS=THREE>THREE").select("p")
        let one: Element = els[0]
        let two: Element = els[1]
        let thr: Element = els[2]
        @Assert(one.hasClass("One"))
        @Assert(one.hasClass("ONE"))
        @Assert(two.hasClass("TWO"))
        @Assert(two.hasClass("Two"))
        @Assert(thr.hasClass("ThreE"))
        @Assert(thr.hasClass("three"))
    }

    @TestCase
    public func text(): Unit {
        let h: String = "<div><p>Hello<p>there<p>world</div>"
        let doc: Document = Html4cj.parse(h)
        @Assert("Hello there world", doc.select("div > *").text())
    }

    @TestCase
    public func hasText(): Unit {
        let doc: Document = Html4cj.parse("<div><p>Hello</p></div><div><p></p></div>")
        let divs: Elements = doc.select("div")
        @Assert(divs.hasText())
        @Assert(false,doc.select("div + div").hasText())
    }

    @TestCase
    public func html(): Unit {
        let doc: Document = Html4cj.parse("<div><p>Hello</p></div><div><p>There</p></div>")
        let divs: Elements = doc.select("div")
        @Assert("<p>Hello</p>\n<p>There</p>", divs.html())
    }

    @TestCase
    public func outerHtml(): Unit {
        let doc: Document = Html4cj.parse("<div><p>Hello</p></div><div><p>There</p></div>")
        let divs: Elements = doc.select("div")
        @Assert("<div><p>Hello</p></div><div><p>There</p></div>", TextUtil.stripNewlines(divs.outerHtml()))
    }

    @TestCase
    public func setHtml(): Unit {
        let doc: Document = Html4cj.parse("<p>One</p><p>Two</p><p>Three</p>")
        let ps: Elements = doc.select("p")
        ps.prepend("<b>Bold</b>").append("<i>Ital</i>")
        @Assert("<p><b>Bold</b>Two<i>Ital</i></p>", TextUtil.stripNewlines(ps[1].outerHtml()))
        ps.html("<span>Gone</span>")
        @Assert("<p><span>Gone</span></p>", TextUtil.stripNewlines(ps[1].outerHtml()))
    }

    @TestCase
    public func val(): Unit {
        let doc: Document = Html4cj.parse("<input value='one' /><textarea>two</textarea>")
        let els: Elements = doc.select("input, textarea")
        @Assert(2, els.size)
        @Assert("one", els.val())
        @Assert("two", els.last().getOrThrow().val())
        els.val("three")
        @Assert("three", els.first().getOrThrow().val())
        @Assert("three", els.last().getOrThrow().val())
        @Assert("<textarea>three</textarea>", els.last().getOrThrow().outerHtml())
    }

    @TestCase
    public func before(): Unit {
        let doc: Document = Html4cj.parse("<p>This <a>is</a> <a>jsoup</a>.</p>")
        doc.select("a").before("<span>foo</span>")
        @Assert("<p>This <span>foo</span><a>is</a> <span>foo</span><a>jsoup</a>.</p>", TextUtil.stripNewlines(doc.body().html()))
    }

    @TestCase
    public func after(): Unit {
        let doc: Document = Html4cj.parse("<p>This <a>is</a> <a>jsoup</a>.</p>")
        doc.select("a").after("<span>foo</span>")
        @Assert("<p>This <a>is</a><span>foo</span> <a>jsoup</a><span>foo</span>.</p>", TextUtil.stripNewlines(doc.body().html()))
    }

    @TestCase
    public func wrap(): Unit {
        let h: String = "<p><b>This</b> is <b>jsoup</b></p>"
        let doc: Document = Html4cj.parse(h)
        doc.select("b").wrap("<i></i>")
        @Assert("<p><i><b>This</b></i> is <i><b>jsoup</b></i></p>", doc.body().html())
    }

    @TestCase
    public func wrapDiv(): Unit {
        let h: String = "<p><b>This</b> is <b>jsoup</b>.</p> <p>How do you like it?</p>"
        let doc: Document = Html4cj.parse(h)
        doc.select("p").wrap("<div></div>")
        @Assert(
            "<div>\n <p><b>This</b> is <b>jsoup</b>.</p>\n</div>\n<div>\n <p>How do you like it?</p>\n</div>",
            doc.body().html())
    }

    @TestCase
    public func unwrap(): Unit {
        let h: String = "<div><font>One</font> <font><a href=\"/\">Two</a></font></div"
        let doc: Document = Html4cj.parse(h)
        doc.select("font").unwrap()
        @Assert("<div>One <a href=\"/\">Two</a></div>", TextUtil.stripNewlines(doc.body().html()))
    }

    @TestCase
    public func unwrapP(): Unit {
        let h: String = "<p><a>One</a> Two</p> Three <i>Four</i> <p>Fix <i>Six</i></p>"
        let doc: Document = Html4cj.parse(h)
        doc.select("p").unwrap()
        @Assert("<a>One</a> Two Three <i>Four</i> Fix <i>Six</i>", TextUtil.stripNewlines(doc.body().html()))
    }

    @TestCase
    public func unwrapKeepsSpace(): Unit {
        let h: String = "<p>One <span>two</span> <span>three</span> four</p>"
        let doc: Document = Html4cj.parse(h)
        doc.select("span").unwrap()
        @Assert("<p>One two three four</p>", doc.body().html())
    }

    @TestCase
    public func empty(): Unit {
        let doc: Document = Html4cj.parse("<div><p>Hello <b>there</b></p> <p>now!</p></div>")
        doc.outputSettings().prettyPrint(false)
        doc.select("p").empty()
        @Assert("<div><p></p> <p></p></div>", doc.body().html())
    }

    @TestCase
    public func remove(): Unit {
        let doc: Document = Html4cj.parse("<div><p>Hello <b>there</b></p> jsoup <p>now!</p></div>")
        doc.outputSettings().prettyPrint(false)
        doc.select("p").remove()
        @Assert("<div> jsoup </div>", doc.body().html())
    }

    @TestCase
    public func eq(): Unit {
        let h: String = "<p>Hello<p>there<p>world"
        let doc: Document = Html4cj.parse(h)
        @Assert("there", doc.select("p").eq(1).text())
        @Assert("there", doc.select("p")[1].text())
    }

    @TestCase
    public func check(): Unit {
        let h: String = "<p>Hello<p title=foo>there<p>world"
        let doc: Document = Html4cj.parse(h)
        let ps: Elements = doc.select("p")
        @Assert(ps.check("[title=foo]"))
        @Assert(false,ps.check("[title=bar]"))
    }

    @TestCase
    public func parents(): Unit {
        let doc: Document = Html4cj.parse("<div><p>Hello</p></div><p>There</p>")
        let parents: Elements = doc.select("p").parents()
        @Assert(3, parents.size)
        @Assert("div", parents[0].tagName())
        @Assert("body", parents[1].tagName())
        @Assert("html", parents[2].tagName())
    }

    @TestCase
    public func not(): Unit {
        let doc: Document = Html4cj.parse("<div id=1><p>One</p></div> <div id=2><p><span>Two</span></p></div>")
        let div1: Elements = doc.select("div").not(":has(p > span)")
        @Assert(1, div1.size)
        @Assert("1", div1.first().getOrThrow().id())
        let div2: Elements = doc.select("div").not("#1")
        @Assert(1, div2.size)
        @Assert("2", div2.first().getOrThrow().id())
    }

    @TestCase
    public func tagNameSet(): Unit {
        let doc: Document = Html4cj.parse("<p>Hello <i>there</i> <i>now</i></p>")
        doc.select("i").tagName("em")
        @Assert("<p>Hello <em>there</em> <em>now</em></p>", doc.body().html())
    }

    @TestCase
    public func traverse(): Unit {
        let doc: Document = Html4cj.parse("<div><p>Hello</p></div><div>There</div>")
        let accum: StringBuilder = StringBuilder()
        doc.select("div").traverse(MyVisitor(accum))
        @Assert("<div><p><#text></#text></p></div><div><#text></#text></div>", accum.toString())
    }

    @TestCase
    public func forms(): Unit {
        let doc: Document = Html4cj.parse("<form id=1><input name=q></form><div /><form id=2><input name=f></form>")
        let els: Elements = doc.select("form, div")
        @Assert(3, els.size)
        let forms: ArrayList<FormElement> = els.forms()
        @Assert(2, forms.size)
        @Assert("1", forms[0].id())
        @Assert("2", forms[1].id())
    }

    @TestCase
    public func comments(): Unit {
        let doc: Document = Html4cj.parse("<!-- comment1 --><p><!-- comment2 --><p class=two><!-- comment3 -->")
        let comments: ArrayList<Comment> = doc.select("p").comments()
        @Assert(2, comments.size)
        @Assert(" comment2 ", comments[0].getData())
        @Assert(" comment3 ", comments[1].getData())
        let comments1: ArrayList<Comment> = doc.select("p.two").comments()
        @Assert(1, comments1.size)
        @Assert(" comment3 ", comments1[0].getData())
    }

    @TestCase
    public func textNodes(): Unit {
        let doc: Document = Html4cj.parse("One<p>Two<a>Three</a><p>Four</p>Five")
        let textNodes: ArrayList<TextNode> = doc.select("p").textNodes()
        @Assert(2, textNodes.size)
        @Assert("Two", textNodes[0].text())
        @Assert("Four", textNodes[1].text())
    }

    @TestCase
    public func dataNodes(): Unit {
        var doc: Document = Html4cj.parse("<p>One</p><script>Two</script><style>Three</style>")
        let dataNodes: ArrayList<DataNode> = doc.select("p, script, style").dataNodes()
        @Assert(2, dataNodes.size)
        @Assert("Two", dataNodes[0].getWholeData())
        @Assert("Three", dataNodes[1].getWholeData())
        doc = Html4cj.parse("<head><script type=application/json><crux></script><script src=foo>Blah</script>")
        let script: Elements = doc.select("script[type=application/json]")
        let scriptNode: ArrayList<DataNode> = script.dataNodes()
        @Assert(1, scriptNode.size)
        let dataNode: DataNode = scriptNode[0]
        @Assert("<crux>", dataNode.getWholeData())

        // check if they're live
        dataNode.setWholeData("<cromulent>")
        @Assert("<script type=\"application/json\"><cromulent></script>", script.outerHtml())
    }

    @TestCase
    public func nodesEmpty(): Unit {
        let doc: Document = Html4cj.parse("<p>")
        @Assert(0, doc.select("form").textNodes().size)
    }

    @TestCase
    public func classWithHyphen(): Unit {
        let doc: Document = Html4cj.parse("<p class='tab-nav'>Check</p>")
        let els: Elements = doc.getElementsByClass("tab-nav")
        @Assert(1, els.size)
        @Assert("Check", els.text())
    }

    @TestCase
    public func siblings(): Unit {
        let doc: Document = Html4cj.parse("<div><p>1<p>2<p>3<p>4<p>5<p>6</div><div><p>7<p>8<p>9<p>10<p>11<p>12</div>")

        // gets p4 and p10
        let els: Elements = doc.select("p:eq(3)")
        @Assert(2, els.size)
        let next: Elements = els.next()
        @Assert(2, next.size)
        @Assert("5", next.first().getOrThrow().text())
        @Assert("11", next.last().getOrThrow().text())
        for (e in els) {
            println(e.text())
        }
        for (e in els.next("p:contains(6)")) {
            println(e.text())
        }
        @Assert(0, els.next("p:contains(6)").size)
        let nextF: Elements = els.next("p:contains(5)")
        @Assert(1, nextF.size)
        @Assert("5", nextF.first().getOrThrow().text())
        let nextA: Elements = els.nextAll()
        @Assert(4, nextA.size)
        @Assert("5", nextA.first().getOrThrow().text())
        @Assert("12", nextA.last().getOrThrow().text())
        let nextAF: Elements = els.nextAll("p:contains(6)")
        @Assert(1, nextAF.size)
        @Assert("6", nextAF.first().getOrThrow().text())
        let prev: Elements = els.prev()
        @Assert(2, prev.size)
        @Assert("3", prev.first().getOrThrow().text())
        @Assert("9", prev.last().getOrThrow().text())
        @Assert(0, els.prev("p:contains(1)").size)
        let prevF: Elements = els.prev("p:contains(3)")
        @Assert(1, prevF.size)
        @Assert("3", prevF.first().getOrThrow().text())
        let prevA: Elements = els.prevAll()
        @Assert(6, prevA.size)
        @Assert("3", prevA.first().getOrThrow().text())
        @Assert("7", prevA.last().getOrThrow().text())
        let prevAF: Elements = els.prevAll("p:contains(1)")
        @Assert(1, prevAF.size)
        @Assert("1", prevAF.first().getOrThrow().text())
    }

    @TestCase
    public func eachText(): Unit {
        let doc: Document = Html4cj.parse(
            "<div><p>1<p>2<p>3<p>4<p>5<p>6</div><div><p>7<p>8<p>9<p>10<p>11<p>12<p></p></div>")
        let divText: ArrayList<String> = doc.select("div").eachText()
        @Assert(2, divText.size)
        @Assert("1 2 3 4 5 6", divText[0])
        @Assert("7 8 9 10 11 12", divText[1])

        let pText: ArrayList<String> = doc.select("p").eachText()
        let ps: Elements = doc.select("p")
        @Assert(13, ps.size)
        @Assert(12, pText.size) // not 13, as last doesn't have text
        @Assert("1", pText[0])
        @Assert("2", pText[1])
        @Assert("5", pText[4])
        @Assert("7", pText[6])
        @Assert("12", pText[11])
    }

    @TestCase
    public func eachAttr(): Unit {
        let doc: Document = Html4cj.parse(
            "<div><a href='/foo'>1</a><a href='http://example.com/bar'>2</a><a href=''>3</a><a>4</a>",
            "http://example.com"
        )
        let hrefAttrs: ArrayList<String> = doc.select("a").eachAttr("href")
        @Assert(3, hrefAttrs.size)
        @Assert("/foo", hrefAttrs[0])
        @Assert("http://example.com/bar", hrefAttrs[1])
        @Assert("", hrefAttrs[2])
        @Assert(4, doc.select("a").size)
        let absAttrs: ArrayList<String> = doc.select("a").eachAttr("abs:href")
        @Assert(3, absAttrs.size)
        @Assert(3, absAttrs.size)
        @Assert("http://example.com/foo", absAttrs[0])
        @Assert("http://example.com/bar", absAttrs[1])
        @Assert("http://example.com", absAttrs[2])
    }
}

class MyVisitor <: NodeVisitor {
    let accum: StringBuilder
    
    init(accum: StringBuilder) {
        this.accum = accum
    }

    public func head(node: Node, depth: Int64): Unit {
        (depth)
        accum.append("<")
        accum.append(node.nodeName())
        accum.append(">")
    }

    public func tail(node: Node, depth: Int64): Unit {
        (depth)
        accum.append("</")
        accum.append(node.nodeName())
        accum.append(">")
    }
}
