// 3rd_party_lib:diffutils4cj/build/release/diffUtils4cj
// 3rd_party_lib_ohos:diffutils4cj/build/aarch64-linux-ohos/diffUtils4cj

import std.unittest.*
import std.unittest.testmacro.*
import std.collection.*
import diffUtils4cj.*

@Test
public class TestChunkB001{
    /***
        public func verify(target: ArrayList<T>): Unit
        public init(position: Int64, lines: ArrayList<T>)
        public init(position: Int64, lines: Array<T>)
        测试场景:last()>target.size
    ***/
    @TestCase
    func testChunkVerify01(): Unit {
        var chunk01=Chunk(123,ArrayList<Int64>())
        var chunk02=Chunk(123,Array<Int64>())
        var target=ArrayList<Int64>(Array<Int64>(10,repeat:108))
        var flag=0
        try{
            chunk01.verify(target)
        }catch(e:PatchFailedException){
            if(e.toString().contains("PatchFailedException: Incorrect Chunk, the position of chunk > target size")){
                flag=1
            }
        }
        @Assert(flag,1)
        flag=0
        try{
            chunk02.verify(target)
        }catch(e:PatchFailedException){
            if(e.toString().contains("PatchFailedException: Incorrect Chunk, the position of chunk > target size")){
                flag=1
            }
        }
        @Assert(flag,1)
    }
}