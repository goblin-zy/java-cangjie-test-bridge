// 3rd_party_lib:ahocorasick4cj/build/ahoCorasick4cj
// 3rd_party_lib_ohos:ahocorasick4cj/build/aarch64-linux-ohos/ahoCorasick4cj
import ahoCorasick4cj.*
import std.unittest.*
import std.collection.*

@Test
public class AhoCorasickTest {
    @TestCase
    func testFragmentToken(): Unit {
        var ft0: FragmentToken = FragmentToken("a^&%HGHJGlkjkj31")
        var ft1: FragmentToken = FragmentToken("")
        var fragments0 = ft0.getFragment()
        @Assert(fragments0, "a^&%HGHJGlkjkj31")
        var fragments1 = ft1.getFragment()
        @Assert(fragments1, "")
        var ismatchs = ft0.isMatch()
        @Assert(ismatchs, false)
        var fremit = ft0.getEmit()
        var fragemitBool: Bool = true
        if (let None <- fremit) {
            fragemitBool = false
        }
        @Assert(fragemitBool,false)
    }

    @TestCase
    func testMatchToken(): Unit {
        var mt: MatchToken = MatchToken("b8 ** & 0", Emit(0, 11, ""))
        var mtfrags = mt.getFragment()
        @Assert(mtfrags, "b8 ** & 0")
        var mtismatchs = mt.isMatch()
        @Assert(mtismatchs, true)
        var mtemit = mt.getEmit().getOrThrow()

        @Assert(0, mtemit.getStart())
        @Assert(11, mtemit.getEnd())
        @Assert("", mtemit.getKeyword())
    }
}
