// 3rd_party_lib:diffutils4cj/build/release/diffUtils4cj
// 3rd_party_lib_ohos:diffutils4cj/build/aarch64-linux-ohos/diffUtils4cj

import std.unittest.*
import std.unittest.testmacro.*
import std.collection.*
import diffUtils4cj.*

@Test
public class TestPatchV002{
    /***
        public init()
        public func restore(target: ArrayList<T>): ArrayList<T>
        测试场景:Patch中仅有InsertDelta,target非空
    ***/
    @TestCase
    func testPatchRestore03(): Unit {
        var original=Chunk(1,ArrayList<Int64>([10, 11, 12, 13, 14]))
        var revised=Chunk(1,[3,4,5,7,8,6])
        let insertDelta=InsertDelta(original,revised)
        var patch=Patch<Int64>()
        patch.addDelta(insertDelta)
        var target=ArrayList<Int64>([2, 7, 1, 7, 1, 2, 3, 8, 9])
        let result=patch.restore(target)
        var exp_result=ArrayList<Int64>([2, 8, 9])
        @Assert(result,exp_result)
    }
}