// 3rd_party_lib:diffutils4cj/build/release/diffUtils4cj
// 3rd_party_lib_ohos:diffutils4cj/build/aarch64-linux-ohos/diffUtils4cj

import std.unittest.*
import std.unittest.testmacro.*
import diffUtils4cj.*

@Test
public class TestStringUtills{
    /***
        public static func wrapText(line: String, columnWidth: Int64): String
        测试场景:line.size<=columnWidth
    ***/
    @TestCase
    func testStringUtillsWrapText0101(): Unit {
        let line="absf"
        let columnWidth=4
        let re_wrapText=StringUtills.wrapText(line,columnWidth)
        let exp_wrapText=line
        @Assert(re_wrapText,exp_wrapText)
    }
}