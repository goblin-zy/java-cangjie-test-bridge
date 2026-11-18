// 3rd_party_lib:diffutils4cj/build/release/diffUtils4cj
// 3rd_party_lib_ohos:diffutils4cj/build/aarch64-linux-ohos/diffUtils4cj

import std.unittest.*
import std.unittest.testmacro.*
import diffUtils4cj.*

@Test
public class TestStringUtills{
    /***
        public static func htmlEntites(str: String): String
        测试场景:str不包含<,>,&lt,&gt,《,》
    ***/
    @TestCase
    func testStringUtillsHtmlEntites02(): Unit {
        let str01="ab cd"
        let str02=""
        let re_htmlEntites01=StringUtills.htmlEntites(str01)
        let re_htmlEntites02=StringUtills.htmlEntites(str02)
        @Assert(re_htmlEntites01,str01)
        @Assert(re_htmlEntites02,str02)
    }
}