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
        测试场景:original!=revised,original有revised中没有的元素,original没有revised中有的元素
    ***/
    @TestCase
    func testDiffUtilsDiff131(): Unit {
        var original=ArrayList<String>(["value01","value02","value03","old","value04","value05","value06","value07"])
        var revised=ArrayList<String>(["value02","value03","value04","value05","value06","new","value07","value08"])
        var pathch01=DiffUtils.diff(original,revised)
        var deltas=pathch01.getDeltas()
        @Assert(deltas.size,4)
        @Assert(deltas[0] is DeleteDelta<String>,true)
        @Assert(deltas[0].getOriginal().getLines(),ArrayList<String>(["value01"]))
        @Assert(deltas[0].getRevised().getLines(),ArrayList<String>([]))

        @Assert(deltas[1] is DeleteDelta<String>,true)
        @Assert(deltas[1].getOriginal().getLines(),ArrayList<String>(["old"]))
        @Assert(deltas[1].getRevised().getLines(),ArrayList<String>([]))

        @Assert(deltas[2] is InsertDelta<String>,true)
        @Assert(deltas[2].getOriginal().getLines(),ArrayList<String>([]))
        @Assert(deltas[2].getRevised().getLines(),ArrayList<String>(["new"]))

        @Assert(deltas[3] is InsertDelta<String>,true)
        @Assert(deltas[3].getOriginal().getLines(),ArrayList<String>([]))
        @Assert(deltas[3].getRevised().getLines(),ArrayList<String>(["value08"]))
    }
}