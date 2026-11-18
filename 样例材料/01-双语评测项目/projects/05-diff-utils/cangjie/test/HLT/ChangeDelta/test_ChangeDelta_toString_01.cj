// 3rd_party_lib:diffutils4cj/build/release/diffUtils4cj
// 3rd_party_lib_ohos:diffutils4cj/build/aarch64-linux-ohos/diffUtils4cj

import std.unittest.*
import std.unittest.testmacro.*
import std.collection.*
import diffUtils4cj.*

@Test
public class TestChangeDeltaV002{
    /***
        public init(original: Chunk<T>, revised: Chunk<T> )
        public func toString(): String
        测试场景:修订后内容(即;revised)是否为空序列-是
    ***/
    @TestCase
    func testChangeDeltaToString01(): Unit {
        var original=Chunk(123,ArrayList<Int64>([1,2,3,4,5,6]))
        var revised=Chunk(123,Array<Int64>())
        let changeDelta=ChangeDelta(original,revised)
        let re_act=changeDelta.toString()
        let re_exp="[ChangeDelta, position: ${original.getPosition()}, lines: ${original.getLines()} to ${revised.getLines()}]"
        @Assert(re_act,re_exp)
    }
}