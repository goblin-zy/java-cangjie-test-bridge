// DEPENDENCE: text_util_test.cj
// EXEC: cjc %import-path %L %l %f text_util_test.cj -g
// EXEC: ./main
import cangjie_tpc::html4cj.*
import std.collection.*
import std.sync.*
import std.unittest.*
import std.unittest.testmacro.*

main(): Int64 {
    let tester = TraversorTest()
    tester.filterVisit()
    tester.filterSkipChildren()
    tester.filterSkipEntirely()
    tester.filterRemove()
    tester.filterStop()
    tester.replaceElement()
    tester.canAddChildren()
    tester.canSpecifyOnlyHead()
    tester.canRemoveDuringHead()
    0
}

@Test
public class TraversorTest {
    // Note: NodeTraversor.traverse(MyNodeVisitor) is tested in
    // ElementsTest#traverse()
    @TestCase
    public func filterVisit(): Unit {
        let doc: Document = Html4cj.parse("<div><p>Hello</p></div><div>There</div>")
        let accum: StringBuilder = StringBuilder()
        let headFunc: filterFunc = {
            node, depth =>
            (depth)
            accum.append("<")
            accum.append(node.nodeName())
            accum.append(">")
            return FilterResult.CONTINUE
        }
        let tailFunc: filterFunc = {
            node, depth =>
            (depth)
            accum.append("</")
            accum.append(node.nodeName())
            accum.append(">")
            return FilterResult.CONTINUE
        }
        let filter = MyNodeFilter(headFunc, tailFunc)

        // NodeTraversor.filter(filter, doc.select("div"))
        doc.select("div").filter(filter)
        @Assert("<div><p><#text></#text></p></div><div><#text></#text></div>", accum.toString())
    }

    @TestCase
    public func filterSkipChildren(): Unit {
        let doc: Document = Html4cj.parse("<div><p>Hello</p></div><div>There</div>")
        let accum: StringBuilder = StringBuilder()
        let headFunc: filterFunc = {
            node, depth =>
            (depth)
            accum.append("<")
            accum.append(node.nodeName())
            accum.append(">")

            // OMIT contents of p:
        return if ("p" == node.nodeName()) {
                FilterResult.SKIP_CHILDREN
            } else {
                FilterResult.CONTINUE
            }
        }
        let tailFunc: filterFunc = {
            node, depth =>
            (depth)
            accum.append("</")
            accum.append(node.nodeName())
            accum.append(">")
            return FilterResult.CONTINUE
        }
        let filter = MyNodeFilter(headFunc, tailFunc)

        // NodeTraversor.filter(filter, doc.select("div"))
        doc.select("div").filter(filter)
        @Assert("<div><p></p></div><div><#text></#text></div>", accum.toString())
    }

    @TestCase
    public func filterSkipEntirely(): Unit {
        let doc: Document = Html4cj.parse("<div><p>Hello</p></div><div>There</div>")
        let accum: StringBuilder = StringBuilder()
        let headFunc: filterFunc = {
            node, depth =>
            (node, depth)

            // OMIT p:
        if ("p" == node.nodeName()) {
                return FilterResult.SKIP_ENTIRELY
            }
            accum.append("<")
            accum.append(node.nodeName())
            accum.append(">")
            return FilterResult.CONTINUE
        }
        let tailFunc: filterFunc = {
            node, depth =>
            (depth)
            accum.append("</")
            accum.append(node.nodeName())
            accum.append(">")
            return FilterResult.CONTINUE
        }
        let filter = MyNodeFilter(headFunc, tailFunc)

        // NodeTraversor.filter(filter, doc.select("div"))
        doc.select("div").filter(filter)
        @Assert("<div></div><div><#text></#text></div>", accum.toString())
    }

    @TestCase
    public func filterRemove(): Unit {
        let doc: Document = Html4cj.parse("<div><p>Hello</p></div><div>There be <b>bold</b></div>")
        let headFunc: filterFunc = {
            node, depth =>
            // Delete "p" in head:
        (node, depth)
            return if ("p" == node.nodeName()) {
                FilterResult.REMOVE
            } else {
                FilterResult.CONTINUE
            }
        }
        let tailFunc: filterFunc = {
            node, depth =>
            // Delete "b" in tail:
        (node, depth)
            return if ("b" == node.nodeName()) {
                FilterResult.REMOVE
            } else {
                FilterResult.CONTINUE
            }
        }
        let filter = MyNodeFilter(headFunc, tailFunc)

        // NodeTraversor.filter(filter, doc.select("div"))
        doc.select("div").filter(filter)
        @Assert("<div></div>\n<div>\n There be\n</div>", doc.select("body").html())
    }

