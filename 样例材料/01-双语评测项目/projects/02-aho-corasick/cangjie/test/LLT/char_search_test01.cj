// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

import ahoCorasick4cj.*
import std.unittest.*
import std.unittest.testmacro.*

main(): Int64 {
    let charSearchTest = CharSearchTest()

    charSearchTest.testDefaultPayloadEmitHandler()
    charSearchTest.testEmit()
    charSearchTest.testInterval()
    charSearchTest.testPayload()
    charSearchTest.testPayloadEmit()
    charSearchTest.testTrieConfig()
    charSearchTest.testPayloadState()

    return 0
}

@Test
public class CharSearchTest {

    @TestCase
    public func testDefaultPayloadEmitHandler(): Unit {
        var d: DefaultPayloadEmitHandler<String> = DefaultPayloadEmitHandler<String>()
        let arr = d.getEmits()
        arr.isEmpty()
        let res = d.emit(PayloadEmit<String>(0, 0, "", None))
        @Assert(res, true)
    }

    @TestCase
    public func testEmit(): Unit {
        let e: Emit = Emit(0, 0, "hel")
        let e2: Emit = Emit(0, 0, "hello")
        let e3: Emit = Emit(0, 0, "hel")
        let k: String = e.getKeyword()
        let b1: Bool = e ==(e2)
        let b2: Bool = e !=(e2)
        let b3: Bool = e !=(e3)
        let b4: Bool = e ==(e3)
        let i = e.hashCode()
        let str = e.toString()
        @Assert(k, "hel")
        @Assert(b1, false)
        @Assert(b2, true)
        @Assert(b3, false)
        @Assert(b4, true)
        @Assert(str, "0:0=hel")
    }

    @TestCase
    public func testInterval(): Unit {
        let i: Interval = Interval(1, 2)
        let i2: Interval = Interval(1, 3)
        let i3: Interval = Interval(1, 2)
        let start = i.getStart()
        let b1: Bool = i ==(i2)
        let b2: Bool = i !=(i2)
        let b3: Bool = i !=(i3)
        let b4: Bool = i ==(i3)
        let h = i.hashCode()
        i.getEnd()
        i.size()
        i.toString()
        @Assert(start, 1)
        @Assert(b1, false)
        @Assert(b2, true)
        @Assert(b3, false)
        @Assert(b4, true)
    }

    @TestCase
    public func testPayload(): Unit {
        let p: Payload<String> = Payload<String>("hel", "lo")
        let p2: Payload<String> = Payload<String>("cang", "jie")
        let str: String = p.getKeyword()
        let data = p.getData()
        let b1: Bool = p ==(p2)
        let b2: Bool = p !=(p2)
        let h = p.hashCode()
        p.compare(p2)
        @Assert(str, "hel")
        @Assert(data, "lo")
        @Assert(b1, false)
        @Assert(b2, true)
    }

    @TestCase
    public func testPayloadEmit(): Unit {
        let p: PayloadEmit<String> = PayloadEmit<String>(5, 7, "hel", "lo")
        let p2: PayloadEmit<String> = PayloadEmit<String>(5, 7, "cang", "jie")
        let str: String = p.getKeyword()
        let data = p.getPayload()
        let str2: String = p2.toString()
        str2.isEmpty()
        let b1: Bool = p ==(p2)
        let b2: Bool = p !=(p2)
        let h = p.hashCode()
        @Assert(str, "hel")
        @Assert(data, "lo")
        @Assert(b1, false)
        @Assert(b2, true)
    }

    @TestCase
    public func testPayloadState(): Unit {
        let p: PayloadState<String> = PayloadState<String>(0)
        p.addEmit(Payload<String>("hel", "lo"))
        let ps: PayloadState<String> = p.addState(r'h')
        p.nextStateIgnoreRootState(r'e')
        p.nextState(r'r')
        p.getStates()
        p.setFailure(ps)
        let col = p.getTransitions().toArray().toString()
        p.failures()
        let e = p.emit()
        p.addEmit(e)
        @Assert(col, "[h]")
    }

    @TestCase
    public func testTrieConfig(): Unit {
        let tc: TrieConfig = TrieConfig()
        tc.setStopOnHit(true)
        let so = tc.isStopOnHit()
        tc.setAllowOverlaps(false)
        let ao = tc.isAllowOverlaps()
        tc.setOnlyWholeWords(true)
        let ow = tc.isOnlyWholeWords()
        tc.setOnlyWholeWordsWhiteSpaceSeparated(true)
        let owwss = tc.isOnlyWholeWordsWhiteSpaceSeparated()
        tc.setCaseInsensitive(false)
        let ci = tc.isCaseInsensitive()
        @Assert(so, true)
        @Assert(ao, false)
        @Assert(ow, true)
        @Assert(owwss, true)
        @Assert(ci, false)
    }

}
