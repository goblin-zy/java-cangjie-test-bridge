package ahoCorasick4cj
import std.collection.*
import std.unittest.*
import std.unittest.testmacro.*

private class IntervalBridge <: Comparable<IntervalBridge> {
    public let interval: Interval
    public init(interval: Interval) { this.interval = interval }
    public func compare(rhs: IntervalBridge): Ordering { return interval.compareTo(rhs.interval).compare(0) }
}
private class UnrelatedValue { public init() {} }
@Test
class IntervalTest {
    @TestCase
    func test_construct(): Unit {
        let interval = Interval(1, 3)
        @Assert(Int32(1), interval.getStart())
        @Assert(Int32(3), interval.getEnd())
    }
    @TestCase
    func test_size(): Unit {
        @Assert(Int32(3), Interval(0, 2).size())
    }
    @TestCase
    func test_intervaloverlaps(): Unit {
        @Assert(Interval(1, 3).overlapsWith(Interval(2, 4)))
    }
    @TestCase
    func test_intervalDoesNotOverlap(): Unit {
        @Assert(!Interval(1, 13).overlapsWith(Interval(27, 42)))
    }
    @TestCase
    func test_pointOverlaps(): Unit {
        @Assert(Interval(1, 3).overlapsWith(Int32(2)))
    }
    @TestCase
    func test_pointDoesNotOverlap(): Unit {
        @Assert(!Interval(1, 13).overlapsWith(Int32(42)))
    }
    @TestCase
    func test_comparable(): Unit {
        let ordered = TreeSet<IntervalBridge>()
        ordered.add(IntervalBridge(Interval(4, 6)))
        ordered.add(IntervalBridge(Interval(2, 7)))
        ordered.add(IntervalBridge(Interval(3, 4)))
        let cursor = ordered.iterator()
        @Assert(Int32(2), cursor.next().getOrThrow().interval.getStart())
        @Assert(Int32(3), cursor.next().getOrThrow().interval.getStart())
        @Assert(Int32(4), cursor.next().getOrThrow().interval.getStart())
    }
    @TestCase
    func test_checkToString(): Unit {
        @Assert("4:6", Interval(4, 6).toString())
    }
    @TestCase
    func test_compareToNegativeTest(): Unit {
        @Assert(Int32(-1), Interval(4, 6).compareTo(UnrelatedValue()))
    }
}
