// 3rd_party_lib:diffutils4cj/build/release/diffUtils4cj
// 3rd_party_lib_ohos:diffutils4cj/build/aarch64-linux-ohos/diffUtils4cj

import std.unittest.*
import std.unittest.testmacro.*
import std.collection.*
import diffUtils4cj.*

@Test
public class TestDeleteDeltaV002{
    /***
        public init(original: Chunk<T>, revised: Chunk<T> )
        public func restore(target: ArrayList<T>): Unit
        测试场景:revised.getPosition()+rev_list.size > target.size
    ***/
    @TestCase
    func testDeleteDeltaRestore01(): Unit {
        var original=Chunk(-1,ArrayList<Int64>([1,2,3,4,5,6]))
        var revised=Chunk(1,[7,8,9,10,11,12])
        let deleteDelta=DeleteDelta(original,revised)
        var target=ArrayList<Int64>([1,2,3,4,5,6])
        deleteDelta.restore(target)
        var exp_target=ArrayList<Int64>([1, 1, 2, 3, 4, 5, 6, 2, 3, 4, 5, 6])
        @Assert(target,exp_target)

    }
}