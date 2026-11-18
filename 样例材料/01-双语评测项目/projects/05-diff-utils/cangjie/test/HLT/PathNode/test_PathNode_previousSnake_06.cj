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
        测试场景:当前不是snake节点,不是bootstrap节点,下一级先遇到Snake--当前节点不是Option.None
    ***/
    @TestCase
    func testPathNodePreviousSnake05(): Unit {
        var pathNode01=Snake(-1,1,Option<PathNode>.None)
        var pathNode02=DiffNode(1,1,Option<PathNode>.Some(pathNode01))
        var pathNode03=Snake(1,1,Option<PathNode>.Some(pathNode02))
        var pathNode04=DiffNode(1,1,Option<PathNode>.Some(pathNode03))
        var pathNode05=DiffNode(1,1,Option<PathNode>.Some(pathNode04))
        @Assert(pathNode05.isBootstrap(),false)
        @Assert(pathNode05.isSnake(),false)
        @Assert(pathNode05.previousSnake().getOrThrow().toString(),pathNode03.toString())
    }
}