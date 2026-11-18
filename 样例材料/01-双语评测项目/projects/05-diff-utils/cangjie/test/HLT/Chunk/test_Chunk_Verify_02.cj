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
        测试场景:last()=target.size,lines为空
    ***/
    @TestCase
    func testChunkVerify02(): Unit {
        var chunk01=Chunk(123,ArrayList<Int64>())
        var chunk02=Chunk(123,Array<Int64>())
        var target=ArrayList<Int64>(Array<Int64>(chunk01.last(),repeat:107))//last()=122
        var flag=0
        try{
            chunk01.verify(target)
        }catch(e:PatchFailedException){
            flag=1
        }
        @Assert(flag,0)
        flag=0
        try{
            chunk02.verify(target)
        }catch(e:PatchFailedException){
            flag=1
        }
        @Assert(flag,0)
    }
}