// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
//dependence:../util_test/createsourcedata.cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

@Test
public class SrcRangeTest {
    let srcPositionIns_1: SrcPosition = SrcPosition(-1, 0, -1)
    var returnFlag: Int64 = -1
    var intRes: Int64 = -1
    var boolRes: Bool = false
    var strRes: String = ""

    @TestCase
    func testSrcRange_combination_01(): Unit {
        let srcPositionIns_2: SrcPosition = SrcPosition(1, 2, 3)
        let SrcRangeIns_1: SrcRange = SrcRange(srcPositionIns_1, srcPositionIns_2)
        strRes = SrcRangeIns_1.start().toString()
        @Assert(strRes, "0,-1:-1")
        boolRes = SrcRangeIns_1.isTracked()
        @Assert(boolRes, true)
        intRes = SrcRangeIns_1.hashCode()
        let SrcRangeIns_2: SrcRange = SrcRange(srcPositionIns_1, srcPositionIns_2)
        boolRes = SrcRangeIns_2 == SrcRangeIns_1
        @Assert(boolRes, true)
        strRes = SrcRangeIns_1.toString() 
        @Assert(strRes, "0,-1:-1-2,3:1")
        @Assert(SrcRangeIns_2.hashCode() == SrcRangeIns_1.hashCode(), true)
        @Assert(SrcRangeIns_2.hashCode(), -28796)
        let srcPositionIns_3: SrcPosition = SrcPosition(-1, -1, -1)
        let SrcRangeIns_3: SrcRange = SrcRange(srcPositionIns_3, srcPositionIns_2)
        let SrcRangeIns_4: SrcRange = SrcRange(srcPositionIns_3, srcPositionIns_3)
        @Assert(SrcRangeIns_3.hashCode() != SrcRangeIns_2.hashCode(), true)
        @Assert(SrcRangeIns_4.isTracked(), false)
        @Assert(SrcRangeIns_4.end() == SrcRangeIns_3.start() , true)
    }
}
