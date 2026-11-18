// 3rd_party_lib:diffutils4cj/build/release/diffUtils4cj
// 3rd_party_lib_ohos:diffutils4cj/build/aarch64-linux-ohos/diffUtils4cj

import std.unittest.*
import std.unittest.testmacro.*
import std.collection.*
import diffUtils4cj.*

@Test
public class TestChunkB001{
    /***
        public func setLines(lines: ArrayList<T>): Unit
        public init(position: Int64, lines: ArrayList<T>)
        public init(position: Int64, lines: Array<T>)
        测试场景:初始化构造为空，set为空
    ***/
    @TestCase
    func testChunkSetLines01(): Unit {
        var chunk01=Chunk(123,ArrayList<Int64>())
        var chunk02=Chunk(123,Array<Int64>())
        chunk01.setLines(ArrayList<Int64>())
        chunk02.setLines(ArrayList<Int64>())
        @Assert(chunk01.getLines(),ArrayList<Int64>())
        @Assert(chunk02.getLines(),ArrayList<Int64>())
    }
}