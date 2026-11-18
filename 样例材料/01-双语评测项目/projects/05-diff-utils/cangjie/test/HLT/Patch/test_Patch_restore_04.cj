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
        测试场景:Patch中仅有DeleteDelta,target非空
    ***/
    @TestCase
    func testPatchRestore04(): Unit {
        var original=Chunk(1,ArrayList<Int64>([7, 3, 4, 5, 7, 8]))
        var revised=Chunk(1,[3,4,5,7,8,6])
        let deleteDelta=DeleteDelta(original,revised)
        var patch=Patch<Int64>()
        patch.addDelta(deleteDelta)
        var target=ArrayList<Int64>([2, 7, 1, 7, 1, 2, 3, 8, 9])
        let result=patch.restore(target)
        var exp_result=ArrayList<Int64>([2, 7, 3, 4, 5, 7, 8, 7, 1, 7, 1, 2, 3, 8, 9])
        @Assert(result,exp_result)
    }
}