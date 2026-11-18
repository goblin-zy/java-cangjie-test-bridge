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
        public func restore(target: ArrayList<T>): Unit
        测试场景:revise.size()==0且original.getlines().size==0--不进入循环
    ***/
    @TestCase
    func testChangeDeltaRestore01(): Unit {
        var original=Chunk(-1,ArrayList<Int64>())
        var revised=Chunk(-1,Array<Int64>())
        let changeDelta=ChangeDelta(original,revised)
        var target=ArrayList<Int64>()
        var exp_target=ArrayList<Int64>()
        changeDelta.restore(target)
        @Assert(target,exp_target)
    }
}