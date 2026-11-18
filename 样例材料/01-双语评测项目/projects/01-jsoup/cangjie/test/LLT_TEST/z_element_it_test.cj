package cangjie_tpc::html4cj

@Test
public class ElementITTest {
    @TestCase
    public func testFastReparent(): Unit {
        // 1
        var htmlBuf: StringBuilder = StringBuilder()
        var rows: Int64 = 300
        for (i in 1..=rows) {
            htmlBuf.append("<p>El-")
            htmlBuf.append(i)
            htmlBuf.append("</p>")
        }
        var html: String = htmlBuf.toString()
        var doc: Document = Html4cj.parse(html)
        var wrapper: Element = Element("div")
        var childNodes: ArrayList<Node> = doc.body().childNodes()
        wrapper.insertChildren(0, childNodes)
        @Assert(rows, wrapper.childNodeSize())

        // child nodes is a wrapper, so still there
        @Assert(rows, childNodes.size)

        // but on a fresh look, all gone
        @Assert(0, doc.body().childNodes().size)
        (doc.body().empty() as Element).getOrThrow().appendChild(wrapper)
        var wrapperAcutal: Element = doc.body().children().elementArr[0]
        @Assert(wrapper, wrapperAcutal)
        @Assert("El-1", wrapperAcutal.children().elementArr[0].text())
        @Assert("El-" + rows.toString(), wrapperAcutal.children().elementArr[rows - 1].text())

        println("Pass1")
    }

    @TestCase
    public func testFastReparentExistingContent(): Unit {
        // 2
        var htmlBuf: StringBuilder = StringBuilder()
        var rows: Int64 = 300
        for (i in 1..=rows) {
            htmlBuf.append("<p>El-")
            htmlBuf.append(i)
            htmlBuf.append("</p>")
        }
        var html: String = htmlBuf.toString()
        var doc: Document = Html4cj.parse(html)
        var wrapper: Element = Element("div")

        wrapper.append("<p>Prior Content</p>")
        wrapper.append("<p>End Content</p>")
        @Assert(2, wrapper.childNodeSize())
        var childNodes: ArrayList<Node> = doc.body().childNodes()
        wrapper.insertChildren(1, childNodes)
        @Assert(rows + 2, wrapper.childNodeSize())
        
        // child nodes is a wrapper, so still there
        @Assert(rows, childNodes.size)

        // but on a fresh look, all gone
        @Assert(0, doc.body().childNodes().size)
        (doc.body().empty() as Element).getOrThrow().appendChild(wrapper)
        var wrapperAcutal: Element = doc.body().children().elementArr[0]
        @Assert(wrapper, wrapperAcutal)
        @Assert("Prior Content", wrapperAcutal.children().elementArr[0].text())
        @Assert("El-1", wrapperAcutal.children().elementArr[1].text())
        @Assert("El-" + rows.toString(), wrapperAcutal.children().elementArr[rows].text())
        @Assert("End Content", wrapperAcutal.children().elementArr[rows + 1].text())
        println("Pass2")
    }

    @TestCase
    public func hasTextNoOverflow(): Unit {
        // 3
        // hasText() was recursive, so could overflow
        var doc: Document = Document("https://example.com/")
        var el: Element = doc.body()
        var rows: Int64 = 50
        for (i in 0..=rows) {
            i
            el = el.appendElement("p")
        }
        @Assert(doc.hasText(), false)
        el.text("Hello")
        @Assert(doc.hasText(), true)
        @Assert(el.text(), doc.text())

        println("Pass3")
    }

    @TestCase
    public func dataNoOverflow(): Unit {
        // 4
        // data() was recursive, so could overflow
        var doc: Document = Document("https://example.com/")
        var el: Element = doc.body()
        var rows: Int64 = 50
        for (i in 0..=rows) {
            i
            el = el.appendElement("p")
        }
        var script: Element = el.appendElement("script")

        // holds data nodes, so inserts as data, not text
        script.text("script")
        @Assert(script.hasText(), false)
        @Assert("script", script.data())
        @Assert(el.data(), doc.data())

        println("Pass4")
    }

    @TestCase
    public func parentsNoOverflow(): Unit {
        // 5
        // parents() was recursive, so could overflow
        var doc: Document = Document("https://example.com/")
        var el: Element = doc.body()
        var num: Int64 = 50
        for (i in 0..=num) {
            i
            el = el.appendElement("p")
        }
        var parents: Elements = el.parents()

        // +2 for html and body
        @Assert(num + 2, parents.elementArr.size)
        @Assert(doc, el.ownerDocument())

        println("Pass5")
    }

    @TestCase
    public func wrapNoOverflow(): Unit {
        // 6        
        // deepChild was recursive, so could overflow if presented with a fairly insane wrap
        var doc: Document = Document("https://example.com/")
        var el: Element = doc.body().appendElement("p")
        var num: Int64 = 50
        var sb: StringBuilder = StringBuilder()
        for (i in 0..=num) {
            i
            sb.append("<div>")
        }

        el.wrap(sb.toString())
        var html: String = doc.body().html()
        @Assert(html.startsWith("<div>"), true)
        @Assert(num + 3, el.parents().elementArr.size)
        println("Pass6")
    }
}
