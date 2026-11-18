// 3rd_party_lib:diffutils4cj/build/release/diffUtils4cj
// 3rd_party_lib_ohos:diffutils4cj/build/aarch64-linux-ohos/diffUtils4cj

import std.unittest.*
import std.unittest.testmacro.*
import std.collection.*
import diffUtils4cj.*

@Test
public class TestDiffRowGenerator{
    /***
        public static func wrapInTag(sequence: ArrayList<String>, startPosition: Int64, endPosition: Int64,tag: String, cssClass: Option<String>): ArrayList<String>
        测试场景:列表为空,cssClass为Option<String>.None
    ***/
    @TestCase
    func testDiffRowGeneratorWrapInTag0201(): Unit {
        let sequence=ArrayList<String>()
        let startPosition=0
        let endPosition=1
        let tag="tag"
        let cssClass=Option<String>.None
        let re_wrapInTag=DiffRowGenerator.wrapInTag(sequence,startPosition,endPosition,tag,cssClass)
        let exp_startTag="<${tag}>"
        let exp_endTag="</${tag}>"
        let exp_wrapInTag=ArrayList<String>([exp_startTag,exp_endTag])
        @Assert(re_wrapInTag,exp_wrapInTag)
    }
}