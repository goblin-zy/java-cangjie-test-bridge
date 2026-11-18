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
        测试场景:列表不为空,cssClass为Option<String>.None,startPosition>sequence.size+1,endPosition任意
    ***/
    @TestCase
    func testDiffRowGeneratorWrapInTag0203(): Unit {
        let sequence=ArrayList<String>(["1","2","3","4","5"])
        let startPosition=sequence.size+2
        let endPosition=sequence.size+1
        let tag="tag"
        let cssClass=Option<String>.None
        var re_wrapInTag_flag=0
        try{
            DiffRowGenerator.wrapInTag(sequence,startPosition,endPosition,tag,cssClass)
        }catch(e:IndexOutOfBoundsException){

            re_wrapInTag_flag=1
        }
        @Assert(re_wrapInTag_flag,1)
    }
}