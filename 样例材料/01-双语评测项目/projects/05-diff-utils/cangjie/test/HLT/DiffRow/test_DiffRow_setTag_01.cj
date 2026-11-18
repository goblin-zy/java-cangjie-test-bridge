// 3rd_party_lib:diffutils4cj/build/release/diffUtils4cj
// 3rd_party_lib_ohos:diffutils4cj/build/aarch64-linux-ohos/diffUtils4cj

import std.unittest.*
import std.unittest.testmacro.*
import diffUtils4cj.*

@Test
public class TestDiffRow{
    /***
        public init(tag: Tag, oldLine: String, newLine: String)
        public func setTag(tag: Tag): Unit
        测试场景:设置单次,多次,与之前设置一致,不一致
    ***/
    @TestCase
    func testDiffRowSetTag01(): Unit {
        let diffRow01=DiffRow(Tag.INSERT,"oldLine","newLine")
        @Assert(diffRow01.getTag().toString(),"INSERT")
        diffRow01.setTag(Tag.DELETE)
        @Assert(diffRow01.getTag().toString(),"DELETE")
        diffRow01.setTag(Tag.INSERT)
        @Assert(diffRow01.getTag().toString(),"INSERT")
    }
}