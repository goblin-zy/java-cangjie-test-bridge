// 3rd_party_lib:diffutils4cj/build/release/diffUtils4cj
// 3rd_party_lib_ohos:diffutils4cj/build/aarch64-linux-ohos/diffUtils4cj

import std.unittest.*
import std.unittest.testmacro.*
import std.collection.*
import diffUtils4cj.*

@Test
public class TestPatchB001{
    /***
        public func addDelta(delta: Delta<T>): Unit
        测试场景:添加/多次添加/添加不同子类
    ***/
    @TestCase
    func testPatchAddDelta01(): Unit {
        var chunk01=Chunk(123,ArrayList<Int64>([1,2,3,4,5,6]))
        var chunk02=Chunk(123,[1,2,3,4,5,6])
        let changeDelta=ChangeDelta(chunk01,chunk02)
        let insertDelta=InsertDelta(chunk01,chunk02)
        let deleteDelta=DeleteDelta(chunk01,chunk02)
        var patch01=Patch<Int64>()
        patch01.addDelta(changeDelta)
        patch01.addDelta(insertDelta)
        patch01.addDelta(deleteDelta)
        var deltas=patch01.getDeltas()
        var change=0
        var insert=0
        var delete=0
        @Assert(deltas.size,3)
        for (i in deltas){
            if(i is ChangeDelta<Int64>){
                change+=1
            }else if(i is InsertDelta<Int64>){
                insert+=1
            }else if(i is DeleteDelta<Int64>){
                delete+=1
            }else{

            }
        }
        @Assert(change,1)
        @Assert(insert,1)
        @Assert(delete,1)
    }
}