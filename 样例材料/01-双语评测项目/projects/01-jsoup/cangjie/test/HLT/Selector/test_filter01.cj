// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

@Test
public class SrcRangeTest {
    @TestCase
    func testfilter_01(): Unit {
        var evaluator: MyNodeFilter = MyNodeFilter()
        var element: Element = Element("html")
        var element1: Element = Element("html1")
        var src = evaluator.head(element, 6)
        @Assert(src.toString(), "CONTINUE")
        var src1 = evaluator.tail(element1, 61)
        @Assert(src1.toString(), "SKIP_CHILDREN")
    }
}

public class MyNodeFilter <: NodeFilter {
    init() {}

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
        return FilterResult.SKIP_CHILDREN
    }
}
