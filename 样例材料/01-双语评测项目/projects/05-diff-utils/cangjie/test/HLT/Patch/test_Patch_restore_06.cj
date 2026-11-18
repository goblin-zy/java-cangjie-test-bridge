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
        测试场景:Patch中有多个节点
    ***/
    @TestCase
    func testPatchRestore06(): Unit {
        var original01=Chunk(2,ArrayList<Int64>([1,2,3]))
        var original02=Chunk(1,ArrayList<Int64>([7, 3, 4, 5, 7, 8]))
        var original03=Chunk(1,ArrayList<Int64>([10, 11, 12, 13, 14]))
        var revised01=Chunk(3,[3,4,5,7,8,6])
        var revised02=Chunk(1,[3,4,5,7,8,6])
        var revised03=Chunk(1,[3,4,5,7,8,6])
        let changeDelta=ChangeDelta(original01,revised01)
        let deleteDelta=DeleteDelta(original02,revised02)
        let insertDelta=InsertDelta(original03,revised03)
        var patch=Patch<Int64>()
        patch.addDelta(changeDelta)
        patch.addDelta(insertDelta)
        patch.addDelta(deleteDelta)
        var target=ArrayList<Int64>([2, 7, 1, 2, 3, 8, 9, 7, 1])
        let result=patch.restore(target)
        var exp_result=ArrayList<Int64>([2, 7, 1, 1, 2, 3])
        @Assert(result,exp_result)
    }
}