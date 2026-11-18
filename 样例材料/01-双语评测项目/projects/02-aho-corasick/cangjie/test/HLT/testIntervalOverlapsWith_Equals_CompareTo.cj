// 3rd_party_lib:ahocorasick4cj/build/ahoCorasick4cj
// 3rd_party_lib_ohos:ahocorasick4cj/build/aarch64-linux-ohos/ahoCorasick4cj
import ahoCorasick4cj.*
import std.unittest.*
import std.collection.*

@Test
public class AhoCorasickTest {
    @TestCase
    func testInterval_03(): Unit {
        var i: Interval = Interval(0, 11)
        var i2: Interval = Interval(5, 23)
        var i3: Interval = Interval(15, 23)
        let t1 = i.overlapsWith(i2)
        let t2 = i.overlapsWith(10)
        let t3 = i.overlapsWith(i3)
        let t4 = i.overlapsWith(12)
        @Assert(t1, true)
        @Assert(t2, true)
        @Assert(t3, false)
        @Assert(t4, false)
    }

    @TestCase
    func testInterval_04(): Unit {
        var i: Interval = Interval(0, 11)
        var i2: Interval = Interval(0, 11)
        var i3: Interval = Interval(0, 23)
        var i4: Interval = Interval(11, 19)
        let t1 = i.equals(i2)
        let t2 = i.equals(i)
        let t3 = i.equals(i3)
        let t4 = i2.equals(i4)
        @Assert(t1, true)
        @Assert(t2, true)
        @Assert(t3, false)
        @Assert(t4, false)
    }

    @TestCase
    func testInterval_05(): Unit {
        var i: Interval = Interval(0, 11)
        var i2: Interval = Interval(0, 11)
        var i3: Interval = Interval(0, 23)
        var i4: Interval = Interval(11, 19)
        var t1 = i.compareTo(i)
        var t2 = i.compareTo(i2)
        var t3 = i.compareTo(i3)
        var t4 = i.compareTo(i4)
        var t5 = i4.compareTo(i)
        var t6 = i2.compareTo(i3)
        @Assert(t1, 0)
        @Assert(t2, 0)
        @Assert(t3, -12)
        @Assert(t4, -11)
        @Assert(t5, 11)
        @Assert(t6, -12)
    }
}
