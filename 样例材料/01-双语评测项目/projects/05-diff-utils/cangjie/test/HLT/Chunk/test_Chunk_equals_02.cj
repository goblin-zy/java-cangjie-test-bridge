// 3rd_party_lib:diffutils4cj/build/release/diffUtils4cj
// 3rd_party_lib_ohos:diffutils4cj/build/aarch64-linux-ohos/diffUtils4cj

import std.unittest.*
import std.unittest.testmacro.*
import std.collection.*
import diffUtils4cj.*

@Test
public class TestChunkB001{
    /***
        public func equals(obj: Chunk<T>): Bool
        public init(position: Int64, lines: ArrayList<T>)
        public init(position: Int64, lines: Array<T>)
        测试场景:不等
    ***/
    @TestCase
    func testChunkEquals02(): Unit {
        var chunk01=Chunk(123,ArrayList<Int64>())
        var chunk02=Chunk(456,Array<Int64>())
        var chunk03=Chunk(123,ArrayList<Int64>([1,2,3,4,5,6]))
        var chunk04=Chunk(456,[1,2,3,4,5,6])
        @Assert(chunk02.equals(chunk01),false)
        @Assert(chunk03.equals(chunk04),false)
        @Assert(chunk01.equals(chunk04),false)
        @Assert(chunk03.equals(chunk01),false)
    }
}