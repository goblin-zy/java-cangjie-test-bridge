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
        public func verify(target: ArrayList<T>): Unit
        测试场景:original.verify(target)正常，但getOriginal().getPosition() > target.size()，抛异常
    ***/
    @TestCase
    func testChangeDeltaVerify02(): Unit {
        var lines_arrlist=ArrayList<Rune>()
        var original=Chunk(123,lines_arrlist)
        var revised=Chunk(123,lines_arrlist)
        let ChangeDelta=ChangeDelta(original,revised)
        var target=ArrayList<Rune>(Array<Rune>(122,repeat:r'c'))
        var flag=1
        try{
            ChangeDelta.verify(target)
        }catch(e:PatchFailedException){

            if(e.toString().contains("PatchFailedException: Incorrect patch for delta, delta original position > target size")){
                flag=0
            }
        }
        @Assert(flag,0)
    }
}