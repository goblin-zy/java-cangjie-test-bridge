// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

import std.unittest.*
import std.unittest.testmacro.*
import std.collection.*
import diffUtils4cj.*

main() {
    let ccc = Test_FeatureApi01()
    let tester = ccc.asTestSuite()
    let res = tester.runTests()
    res.failedCount
}
@Test
public class Test_FeatureApi01 {
    @TestCase
    public func testFeatureApi01(): Unit {
		var patch:  Patch<String>= DiffUtils.diff(ArrayList<String>(["hhh"]), ArrayList<String>(["hhh", "jjj", "kkk"]))
		@Assert(patch.getDeltas().isEmpty(),false)
		@Assert(patch.getDeltas().size,1)

		var  delta = patch.getDeltas().get(0).getOrThrow()
		@Assert(delta is InsertDelta<String>, true)
        @Assert(delta.getOriginal().getLines().isEmpty(), true)
        @Assert(delta.getRevised().getLines().toArray().toString(), "[jjj, kkk]")
    }
}