// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

public var returnTag: Int64 = -1
@Test
public class SrcRangeTest {
    @TestCase
    func testfilter_01(): Unit {
        var evaluator: testNodeVisitor = testNodeVisitor()
        var element: Element = Element("html")
        var element1: Element = Element("html1")
        evaluator.tail(element1, 11)
        @Assert(returnTag, 11)
        evaluator.head(element, 0)
        @Assert(returnTag, 0)
    }
}
public class testNodeVisitor <: NodeVisitor {
    init() {}

    public func head(node: Node, depth: Int64): Unit {
        if (node is Element) {
            if (depth < 0) {}
        }
        returnTag = depth
    }
    public func tail(node: Node, depth: Int64): Unit {
        if (node is Element) {
            if (depth < 0) {}
        }
        returnTag = depth
    }
}
