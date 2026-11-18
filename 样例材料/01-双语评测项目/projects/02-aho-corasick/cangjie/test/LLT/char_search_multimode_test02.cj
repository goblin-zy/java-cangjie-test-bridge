// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

import ahoCorasick4cj.*
import std.unittest.*
import std.unittest.testmacro.*

main(): Int64 {
    let charSearchTest04 = CharSearchTest04()

    charSearchTest04.testCharSearch01()
    charSearchTest04.testCharSearch02()
    charSearchTest04.testCharSearch03()
    charSearchTest04.testCharSearch04()
    charSearchTest04.testCharSearch05()
    charSearchTest04.testCharSearch06()
    charSearchTest04.testCharSearch07()
    charSearchTest04.testCharSearch08()
    charSearchTest04.testCharSearch09()
    charSearchTest04.testCharSearch10()
    charSearchTest04.testCharSearch11()
    charSearchTest04.testCharSearch12()
    charSearchTest04.testCharSearch13()
    charSearchTest04.testCharSearch14()
    charSearchTest04.testCharSearch15()
    charSearchTest04.testCharSearch16()
    charSearchTest04.testCharSearch17()
    charSearchTest04.testCharSearch18()
    charSearchTest04.testCharSearch19()

    return 0
}

@Test
public class CharSearchTest04 {

    @TestCase
    public func testCharSearch01(): Unit {
        var trie = Trie.builder().ignoreOverlaps()
            .addKeyword("ab")
            .addKeyword("cba")
            .addKeyword("ababc")
            .build()
        var firstMatch: Emit = trie.firstMatch("ababcbab").getOrThrow()
        println(firstMatch.toString())
    }

    @TestCase
    public func testCharSearch02(): Unit {
        var trie = Trie.builder().ignoreOverlaps()
            .addKeyword("ab")
            .addKeyword("cba")
            .addKeyword("ababc")
            .build()
        try {
            trie.firstMatch("zxvzxbbwsf").getOrThrow()
        } catch (e: NoneValueException) {
            e.printStackTrace()
        }
    }

    @TestCase
    public func testCharSearch03(): Unit {
        var df: DefaultEmitHandler = DefaultEmitHandler()
        var ft: FragmentToken = FragmentToken("a")
        var dt: DefaultToken = DefaultToken(PayloadMatchToken<String>("", PayloadEmit<String>(0, 11, "c", None)))
        dt.getEmit()
        var mt: MatchToken = MatchToken("b", Emit(0, 11, ""))
        mt.isMatch()
        mt.getEmit()
        ft.getEmit()
        var t1 = ft.isMatch()
        var t2 = df.emit(Emit(0, 11, ""))
        df.getEmits()
        @Assert(t1, false)
        @Assert(t2, true)
    }

    @TestCase
    public func testCharSearch04(): Unit {
        var i: Interval = Interval(0, 11)
        var i2: Interval = Interval(5, 23)
        let t1 = i.overlapsWith(i2)
        let t2 = i.overlapsWith(10)
        i.compareTo(i2)
        @Assert(t1, true)
        @Assert(t2, true)
    }

    @TestCase
    public func testCharSearch05(): Unit {
        var ped: PayloadEmitDelegateHandler = PayloadEmitDelegateHandler(DefaultEmitHandler())
        var pft: PayloadFragmentToken<String> = PayloadFragmentToken<String>("d")
        var pmt: PayloadMatchToken<String> = PayloadMatchToken<String>("e", PayloadEmit<String>(0, 11, "c", None))
        pmt.getEmit()
        pft.getEmit()
        let t1 = ped.emit(PayloadEmit<String>(0, 11, "c", None))
        @Assert(t1, true)
    }

