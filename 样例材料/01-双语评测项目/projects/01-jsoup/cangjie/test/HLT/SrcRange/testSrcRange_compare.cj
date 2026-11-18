// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
//dependence:../util_test/createsourcedata.cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

@Test
public class SrcRangeTest {
    let srcPositionIns_1: SrcPosition = SrcPosition(0, 0, 0)
    var intRes: Int64 = -1
    var boolRes: Bool = false
    var strRes: String = ""
    var returnFlag: Int64 = -1

    @TestCase
    func testSrcRange_compare_01(): Unit {
        let srcPositionIns_2: SrcPosition = SrcPosition(1, 2, 3)
        let SrcRangeIns_1: SrcRange = SrcRange(srcPositionIns_1, srcPositionIns_2)
        intRes = SrcRangeIns_1.hashCode()
        @Assert(intRes, 1026)
        let SrcRangeIns_2: SrcRange = SrcRange(srcPositionIns_1, srcPositionIns_2)
        boolRes = SrcRangeIns_2 == SrcRangeIns_1
        @Assert(boolRes, true)
        strRes = SrcRangeIns_1.toString() 
        @Assert(strRes, "0,0:0-2,3:1")
        @Assert(SrcRangeIns_2.hashCode() == SrcRangeIns_1.hashCode() , true)
        let SrcRangeIns_3: SrcRange = SrcRange(srcPositionIns_2, srcPositionIns_2)
        @Assert(SrcRangeIns_3.toString(), "2,3:1-2,3:1")
        @Assert(SrcRangeIns_3.start().toString(), "2,3:1")
        @Assert(SrcRangeIns_3.end().toString(), "2,3:1")
        @Assert(SrcRangeIns_3.hashCode() != SrcRangeIns_1.hashCode(), true)
    }
}
