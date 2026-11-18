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
        测试场景:original.verify(target)异常,抛异常
    ***/
    @TestCase
    func testDeleteDeltaVerify01(): Unit {
        var original=Chunk(123,ArrayList<Int64>())
        var revised=Chunk(123,Array<Int64>())
        let deleteDelta=DeleteDelta(original,revised)
        var target=ArrayList<Int64>(Array<Int64>(10,repeat:108))
        var flag=1
        try{
            deleteDelta.verify(target)
        }catch(e:PatchFailedException){

            if(e.toString().contains("PatchFailedException: Incorrect Chunk, the position of chunk > target size")){
                flag=0
            }
        }
        @Assert(flag,0)

    }
}