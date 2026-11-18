// 3rd_party_lib:diffutils4cj/build/release/diffUtils4cj
// 3rd_party_lib_ohos:diffutils4cj/build/aarch64-linux-ohos/diffUtils4cj

import std.unittest.*
import std.unittest.testmacro.*
import std.collection.*
import diffUtils4cj.*

@Test
public class TestPathNodeB001{
    /***
        public func toString(): String
        测试场景:当前pathNode存在下n级节点
    ***/
    @TestCase
    func testPathNodeToString02(): Unit {
        var pathNode01=Snake(0,0,Option<PathNode>.None)
        var pathNode02=DiffNode(1,1,Option<PathNode>.Some(pathNode01))
        var pathNode03=DiffNode(2,2,Option<PathNode>.Some(pathNode02))
        var pathNode04=DiffNode(3,3,Option<PathNode>.Some(pathNode03))
        var pathNode05=DiffNode(4,4,Option<PathNode>.Some(pathNode04))
        var pathNode06=DiffNode(5,5,Option<PathNode>.Some(pathNode05))
        var pathNode07=DiffNode(6,6,Option<PathNode>.Some(pathNode06))
        @Assert(pathNode07.toString(),"[(6,6)(0,0)]")
    }
}