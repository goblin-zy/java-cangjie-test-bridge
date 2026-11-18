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
        测试场景:入参数组非空，存在空元素且,数组中值有+++开头,
    ***/
    @TestCase
    func testDiffUtilsParseUnifiedDiff04(): Unit {
        let diff=ArrayList<String>(["+++",""])
        let patch=DiffUtils.parseUnifiedDiff(diff)
        let deltas=patch.getDeltas()
        @Assert(deltas.size,1)
        let delta01=(deltas[0] as ChangeDelta<String>).getOrThrow()
        let re_delta01=delta01.toString()
        let exp_delta="[ChangeDelta, position: -1, lines: [] to []]"
        @Assert(re_delta01,exp_delta)
    }
}