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
        测试场景:当前pathNode下一级节点为非None
    ***/
    @TestCase
    func testPathNodeToString02(): Unit {
        var pathNode01=Snake(1,1,Option<PathNode>.None)
        var pathNode02=DiffNode(1,1,Option<PathNode>.Some(pathNode01))
        @Assert(pathNode02.toString(),"[(1,1)(1,1)]")
    }
}