// 3rd_party_lib:diffutils4cj/build/release/diffUtils4cj
// 3rd_party_lib_ohos:diffutils4cj/build/aarch64-linux-ohos/diffUtils4cj

import std.unittest.*
import std.unittest.testmacro.*
import diffUtils4cj.*
import std.collection.*

@Test
public class TestBuilder{
    /***
        public func ignoreBlankLines(val: Bool): Builder
        public func build(): DiffRowGenerator
        测试场景:设置为true
    ***/
    let original=ArrayList<String>(["12","34","56","78","12","34","             ","56","78","12","34","56"," ","78","12","\t","34","56","78","12","34","56","78","12","34","56","78"])
    let revised=ArrayList<String>(["910","911","912"])
    @TestCase
    func testBuilderIgnoreBlankLines01(): Unit {
        let delta01=getChangeDelta01()
        let delta02=getChangeDelta02()
        let delta03=getChangeDelta03()
        var patch=Patch<String>()
        patch.addDelta(delta01)
        patch.addDelta(delta02)
        patch.addDelta(delta03)
        var builder=Builder().ignoreBlankLines(true)
        let diffRowGenerator=builder.build()
        let re_generateDiffRows=diffRowGenerator.generateDiffRows(original,revised,patch).toString()
        let exp_generateDiffRows="[[EQUAL,12,12], [EQUAL,34,34], [EQUAL,56,56], [CHANGE,1 4,1 4], [CHANGE,2,2], [CHANGE,3 6,9 34], [CHANGE,4,4], [EQUAL,56,56], [EQUAL,78,78], [EQUAL,12,12], [CHANGE,7,7], [CHANGE,8,8], [CHANGE,9,9], [CHANGE,1 0,1 0], [CHANGE,3,34], [CHANGE,6,10], [EQUAL,34,34], [EQUAL,56,56], [EQUAL,78,78], [EQUAL,12,12], [CHANGE,4,1 1], [CHANGE,7,7], [CHANGE,6,3 4], [EQUAL,12,12], [EQUAL,34,34], [EQUAL,56,56], [EQUAL,78,78]]"
        @Assert(re_generateDiffRows,exp_generateDiffRows)
        
    }
    @TestCase
    func testBuilderIgnoreBlankLines02(): Unit {
        let delta01=getChangeDelta01()
        let delta02=getChangeDelta02()
        let delta03=getChangeDelta03()
        var patch=Patch<String>()
        patch.addDelta(delta01)
        patch.addDelta(delta02)
        patch.addDelta(delta03)
        var builder=Builder()
        let diffRowGenerator=builder.build()
        let re_generateDiffRows=diffRowGenerator.generateDiffRows(original,revised,patch).toString()
        let exp_generateDiffRows="[[EQUAL,12,12], [EQUAL,34,34], [EQUAL,56,56], [CHANGE,1 4,1 4], [CHANGE,2,2], [CHANGE,3 6,9 34], [CHANGE,4,4], [EQUAL,56,56], [EQUAL,78,78], [EQUAL,12,12], [CHANGE,7,7], [CHANGE,8,8], [CHANGE,9,9], [CHANGE,1 0,1 0], [CHANGE,3,34], [CHANGE,6,10], [EQUAL,34,34], [EQUAL,56,56], [EQUAL,78,78], [EQUAL,12,12], [CHANGE,4,1 1], [CHANGE,7,7], [CHANGE,6,3 4], [EQUAL,12,12], [EQUAL,34,34], [EQUAL,56,56], [EQUAL,78,78]]"
        @Assert(re_generateDiffRows,exp_generateDiffRows)

    }
}
public func getChangeDelta01():ChangeDelta<String>{
    let chunk_ori_lines=ArrayList<String>(["1 4","2","3 6","4"])
    let chunk_ori=Chunk(3,chunk_ori_lines)
    let chunk_rev_lines=ArrayList<String>(["1 4","2","9 34","4"])
    let chunk_rev=Chunk(3,chunk_rev_lines)
    let changeDelta=ChangeDelta(chunk_ori,chunk_rev)
    return changeDelta
}

public func getChangeDelta02():ChangeDelta<String>{
    let chunk_ori_lines=ArrayList<String>(["7","8","9","1 0","3","6"])
    let chunk_ori=Chunk(10,chunk_ori_lines)
    let chunk_rev_lines=ArrayList<String>(["7","8","9","1 0","34","10"])
    let chunk_rev=Chunk(3,chunk_rev_lines)
    let changeDelta=ChangeDelta(chunk_ori,chunk_rev)
    return changeDelta
}

public func getChangeDelta03():ChangeDelta<String>{
    let chunk_ori_lines=ArrayList<String>(["4","7","6"])
    let chunk_ori=Chunk(20,chunk_ori_lines)
    let chunk_rev_lines=ArrayList<String>(["1 1","7","3 4"])
    let chunk_rev=Chunk(3,chunk_rev_lines)
    let changeDelta=ChangeDelta(chunk_ori,chunk_rev)
    return changeDelta
}