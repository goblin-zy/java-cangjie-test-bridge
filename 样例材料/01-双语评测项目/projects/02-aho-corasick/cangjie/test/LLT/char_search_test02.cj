// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

import ahoCorasick4cj.*
import std.unittest.*
import std.unittest.testmacro.*

main(): Int64 {
    let charSearchTest02 = CharSearchTest02()

    charSearchTest02.testDefaultPayloadEmitHandler()
    charSearchTest02.testEmit()
    charSearchTest02.testInterval()
    charSearchTest02.testPayload()
    charSearchTest02.testPayloadEmit()
    charSearchTest02.testTrieConfig()
    charSearchTest02.testPayloadState()

    return 0
}

@Test
public class CharSearchTest02 {

    @TestCase
    public func testDefaultPayloadEmitHandler(): Unit {
        var d: DefaultPayloadEmitHandler<String> = DefaultPayloadEmitHandler<String>()
        let res = d.emit(PayloadEmit<String>(1, 9, "", None))
        d.getEmits()
        @Assert(res, true)
    }

    @TestCase
    public func testEmit(): Unit {
        let e: Emit = Emit(0, 0, "cang")
        let e2: Emit = Emit(0, 0, "cangjie")
        let e3: Emit = Emit(0, 0, "cang")
        let k: String = e.getKeyword()
        let b1: Bool = e ==(e2)
        let b2: Bool = e !=(e2)
        let b3: Bool = e !=(e3)
        let b4: Bool = e ==(e3)
        @Assert(k, "cang")
        @Assert(b1, false)
        @Assert(b2, true)
        @Assert(b3, false)
        @Assert(b4, true)
    }

    @TestCase
    public func testInterval(): Unit {
        let i: Interval = Interval(5, 5)
        let i2: Interval = Interval(1, 3)
        let i3: Interval = Interval(5, 5)
        let start = i.getStart()
        let b1: Bool = i ==(i2)
        let b2: Bool = i !=(i2)
        let b3: Bool = i !=(i3)
        let b4: Bool = i ==(i3)
        @Assert(start, 5)
        @Assert(b1, false)
        @Assert(b2, true)
        @Assert(b3, false)
        @Assert(b4, true)
    }

    @TestCase
    public func testPayload(): Unit {
        let p: Payload<String> = Payload<String>("hhh", "ccc")
        let p2: Payload<String> = Payload<String>("qqq", "www")
        let str: String = p.getKeyword()
        let data = p.getData()
        let b1: Bool = p ==(p2)
        let b2: Bool = p !=(p2)
        @Assert(str, "hhh")
        @Assert(data, "ccc")
        @Assert(b1, false)
        @Assert(b2, true)
    }

    @TestCase
    public func testPayloadEmit(): Unit {
        let p: PayloadEmit<String> = PayloadEmit<String>(5, 7, "sss", "ddd")
        let p2: PayloadEmit<String> = PayloadEmit<String>(5, 7, "fff", "ggg")
        let str: String = p.getKeyword()
        let data = p.getPayload()
        let b1: Bool = p ==(p2)
        let b2: Bool = p !=(p2)
        p2.toString()
        @Assert(str, "sss")
        @Assert(data, "ddd")
        @Assert(b1, false)
        @Assert(b2, true)
    }

    @TestCase
    public func testPayloadState(): Unit {
        let p: PayloadState<String> = PayloadState<String>(0)
        p.addEmit(Payload<String>("uuu", "vvv"))
        let ps: PayloadState<String> = p.addState(r'a')
        p.nextStateIgnoreRootState(r'b')
        p.nextState(r'c')
        p.getStates()
        p.setFailure(ps)
        let col = p.getTransitions().toArray().toString()
        p.failures()
        let e = p.emit()
        p.addEmit(e)
        @Assert(col, "[a]")
    }

    @TestCase
    public func testTrieConfig(): Unit {
        let tc: TrieConfig = TrieConfig()
        tc.setStopOnHit(false)
        let so = tc.isStopOnHit()
        tc.setAllowOverlaps(false)
        let ao = tc.isAllowOverlaps()
        tc.setOnlyWholeWords(false)
        let ow = tc.isOnlyWholeWords()
        tc.setOnlyWholeWordsWhiteSpaceSeparated(false)
        let owwss = tc.isOnlyWholeWordsWhiteSpaceSeparated()
        tc.setCaseInsensitive(false)
        let ci = tc.isCaseInsensitive()
        @Assert(so, false)
        @Assert(ao, false)
        @Assert(ow, false)
        @Assert(owwss, false)
        @Assert(ci, false)
    }

}
