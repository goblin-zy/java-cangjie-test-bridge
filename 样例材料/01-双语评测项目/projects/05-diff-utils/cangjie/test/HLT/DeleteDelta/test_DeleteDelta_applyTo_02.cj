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
        public func applyTo(target: ArrayList<T>): Unit
        测试场景:verify结果正常(original.verify(target)正常)
                original.getPosition()<0 && original.size()==0---不走循环
    ***/
    @TestCase
    func testDeleteDeltaApplyTo02(): Unit {
        var original=Chunk(-1,ArrayList<Int64>())
        var revised=Chunk(-1,Array<Int64>())
        let deleteDelta=DeleteDelta(original,revised)
        var target=ArrayList<Int64>()
        var exp_target=ArrayList<Int64>()
        deleteDelta.applyTo(target)
        @Assert(target,exp_target)
    }
}