// 3rd_party_lib:diffutils4cj/build/release/diffUtils4cj
// 3rd_party_lib_ohos:diffutils4cj/build/aarch64-linux-ohos/diffUtils4cj

import std.unittest.*
import std.unittest.testmacro.*
import diffUtils4cj.*

@Test
public class TestStringUtills{
    /***
        public static func expandTabs(str: String): String
        测试场景:str包含单个/多个:"\t"
    ***/
    @TestCase
    func testStringUtillsExpandTabs02(): Unit {
        let str01="ab\tcd\trf\t\t"
        let re_expandTabs01=StringUtills.expandTabs(str01)
        @Assert(re_expandTabs01,"ab    cd    rf        ")
    }
}