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
        测试场景:last()=target.size,lines不为空,循环target.get(position + i)==lines.get(i)均成立
    ***/
    @TestCase
    func testChunkVerify0203(): Unit {
        var target=ArrayList<Rune>(Array<Rune>(250,repeat:r'c'))
        var lines_arrlist=ArrayList<Rune>(Array<Rune>(100,repeat:r'c'))
        var lines_arr=Array<Rune>(100,repeat:r'c')
        var chunk01=Chunk(123,lines_arrlist)
        var chunk02=Chunk(123,lines_arr)
        var flag=0
        try{
            chunk01.verify(target)
        }catch(e:PatchFailedException){
           flag=1
        }
        @Assert(flag,0)
        try{
            chunk02.verify(target)
        }catch(e:PatchFailedException){
           flag=1
        }
        @Assert(flag,0)
    }
}