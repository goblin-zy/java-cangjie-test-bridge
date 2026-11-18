// 3rd_party_lib:ahocorasick4cj/build/ahoCorasick4cj
// 3rd_party_lib_ohos:ahocorasick4cj/build/aarch64-linux-ohos/ahoCorasick4cj
import ahoCorasick4cj.*
import std.unittest.*
import std.collection.*

@Test
public class AhoCorasickTest {
    @TestCase
    func tesPayloadFragmentToken_00(): Unit {
        var fragt = PayloadFragmentToken<String>("abc")
        var dtfragment: String = fragt.getFragment()
        @Assert("abc", dtfragment)
        @Assert(false, fragt.isMatch())
        var fragemit = fragt.getEmit()
        var fragemitBool: Bool = true
        if (let None <- fragemit) {
            fragemitBool = false
        }
        @Assert(fragemitBool,false)
    }
}
