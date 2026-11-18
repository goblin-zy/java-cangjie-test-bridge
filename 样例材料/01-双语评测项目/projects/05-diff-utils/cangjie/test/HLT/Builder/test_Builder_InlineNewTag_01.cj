// 3rd_party_lib:diffutils4cj/build/release/diffUtils4cj
// 3rd_party_lib_ohos:diffutils4cj/build/aarch64-linux-ohos/diffUtils4cj

import std.unittest.*
import std.unittest.testmacro.*
import diffUtils4cj.*
import std.collection.*
@Test
public class TestBuilder{
    /***
        public func InlineNewTag(tag: String): Builder
        public func build(): DiffRowGenerator
        测试场景:设置与之前不一致
    ***/
    let original=ArrayList<String>(["12","34","56","78","12","34","56","78","12","34","56","7 8","12","34","56","78","12","34","56","78","12","34","56","78"])
    let revised=ArrayList<String>(["910","911","912"])
    @TestCase
    func testBuilderInlineNewTag01(): Unit {
        let delta01=getChangeDelta01()
        let delta02=getChangeDelta02()
        let delta03=getChangeDelta03()
        var patch=Patch<String>()
        patch.addDelta(delta01)
        patch.addDelta(delta02)
        patch.addDelta(delta03)
        var builder=Builder().showInlineDiffs(true).InlineNewTag("myNewTag")
        let diffRowGenerator=builder.build()
        let re_generateDiffRows=diffRowGenerator.generateDiffRows(original,revised,patch).toString()
        let exp_generateDiffRows="[[EQUAL,12,12], [EQUAL,34,34], [EQUAL,56,56], [CHANGE,14,14], [CHANGE,2,2], [CHANGE,3<span class=\"editOldInline\">6</span>,<myNewTag class=\"editNewInline\">9</myNewTag>3<myNewTag class=\"editNewInline\">4</myNewTag>], [CHANGE,4,4], [EQUAL,78,78], [EQUAL,12,12], [EQUAL,34,34], [CHANGE,7,7], [CHANGE,8,8], [CHANGE,9,9], [CHANGE,10,10], [CHANGE,3,3<myNewTag class=\"editNewInline\">4</myNewTag>], [CHANGE,<span class=\"editOldInline\">6</span>,<myNewTag class=\"editNewInline\">10</myNewTag>], [EQUAL,12,12], [EQUAL,34,34], [EQUAL,56,56], [EQUAL,78,78], [CHANGE,<span class=\"editOldInline\">4</span>,<myNewTag class=\"editNewInline\">11</myNewTag>], [CHANGE,7,7], [CHANGE,<span class=\"editOldInline\">6</span>,<myNewTag class=\"editNewInline\">34</myNewTag>], [EQUAL,78,78]]"
        @Assert(re_generateDiffRows,exp_generateDiffRows)
    }

    @TestCase
    func testBuilderInlineNewTag02(): Unit {
        let delta01=getChangeDelta01()
        let delta02=getChangeDelta02()
        let delta03=getChangeDelta03()
        var patch=Patch<String>()
        patch.addDelta(delta01)
        patch.addDelta(delta02)
        patch.addDelta(delta03)
        var builder=Builder().showInlineDiffs(true)
        let diffRowGenerator=builder.build()
        let re_generateDiffRows=diffRowGenerator.generateDiffRows(original,revised,patch).toString()
        let exp_generateDiffRows="[[EQUAL,12,12], [EQUAL,34,34], [EQUAL,56,56], [CHANGE,14,14], [CHANGE,2,2], [CHANGE,3<span class=\"editOldInline\">6</span>,<span class=\"editNewInline\">9</span>3<span class=\"editNewInline\">4</span>], [CHANGE,4,4], [EQUAL,78,78], [EQUAL,12,12], [EQUAL,34,34], [CHANGE,7,7], [CHANGE,8,8], [CHANGE,9,9], [CHANGE,10,10], [CHANGE,3,3<span class=\"editNewInline\">4</span>], [CHANGE,<span class=\"editOldInline\">6</span>,<span class=\"editNewInline\">10</span>], [EQUAL,12,12], [EQUAL,34,34], [EQUAL,56,56], [EQUAL,78,78], [CHANGE,<span class=\"editOldInline\">4</span>,<span class=\"editNewInline\">11</span>], [CHANGE,7,7], [CHANGE,<span class=\"editOldInline\">6</span>,<span class=\"editNewInline\">34</span>], [EQUAL,78,78]]"
        @Assert(re_generateDiffRows,exp_generateDiffRows)

    }
}
public func getChangeDelta01():ChangeDelta<String>{
    let chunk_ori_lines=ArrayList<String>(["14","2","36","4"])
    let chunk_ori=Chunk(3,chunk_ori_lines)
    let chunk_rev_lines=ArrayList<String>(["14","2","934","4"])
    let chunk_rev=Chunk(3,chunk_rev_lines)
    let changeDelta=ChangeDelta(chunk_ori,chunk_rev)
    return changeDelta
}

public func getChangeDelta02():ChangeDelta<String>{
    let chunk_ori_lines=ArrayList<String>(["7","8","9","10","3","6"])
    let chunk_ori=Chunk(10,chunk_ori_lines)
    let chunk_rev_lines=ArrayList<String>(["7","8","9","10","34","10"])
    let chunk_rev=Chunk(3,chunk_rev_lines)
    let changeDelta=ChangeDelta(chunk_ori,chunk_rev)
    return changeDelta
}

public func getChangeDelta03():ChangeDelta<String>{
    let chunk_ori_lines=ArrayList<String>(["4","7","6"])
    let chunk_ori=Chunk(20,chunk_ori_lines)
    let chunk_rev_lines=ArrayList<String>(["11","7","34"])
    let chunk_rev=Chunk(3,chunk_rev_lines)
    let changeDelta=ChangeDelta(chunk_ori,chunk_rev)
    return changeDelta
}