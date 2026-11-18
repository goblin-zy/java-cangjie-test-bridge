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
        测试场景:入参数组非空，存在非空元素,数组中值有+++开头,不能匹配到^@@\s+-(?:(\d+)(?:,(\d+))?)\s+\+(?:(\d+)(?:,(\d+))?)\s+@@$的元素,开头不是" ","+","-"
    ***/
    @TestCase
    func testDiffUtilsParseUnifiedDiff04(): Unit {
        let diff=ArrayList<String>(["+++","fsf"])
        let patch=DiffUtils.parseUnifiedDiff(diff)
        let deltas=patch.getDeltas()
        @Assert(deltas.size,0)
    }
}