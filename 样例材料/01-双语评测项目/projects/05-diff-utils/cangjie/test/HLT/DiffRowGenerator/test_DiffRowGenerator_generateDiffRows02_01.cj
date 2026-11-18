// 3rd_party_lib:diffutils4cj/build/release/diffUtils4cj
// 3rd_party_lib_ohos:diffutils4cj/build/aarch64-linux-ohos/diffUtils4cj

import std.unittest.*
import std.unittest.testmacro.*
import diffUtils4cj.*
import std.collection.*

@Test
public class TestDiffRowGenerator{
    /***
        public func generateDiffRows(original: ArrayList<String>, revised: ArrayList<String>): ArrayList<DiffRow>
        测试场景: ignoreWhiteSpaces为true
    ***/
    let original=ArrayList<String>([" 1 2    ","34    ","    5 6","  78","12   ","3 4","56","7\\s8","12","34","56","7 8","12","34","5 6","78","12","34\\s","56","78","12","34","\\s56","78"])
    let revised=ArrayList<String>(["   910","9\\s11","\\s91 2\\s"])
    @TestCase
    func testDiffRowGeneratorGenerateDiffRows0201(): Unit {
        var builder=Builder().ignoreWhiteSpaces(true)
        let diffRowGenerator=builder.build()
        let re_generateDiffRows=diffRowGenerator.generateDiffRows(original,revised).toString()
        let exp_generateDiffRows="[[CHANGE, 1 2    ,   910], [CHANGE,34    ,9\\s11], [CHANGE,    5 6,\\s91 2\\s], [CHANGE,  78,], [CHANGE,12   ,], [CHANGE,3 4,], [CHANGE,56,], [CHANGE,7\\s8,], [CHANGE,12,], [CHANGE,34,], [CHANGE,56,], [CHANGE,7 8,], [CHANGE,12,], [CHANGE,34,], [CHANGE,5 6,], [CHANGE,78,], [CHANGE,12,], [CHANGE,34\\s,], [CHANGE,56,], [CHANGE,78,], [CHANGE,12,], [CHANGE,34,], [CHANGE,\\s56,], [CHANGE,78,]]"
        @Assert(re_generateDiffRows,exp_generateDiffRows)
    }
}