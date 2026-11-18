// 3rd_party_lib:ahocorasick4cj/build/ahoCorasick4cj
// 3rd_party_lib_ohos:ahocorasick4cj/build/aarch64-linux-ohos/ahoCorasick4cj
import ahoCorasick4cj.*
import std.unittest.*
import std.collection.*

@Test
public class AhoCorasickTest {
    var strRes: String = ""

    @TestCase
    func testTrieBuilder_01(): Unit {
        let speech: String = "The Answer to the Great Question... Of Life, "
        var trie = Trie.builder().ignoreCase().addKeyword("great question").build()
        let emitColl_1: Collection<Emit> = trie.parseText(speech)
        @Assert(emitColl_1.size,1)
        var it_1 = emitColl_1.iterator()
        for (obj in it_1) {
            strRes += obj.toString()
        }
        @Assert(strRes,"18:31=great question")
    }

    @TestCase
    func testTrieBuilder_02(): Unit {
        let speech: String = "The Answer to the Great Question... Of Life, "
        var trie = Trie.builder().addKeyword("great question").build()
        let emitColl_1: Collection<Emit> = trie.parseText(speech)
        @Assert(emitColl_1.size,0)
    }

    @TestCase
    public func testTrieBuilder_03(): Unit {
        var trie = Trie.builder().ignoreOverlaps().addKeyword("ab").addKeyword("cba").addKeyword("ababc").build()
        let emitColl_1: Collection<Emit> = trie.parseText("ababcbab")
        var it_1 = emitColl_1.iterator()
        var strRes1: String = ""
        for (obj in it_1) {
            strRes1 += obj.toString()
        }
        @Assert(strRes1,"0:4=ababc6:7=ab")
    }

    @TestCase
    public func testTrieBuilder_04(): Unit {
        var trie = Trie.builder().addKeyword("ab").addKeyword("cba").addKeyword("ababc").build()
        let emitColl_1: Collection<Emit> = trie.parseText("ababcbab")
        var it_1 = emitColl_1.iterator()
        var strRes1: String = ""
        for (obj in it_1) {
            strRes1 += obj.toString()
        }
        @Assert(strRes1,"0:1=ab2:3=ab0:4=ababc4:6=cba6:7=ab")
    }

    @TestCase
    public func testTrieBuilder_05(): Unit {
        var builder = Trie.builder().addKeywords(["hel", "llo", "cang"])
        var trie = builder.build()
        let emitColl_1: Collection<Emit> = trie.parseText("dzxvmhellocx,mznvjwio")
        var it_1 = emitColl_1.iterator()
        var strRes1: String = ""
        for (obj in it_1) {
            strRes1 += obj.toString()
        }
        @Assert(strRes1, "5:7=hel7:9=llo")
    }

    @TestCase
    public func testTrieBuilder_06(): Unit {
        var builder = Trie.builder().addKeywords([])
        var trie = builder.build()
        let emitColl_1: Collection<Emit> = trie.parseText("dzxvmhellocx,mznvjwio")
        @Assert(emitColl_1.size, 0)
    }

    @TestCase
    public func testTrieBuilder_07(): Unit {
        var trie = Trie.builder().onlyWholeWords().addKeyword("ab").build()
        let emitColl_1: Collection<Emit> = trie.parseText("babcbab ab cab cabcc@@")
        var it_1 = emitColl_1.iterator()
        var strRes1: String = ""
        for (obj in it_1) {
            strRes1 += obj.toString()
        }
        @Assert(strRes1,"8:9=ab")
    }

    @TestCase
    public func testTrieBuilder_08(): Unit {
        var trie = Trie.builder().addKeyword("ab").build()
        let emitColl_1: Collection<Emit> = trie.parseText("@abcbab ab cab cabcc@@")
        var it_1 = emitColl_1.iterator()
        var strRes1: String = ""
        for (obj in it_1) {
            strRes1 += obj.toString()
        }
        @Assert(strRes1,"1:2=ab5:6=ab8:9=ab12:13=ab16:17=ab")
    }

    @TestCase
    public func testTrieBuilder_09(): Unit {
        var trie = Trie.builder().addKeyword("ab").build()
        let emitColl_1: Collection<Emit> = trie.parseText("@abcbab ab cab cabcc@@")
        var it_1 = emitColl_1.iterator()
        var strRes1: String = ""
        for (obj in it_1) {
            strRes1 += obj.toString()
        }
        @Assert(strRes1,"1:2=ab5:6=ab8:9=ab12:13=ab16:17=ab")
    }

    @TestCase
    public func testTrieBuilder_10(): Unit {
        var builder = Trie.builder().addKeywords(["dzxvm", "dzxvmhelcx"]).onlyWholeWordsWhiteSpaceSeparated()
        var trie = builder.build()
        let emitColl_1: Collection<Emit> = trie.parseText("- dzxvmhelcx dzxvmhelcx ,dzxvmhelcx ,mznvjwio ; dzxvmhelcx")
        var it_1 = emitColl_1.iterator()
        var strRes1: String = ""
        for (obj in it_1) {
            strRes1 += obj.toString()
        }
        @Assert(strRes1,"2:6=dzxvm2:11=dzxvmhelcx13:17=dzxvm13:22=dzxvmhelcx25:29=dzxvm25:34=dzxvmhelcx48:52=dzxvm48:57=dzxvmhelcx")
    }

    @TestCase
    public func testTrieBuilder_11(): Unit {
        var trie = Trie.builder().stopOnHit().addKeyword("ab").addKeyword("cba").addKeyword("ababc").build()
        let emitColl_1: Collection<Emit> = trie.parseText("ababcbab")
        var it_1 = emitColl_1.iterator()
        var strRes1: String = ""
        for (obj in it_1) {
            strRes1 += obj.toString()
        }
        @Assert(strRes1,"0:1=ab")
    }

    @TestCase
    public func testTrieBuilder_12(): Unit {
        var trie = Trie.builder().addKeyword("ab").addKeyword("cba").addKeyword("ababc").build()
        let emitColl_1: Collection<Emit> = trie.parseText("AbABcbab")
        var it_1 = emitColl_1.iterator()
        var strRes1: String = ""
        for (obj in it_1) {
            strRes1 += obj.toString()
        }
        @Assert(strRes1,"4:6=cba6:7=ab")
    }

    @TestCase
    public func testTrieBuilder_13(): Unit {
        var trie = Trie.builder().caseInsensitive().addKeyword("ab").addKeyword("cba").addKeyword("ababc").build()
        let emitColl_1: Collection<Emit> = trie.parseText("AbABcbab")
        var it_1 = emitColl_1.iterator()
        var strRes1: String = ""
        for (obj in it_1) {
            strRes1 += obj.toString()
        }
        @Assert(strRes1,"0:1=ab2:3=ab0:4=ababc4:6=cba6:7=ab")
    }

    @TestCase
    public func testTrieBuilder_14(): Unit {
        var trie = Trie.builder().removeOverlaps().addKeyword("ab").addKeyword("cba").addKeyword("ababc").build()
        let emitColl_1: Collection<Emit> = trie.parseText("ababcbab")
        var it_1 = emitColl_1.iterator()
        var strRes1: String = ""
        for (obj in it_1) {
            strRes1 += obj.toString()
        }
        @Assert(strRes1,"0:4=ababc6:7=ab")
    }
}
