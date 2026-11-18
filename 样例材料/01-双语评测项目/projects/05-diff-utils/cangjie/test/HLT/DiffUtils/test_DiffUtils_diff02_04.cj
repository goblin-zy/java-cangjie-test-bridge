// 3rd_party_lib:diffutils4cj/build/release/diffUtils4cj
// 3rd_party_lib_ohos:diffutils4cj/build/aarch64-linux-ohos/diffUtils4cj
// dependence: ../common_Values.cj
import std.unittest.*
import std.unittest.testmacro.*
import std.collection.*
import diffUtils4cj.*

@Test
public class TestDiffUtilsB001{
    /***
        public static func diff<T>(original: ArrayList<T>, revised: ArrayList<T>,algorithm: DiffAlgorithm<T>): Patch<T> where T <: Equal<T> & ToString
        测试场景:original!=revised,original完全不等于revised
    ***/
    public var original=ArrayList<String>(["value01","value02","value03","value04","value05","value06","value07"])
    public var revised=ArrayList<String>(["value08","value09","value10","value11","value12","value13","value14"])
    @TestCase
    func testDiffUtilsDiff241(): Unit {
        var algorithm01=MyersDiff<String>()
        var pathch01=DiffUtils.diff(original,revised,algorithm01)
        var deltas01=pathch01.getDeltas()
        @Assert(deltas01.size,1)
        @Assert(deltas01[0] is ChangeDelta<String>,true)
        @Assert(deltas01[0].getOriginal().getLines(),original)
        @Assert(deltas01[0].getRevised().getLines(),revised)
    }
    @TestCase
    func testDiffUtilsDiff242(): Unit {
        var algorithm02=MyersDiff<String>(SubEqualizer01<String>())
        var pathch02=DiffUtils.diff(original,revised,algorithm02)
        var deltas02=pathch02.getDeltas()
        @Assert(deltas02.size,1)
        @Assert(deltas02[0] is ChangeDelta<String>,true)
        @Assert(deltas02[0].getOriginal().getLines(),original)
        @Assert(deltas02[0].getRevised().getLines(),revised)

    }
}