// 3rd_party_lib:diffutils4cj/build/release/diffUtils4cj
// 3rd_party_lib_ohos:diffutils4cj/build/aarch64-linux-ohos/diffUtils4cj

import std.unittest.*
import std.unittest.testmacro.*
import std.collection.*
import diffUtils4cj.*

@Test
public class TestPathNodeB001{
    /***
        public func isSnake(): Bool
        测试场景:相等
    ***/
    @TestCase
    func testPathNodeIsSnake01(): Unit {
        var pathNode01=Snake(1,1,Option<PathNode>.None)
        var pathNode02=DiffNode(1,1,Option<PathNode>.Some(pathNode01))
        @Assert(pathNode01.isSnake(),true)
        @Assert(pathNode02.isSnake(),false)

    }
}