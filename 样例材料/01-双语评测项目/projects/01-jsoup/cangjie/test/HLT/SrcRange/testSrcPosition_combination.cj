// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
//dependence:../util_test/createsourcedata.cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*
import std.math.*

@Test
public class SrcRangeTest {
    let srcPositionIns_1: SrcPosition = SrcPosition(0, 0, 0)
    let sourceDataIns: SourceData = SourceData()
    var returnFlag: Int64 = -1
    var intRes: Int64 = -1
    var boolRes: Bool = false
    var strRes: String = ""

    @TestCase
    func testSrcPosition_combination_01(): Unit {
        intRes = srcPositionIns_1.pos()
        @Assert(intRes, 0)
        intRes = srcPositionIns_1.lineNumber()
        @Assert(intRes, 0)
        intRes = srcPositionIns_1.columnNumber()
        @Assert(intRes, 0)
        boolRes = srcPositionIns_1.isTracked()
        @Assert(boolRes, true)
        strRes = srcPositionIns_1.toString() // 0,0:0 限定格式
        @Assert(strRes, "0,0:0")
        let srcPositionIns_2: SrcPosition = SrcPosition(Int64.Min, 500, Int64.Max)
        @Assert(srcPositionIns_2.pos(), Int64.Min)
        @Assert(srcPositionIns_2.lineNumber(), 500)
        @Assert(srcPositionIns_2.columnNumber(), Int64.Max)
    }

    @TestCase
    func testSrcPosition_combination_02(): Unit {
        let srcPositionIns_1: SrcPosition = SrcPosition(-1, -1, -1)
        intRes = srcPositionIns_1.pos()
        @Assert(intRes, -1)
        intRes = srcPositionIns_1.lineNumber()
        @Assert(intRes, -1)
        intRes = srcPositionIns_1.columnNumber()
        @Assert(intRes, -1)
        boolRes = srcPositionIns_1.isTracked()
        @Assert(boolRes, false)
        strRes = srcPositionIns_1.toString()
        @Assert(strRes, "-1,-1:-1")
        let srcPositionIns_2: SrcPosition = SrcPosition(-16, 2, 12)
        let srcPositionIns_3: SrcPosition = SrcPosition(16, -2, 12)
        let srcPositionIns_4: SrcPosition = SrcPosition(16, 2, -12)
        @Assert(srcPositionIns_2.toString(), "2,12:-16")
        @Assert(srcPositionIns_3.toString(), "-2,12:16")
        @Assert(srcPositionIns_4.toString(), "2,-12:16")
    }
}
