// 3rd_party_lib:diffutils4cj/build/release/diffUtils4cj
// 3rd_party_lib_ohos:diffutils4cj/build/aarch64-linux-ohos/diffUtils4cj

import std.unittest.*
import std.unittest.testmacro.*
import std.collection.*
import diffUtils4cj.*

@Test
public class TestDeleteDeltaV002{
    /***
        public init(original: Chunk<T>, revised: Chunk<T> )
        public func verify(target: ArrayList<T>): Unit
        测试场景:original.verify(target)正常,不抛异常
    ***/
    @TestCase
    func testDeleteDeltaVerify02(): Unit {
        var lines_arrlist=ArrayList<Rune>(Array<Rune>(100,repeat: r'c'))
        var original=Chunk(123,lines_arrlist)//last()=224,size=100
        var revised=Chunk(123,lines_arrlist)//last()=224,size=100
        let deleteDelta=DeleteDelta(original,revised)
        var target=ArrayList<Rune>(Array<Rune>(250,repeat: r'c'))
        var flag=1
        try{
            deleteDelta.verify(target)
        }catch(e:PatchFailedException){
            flag=0
        }
        @Assert(flag,1)
    }
}