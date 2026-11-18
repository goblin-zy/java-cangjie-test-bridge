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
        public static func diff<T>(original: ArrayList<T>, revised: ArrayList<T>,equalizer: Equalizer<T>): Patch<T> where T <: Equal<T> & ToString
        测试场景:original==revised,均不为空
    ***/
    public var arrlist=ArrayList<String>(["value01","value01","value01","value01","value01","value01","value01"])
    @TestCase
    func testDiffUtilsDiff321(): Unit {
        var subEqualizer01=SubEqualizer01<String>()
        var pathch01=DiffUtils.diff(arrlist,arrlist,subEqualizer01)
        @Assert(pathch01.getDeltas().size,0)
    }
    @TestCase
    func testDiffUtilsDiff322(): Unit {
        var subEqualizer02=SubEqualizer02<String>()
        var pathch02=DiffUtils.diff(arrlist,arrlist,subEqualizer02)
        var deltas01=pathch02.getDeltas()
        @Assert(deltas01.size,1)
        @Assert(deltas01[0] is ChangeDelta<String>,true)
        @Assert(deltas01[0].getOriginal().getLines(),arrlist)
        @Assert(deltas01[0].getRevised().getLines(),arrlist)
    }
}