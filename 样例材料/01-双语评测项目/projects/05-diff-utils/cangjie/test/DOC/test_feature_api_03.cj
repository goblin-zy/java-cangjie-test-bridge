// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

import std.math.*
import std.unittest.*
import std.unittest.testmacro.*
import std.collection.*
import diffUtils4cj.*

main() {
    let ccc = Test_FeatureApi03()
    let tester = ccc.asTestSuite()
    let res = tester.runTests()
    res.failedCount
}
@Test
public class Test_FeatureApi03 {
    @TestCase
    public func testFeatureApi03(): Unit {
		var first = "anything \n \nother\nmore lines"
		var second ="anything\n\nother\nsome more lines"
		var generator = Builder().ignoreWhiteSpaces(true).columnWidth(Int64.Max).build()
		var rows = generator.generateDiffRows(ArrayList<String>(first.split("\n")), ArrayList<String>(second.split("\n")))
			
		@Assert(rows.size,4)
		@Assert(rows.get(0).getOrThrow().getTag().toString(),"EQUAL")
		@Assert(rows.get(1).getOrThrow().getTag().toString(),"EQUAL")
        @Assert(rows.get(2).getOrThrow().getTag().toString(),"EQUAL")
        @Assert(rows.get(3).getOrThrow().getTag().toString(),"CHANGE")
    }
}