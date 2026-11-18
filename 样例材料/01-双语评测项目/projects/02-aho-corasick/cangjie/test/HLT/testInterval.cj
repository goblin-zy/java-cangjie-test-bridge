// 3rd_party_lib:ahocorasick4cj/build/ahoCorasick4cj
// 3rd_party_lib_ohos:ahocorasick4cj/build/aarch64-linux-ohos/ahoCorasick4cj
import ahoCorasick4cj.*
import std.unittest.*
import std.collection.*
import std.math.MathExtension

@Test
public class AhoCorasickTest {
    var strRes: String = ""
    var intRes: Int64 = -1
    var int32Res: Int32 = -1
    var returnFlag: Int64 = -1

    @TestCase
    func testInterval_01(): Unit {
        let interval_1: Interval = Interval(0, 0)
        int32Res = interval_1.getStart()
        @Assert(int32Res,0)
        intRes = interval_1.hashCode()
        @Assert(intRes, 0)
        strRes = interval_1.toString()
        @Assert(strRes, "0:0")
        int32Res = interval_1.getEnd()
        @Assert(int32Res,0)
        int32Res = interval_1.size()
        @Assert(int32Res,1)
        let interval_2: Interval = Interval(0, 2)
        @Assert(interval_2.hashCode() == interval_1.hashCode(), false)
        @Assert(interval_2 != interval_1, true)
        @Assert(interval_2.toString(), "0:2")
        @Assert(interval_2.hashCode(), 2)
    }

    @TestCase
    func testInterval_02(): Unit {
        returnFlag = -1
        let interval_1: Interval = Interval(-2, 0)
        int32Res = interval_1.getStart()
        @Assert(int32Res,-2)
        strRes = interval_1.toString()
        @Assert(strRes, "-2:0")
        int32Res = interval_1.getEnd()
        @Assert(int32Res,0)
        int32Res = interval_1.size()
        @Assert(int32Res,3)

        try {
            let interval_2: Interval = Interval(-2, 0)
            @Assert(interval_2.hashCode() != interval_1.hashCode(), false)
            @Assert(interval_2 == interval_1, true)
            @Assert(interval_2.hashCode(), -2)
        } catch (e1: IllegalArgumentException) {
            returnFlag = 1
        }

        try {
            let interval_3: Interval = Interval(Int32.Min, Int32.Max)
            @Assert(interval_3.getStart(),Int32.Min)
        } catch (e1: OverflowException) {
            @Assert(e1.toString().contains("OverflowException:"), true)
            returnFlag = 0
        }
        @Assert(returnFlag ,0)
    }
}
