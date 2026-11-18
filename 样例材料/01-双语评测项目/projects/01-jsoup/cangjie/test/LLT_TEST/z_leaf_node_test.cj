package cangjie_tpc::html4cj

@Test
public class LeafNodeTest {
    @TestCase
    public func doesNotGetAttributesTooEasily(): Unit {
        // test to make sure we're not setting attributes on all nodes right away
        let body: String = "<p>One <!-- Two --> Three<![CDATA[Four]]></p>"
        let doc: Document = Html4cj.parse(body)
        @Assert(hasAnyAttributes(doc)) // should have one - the base uri on the doc

        let html: Element = doc.child(0)
        @Assert(false, hasAnyAttributes(html))

        doc.outerHtml()
        @Assert(false, hasAnyAttributes(html))

        var els: Elements = doc.select("p")
        let p: Element = els.first().getOrThrow()
        @Assert(1, els.size)
        @Assert(false, hasAnyAttributes(html))

        els = doc.select("p.none")
        @Assert(false, hasAnyAttributes(html))

        let id: String = p.id()
        @Assert("", id)
        @Assert(false, p.hasClass("Foobs"))
        @Assert(false, hasAnyAttributes(html))

        p.addClass("Foobs")
        @Assert(p.hasClass("Foobs"))
        @Assert(hasAnyAttributes(html))
        @Assert(hasAnyAttributes(p))

        let attributes: Attributes = p.attributes()
        @Assert(attributes.hasKey("class"))
        p.clearAttributes()
        @Assert(false, hasAnyAttributes(p))
        @Assert(false, hasAnyAttributes(html))
        @Assert(false, attributes.hasKey("class"))
    }

    private func hasAnyAttributes(node: Node): Bool {
        let found: Array<Bool> = [false]
        node.filter(MyNodeFilter1(found))
        return found[0]
    }
}

class MyNodeFilter1 <: NodeFilter {
    let found: Array<Bool>
    
    init(found: Array<Bool>) {
        this.found = found
    }
    public override func head(node: Node, depth: Int64): FilterResult {
        (node, depth)
        if (node.hasAttributes()) {
            found[0] = true
            return FilterResult.STOP
        } else {
            return FilterResult.CONTINUE
        }
    }
    public override func tail(node: Node, depth: Int64): FilterResult {
        (node, depth)
        return FilterResult.CONTINUE
    }
}
