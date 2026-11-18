// 3rd_party_lib:diffutils4cj/build/release/diffUtils4cj
// 3rd_party_lib_ohos:diffutils4cj/build/aarch64-linux-ohos/diffUtils4cj

import std.unittest.*
import std.unittest.testmacro.*
import std.collection.*
import diffUtils4cj.*

@Test
public class TestChangeDeltaV002{
    /***
        public init(original: Chunk<T>, revised: Chunk<T> )
        public func applyTo(target: ArrayList<T>): Unit
        测试场景:verify结果异常(original.verify(target)异常),结果异常
    ***/
    @TestCase
    func testChangeDeltaApplyTo01(): Unit {
        var original=Chunk(123,ArrayList<Int64>([1,2,3,4,5,6]))
        var revised=Chunk(123, [1,2,3,4,5,6])
        let changeDelta=ChangeDelta(original,revised)
        var target=ArrayList<Int64>()
        var flag=1
        try{
            changeDelta.applyTo(target)
        }catch(e:PatchFailedException){

            if(e.toString().contains("PatchFailedException: Incorrect Chunk, the position of chunk > target size")){
                flag=0
            }
        }
        @Assert(flag,0)

    }
}