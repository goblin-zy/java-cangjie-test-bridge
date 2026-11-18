// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*
import std.regex.*

@Test
public class NodeTest {
    @TestCase
    func testElement_60_01(): Unit {
        let cou = "<html><span><body><div><!-- a simple comment -->One</div><b> two </b></body></span></html>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("html").first().getOrThrow()
        let sc = str.shallowClone()
        @Assert(13,sc.toString().toRuneArray().size)
        @Assert(sc.toString().contains("<html></html>"),true)
    }

    @TestCase
    func testElement_60_02(): Unit {
        let cou = "<html><span><body><div><!-- a simple comment -->One</div><b> two </b></body></span></html>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("b").first().getOrThrow()
        let sc = str.shallowClone()
        @Assert(7,sc.toString().toRuneArray().size)
        @Assert(sc.toString().contains("<b></b>"),true)
    }

    @TestCase
    func testElement_60_03(): Unit {
        let cou = "<html><span><body><div><!-- a simple comment -->One</div><b> two </b></body></span></html>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("b").first().getOrThrow()
        let sc = str.traverse(TestNodeVisitor(ArrayList<Int64>()))
        @Assert(12,sc.toString().toRuneArray().size)
        @Assert(sc.toString().contains("<b> two </b>"),true)
    }

    @TestCase
    func testElement_60_04(): Unit {
        let cou = "<html><span><body><div><!-- a simple comment -->One</div><b> two </b></body></span></html>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("b").first().getOrThrow()
        let sc = str.filter(TestNodeFilter())
        @Assert(12,sc.toString().toRuneArray().size)
        @Assert(sc.toString().contains("<b> two </b>"),true)
    }
}
class TestNodeVisitor <: NodeVisitor {
    var cour: ArrayList<Int64>

    public init(cour: ArrayList<Int64>) {
        this.cour = cour
    }
    public override func head(node: Node, depth: Int64): Unit {
        if (node is Element) {}
        cour.add(depth)
    }

    public override func tail(node: Node, depth: Int64): Unit {
        if (node is Element) {}
        cour.add(depth)
    }
}

class TestNodeFilter <: NodeFilter {
    public override func head(node: Node, depth: Int64): FilterResult {
        if (node is Element) {
            if (depth < 0) {
                return FilterResult.STOP
            }
        }
        return FilterResult.CONTINUE
    }

    public override func tail(node: Node, depth: Int64): FilterResult {
        if (node is Element) {
            if (depth < 0) {
                return FilterResult.STOP
            }
        }
        return FilterResult.CONTINUE
    }
}
