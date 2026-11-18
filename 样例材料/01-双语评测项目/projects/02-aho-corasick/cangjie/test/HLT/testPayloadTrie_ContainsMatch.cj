// 3rd_party_lib:ahocorasick4cj/build/ahoCorasick4cj
// 3rd_party_lib_ohos:ahocorasick4cj/build/aarch64-linux-ohos/ahoCorasick4cj
import ahoCorasick4cj.*
import std.unittest.*
import std.collection.*

@Test
public class AhoCorasickTest {
    @TestCase
    func testPayloadTrie_00(): Unit {
        var payloadTrieBuilder_1 = PayloadTrie<String>.builder()
        var payloadTrieBuild_1 =
            payloadTrieBuilder_1.ignoreOverlaps().addKeyword("ab").addKeyword("cba").addKeyword("ababc").build()
        @Assert(payloadTrieBuild_1.containsMatch("ababcbab"),true)
    }

    @TestCase
    func testPayloadTrie_01(): Unit {
        var payloadTrieBuilder_1 = PayloadTrie<String>.builder()
        var payloadTrieBuild_1 =
            payloadTrieBuilder_1.ignoreOverlaps().addKeyword("324432").addKeyword("cba").addKeyword("ababc").build()
        @Assert(payloadTrieBuild_1.containsMatch("adbdadbfcxbchchahbdddd"),false)
    }
}
