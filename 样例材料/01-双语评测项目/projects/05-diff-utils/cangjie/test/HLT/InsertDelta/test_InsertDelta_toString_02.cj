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
        public func toString(): String
        测试场景:修订后内容(即;revised)是否为空序列-否
    ***/
    @TestCase
    func testInsertDeltaToString02(): Unit {
        var original=Chunk(123,ArrayList<Int64>([1,2,3,4,5,6]))
        var revised=Chunk(123,[7,8,9,10,11,12])
        let insertDelta=InsertDelta(original,revised)
        let re_act=insertDelta.toString()
        let re_exp="[InsertDelta, position: ${original.getPosition()}, lines: ${revised.getLines()}]"
        @Assert(re_act,re_exp)
    }
}