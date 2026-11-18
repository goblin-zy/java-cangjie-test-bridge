// 3rd_party_lib:diffutils4cj/build/release/diffUtils4cj
// 3rd_party_lib_ohos:diffutils4cj/build/aarch64-linux-ohos/diffUtils4cj

import std.unittest.*
import std.unittest.testmacro.*
import diffUtils4cj.*
import std.collection.*

@Test
public class TestStringUtills{
    /***
        public static func wrapText( list: ArrayList<String>, columnWidth: Int64): ArrayList<String>
        测试场景:list非空
    ***/
    @TestCase
    func testStringUtillsWrapText0202(): Unit {
        let list=ArrayList<String>(["absf","absff","absffabsffabsffabsffabsffabsff"])
        let columnWidth=4
        let re_wrapText=StringUtills.wrapText(list,columnWidth)
        let exp_wrapText=ArrayList<String>(["absf","absf"+"<br>"+"f","absf"+"<br>"+"fabs"+"<br>"+"ffab"+"<br>"+"sffa"+"<br>"+"bsff"+"<br>"+"absf"+"<br>"+"fabs"+"<br>"+"ff"])
        @Assert(re_wrapText,exp_wrapText)
    }
}