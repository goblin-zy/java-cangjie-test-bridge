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
        测试场景:当前不是snake节点,不是bootstrap节点,一直未遇到Snake节点和bootStrap节点--当前节点不是Option.None
    ***/
    @TestCase
    func testPathNodePreviousSnake04(): Unit {
        var pathNode01=DiffNode(1,1,Option<PathNode>.None)
        var pathNode02=DiffNode(2,2,Option<PathNode>.Some(pathNode01))
        var pathNode03=DiffNode(3,3,Option<PathNode>.Some(pathNode02))
        @Assert(pathNode03.isBootstrap(),false)
        @Assert(pathNode03.isSnake(),false)
        var nodes=pathNode03.previousSnake().getOrThrow().toString()
        @Assert(nodes,"[(1,1)]")
    }
}