    @TestCase
    public func filterStop(): Unit {
        let doc: Document = Html4cj.parse("<div><p>Hello</p></div><div>There</div>")
        let accum: StringBuilder = StringBuilder()
        let headFunc: filterFunc = {
            node, depth =>
            (depth)
            accum.append("<")
            accum.append(node.nodeName())
            accum.append(">")
            return FilterResult.CONTINUE
        }
        let tailFunc: filterFunc = {
            node, depth =>
            (depth)
            accum.append("</")
            accum.append(node.nodeName())
            accum.append(">")

            // Stop after p.
        return if ("p" == node.nodeName()) {
                FilterResult.STOP
            } else {
                FilterResult.CONTINUE
            }
        }
        let filter = MyNodeFilter(headFunc, tailFunc)

        // NodeTraversor.filter(filter, doc.select("div"))
        doc.select("div").filter(filter)
        @Assert("<div><p><#text></#text></p>", accum.toString())
    }

    @TestCase
    public func replaceElement(): Unit {
        // https://github.com/jhy/jsoup/issues/1289
        // test we can replace an element during traversal
        let html: String = "<div><p>One <i>two</i> <i>three</i> four.</p></div>"
        let doc: Document = Html4cj.parse(html)

        let headFunc: visitorFunc = {
            node, depth => if (node is Element) {
                (depth)
                let el: Element = (node as Element).getOrThrow()
                if (el.normalName() == "i") {
                    let u: Element = Element("u").insertChildren(0, el.childNodes())
                    el.replaceWith(u)
                }
            }
        }

        // NodeTraversor.traverse(MyNodeVisitor(headFunc), doc)
        doc.traverse(MyNodeVisitor(headFunc))

        let p: Element = doc.selectFirst("p").getOrThrow()

        // assertNotNull(p)
        @Assert("<p>One <u>two</u> <u>three</u> four.</p>", p.outerHtml())
    }

    @TestCase
    public func canAddChildren(): Unit {
        let doc: Document = Html4cj.parse("<div><p></p><p></p></div>")
        let flag: AtomicInt64 = AtomicInt64(0)
        let headFunc: visitorFunc = {
            node, depth => if (node.nodeName() == "p") {
                (depth)
                let p: Element = (node as Element).getOrThrow()
                p.append("<span>${flag.load()}</span>")
                flag.fetchAdd(1)
            }
        }
        let tailFunc: visitorFunc = {
            node, depth => if (node.nodeName() == "p") {
                (depth)
                let p: Element = (node as Element).getOrThrow()
                p.append("<span>${flag.load()}</span>")
                flag.fetchAdd(1)
            }
        }

        // NodeTraversor.traverse(MyNodeVisitor(headFunc, tailFunc: tailFunc), doc)
        doc.traverse(MyNodeVisitor(headFunc, tailFunc: tailFunc))

        @Assert("<div>\n" +
            " <p><span>0</span><span>1</span></p>\n" +
            " <p><span>2</span><span>3</span></p>\n" +
            "</div>", doc.body().html())
    }

    @TestCase
    public func canSpecifyOnlyHead(): Unit {
        // really, a compilation test - works as a lambda if just head
        let doc: Document = Html4cj.parse("<div><p>One</p></div>")
        let count: Array<Int64> = [0]

        // NodeTraversor.traverse(MyNodeVisitor({node, depth => count[0] = count[0] + 1}), doc)
        doc.traverse(
            MyNodeVisitor(
                {
                    node, depth =>
                    (node, depth)
                    count[0] = count[0] + 1
                }
            )
        )
        @Assert(7, count[0])
    }

    @TestCase
    public func canRemoveDuringHead(): Unit {
        let doc: Document = Html4cj.parse("<div><p id=1>Zero<p id=1>One<p id=2>Two<p>Three</div>")
        let headFunc: visitorFunc = {
            node, depth => if (node.attr("id") == "1") {
                (depth)
                node.remove()
            } else if (node is TextNode && (node as TextNode).getOrThrow().text() == "Three") {
                node.remove()
            }
        }

        // NodeTraversor.traverse(MyNodeVisitor(headFunc), doc)
        doc.traverse(MyNodeVisitor(headFunc))

        @Assert("<div><p id=\"2\">Two</p><p></p></div>", TextUtil.stripNewlines(doc.body().html()))
    }
}

type filterFunc = (Node, Int64) -> FilterResult

class MyNodeFilter <: NodeFilter {
    let headFunc: filterFunc
    let tailFunc: filterFunc

    init(headFunc: filterFunc, tailFunc: filterFunc) {
        this.headFunc = headFunc
        this.tailFunc = tailFunc
    }

    public override func head(node: Node, depth: Int64): FilterResult {
        return headFunc(node, depth)
    }

    public override func tail(node: Node, depth: Int64): FilterResult {
        return tailFunc(node, depth)
    }
}

type visitorFunc = (Node, Int64) -> Unit

class MyNodeVisitor <: NodeVisitor {
    let headFunc: visitorFunc
    let tailFunc: visitorFunc

    init(headFunc: visitorFunc, tailFunc!: visitorFunc = {node, depth => (node, depth)}) {
        this.headFunc = headFunc
        this.tailFunc = tailFunc
    }

    public override func head(node: Node, depth: Int64): Unit {
        return headFunc(node, depth)
    }

    public override func tail(node: Node, depth: Int64): Unit {
        return tailFunc(node, depth)
    }
}