    @TestCase
    public func testCharSearch06(): Unit {
        var s: State = State(0)
        var sped: StatefulPayloadEmitDelegateHandler = StatefulPayloadEmitDelegateHandler(DefaultEmitHandler())
        sped.emit(PayloadEmit<String>(0, 13, "ccs", None))
        sped.getEmits()
        s.nextState(r'c')
        s.nextStateIgnoreRootState(r'b')
        var s1 = s.addState("cccd")
        var s2 = s1.addState("weeee")
        s2.getDepth()
        s2.addEmit("uuu")
        s2.emit()
        s2.failures()
        s2.getStates()
        s2.setFailure(s1)
        let col = s2.getTransitions().toArray().toString()
        @Assert(col, "[]")
    }

    @TestCase
    public func testCharSearch07(): Unit {
        var trie = Trie.builder().ignoreOverlaps()
            .addKeyword("nm,cx")
            .addKeyword("dsad")
            .addKeyword("wqweqw")
            .build()
        var firstMatch: Emit = trie.firstMatch("dsajkdnm,cxz").getOrThrow()
        println(firstMatch.toString())
    }

    @TestCase
    public func testCharSearch08(): Unit {
        var trie = Trie.builder().ignoreOverlaps()
            .addKeyword("ab")
            .addKeyword("cba")
            .addKeyword("ababc")
            .build()
        try {
            trie.firstMatch("qwrravzadsxbgf").getOrThrow()
        } catch (e: NoneValueException) {
            e.printStackTrace()
        }
    }

    @TestCase
    public func testCharSearch09(): Unit {
        var df: DefaultEmitHandler = DefaultEmitHandler()
        var ft: FragmentToken = FragmentToken("aaaa")
        var dt: DefaultToken = DefaultToken(PayloadMatchToken<String>("", PayloadEmit<String>(0, 11, "c", None)))
        dt.getEmit()
        var mt: MatchToken = MatchToken("b", Emit(0, 11, ""))
        mt.isMatch()
        mt.getEmit()
        ft.getEmit()
        var t1 = ft.isMatch()
        var t2 = df.emit(Emit(0, 11, ""))
        df.getEmits()
        @Assert(t1, false)
        @Assert(t2, true)
    }

    @TestCase
    public func testCharSearch10(): Unit {
        var ped: PayloadEmitDelegateHandler = PayloadEmitDelegateHandler(DefaultEmitHandler())
        var pft: PayloadFragmentToken<String> = PayloadFragmentToken<String>("rrrrr")
        var pmt: PayloadMatchToken<String> = PayloadMatchToken<String>("yyyyy", PayloadEmit<String>(0, 11, "c", None))
        pmt.getEmit()
        pft.getEmit()
        let t1 = ped.emit(PayloadEmit<String>(0, 15, "fasfasg", None))
        @Assert(t1, true)
    }

    @TestCase
    public func testCharSearch11(): Unit {
        var ped: PayloadEmitDelegateHandler = PayloadEmitDelegateHandler(DefaultEmitHandler())
        var pft: PayloadFragmentToken<String> = PayloadFragmentToken<String>("ddd")
        var pmt: PayloadMatchToken<String> = PayloadMatchToken<String>("eee", PayloadEmit<String>(0, 11, "c", None))
        pmt.getEmit()
        pft.getEmit()
        let t1 = ped.emit(PayloadEmit<String>(0, 13, "cccc", None))
        @Assert(t1, true)
    }

    @TestCase
    public func testCharSearch12(): Unit {
        var s: State = State(0)
        var sped: StatefulPayloadEmitDelegateHandler = StatefulPayloadEmitDelegateHandler(DefaultEmitHandler())
        sped.emit(PayloadEmit<String>(1, 50, "ccs", None))
        sped.getEmits()
        s.nextState(r'c')
        s.nextStateIgnoreRootState(r'b')
        var s1 = s.addState("cccd")
        var s2 = s1.addState("weeee")
        let col = s2.getTransitions().toArray().toString()
        @Assert(col, "[]")
    }

