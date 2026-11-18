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
        测试场景:revised.getPosition()+rev_list.size = target.size
    ***/
    @TestCase
    func testInsertDeltaRestore02(): Unit {
        var original=Chunk(2,ArrayList<Int64>([1,2,3,4,5,6]))
        var revisedRestore=Chunk(0,[7,8,9,10,11,12])
        let insertDeltaRestore=InsertDelta(original,revisedRestore)
        var targetRestore=ArrayList<Int64>([1,2,3,4,5,6])
        insertDeltaRestore.restore(targetRestore)
        @Assert(targetRestore,ArrayList<Int64>())

    }
}