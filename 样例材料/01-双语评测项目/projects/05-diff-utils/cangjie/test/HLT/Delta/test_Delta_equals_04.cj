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
        测试场景:抽象类，与其他子类对象对比,original，revised均不相等
    ***/
    @TestCase
    func testDeltaEquals04(): Unit {
        var original=Chunk(124,ArrayList<Int64>([1,2,3,4,5,6]))
        var revised=Chunk(123,[1,2,3,4,5,6])
        let insertDelta01=InsertDelta(original,revised)
        let insertDelta02=InsertDelta(revised,original)
        @Assert(insertDelta01.equals(insertDelta02),false)
    }
}