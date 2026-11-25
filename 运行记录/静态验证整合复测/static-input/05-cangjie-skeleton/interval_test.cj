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
        /* FRAGMENT_BEGIN:W12_01 */
        throw Exception("SKELETON_PLACEHOLDER:W12_01")
        /* FRAGMENT_END:W12_01 */
    }
    @TestCase
    func test_size(): Unit {
        /* FRAGMENT_BEGIN:W12_02 */
        throw Exception("SKELETON_PLACEHOLDER:W12_02")
        /* FRAGMENT_END:W12_02 */
    }
    @TestCase
    func test_intervaloverlaps(): Unit {
        /* FRAGMENT_BEGIN:W12_03 */
        throw Exception("SKELETON_PLACEHOLDER:W12_03")
        /* FRAGMENT_END:W12_03 */
    }
    @TestCase
    func test_intervalDoesNotOverlap(): Unit {
        /* FRAGMENT_BEGIN:W12_04 */
        throw Exception("SKELETON_PLACEHOLDER:W12_04")
        /* FRAGMENT_END:W12_04 */
    }
    @TestCase
    func test_pointOverlaps(): Unit {
        /* FRAGMENT_BEGIN:W12_05 */
        throw Exception("SKELETON_PLACEHOLDER:W12_05")
        /* FRAGMENT_END:W12_05 */
    }
    @TestCase
    func test_pointDoesNotOverlap(): Unit {
        /* FRAGMENT_BEGIN:W12_06 */
        throw Exception("SKELETON_PLACEHOLDER:W12_06")
        /* FRAGMENT_END:W12_06 */
    }
    @TestCase
    func test_comparable(): Unit {
        /* FRAGMENT_BEGIN:W12_07 */
        throw Exception("SKELETON_PLACEHOLDER:W12_07")
        /* FRAGMENT_END:W12_07 */
    }
    @TestCase
    func test_checkToString(): Unit {
        /* FRAGMENT_BEGIN:W12_08 */
        throw Exception("SKELETON_PLACEHOLDER:W12_08")
        /* FRAGMENT_END:W12_08 */
    }
    @TestCase
    func test_compareToNegativeTest(): Unit {
        /* FRAGMENT_BEGIN:W12_09 */
        throw Exception("SKELETON_PLACEHOLDER:W12_09")
        /* FRAGMENT_END:W12_09 */
    }
}
