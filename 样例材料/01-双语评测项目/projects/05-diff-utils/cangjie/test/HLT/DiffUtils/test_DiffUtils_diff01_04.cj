// 3rd_party_lib:diffutils4cj/build/release/diffUtils4cj
// 3rd_party_lib_ohos:diffutils4cj/build/aarch64-linux-ohos/diffUtils4cj

import std.unittest.*
import std.unittest.testmacro.*
import std.collection.*
import diffUtils4cj.*

@Test
public class TestDiffUtilsB001{
    /***
        public static func diff<T>( original: ArrayList<T>, revised: ArrayList<T>): Patch<T> where T <: Equal<T> & ToString
        测试场景:original!=revised,original完全不等于revised
    ***/
    @TestCase
    func testDiffUtilsDiff141(): Unit {
        var original=ArrayList<String>(["value01","value02","value03","value04","value05","value06","value07"])
        var revised=ArrayList<String>(["value08","value09","value10","value11","value12","value13","value14"])
        var patch01=DiffUtils.diff(original,revised)
        var deltas=patch01.getDeltas()
        @Assert(deltas.size,1)
        @Assert(deltas[0] is ChangeDelta<String>,true)
        @Assert(deltas[0].getOriginal().getLines(),original)
        @Assert(deltas[0].getRevised().getLines(),revised)
    }
}