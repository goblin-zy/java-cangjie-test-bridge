// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

@Test
public class NodeTest {
    @TestCase
    func testNode_14_01(): Unit {
        var doc = Html4cj.parse("<p>One <em>four</em><b>two</b> three</p>")
        var str = doc.select("b").first().getOrThrow()
        var cou: ArrayList<Int64> = ArrayList<Int64>()
        let sc = str.traverse(TestNodeVisitor(cou))
        @Assert(str,sc)
        @Assert("<b>two</b>",str.toString())
    }

    @TestCase
    func testNode_14_02(): Unit {
        var doc = Html4cj.parse("<div><p>One <em>four</em><b>two</b> three</p>five")
        var str = doc.select("div").first().getOrThrow()
        let sc = str.filter(Test2NodeVisitor())
        @Assert(refEq(str, sc),true)
    }

    @TestCase
    func testNode_14_03(): Unit {
        var doc = Html4cj.parse("<div><p>One <em>four</em><b>two</b> three</p>five")
        var str = doc.select("div").first().getOrThrow()
        let sc = str.filter(Test2NodeVisitor())
        @Assert(refEq(str, sc),true)
    }

    @TestCase
    func testNode_14_04(): Unit {
        var doc = Html4cj.parse("<div><p>One <em>four</em><b>two</b> three</p>five")
        var str = doc.select("div").first().getOrThrow()
        let sc = str.outerHtml()
        @Assert("<div>\n <p>One <em>four</em><b>two</b> three</p>five\n</div>",sc)
    }

    @TestCase
    func testNode_14_05(): Unit {
        var doc = Html4cj.parse("<div><!-- a simple comment -->")
        var str = doc.childNode(0)
        let sc = str.outerHtml()
        let sccc = ###"<html>
 <head></head>
 <body>
  <div>
   <!-- a simple comment -->
  </div>
 </body>
</html>"###
        @Assert(sccc,sc)
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

class Test2NodeVisitor <: NodeFilter {
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
