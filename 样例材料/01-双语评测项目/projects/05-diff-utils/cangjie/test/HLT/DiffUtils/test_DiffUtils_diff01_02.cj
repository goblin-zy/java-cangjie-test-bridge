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
        测试场景:original==revised,均不为空
    ***/
    @TestCase
    func testDiffUtilsDiff121(): Unit {
        var arr=ArrayList<String>(["value01","value01","value01","value01","value01","value01","value01"])
        var pathch01=DiffUtils.diff(arr,arr)
        @Assert(pathch01.getDeltas().size,0)
    }
}