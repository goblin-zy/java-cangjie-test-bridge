// 3rd_party_lib:diffutils4cj/build/release/diffUtils4cj
// 3rd_party_lib_ohos:diffutils4cj/build/aarch64-linux-ohos/diffUtils4cj

import std.unittest.*
import std.unittest.testmacro.*
import diffUtils4cj.*

@Test
public class TestDiffRow{
    /***
        public init(tag: Tag, oldLine: String, newLine: String)
        public func getNewLine(): String
        测试场景:与构造器一致
    ***/
    @TestCase
    func testDiffRowGetNewLine01(): Unit {
        let diffRow01=DiffRow(Tag.INSERT,"oldLine","newLine")
        @Assert(diffRow01.getNewLine(),"newLine")
    }
}