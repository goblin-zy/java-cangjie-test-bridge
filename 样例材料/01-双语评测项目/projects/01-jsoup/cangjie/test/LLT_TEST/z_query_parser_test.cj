package cangjie_tpc::html4cj

/*
 * Tests for the Selector Query Parser.
 */
@Test
public class QueryParserTest {
    @TestCase
    public func testConsumeSubQuery(): Unit {
        let doc: Document = Html4cj.parse(
            "<html><head>h</head><body>" + "<li><strong>l1</strong></li>" + "<a><li><strong>l2</strong></li></a>" +
                "<p><strong>yes</strong></p>" + "</body></html>"
        )
        @Assert("l1 l2 yes", doc.body().select(">p>strong,>*>li>strong").text())
        @Assert("l2 yes", doc.select("body>p>strong,body>*>li>strong").text())
        @Assert("yes", doc.select(">body>*>li>strong,>body>p>strong").text())
        @Assert("l2", doc.select(">body>p>strong,>body>*>li>strong").text())
    }

    @TestCase
    public func testOrGetsCorrectPrecedence(): Unit {
        // tests that a selector "a b, c d, e f" evals to (a AND b) OR (c AND d) OR (e AND f)"
        // top level or, three child ands
        let eval: Evaluator = QueryParser.parse("a b, c d, e f")
        @Assert(eval is CombiningEvaluatorOr)
        let or: CombiningEvaluatorOr = (eval as CombiningEvaluatorOr).getOrThrow()
        @Assert(3, or.evaluators.size)
        for (innerEval in or.evaluators) {
            @Assert(innerEval is CombiningEvaluatorAnd)
            let and: CombiningEvaluatorAnd = (innerEval as CombiningEvaluatorAnd).getOrThrow()
            @Assert(2, and.evaluators.size)
            @Assert(and.evaluators[0] is StructuralEvaluatorParent)
            @Assert(and.evaluators[1] is EvaluatorTag)
        }
    }

    @TestCase
    public func testParsesMultiCorrectly(): Unit {
        let query: String = ".foo > ol, ol > li + li"
        let eval: Evaluator = QueryParser.parse(query)
        @Assert(eval is CombiningEvaluatorOr)
        let or: CombiningEvaluatorOr = (eval as CombiningEvaluatorOr).getOrThrow()
        @Assert(2, or.evaluators.size)

        let andLeft: CombiningEvaluatorAnd = (or.evaluators[0] as CombiningEvaluatorAnd).getOrThrow()
        let andRight: CombiningEvaluatorAnd = (or.evaluators[1] as CombiningEvaluatorAnd).getOrThrow()

        @Assert(".foo > ol", andLeft.toString())
        @Assert(2, andLeft.evaluators.size)
        @Assert("ol > li + li", andRight.toString())
        @Assert(2, andRight.evaluators.size)
        @Assert(query, eval.toString())
    }

    @TestCase
    public func exceptionOnUncloseAttribute(): Unit {
        try {
            QueryParser.parse("section > a[href=\"]")
            throw Exception()
        } catch (e: SelectorParseException) {
            // expected
        }
    }

    @TestCase
    public func testParsesSingleQuoteInContains(): Unit {
        try {
            QueryParser.parse("p:contains(One \" One)")
            throw Exception()
        } catch (e: SelectorParseException) {
            // expected
        }
    }

    @TestCase
    public func exceptOnEmptySelector(): Unit {
        try {
            QueryParser.parse("")
            throw Exception()
        } catch (e: SelectorParseException) {
            // expected
        }
    }

    @TestCase
    public func okOnSpacesForeAndAft(): Unit {
        let parse: Evaluator = QueryParser.parse(" span div  ")
        @Assert("span div", parse.toString())
    }

    @TestCase
    public func structuralEvaluatorsToString(): Unit {
        let q: String = "a:not(:has(span.foo)) b d > e + f ~ g"
        let parse: Evaluator = QueryParser.parse(q)
        @Assert(q, parse.toString())
    }
}
