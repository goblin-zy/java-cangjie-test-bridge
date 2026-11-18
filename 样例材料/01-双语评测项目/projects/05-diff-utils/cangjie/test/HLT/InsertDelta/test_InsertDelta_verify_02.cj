// 3rd_party_lib:diffutils4cj/build/release/diffUtils4cj
// 3rd_party_lib_ohos:diffutils4cj/build/aarch64-linux-ohos/diffUtils4cj

import std.unittest.*
import std.unittest.testmacro.*
import std.collection.*
import diffUtils4cj.*

@Test
public class TestInsertDeltaV002{
    /***
        public init(original: Chunk<T>, revised: Chunk<T> )
        public func verify(target: ArrayList<T>): Unit
        测试场景:original.getOriginal().getPosition()=target.size,不抛
    ***/
    @TestCase
    func testInsertDeltaVerify02(): Unit {
        var original=Chunk(123,ArrayList<Int64>([1,2,3,4,5,6]))
        var revised=Chunk(123,[1,2,3,4,5,6])
        let insertDelta=InsertDelta(original,revised)
        var target=ArrayList<Int64>(Array<Int64>(123,repeat:5))
        @Assert(original.getPosition() > target.size,false)
        var flag=1
        try{
            insertDelta.verify(target)
        }catch(e:PatchFailedException){
            flag=0
        }
        @Assert(flag,1)
    }
}