// 3rd_party_lib:diffutils4cj/build/release/diffUtils4cj
// 3rd_party_lib_ohos:diffutils4cj/build/aarch64-linux-ohos/diffUtils4cj

import std.unittest.*
import std.unittest.testmacro.*
import std.collection.*
import diffUtils4cj.*

@Test
public class TestChunkB001{
    /***
        public func getPosition(): Int64
        public init(position: Int64, lines: ArrayList<T>)
        public init(position: Int64, lines: Array<T>)
        测试场景:与构造器传入一致
    ***/
    @TestCase
    func testChunkGetPosition01(): Unit {
        var chunk01=Chunk(123,ArrayList<String>())
        var chunk02=Chunk(123,Array<String>())
        @Assert(chunk01.getPosition(),123)
        @Assert(chunk02.getPosition(),123)
    }
}