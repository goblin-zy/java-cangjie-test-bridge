// 3rd_party_lib:diffutils4cj/build/release/diffUtils4cj
// 3rd_party_lib_ohos:diffutils4cj/build/aarch64-linux-ohos/diffUtils4cj

import std.unittest.*
import std.unittest.testmacro.*
import std.collection.*
import diffUtils4cj.*

@Test
public class TestDeltaB001{
    /***
        public func getOriginal(): Chunk<T>
        测试场景:与构造器传入一致
    ***/
    @TestCase
    func testDeltaGetOriginal01(): Unit {
        var chunkOriginal=Chunk(123,ArrayList<Int64>())
        var chunkRevised=Chunk(123,ArrayList<Int64>([1,2,3,4,5,6,7,8,9,10]))
        var delta01=ChangeDelta(chunkOriginal,chunkRevised)
        @Assert(delta01.getOriginal().equals(chunkOriginal),true)
    }
}