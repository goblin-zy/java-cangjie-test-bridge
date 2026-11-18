// 3rd_party_lib:diffutils4cj/build/release/diffUtils4cj
// 3rd_party_lib_ohos:diffutils4cj/build/aarch64-linux-ohos/diffUtils4cj

import std.unittest.*
import std.unittest.testmacro.*
import std.collection.*
import diffUtils4cj.*

@Test
public class TestInsertDeltaV002{
    /***
        public init(original: Chunk<T>, revised: Chunk<T> )
        public func restore(target: ArrayList<T>): Unit
        测试场景:revised.getPosition()+rev_list.size < target.size
    ***/
    @TestCase
    func testInsertDeltaRestore03(): Unit {
        var original=Chunk(-1,ArrayList<Int64>([1,2,3,4,5,6]))
        var revised=Chunk(2,[7,8,9])
        let insertDeltaRestore=InsertDelta(original,revised)
        var target=ArrayList<Int64>([1,2,3,4,5,6])
        insertDeltaRestore.restore(target)
        let exp_target=ArrayList<Int64>([1,2,6])
        @Assert(target,exp_target)

    }
}