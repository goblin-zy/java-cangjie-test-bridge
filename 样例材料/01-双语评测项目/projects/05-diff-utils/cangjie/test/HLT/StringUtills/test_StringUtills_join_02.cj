// 3rd_party_lib:diffutils4cj/build/release/diffUtils4cj
// 3rd_party_lib_ohos:diffutils4cj/build/aarch64-linux-ohos/diffUtils4cj

import std.unittest.*
import std.unittest.testmacro.*
import diffUtils4cj.*

@Test
public class TestStringUtills{
    /***
        public static func join<T>(objs: Iterable<T>, delimiter: String): String where T <: ToString
        测试场景:序列为空/非空,delimiter为空字符串
    ***/
    @TestCase
    func testStringUtillsJoin03(): Unit {
        let arr01=Array<Int64>()
        let re_join=StringUtills.join(arr01,"")
        @Assert(re_join,"")
    }
    @TestCase
    func testStringUtillsJoin04(): Unit {
        let arr02=[0,2,3,4,5]
        let re_join=StringUtills.join(arr02,"")
        @Assert(re_join,"02345")
    }
}