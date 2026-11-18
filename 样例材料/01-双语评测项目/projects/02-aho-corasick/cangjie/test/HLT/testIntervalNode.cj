// 3rd_party_lib:ahocorasick4cj/build/ahoCorasick4cj
// 3rd_party_lib_ohos:ahocorasick4cj/build/aarch64-linux-ohos/ahoCorasick4cj
import ahoCorasick4cj.*
import std.unittest.*
import std.collection.*

@Test
public class AhoCorasickTest {
    var int32Res: Int32 = -2
    var strRes: String = ""
    var returnFlag: Int64 = -1

    @TestCase
    func testIntervalNode_01(): Unit {
        let intervalNode_1: IntervalNode = IntervalNode.newInstance(ArrayList<Intervalable>())
        int32Res = IntervalNode.determineMedian(ArrayList<Intervalable>())
        @Assert(int32Res,-1)
        let emit_1: Emit = Emit(0, 0, "emit_1")
        let emit_2: Emit = Emit(-3, 0, "emit_2")
        let intervalableArrL: ArrayList<Intervalable> = ArrayList<Intervalable>([emit_1, emit_2])
        int32Res = IntervalNode.determineMedian(intervalableArrL)
        @Assert(int32Res,-1)
        let resArrL_1: ArrayList<Intervalable> = intervalNode_1.findOverlaps(emit_1)
        @Assert(resArrL_1.size,0)
    }

    @TestCase
    func testIntervalNode_02(): Unit {
        let emit_1: Emit = Emit(0, 0, "emit_1")
        let emit_2: Emit = Emit(-3, 0, "emit_2")
        let emit_3: Emit = Emit(12, 31, "emit_3")
        let intervalableArrL: ArrayList<Intervalable> = ArrayList<Intervalable>([emit_1, emit_2, emit_3])
        let intervalNode_1: IntervalNode = IntervalNode.newInstance(intervalableArrL)
        int32Res = IntervalNode.determineMedian(intervalableArrL)
        @Assert(int32Res,14)
        int32Res = IntervalNode.determineMedian(ArrayList<Intervalable>())
        @Assert(int32Res,-1)
        let resArrL_1: ArrayList<Intervalable> = intervalNode_1.findOverlaps(emit_1)
        @Assert(resArrL_1.size,1)
        var it_1 = resArrL_1.iterator()
        for (obj in it_1) {
            strRes += obj.toString()
        }
        @Assert(strRes,"-3:0=emit_2") 
        let resArrL_2: ArrayList<Intervalable> = intervalNode_1.findOverlaps(emit_3)
        @Assert(resArrL_2.size,0)
    }

    @TestCase
    func testIntervalNode_03(): Unit {
        var intervals: ArrayList<Intervalable> = ArrayList<Intervalable>()
        intervals.add(Interval(0, 2));
        intervals.add(Interval(1, 3));
        intervals.add(Interval(2, 4));
        intervals.add(Interval(3, 5));
        intervals.add(Interval(4, 6));
        intervals.add(Interval(5, 7));
        var intervalTree: IntervalTree = IntervalTree(intervals)
        var overlaps: ArrayList<Intervalable> = intervalTree.findOverlaps(Interval(1, 3))
        @Assert(3, overlaps.size)
    }
}
