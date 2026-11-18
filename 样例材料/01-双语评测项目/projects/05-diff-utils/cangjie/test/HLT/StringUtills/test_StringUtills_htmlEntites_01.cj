// 3rd_party_lib:diffutils4cj/build/release/diffUtils4cj
// 3rd_party_lib_ohos:diffutils4cj/build/aarch64-linux-ohos/diffUtils4cj

import std.unittest.*
import std.unittest.testmacro.*
import diffUtils4cj.*

@Test
public class TestStringUtills{
    /***
        public static func htmlEntites(str: String): String
        测试场景:str包含<,>,&lt,&gt,《,》
    ***/
    @TestCase
    func testStringUtillsHtmlEntites01(): Unit {
        let str01="ab《c<d>d》ddf&ltds>d&gtfsd<f"
        let exp_re="ab《c&lt;d&gt;d》ddf&ltds&gt;d&gtfsd&lt;f"
        let re_htmlEntites01=StringUtills.htmlEntites(str01)
        @Assert(re_htmlEntites01,exp_re)
    }
}