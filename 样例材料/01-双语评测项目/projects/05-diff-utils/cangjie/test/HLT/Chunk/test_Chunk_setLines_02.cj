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
        测试场景:初始化构造为空，set不为空
    ***/
    @TestCase
    func testChunkSetLines02(): Unit {
        var chunk01=Chunk(123,ArrayList<Int32>())
        var chunk02=Chunk(123,Array<Int32>())
        var changed=ArrayList<Int32>([1,2,3,4,5,6])
        chunk01.setLines(changed)
        chunk02.setLines(changed)
        @Assert(chunk01.getLines(),changed)
        @Assert(chunk02.getLines(),changed)
    }
}