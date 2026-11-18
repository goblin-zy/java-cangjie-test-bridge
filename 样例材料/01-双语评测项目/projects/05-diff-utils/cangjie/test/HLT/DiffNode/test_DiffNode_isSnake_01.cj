// 3rd_party_lib:diffutils4cj/build/release/diffUtils4cj
// 3rd_party_lib_ohos:diffutils4cj/build/aarch64-linux-ohos/diffUtils4cj

import std.unittest.*
import std.unittest.testmacro.*
import std.collection.*
import diffUtils4cj.*

@Test
public class TestDiffNodeB001{
    /***
        public init(i: Int64, j: Int64, prev: Option<PathNode>)
        public func isSnake(): Bool
        测试场景:非Snake节点
    ***/
    @TestCase
    func testDiffNodeIsSnake01(): Unit {
        var diffNode01=DiffNode(1,1,Option<PathNode>.None)
        @Assert(diffNode01.isSnake(),false)
    }
}