// 3rd_party_lib:ahocorasick4cj/build/ahoCorasick4cj
// 3rd_party_lib_ohos:ahocorasick4cj/build/aarch64-linux-ohos/ahoCorasick4cj
import ahoCorasick4cj.*
import std.unittest.*
import std.collection.*

@Test
public class AhoCorasickTest {
    @TestCase
    func testDefaultToken_00(): Unit {
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
    func testDefaultToken_01(): Unit {
        var dt: DefaultToken = DefaultToken(PayloadFragmentToken<String>("abc"))
        var strings = ""
        var dtfragment: String = dt.getFragment()
        @Assert("abc", dtfragment)
        @Assert(false, dt.isMatch())
        try {
            dt.getEmit()
        } catch (e1: NoneValueException) {
            strings = e1.toString()
        }
        @Assert(strings, "NoneValueException")
    }

    @TestCase
    func testDefaultToken_02(): Unit {
        var dt: DefaultToken = DefaultToken(PayloadMatchToken<String>("", PayloadEmit<String>(0, 11, "c", None)))
        dt.getEmit()
        var t1 = dt.isMatch()
        @Assert(t1, true)
        var emitdt = dt.getEmit().getOrThrow()
        var keywords = emitdt.getKeyword()
        @Assert("c", keywords)
    }
}
