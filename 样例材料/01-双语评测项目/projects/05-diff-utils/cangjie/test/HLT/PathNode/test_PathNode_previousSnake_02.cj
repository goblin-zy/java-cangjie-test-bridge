// 3rd_party_lib:diffutils4cj/build/release/diffUtils4cj
// 3rd_party_lib_ohos:diffutils4cj/build/aarch64-linux-ohos/diffUtils4cj

import std.unittest.*
import std.unittest.testmacro.*
import std.collection.*
import diffUtils4cj.*

@Test
public class TestPathNodeB001{
    /***
        public func previousSnake(): Option<PathNode>
        测试场景:当前是snake节点,不是bootstrap节点
    ***/
    @TestCase
    func testPathNodePreviousSnake02(): Unit {
        var pathNode01=Snake(1,1,Option<PathNode>.None)
        @Assert(pathNode01.isBootstrap(),false)
        @Assert(pathNode01.isSnake(),true)
        @Assert(pathNode01.previousSnake().getOrThrow().toString(),pathNode01.toString())
    }
}