// 3rd_party_lib:diffutils4cj/build/release/diffUtils4cj
// 3rd_party_lib_ohos:diffutils4cj/build/aarch64-linux-ohos/diffUtils4cj

import std.unittest.*
import std.unittest.testmacro.*
import diffUtils4cj.*

@Test
public class TestDiffRowGenerator{
    /***
        public static func wrapInTag(line: String, tag: String, cssClass: String): String
        测试场景:line,tag非空,cssClass非Option<String>.None
    ***/
    @TestCase
    func testDiffRowGeneratorWrapInTag0102(): Unit {
        let line="line"
        let tag="PL"
        let cssClass=Option<String>.Some("cssClass")
        let re_wrapInTag=DiffRowGenerator.wrapInTag(line,tag,cssClass)
        let exp_wrapInTag="<"+tag + " class=\""+cssClass.getOrThrow()+"\""+">"+line+"</"+tag +">"
        @Assert(re_wrapInTag,exp_wrapInTag)
    }
}