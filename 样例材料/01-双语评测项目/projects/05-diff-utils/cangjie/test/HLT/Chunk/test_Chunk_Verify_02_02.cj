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
        测试场景:last()=target.size,lines不为空,存在一个target.get(position + i)!=lines.get(i)
    ***/
    @TestCase
    func testChunkVerify0202(): Unit {
        var target=ArrayList<Rune>(Array<Rune>(222,repeat:r'c'))
        var lines01=ArrayList<Rune>(Array<Rune>(100,repeat:r'a'))
        var lines02=Array<Rune>(100,repeat:r'a')
        var chunk01=Chunk(123,lines01)//last()=222,size=100
        var chunk02=Chunk(123,lines02)//last()=222,size=100
        var flag=0
        try{
            chunk01.verify(target)
        }catch(e:PatchFailedException){
            if(e.toString().contains("PatchFailedException: Incorrect Chunk, the chunk content doesn't match the target")){
                flag=1
            }
        }
        @Assert(flag,1)
        flag=0
        try{
            chunk02.verify(target)
        }catch(e:PatchFailedException){
            if(e.toString().contains("PatchFailedException: Incorrect Chunk, the chunk content doesn't match the target")){
                flag=1
            }
        }
        @Assert(flag,1)
    }
}