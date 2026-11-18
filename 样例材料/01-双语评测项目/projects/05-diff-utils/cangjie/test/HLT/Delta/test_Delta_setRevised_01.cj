// 3rd_party_lib:diffutils4cj/build/release/diffUtils4cj
// 3rd_party_lib_ohos:diffutils4cj/build/aarch64-linux-ohos/diffUtils4cj

import std.unittest.*
import std.unittest.testmacro.*
import std.collection.*
import diffUtils4cj.*

@Test
public class TestDeltaB001{
    /***
        public func setRevised(revised: Chunk<T>)
        测试场景:设置单次/多次
    ***/
    @TestCase
    func testDeltaSetOriginal01(): Unit {
        var chunkOriginal=Chunk(123,ArrayList<Int64>())
        var chunkRevised=Chunk(123,ArrayList<Int64>([1,2,3,4,5,6,7,8,9,10]))
        var delta01=ChangeDelta(chunkOriginal,chunkRevised)
        delta01.setRevised(chunkOriginal)
        @Assert(delta01.getRevised().equals(chunkOriginal),true)
        delta01.setRevised(chunkRevised)
        @Assert(delta01.getRevised().equals(chunkRevised),true)
    }
}