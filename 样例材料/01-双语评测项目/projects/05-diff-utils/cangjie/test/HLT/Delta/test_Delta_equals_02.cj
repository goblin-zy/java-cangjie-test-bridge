// 3rd_party_lib:diffutils4cj/build/release/diffUtils4cj
// 3rd_party_lib_ohos:diffutils4cj/build/aarch64-linux-ohos/diffUtils4cj

import std.unittest.*
import std.unittest.testmacro.*
import std.collection.*
import diffUtils4cj.*

@Test
public class TestDeltaV002{
    /***
        public init(original: Chunk<T>, revised: Chunk<T> )
        public func equals(obj: Delta<T>): Bool
        测试场景:抽象类，与其他子类对象对比,original，revised均相等
    ***/
    @TestCase
    func testDeltaEquals02(): Unit {
        var original=Chunk(123,ArrayList<Int64>([1,2,3,4,5,6]))
        var revised=Chunk(123,[1,2,3,4,5,6])
        let changeDelta=ChangeDelta(original,revised)
        let deleteDelta=DeleteDelta(original,revised)
        let insertDelta=InsertDelta(original,revised)
        @Assert(changeDelta.equals(deleteDelta),true)
        @Assert(deleteDelta.equals(insertDelta),true)
        @Assert(insertDelta.equals(changeDelta),true)
    }
}