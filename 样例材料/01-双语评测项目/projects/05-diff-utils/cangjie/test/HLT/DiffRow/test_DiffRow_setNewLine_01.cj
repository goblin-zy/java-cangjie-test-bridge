// 3rd_party_lib:diffutils4cj/build/release/diffUtils4cj
// 3rd_party_lib_ohos:diffutils4cj/build/aarch64-linux-ohos/diffUtils4cj

import std.unittest.*
import std.unittest.testmacro.*
import diffUtils4cj.*

@Test
public class TestDiffRow{
    /***
        public init(tag: Tag, oldLine: String, newLine: String)
        public func setNewLine(newLine: String): Unit
        测试场景:设置单次,多次,与之前设置一致,不一致
    ***/
    @TestCase
    func testDiffRowSetNewLine01(): Unit {
        let diffRow01=DiffRow(Tag.INSERT,"oldLine","newLine")
        diffRow01.setNewLine("RESET_newLine_01")
        @Assert(diffRow01.getNewLine(),"RESET_newLine_01")
        diffRow01.setNewLine("RESET_newLine_02")
        @Assert(diffRow01.getNewLine(),"RESET_newLine_02")
    }
}