    @TestCase
    public func testCharSearch13(): Unit {
        var s: State = State(0)
        var sped: StatefulPayloadEmitDelegateHandler = StatefulPayloadEmitDelegateHandler(DefaultEmitHandler())
        sped.emit(PayloadEmit<String>(0, 13, "asfasf", None))
        sped.getEmits()
        s.nextState(r'a')
        s.nextStateIgnoreRootState(r't')
        var s1 = s.addState("cccd")
        var s2 = s1.addState("fsafasgzxbv")
        let col = s2.getTransitions().toArray().toString()
        @Assert(col, "[]")
    }

    @TestCase
    public func testCharSearch14(): Unit {
        var trie = Trie.builder().ignoreOverlaps()
            .addKeyword("wjlkxznvmwor")
            .addKeyword("dsad")
            .addKeyword("wqweqw")
            .build()
        var firstMatch: Emit = trie.firstMatch("wjlkxznvmwordsajkdnm,cxz").getOrThrow()
        println(firstMatch.toString())
    }

    @TestCase
    public func testCharSearch15(): Unit {
        var trie = Trie.builder().ignoreOverlaps()
            .addKeyword("ncaa")
            .addKeyword("cba")
            .addKeyword("nba")
            .build()
        try {
            trie.firstMatch("faskgzjxlkn").getOrThrow()
        } catch (e: NoneValueException) {
            e.printStackTrace()
        }
    }

    @TestCase
    public func testCharSearch16(): Unit {
        var df: DefaultEmitHandler = DefaultEmitHandler()
        var ft: FragmentToken = FragmentToken("bbbb")
        var dt: DefaultToken = DefaultToken(PayloadMatchToken<String>("", PayloadEmit<String>(0, 11, "c", None)))
        dt.getEmit()
        var mt: MatchToken = MatchToken("c", Emit(0, 16, ""))
        mt.isMatch()
        mt.getEmit()
        ft.getEmit()
        var t1 = ft.isMatch()
        var t2 = df.emit(Emit(0, 16, ""))
        df.getEmits()
        @Assert(t1, false)
        @Assert(t2, true)
    }

    @TestCase
    public func testCharSearch17(): Unit {
        var ped: PayloadEmitDelegateHandler = PayloadEmitDelegateHandler(DefaultEmitHandler())
        var pft: PayloadFragmentToken<String> = PayloadFragmentToken<String>("uuuiqowhn")
        var pmt: PayloadMatchToken<String> = PayloadMatchToken<String>("jfaksln", PayloadEmit<String>(0, 11, "c", None))
        pmt.getEmit()
        pft.getEmit()
        let t1 = ped.emit(PayloadEmit<String>(0, 16, "asfjzm,xnv", None))
        @Assert(t1, true)
    }

    @TestCase
    public func testCharSearch18(): Unit {
        var ped: PayloadEmitDelegateHandler = PayloadEmitDelegateHandler(DefaultEmitHandler())
        var pft: PayloadFragmentToken<String> = PayloadFragmentToken<String>("fff")
        var pmt: PayloadMatchToken<String> = PayloadMatchToken<String>("ggg", PayloadEmit<String>(0, 11, "c", None))
        pmt.getEmit()
        pft.getEmit()
        let t1 = ped.emit(PayloadEmit<String>(0, 13, "zxgvg", None))
        @Assert(t1, true)
    }

    @TestCase
    public func testCharSearch19(): Unit {
        var s: State = State(0)
        var sped: StatefulPayloadEmitDelegateHandler = StatefulPayloadEmitDelegateHandler(DefaultEmitHandler())
        sped.emit(PayloadEmit<String>(1, 32, "ccs", None))
        sped.getEmits()
        s.nextState(r'c')
        s.nextStateIgnoreRootState(r'b')
        var s1 = s.addState("cccd")
        var s2 = s1.addState("weeee")
        let col = s2.getTransitions().toArray().toString()
        @Assert(col, "[]")
    }
}
