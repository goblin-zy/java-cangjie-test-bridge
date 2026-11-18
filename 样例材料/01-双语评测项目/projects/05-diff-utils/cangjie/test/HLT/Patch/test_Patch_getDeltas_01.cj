// 3rd_party_lib:diffutils4cj/build/release/diffUtils4cj
// 3rd_party_lib_ohos:diffutils4cj/build/aarch64-linux-ohos/diffUtils4cj

import std.unittest.*
import std.unittest.testmacro.*
import std.collection.*
import diffUtils4cj.*

@Test
public class TestPatchB001{
    /***
        public func getDeltas(): ArrayList<Delta<T>>
        测试场景:默认值
    ***/
    @TestCase
    func testPatchAddDelta01(): Unit {
        var patch01=Patch<String>()
        @Assert(patch01.getDeltas().size,0)
    }
}