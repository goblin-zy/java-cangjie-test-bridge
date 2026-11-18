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
        测试场景:list不为空
    ***/
    @TestCase
    func testStringUtillsNormalize0202(): Unit {
        let list01=ArrayList<String>(["ab\tc","ab\\tc","ab<c","ab>c"])
        let exp_re=ArrayList<String>(["ab    c","ab\\tc","ab&lt;c","ab&gt;c"])
        let re_normalize=StringUtills.normalize(list01)
        @Assert(re_normalize,exp_re)
    }
}