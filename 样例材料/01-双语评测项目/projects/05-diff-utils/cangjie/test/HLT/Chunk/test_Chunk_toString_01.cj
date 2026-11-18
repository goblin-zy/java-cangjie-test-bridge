// 3rd_party_lib:diffutils4cj/build/release/diffUtils4cj
// 3rd_party_lib_ohos:diffutils4cj/build/aarch64-linux-ohos/diffUtils4cj

import std.unittest.*
import std.unittest.testmacro.*
import std.collection.*
import diffUtils4cj.*

@Test
public class TestChunkB001{
    /***
        public func toString(): String
        public init(position: Int64, lines: ArrayList<T>)
        public init(position: Int64, lines: Array<T>)
        测试场景:与构造器一致即可,lines非空
    ***/
    @TestCase
    func testChunkToString01(): Unit {
        var chunk01=Chunk(123,ArrayList<Int64>([1,2,3,4,5,6]))
        var chunk02=Chunk(123,[1,2,3,4,5,6])
        @Assert(chunk01.toString(),"[position: " + chunk01.getPosition().toString() + ", size: " + chunk01.size().toString() + ", lines: " + chunk01.getLines().toString() + "]")
        @Assert(chunk02.toString(),"[position: " + chunk02.getPosition().toString() + ", size: " + chunk02.size().toString() + ", lines: " + chunk02.getLines().toString() + "]")
        chunk01=Chunk(123,ArrayList<Int64>())
        chunk02=Chunk(123,Array<Int64>())
        @Assert(chunk01.toString(),"[position: " + chunk01.getPosition().toString() + ", size: " + chunk01.size().toString() + ", lines: " + chunk01.getLines().toString() + "]")
        @Assert(chunk02.toString(),"[position: " + chunk02.getPosition().toString() + ", size: " + chunk02.size().toString() + ", lines: " + chunk02.getLines().toString() + "]")

    }
}