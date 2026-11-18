// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

@Test
public class SrcRangeTest {
    @TestCase
    func testfilter_01(): Unit {
        var evaluatorTag: TestEvaluator = TestEvaluator()
        var element: Element = Element("html")
        var element1: Element = Element("html1")
        var element2: Element = Element("html2")
        var element3: Element = Element("html3")
        var isBool: Bool = evaluatorTag.matches(element, element)
        @Assert(isBool, true)
        var isBool1: Bool = evaluatorTag.matches(element, element1)
        @Assert(isBool1, false)
        var isBool2: Bool = evaluatorTag.matches(element, element2)
        @Assert(isBool2, false)
        var isBool3: Bool = evaluatorTag.matches(element, element3)
        @Assert(isBool3, false)
    }

    @TestCase
    func testfilter_02(): Unit {
        var evaluatorTag: TestEvaluator = TestEvaluator()
        var src = evaluatorTag.toString()
        @Assert(src, "testEvaluator")
    }
}

public class TestEvaluator <: Evaluator {
    init() {
        super()
    }

    public override func matches(root: ?Element, element: Element): Bool {
        return refEq(root.getOrThrow(), element)
    }

    public func toString(): String {
        return "testEvaluator"
    }
}
