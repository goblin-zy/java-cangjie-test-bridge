// 3rd_party_lib:diffutils4cj/build/release/diffUtils4cj
// 3rd_party_lib_ohos:diffutils4cj/build/aarch64-linux-ohos/diffUtils4cj

import std.unittest.*
import std.unittest.testmacro.*
import diffUtils4cj.*

@Test
public class TestTag{
    /***
        public func toString(): String
        测试场景:各枚举值打印准确
    ***/
    @TestCase
    func testTagToString01(): Unit {
        let tag01=Tag.INSERT
        let tag02=Tag.DELETE
        let tag03=Tag.CHANGE
        let tag04=Tag.EQUAL
        @Assert(tag01.toString(),"INSERT")
        @Assert(tag02.toString(),"DELETE")
        @Assert(tag03.toString(),"CHANGE")
        @Assert(tag04.toString(),"EQUAL")
    }
}