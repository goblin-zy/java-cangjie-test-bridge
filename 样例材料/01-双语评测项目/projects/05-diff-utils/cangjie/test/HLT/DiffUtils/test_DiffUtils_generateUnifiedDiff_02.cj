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
        测试场景:入参patch仅有一个delta
    ***/
    @TestCase
    func testDiffUtilsGenerateUnifiedDiff02(): Unit {
        let original="original"
        let revised="revised"
        let originalLines=ArrayList<String>(["line01","line02","line03"])
        let delta01=getChangeDelta()
        let patch=Patch<String>()
        patch.addDelta(delta01)
        let contextSize=10
        let re_generateUnifiedDiff=DiffUtils.generateUnifiedDiff(original,revised,originalLines,patch,contextSize)
        let exp_generateUnifiedDiff=ArrayList<String>(["--- original", "+++ revised", "@@ -1,4 +1,4 @@"," line01", "-ele01", "-ele02", "-ele03", "+ele04", "+ele05", "+ele06"])
        @Assert(re_generateUnifiedDiff,exp_generateUnifiedDiff)
    }
}

public func getChangeDelta():ChangeDelta<String>{
    let ori_arr=ArrayList<String>(["ele01","ele02","ele03"])
    let rev_arr=ArrayList<String>(["ele04","ele05","ele06"])
    let ori_chunk=Chunk<String>(1,ori_arr)
    let rev_chunk=Chunk<String>(5,rev_arr)
    let changeDelta=ChangeDelta<String>(ori_chunk,rev_chunk)
    return changeDelta
}