// 3rd_party_lib:diffutils4cj/build/release/diffUtils4cj
// 3rd_party_lib_ohos:diffutils4cj/build/aarch64-linux-ohos/diffUtils4cj

import std.unittest.*
import std.unittest.testmacro.*
import diffUtils4cj.*
import std.collection.*

@Test
public class TestStringUtills{
    /***
        public static func normalize(list: ArrayList<String>): ArrayList<String>
        测试场景:list为空
    ***/
    @TestCase
    func testStringUtillsNormalize0201(): Unit {
        let list01=ArrayList<String>()
        let exp_re=list01
        let re_normalize=StringUtills.normalize(list01)
        @Assert(re_normalize,exp_re)
    }
}