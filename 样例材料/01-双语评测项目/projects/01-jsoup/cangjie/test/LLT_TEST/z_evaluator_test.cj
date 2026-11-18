package cangjie_tpc::html4cj

@Test
public class EvaluatorTest {
    @TestCase
    public func initTest(): Unit {
        // 1
        var testEvaluator: TestEvaluator = TestEvaluator()
        @Assert(testEvaluator.toString(), "")

        println("Pass1")
    }
}

@Test
public class EvaluatorTagTest {
    @TestCase
    public func initTest(): Unit {
        // 1
        var evaluatorTag: EvaluatorTag = EvaluatorTag("html")
        @Assert(evaluatorTag.toString(), "html")
        var element: Element = Element("html")
        var isBool: Bool = evaluatorTag.matches(element, element)
        @Assert(isBool, true)

        println("Pass1")
    }
}

public class TestEvaluator <: Evaluator {
    init() {
        super()
    }

    public override func matches(root: ?Element, element: Element): Bool {
        (root, element)
        return true
    }

    public func toString(): String {
        return ""
    }
}
