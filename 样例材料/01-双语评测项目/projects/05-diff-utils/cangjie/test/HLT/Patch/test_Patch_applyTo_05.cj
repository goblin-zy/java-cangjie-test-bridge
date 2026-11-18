// 3rd_party_lib:diffutils4cj/build/release/diffUtils4cj
// 3rd_party_lib_ohos:diffutils4cj/build/aarch64-linux-ohos/diffUtils4cj

import std.unittest.*
import std.unittest.testmacro.*
import std.collection.*
import diffUtils4cj.*

@Test
public class TestPatchV002{
    /***
        public init()
        public func applyTo(target: ArrayList<T>): ArrayList<T>
        测试场景:Patch中仅有ChangeDelta,target非空
    ***/
    @TestCase
    func testPatchApplyTo05(): Unit {
        var original=Chunk(1,ArrayList<Int64>([1,2,3]))
        var revised=Chunk(1,[3,4,5,7,8,6])
        let changeDelta=ChangeDelta(original,revised)
        var patch=Patch<Int64>()
        patch.addDelta(changeDelta)
        var target=ArrayList<Int64>([7,1,2,3,8,9])
        let result=patch.applyTo(target)
        var exp_result=ArrayList<Int64>([7, 3, 4, 5, 7, 8, 6, 8, 9])
        @Assert(result,exp_result)
    }
}