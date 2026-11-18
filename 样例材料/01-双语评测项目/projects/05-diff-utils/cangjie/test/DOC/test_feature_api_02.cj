// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

import std.unittest.*
import std.unittest.testmacro.*
import std.collection.*
import diffUtils4cj.*

main() {
    let ccc = Test_FeatureApi02()
    let tester = ccc.asTestSuite()
    let res = tester.runTests()
    res.failedCount
}
@Test
public class Test_FeatureApi02 {
    @TestCase
    public func testFeatureApi02(): Unit {
		var rev = ArrayList<String>(["hhh", "jjj", "kkk"])
		var orig= ArrayList<String>()
		var patch:  Patch<String>= DiffUtils.diff(rev, orig)
		var res = DiffUtils.patch(rev,patch)
        @Assert(res == orig, true)
    }
}