// 3rd_party_lib:diffutils4cj/build/release/diffUtils4cj
// 3rd_party_lib_ohos:diffutils4cj/build/aarch64-linux-ohos/diffUtils4cj

import std.unittest.*
import std.unittest.testmacro.*
import std.collection.*
import diffUtils4cj.*

@Test
public class TestDiffUtilsV002{
    /***
        public static func generateUnifiedDiff(original: String, revised: String, originalLines: ArrayList<String>, patch: Patch<String>,contextSize: Int64): ArrayList<String>
        测试场景:入参patch没有delta
    ***/
    @TestCase
    func testDiffUtilsGenerateUnifiedDiff01(): Unit {
        let original="original"
        let revised="revised"
        let originalLines=ArrayList<String>(["line01","line02","line03"])
        let patch=Patch<String>()
        let contextSize=10
        let re_generateUnifiedDiff=DiffUtils.generateUnifiedDiff(original,revised,originalLines,patch,contextSize)
        let exp_generateUnifiedDiff=ArrayList<String>()
        @Assert(re_generateUnifiedDiff,exp_generateUnifiedDiff)
    }
}