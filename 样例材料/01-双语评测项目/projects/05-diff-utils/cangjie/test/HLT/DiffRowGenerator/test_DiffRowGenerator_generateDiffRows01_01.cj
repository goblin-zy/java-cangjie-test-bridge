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
        测试场景:patch没有delta,original,revised为空
    ***/
    @TestCase
    func testDiffRowGeneratorGenerateDiffRows0101(): Unit {
        let original=ArrayList<String>()
        let revised=ArrayList<String>()
        var patch=Patch<String>()
        var builder=Builder()
        let diffRowGenerator=builder.build()
        let re_generateDiffRows=diffRowGenerator.generateDiffRows(original,revised,patch).toString()
        @Assert(re_generateDiffRows,"[]")
    }
}