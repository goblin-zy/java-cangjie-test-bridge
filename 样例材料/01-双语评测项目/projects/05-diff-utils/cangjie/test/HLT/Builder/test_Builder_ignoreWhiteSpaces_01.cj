// 3rd_party_lib:diffutils4cj/build/release/diffUtils4cj
// 3rd_party_lib_ohos:diffutils4cj/build/aarch64-linux-ohos/diffUtils4cj

import std.unittest.*
import std.unittest.testmacro.*
import diffUtils4cj.*
import std.collection.*
@Test
public class TestBuilder{
    /***
        public func ignoreWhiteSpaces(val: Bool): Builder
        public func build(): DiffRowGenerator
        测试场景:设置为true
    ***/
    let original=ArrayList<String>([" 1 2    ","34    ","    5 6","  78","12   ","3 4","56","7\\s8","12","34","56","7 8","12","34","5 6","78","12","34\\s","56","78","12","34","\\s56","78"])
    let revised=ArrayList<String>(["   910","9\\s11","\\s91 2\\s"])
    @TestCase
    func testBuilderIgnoreWhiteSpaces01(): Unit {
        let delta01=getChangeDelta01()
        let delta02=getChangeDelta02()
        let delta03=getChangeDelta03()
        var patch=Patch<String>()
        patch.addDelta(delta01)
        patch.addDelta(delta02)
        patch.addDelta(delta03)
        var builder=Builder().ignoreWhiteSpaces(true)
        let diffRowGenerator=builder.build()
        let re_generateDiffRows=diffRowGenerator.generateDiffRows(original,revised,patch).toString()
        let exp_generateDiffRows="[[EQUAL, 1 2    , 1 2    ], [EQUAL,34    ,34    ], [EQUAL,    5 6,    5 6], [CHANGE,1 4,1 4], [CHANGE,2\\s,2], [CHANGE,3 6,9 34\\s], [CHANGE,4,4], [EQUAL,7\\s8,7\\s8], [EQUAL,12,12], [EQUAL,34,34], [CHANGE,7\\s,7], [CHANGE,8,\\s8], [CHANGE,\\s9,9\\s\\s], [CHANGE,1 0,1 0], [CHANGE,3,3\\s4], [CHANGE,6,10], [EQUAL,12,12], [EQUAL,34\\s,34\\s], [EQUAL,56,56], [EQUAL,78,78], [CHANGE,4,1\\s1], [CHANGE,7\\s,7], [CHANGE,6,3 4\\s], [EQUAL,78,78]]"
        @Assert(re_generateDiffRows,exp_generateDiffRows)
    }

    @TestCase
    func testBuilderIgnoreWhiteSpaces02(): Unit {
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
        let exp_generateDiffRows="[[EQUAL, 1 2    , 1 2    ], [EQUAL,34    ,34    ], [EQUAL,    5 6,    5 6], [CHANGE,1 4,1 4], [CHANGE,2\\s,2], [CHANGE,3 6,9 34\\s], [CHANGE,4,4], [EQUAL,7\\s8,7\\s8], [EQUAL,12,12], [EQUAL,34,34], [CHANGE,7\\s,7], [CHANGE,8,\\s8], [CHANGE,\\s9,9\\s\\s], [CHANGE,1 0,1 0], [CHANGE,3,3\\s4], [CHANGE,6,10], [EQUAL,12,12], [EQUAL,34\\s,34\\s], [EQUAL,56,56], [EQUAL,78,78], [CHANGE,4,1\\s1], [CHANGE,7\\s,7], [CHANGE,6,3 4\\s], [EQUAL,78,78]]"
        @Assert(re_generateDiffRows,exp_generateDiffRows)
    }
}
public func getChangeDelta01():ChangeDelta<String>{
    let chunk_ori_lines=ArrayList<String>(["1 4","2\\s","3 6","4"])
    let chunk_ori=Chunk(3,chunk_ori_lines)
    let chunk_rev_lines=ArrayList<String>(["1 4","2","9 34\\s","4"])
    let chunk_rev=Chunk(3,chunk_rev_lines)
    let changeDelta=ChangeDelta(chunk_ori,chunk_rev)
    return changeDelta
}

public func getChangeDelta02():ChangeDelta<String>{
    let chunk_ori_lines=ArrayList<String>(["7\\s","8","\\s9","1 0","3","6"])
    let chunk_ori=Chunk(10,chunk_ori_lines)
    let chunk_rev_lines=ArrayList<String>(["7","\\s8","9\\s\\s","1 0","3\\s4","10"])
    let chunk_rev=Chunk(3,chunk_rev_lines)
    let changeDelta=ChangeDelta(chunk_ori,chunk_rev)
    return changeDelta
}

public func getChangeDelta03():ChangeDelta<String>{
    let chunk_ori_lines=ArrayList<String>(["4","7\\s","6"])
    let chunk_ori=Chunk(20,chunk_ori_lines)
    let chunk_rev_lines=ArrayList<String>(["1\\s1","7","3 4\\s"])
    let chunk_rev=Chunk(3,chunk_rev_lines)
    let changeDelta=ChangeDelta(chunk_ori,chunk_rev)
    return changeDelta
}