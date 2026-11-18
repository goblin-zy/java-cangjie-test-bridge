// 3rd_party_lib:diffutils4cj/build/release/diffUtils4cj
// 3rd_party_lib_ohos:diffutils4cj/build/aarch64-linux-ohos/diffUtils4cj

import std.unittest.*
import std.unittest.testmacro.*
import diffUtils4cj.*
import std.collection.*

@Test
public class TestDiffRowGenerator{
    /***
        public func generateDiffRows(original: ArrayList<String>, revised: ArrayList<String>, patch: Patch<String>): ArrayList<DiffRow>
        测试场景:patch有DeleteDelta,ChangeDelta,InsertDelta,且original,revised非空
    ***/
    @TestCase
    func testDiffRowGeneratorGenerateDiffRows0112(): Unit {
        let original=ArrayList<String>(["12","34","56","78","12","34","56","78","12","34","56","78","12","34","56","78","12","34","56","78","12","34","56","78"])
        let revised=ArrayList<String>(["910","911","912"])
        var patch=Patch<String>()
        let chunk_ori_lines=ArrayList<String>(["1\t4","2","3<6"])
        let chunk_ori_in=Chunk(3,chunk_ori_lines)
        let chunk_ori_ch=Chunk(10,chunk_ori_lines)
        let chunk_ori_de=Chunk(20,chunk_ori_lines)
        let chunk_rev_lines=ArrayList<String>(["7>11","8\t\t7","9<34","10","9<34","10"])
        let chunk_rev_in=Chunk(3,chunk_rev_lines)
        let chunk_rev_ch=Chunk(3,chunk_rev_lines)
        let chunk_rev_de=Chunk(3,chunk_rev_lines)
        let insertDelta=InsertDelta(chunk_ori_in,chunk_rev_in);
        let changeDelta=ChangeDelta(chunk_ori_ch,chunk_rev_ch);
        let deleteDelta=DeleteDelta(chunk_ori_de,chunk_rev_de);
        patch.addDelta(insertDelta)
        patch.addDelta(deleteDelta)
        patch.addDelta(changeDelta)
        var builder=Builder()
        let diffRowGenerator=builder.build()
        let re_generateDiffRows=diffRowGenerator.generateDiffRows(original,revised,patch).toString()
        let exp_generateDiffRows="[[EQUAL,12,12], [EQUAL,34,34], [EQUAL,56,56], [INSERT,,7&gt;11], [INSERT,,8        7], [INSERT,,9&lt;34], [INSERT,,10], [INSERT,,9&lt;34], [INSERT,,10], [EQUAL,56,56], [EQUAL,78,78], [EQUAL,12,12], [EQUAL,34,34], [CHANGE,1    4,7&gt;11], [CHANGE,2,8        7], [CHANGE,3&lt;6,9&lt;34], [CHANGE,,10], [CHANGE,,9&lt;34], [CHANGE,,10], [EQUAL,34,34], [EQUAL,56,56], [EQUAL,78,78], [EQUAL,12,12], [EQUAL,34,34], [EQUAL,56,56], [EQUAL,78,78], [DELETE,1    4,], [DELETE,2,], [DELETE,3&lt;6,], [EQUAL,78,78]]"
        @Assert(re_generateDiffRows,exp_generateDiffRows)
    }
}

