// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

import ahoCorasick4cj.*
import std.unittest.*
import std.unittest.testmacro.*
import std.collection.*
import std.math.MathExtension

main(): Int64 {
    let bugfixTest = BugfixTest()
    bugfixTest.testAddState01()
    bugfixTest.testAddState02()
    bugfixTest.testInterval01()
    bugfixTest.testInterval02()
    return 0
}

@Test
public class BugfixTest {

    @TestCase
    public func testAddState01(): Unit {
        var payloadState: PayloadState<String> = PayloadState<String>(Int32(Int16.Max))
        payloadState.addState(r'\u{4f60}')
        @Assert(payloadState.getStates().size, 1)
    }

    @TestCase
    public func testAddState02(): Unit {
        var payloadState: PayloadState<String> = PayloadState<String>(Int32(Int16.Max))
        payloadState.addState(r'?')
        @Assert(payloadState.getStates().size, 1)
    }

    @TestCase
    public func testInterval01(): Unit {
        let emit_1: PayloadEmit<String> = PayloadEmit<String>(0,0,"emit_1",None)
        let emit_2: PayloadEmit<String> = PayloadEmit<String>(-2,0,"emit_2","None")
        let emit_3: PayloadEmit<String> = PayloadEmit<String>(3,8,"emit_3","%仓颉%")
        let intervalableArrL1:ArrayList<Intervalable> = ArrayList<Intervalable>([emit_1,emit_2,emit_3])
        let intervalableArrL2:ArrayList<Intervalable> = ArrayList<Intervalable>([emit_1,emit_2])
        let intervalTree_1: IntervalTree = IntervalTree(intervalableArrL1)
        intervalTree_1.findOverlaps(intervalableArrL1.get(0).getOrThrow())
        intervalTree_1.findOverlaps(intervalableArrL2.get(0).getOrThrow())
    }

    @TestCase
    public func testInterval02(): Unit {
        let emit_1: Emit = Emit(0, 0, "emit_1")
        let emit_3: Emit = Emit(1, 1, "emit_3")
        let intervalableArrL:ArrayList<Intervalable> = ArrayList<Intervalable>([emit_1,emit_3])
        IntervalNode.newInstance(intervalableArrL)
        IntervalNode.determineMedian(intervalableArrL)
        try {
            Emit(-3, 0, "emit_2")
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

}
