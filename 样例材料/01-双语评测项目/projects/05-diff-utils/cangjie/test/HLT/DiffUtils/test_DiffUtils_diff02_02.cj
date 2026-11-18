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
        测试场景:original==revised,均不为空
    ***/
    public var arrlist=ArrayList<String>(["value01","value01","value01","value01","value01","value01","value01"])
    @TestCase
    func testDiffUtilsDiff221(): Unit {
        var algorithm01=MyersDiff<String>()
        var pathch01=DiffUtils.diff(arrlist,arrlist,algorithm01)
        @Assert(pathch01.getDeltas().size,0)
    }
    @TestCase
    func testDiffUtilsDiff222(): Unit {
        var algorithm02=MyersDiff<String>(SubEqualizer01<String>())
        var pathch02=DiffUtils.diff(arrlist,arrlist,algorithm02)
        @Assert(pathch02.getDeltas().size,0)
    }
}