package ahoCorasick4cj

import std.collection.*
import std.unittest.*
import std.unittest.testmacro.*

// Test-only bridge: delegate ordering to the existing business method.
private class IntervalOrder <: Comparable<IntervalOrder> {
    public let value: Interval
    public init(value: Interval) {
        this.value = value
    }
    public func compare(other: IntervalOrder): Ordering {
        return value.compareTo(other.value).compare(0)
    }
}

// An ordinary object outside the Intervalable hierarchy.
private class NonIntervalObject {
    public init() {}
}

@Test
class IntervalTest {
    @TestCase
    func test_construct(): Unit {
        let i = Interval(1, 3)
        @Assert(Int32(1), i.getStart())
        @Assert(Int32(3), i.getEnd())
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
        let intervals = TreeSet<IntervalOrder>()
        intervals.add(IntervalOrder(Interval(4, 6)))
        intervals.add(IntervalOrder(Interval(2, 7)))
        intervals.add(IntervalOrder(Interval(3, 4)))
        let it = intervals.iterator()
        let first = it.next().getOrThrow().value.getStart()
        @Assert(Int32(2), first)
        let second = it.next().getOrThrow().value.getStart()
        @Assert(Int32(3), second)
        let third = it.next().getOrThrow().value.getStart()
        @Assert(Int32(4), third)
    }

    @TestCase
    func test_checkToString(): Unit {
        @Assert("4:6", Interval(4, 6).toString())
    }

    @TestCase
    func test_compareToNegativeTest(): Unit {
        @Assert(Int32(-1), Interval(4, 6).compareTo(NonIntervalObject()))
    }

}
