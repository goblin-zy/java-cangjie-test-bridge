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
        测试场景:patch仅有InsertDelta,original,revised非空,且chunk_ori_lines.size<chunk_rev_lines.size
    ***/
    @TestCase
    func testDiffRowGeneratorGenerateDiffRows0108(): Unit {
        let original=ArrayList<String>(["12","34","56","78","12","34","56","78","12","34","56","78"])
        let revised=ArrayList<String>(["910","911","912"])
        var patch=Patch<String>()
        let chunk_ori_lines=ArrayList<String>(["1\t4","2","3<6"])
        let chunk_ori=Chunk(3,chunk_ori_lines)
        let chunk_rev_lines=ArrayList<String>(["7>11","8\t\t7","9<34","10"])
        let chunk_rev=Chunk(3,chunk_rev_lines)
        let insertDelta=InsertDelta(chunk_ori,chunk_rev)
        patch.addDelta(insertDelta)
        var builder=Builder()
        let diffRowGenerator=builder.build()
        let re_generateDiffRows=diffRowGenerator.generateDiffRows(original,revised,patch).toString()
        let exp_generateDiffRows="[[EQUAL,12,12], [EQUAL,34,34], [EQUAL,56,56], [INSERT,,7&gt;11], [INSERT,,8        7], [INSERT,,9&lt;34], [INSERT,,10], [EQUAL,56,56], [EQUAL,78,78], [EQUAL,12,12], [EQUAL,34,34], [EQUAL,56,56], [EQUAL,78,78]]"
        @Assert(re_generateDiffRows,exp_generateDiffRows)
    }
}

