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
        public func applyTo(target: ArrayList<T>): Unit
        测试场景:verify结果异常(original.getPosition()>target.size),结果异常
    ***/
    @TestCase
    func testInsertDeltaApplyTo01(): Unit {
        var original=Chunk(123,ArrayList<Int64>([1,2,3,4,5,6]))
        var revised=Chunk(123,[1,2,3,4,5,6])
        let insertDelta=InsertDelta(original,revised)
        var target=ArrayList<Int64>()
        @Assert(original.getPosition() > target.size,true)
        var flag=1
        try{
            insertDelta.applyTo(target)
        }catch(e:PatchFailedException){
            if(e.toString().contains("PatchFailedException: Incorrect patch for delta, delta original position > target size")){
                flag=0
            }
        }
        @Assert(flag,0)

    }
}