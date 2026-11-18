// 3rd_party_lib:diffutils4cj/build/release/diffUtils4cj
// 3rd_party_lib_ohos:diffutils4cj/build/aarch64-linux-ohos/diffUtils4cj

import std.unittest.*
import std.unittest.testmacro.*
import diffUtils4cj.*

@Test
public class TestStringUtills{
    /***
        public static func normalize(str: String): String
        测试场景:str不包含<,>,\t
    ***/
    @TestCase
    func testStringUtillsNormalize0102(): Unit {
        let str01="  abc d ef  "
        let exp_re=str01
        let re_normalize=StringUtills.normalize(str01)
        @Assert(re_normalize,exp_re)
    }

}