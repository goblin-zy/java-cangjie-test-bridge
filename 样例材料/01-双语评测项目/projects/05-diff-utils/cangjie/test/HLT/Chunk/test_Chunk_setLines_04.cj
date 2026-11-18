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
        var changedArrli=ArrayList<Int16>([1,2,3,4,5,6])
        var changedArray=[1i16,2i16,3i16,4i16,5i16,6i16]
        var chunk01=Chunk(123,changedArrli)
        var chunk02=Chunk(123,changedArray)
        var changed=ArrayList<Int16>([1,2,3,4,5,6,1,2,3,4,5,6])
        chunk01.setLines(changed)
        chunk02.setLines(changed)

        @Assert(chunk01.getLines(),changed)
        @Assert(chunk02.getLines(),changed)
    }
}