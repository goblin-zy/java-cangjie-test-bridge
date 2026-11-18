// 3rd_party_lib:diffutils4cj/build/release/diffUtils4cj
// 3rd_party_lib_ohos:diffutils4cj/build/aarch64-linux-ohos/diffUtils4cj

import std.unittest.*
import std.unittest.testmacro.*
import std.collection.*
import diffUtils4cj.*

@Test
public class TestSnakeB001{
    /***
        public init(i: Int64, j: Int64, prev: Option<PathNode>)
        public func isSnake(): Bool
        测试场景:相等
    ***/
    @TestCase
    func testSnakeIsSnake01(): Unit {
        var snake01=Snake(1,1,Option<PathNode>.None)
        @Assert(snake01.isSnake(),true)
    }
}