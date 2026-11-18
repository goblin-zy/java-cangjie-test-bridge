// 3rd_party_lib:diffutils4cj/build/release/diffUtils4cj
// 3rd_party_lib_ohos:diffutils4cj/build/aarch64-linux-ohos/diffUtils4cj

import std.unittest.*
import std.unittest.testmacro.*
import diffUtils4cj.*

@Test
public class TestDiffRow{
    /***
        public init(tag: Tag, oldLine: String, newLine: String)
        public func getTag(): Tag
        测试场景:与构造器一致
    ***/
    @TestCase
    func testDiffRowGetTag01(): Unit {
        let diffRow01=DiffRow(Tag.INSERT,"oldLine","newLine")
        let diffRow02=DiffRow(Tag.DELETE,"oldLine","newLine")
        let diffRow03=DiffRow(Tag.CHANGE,"oldLine","newLine")
        let diffRow04=DiffRow(Tag.EQUAL,"oldLine","newLine")
        @Assert(diffRow01.getTag().toString(),"INSERT")
        @Assert(diffRow02.getTag().toString(),"DELETE")
        @Assert(diffRow03.getTag().toString(),"CHANGE")
        @Assert(diffRow04.getTag().toString(),"EQUAL")
    }
}