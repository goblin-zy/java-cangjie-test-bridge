// 3rd_party_lib:diffutils4cj/build/release/diffUtils4cj
// 3rd_party_lib_ohos:diffutils4cj/build/aarch64-linux-ohos/diffUtils4cj

import std.unittest.*
import std.unittest.testmacro.*
import std.collection.*
import diffUtils4cj.*

@Test
public class TestPathNodeB001{
    /***
        public func isBootstrap(): Bool
        测试场景:相等
    ***/
    @TestCase
    func testPathNodeIsBootstrap01(): Unit {
        var pathNode01=Snake(1,-1,Option<PathNode>.None)
        var pathNode02=DiffNode(-1,1,Option<PathNode>.Some(pathNode01))

        var pathNode03=Snake(-1,-1,Option<PathNode>.None)
        var pathNode04=Snake(1,1,Option<PathNode>.None)
        @Assert(pathNode01.isBootstrap(),true)
        @Assert(pathNode02.isBootstrap(),true)
        @Assert(pathNode03.isBootstrap(),true)
        @Assert(pathNode04.isBootstrap(),false)
    }
}