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
        测试场景:patch没有delta,original,revised非空
    ***/
    @TestCase
    func testDiffRowGeneratorGenerateDiffRows0102(): Unit {
        let original=ArrayList<String>(["12","34","56","78"])
        let revised=ArrayList<String>(["910","911","912"])
        var patch=Patch<String>()
        var builder=Builder()
        let diffRowGenerator=builder.build()
        let re_generateDiffRows=diffRowGenerator.generateDiffRows(original,revised,patch).toString()
        var exp_generateDiffRows_tmp=ArrayList<DiffRow>()
        for (line in original){
            exp_generateDiffRows_tmp.add(DiffRow(Tag.EQUAL, line, line))
        }
        let exp_generateDiffRows=exp_generateDiffRows_tmp.toString()
        @Assert(re_generateDiffRows,exp_generateDiffRows)
    }
}