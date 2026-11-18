// 3rd_party_lib:diffutils4cj/build/release/diffUtils4cj
// 3rd_party_lib_ohos:diffutils4cj/build/aarch64-linux-ohos/diffUtils4cj

import std.unittest.*
import std.unittest.testmacro.*
import std.collection.*
import diffUtils4cj.*

@Test
public class TestDiffUtilsV002{
    /***
        public static func parseUnifiedDiff(diff: ArrayList<String>): Patch<String>
        测试场景:入参数组为空
    ***/
    @TestCase
    func testDiffUtilsParseUnifiedDiff01(): Unit {
        let diff=ArrayList<String>()
        let patch=DiffUtils.parseUnifiedDiff(diff)
        let deltas=patch.getDeltas()
        @Assert(deltas.size,0)
    }
}