// 3rd_party_lib:ahocorasick4cj/build/ahoCorasick4cj
// 3rd_party_lib_ohos:ahocorasick4cj/build/aarch64-linux-ohos/ahoCorasick4cj
import ahoCorasick4cj.*
import std.unittest.*
import std.collection.*

@Test
public class AhoCorasickTest {
    @TestCase
    func testFirstMatch_00(): Unit {
        var trie = Trie.builder().addKeyword("abc").build()
        var firstMatchs: Emit = trie.firstMatch("abc").getOrThrow()
        @Assert(0, firstMatchs.getStart())
        @Assert(2, firstMatchs.getEnd())
        @Assert("abc", firstMatchs.getKeyword())
    }

    @TestCase
    func testFirstMatch_01(): Unit {
        var trie = Trie.builder().addKeyword("abc").build()
        var firstMatchs: Emit = trie.firstMatch(" " + "abc").getOrThrow()
        @Assert(1, firstMatchs.getStart())
        @Assert(3, firstMatchs.getEnd())
        @Assert("abc", firstMatchs.getKeyword())
    }

    @TestCase
    func testFirstMatch_02(): Unit {
        var trie = Trie.builder().addKeyword("abc").addKeyword("bcd").addKeyword("cde").build()
        var firstMatchs: Emit = trie.firstMatch("bcd").getOrThrow()
        @Assert(0, firstMatchs.getStart())
        @Assert(2, firstMatchs.getEnd())
        @Assert("bcd", firstMatchs.getKeyword())
    }

    @TestCase
    func testFirstMatch_03(): Unit {
        var trie = Trie.builder().addKeyword("hers").addKeyword("his").addKeyword("she").addKeyword("he").build()
        var firstMatchs: Emit = trie.firstMatch("ushers").getOrThrow()
        @Assert(2, firstMatchs.getStart())
        @Assert(3, firstMatchs.getEnd())
        @Assert("he", firstMatchs.getKeyword())
    }

    @TestCase
    func testFirstMatch_04(): Unit {
        var trie = Trie.builder().addKeyword("hers").build()
        var firstMatchs: Emit = trie.firstMatch("h he her hers").getOrThrow()
        @Assert(9, firstMatchs.getStart())
        @Assert(12, firstMatchs.getEnd())
        @Assert("hers", firstMatchs.getKeyword())
    }

    @TestCase
    func testFirstMatch_05(): Unit {
        var trie =
            Trie.builder().addKeyword("veal").addKeyword("cauliflower").addKeyword("broccoli").addKeyword("tomatoes").
        build()
        var firstMatchs: Emit =
            trie.firstMatch("2 cauliflowers, 3 tomatoes, 4 slices of veal, 100g broccoli").getOrThrow()
        @Assert(2, firstMatchs.getStart())
        @Assert(12, firstMatchs.getEnd())
        @Assert("cauliflower", firstMatchs.getKeyword())
    }

    @TestCase
    func testFirstMatch_06(): Unit {
        var trie = Trie.builder().ignoreOverlaps().addKeyword("ab").addKeyword("cba").addKeyword("ababc").build()
        var firstMatchs: Emit = trie.firstMatch("ababcbab").getOrThrow()
        @Assert(0, firstMatchs.getStart())
        @Assert(4, firstMatchs.getEnd())
        @Assert("ababc", firstMatchs.getKeyword())
    }

    @TestCase
    func testFirstMatch_07(): Unit {
        var trie = Trie.builder().onlyWholeWords().addKeyword("sugar").build()
        var firstMatchs: Emit = trie.firstMatch("sugarcane sugarcane sugar canesugar").getOrThrow()
        @Assert(20, firstMatchs.getStart())
        @Assert(24, firstMatchs.getEnd())
        @Assert("sugar", firstMatchs.getKeyword())
    }

    @TestCase
    func testFirstMatch_08(): Unit {
        var trie =
            Trie.builder().ignoreCase().addKeyword("turning").addKeyword("once").addKeyword("again").addKeyword(
            "börkü").build()
        var firstMatchs: Emit = trie.firstMatch("TurninG OnCe AgAiN BÖRKÜ").getOrThrow()
        @Assert(0, firstMatchs.getStart())
        @Assert(6, firstMatchs.getEnd())
        @Assert("turning", firstMatchs.getKeyword())
    }

    @TestCase
    func testFirstMatch_09(): Unit {
        var target: String = "LİKE THIS"
        var trie = Trie.builder().ignoreCase().onlyWholeWords().addKeyword("this").build()
        var firstMatchs: Emit = trie.firstMatch(target).getOrThrow()
        @Assert(6, firstMatchs.getStart())
        @Assert(9, firstMatchs.getEnd())
        @Assert("this", firstMatchs.getKeyword())
    }
}
