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
        测试场景:入参patch有多个delta,且存在(position + delta.getOriginal().size() + contextSize) < (nextDelta.getOriginal().getPosition() - contextSize)
    ***/
    @TestCase
    func testDiffUtilsGenerateUnifiedDiff04(): Unit {
        let original="original"
        let revised="revised"
        let originalLines=ArrayList<String>(["line01","line02","line03","line01","line02","line03","line01","line02","line03","line01","line02","line03","line01","line02","line03","line01","line02","line03","line01","line02","line03","line01","line02","line03","line01","line02","line03"])
        let delta01=getChangeDelta()
        let delta02=getDeleteDelta()
        let delta03=getInsertDelta()
        let patch=Patch<String>()
        patch.addDelta(delta01)
        patch.addDelta(delta02)
        patch.addDelta(delta03)
        let contextSize=10
        let re_generateUnifiedDiff=DiffUtils.generateUnifiedDiff(original,revised,originalLines,patch,contextSize)
        let exp_generateUnifiedDiff=ArrayList<String>(["--- original", "+++ revised", "@@ -1,17 +1,17 @@",  " line01", "-ele01c", "-ele02c", "-ele03c", "+ele04c", "+ele05c", "+ele06c",
                                                        "-ele01i", "-ele02i", "-ele03i", "+ele04i", "+ele05i", "+ele06i",  " line02",  " line03",  " line01",  " line02",  " line03",
                                                        " line01",  " line02",  " line03",  " line01",  " line02", "@@ -16,13 +1,13 @@",  " line01",  " line02",  " line03",  " line01",  " line02",
                                                        " line03",  " line01",  " line02",  " line03",  " line01", "-ele01d", "-ele02d", "-ele03d", "+ele04d", "+ele05d", "+ele06d"])
        @Assert(re_generateUnifiedDiff,exp_generateUnifiedDiff)
    }
}

public func getChangeDelta():ChangeDelta<String>{
    let ori_arr=ArrayList<String>(["ele01c","ele02c","ele03c"])
    let rev_arr=ArrayList<String>(["ele04c","ele05c","ele06c"])
    let ori_chunk=Chunk<String>(1,ori_arr)
    let rev_chunk=Chunk<String>(5,rev_arr)
    let changeDelta=ChangeDelta<String>(ori_chunk,rev_chunk)
    return changeDelta
}
public func getDeleteDelta():DeleteDelta<String>{
    let ori_arr=ArrayList<String>(["ele01d","ele02d","ele03d"])
    let rev_arr=ArrayList<String>(["ele04d","ele05d","ele06d"])
    let ori_chunk=Chunk<String>(25,ori_arr)
    let rev_chunk=Chunk<String>(2,rev_arr)
    let deleteDelta=DeleteDelta<String>(ori_chunk,rev_chunk)
    return deleteDelta
}
public func getInsertDelta():InsertDelta<String>{
    let ori_arr=ArrayList<String>(["ele01i","ele02i","ele03i"])
    let rev_arr=ArrayList<String>(["ele04i","ele05i","ele06i"])
    let ori_chunk=Chunk<String>(1,ori_arr)
    let rev_chunk=Chunk<String>(5,rev_arr)
    let insertDelta=InsertDelta<String>(ori_chunk,rev_chunk)
    return insertDelta
}