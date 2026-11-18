// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
//dependence:../util_test/createsourcedata.cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

@Test
public class SrcRangeTest {
    let srcPositionIns_1: SrcPosition = SrcPosition(0, 0, 0)
    let sourceDataIns: SourceData = SourceData()
    var intRes: Int64 = -1
    var boolRes: Bool = false
    var strRes: String = ""
    var returnFlag: Int64 = -1

    @TestCase
    func testSrcPosition_compare_01(): Unit {
        intRes = srcPositionIns_1.pos() 
        @Assert(intRes, 0)
        intRes = srcPositionIns_1.lineNumber() 
        @Assert(intRes, 0)
        intRes = srcPositionIns_1.columnNumber() 
        @Assert(intRes, 0)
        strRes = srcPositionIns_1.toString()
        @Assert(strRes, "0,0:0")
        intRes = srcPositionIns_1.hashCode()
        @Assert(intRes, 0)
        let srcPositionIns_2: SrcPosition = SrcPosition(-1, -1, -1)
        boolRes = srcPositionIns_2 == srcPositionIns_1
        @Assert(boolRes, false)
        let srcPositionIns_4: SrcPosition = SrcPosition(-1, -1, -1)
        @Assert(srcPositionIns_4 == srcPositionIns_2, true)
        @Assert(srcPositionIns_4.hashCode() == srcPositionIns_2.hashCode(), true)
        @Assert(srcPositionIns_4.toString(), "-1,-1:-1")
        @Assert(srcPositionIns_4.toString() == srcPositionIns_2.toString(), true)
    }
}
