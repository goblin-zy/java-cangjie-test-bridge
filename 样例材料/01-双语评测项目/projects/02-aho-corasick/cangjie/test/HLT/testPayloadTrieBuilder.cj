// 3rd_party_lib:ahocorasick4cj/build/ahoCorasick4cj
// 3rd_party_lib_ohos:ahocorasick4cj/build/aarch64-linux-ohos/ahoCorasick4cj
import ahoCorasick4cj.*
import std.unittest.*
import std.collection.*

@Test
public class AhoCorasickTest {
    var strRes: String = ""

    @TestCase
    func testPayloadTrieBuilder_01(): Unit {
        let speech: String = "The Answer to the Great Question... Of Life, "
        var trie = PayloadTrie<String>.builder().ignoreCase().addKeyword("great question").build()
        let emitColl_1: Collection<PayloadEmit<String>> = trie.parseText(speech)
        @Assert(emitColl_1.size,1)
        var it_1 = emitColl_1.iterator()
        for (obj in it_1) {
            strRes += obj.toString()
        }
        @Assert(strRes,"18:31=great question->")
    }

    @TestCase
    func testPayloadTrieBuilder_02(): Unit {
        let speech: String = "The Answer to the Great Question... Of Life, "
        var trie = PayloadTrie<String>.builder().addKeyword("great question").build()
        let emitColl_1: Collection<PayloadEmit<String>> = trie.parseText(speech)
        @Assert(emitColl_1.size,0)
    }

    @TestCase
    public func testPayloadTrieBuilder_03(): Unit {
        var trie =
            PayloadTrie<String>.builder().ignoreOverlaps().addKeyword("ab").addKeyword("cba").addKeyword("ababc").build(
        )
        let emitColl_1: Collection<PayloadEmit<String>> = trie.parseText("ababcbab")
        var it_1 = emitColl_1.iterator()
        var strRes1: String = ""
        for (obj in it_1) {
            strRes1 += obj.toString()
        }
        @Assert(strRes1,"0:4=ababc->6:7=ab->")
    }

    @TestCase
    public func testPayloadTrieBuilder_04(): Unit {
        var trie = PayloadTrie<String>.builder().addKeyword("ab").addKeyword("cba").addKeyword("ababc").build()
        let emitColl_1: Collection<PayloadEmit<String>> = trie.parseText("ababcbab")
        var it_1 = emitColl_1.iterator()
        var strRes1: String = ""
        for (obj in it_1) {
            strRes1 += obj.toString()
        }
        @Assert(strRes1,"0:1=ab->2:3=ab->0:4=ababc->4:6=cba->6:7=ab->")
    }

    @TestCase
    public func testPayloadTrieBuilder_05(): Unit {
        var builder = PayloadTrie<String>.builder().addKeyword("hel").addKeyword("llo").addKeyword("cang")
        var trie = builder.build()
        let emitColl_1: Collection<PayloadEmit<String>> = trie.parseText("dzxvmhellocx,mznvjwio")
        var it_1 = emitColl_1.iterator()
        var strRes1: String = ""
        for (obj in it_1) {
            strRes1 += obj.toString()
        }
        @Assert(strRes1, "5:7=hel->7:9=llo->")
    }

    @TestCase
    public func testPayloadTrieBuilder_06(): Unit {
        var builder = PayloadTrie<String>.builder().addKeyword("")
        var trie = builder.build()
        let emitColl_1: Collection<PayloadEmit<String>> = trie.parseText("dzxvmhellocx,mznvjwio")
        @Assert(emitColl_1.size, 0)
    }

    @TestCase
    public func testPayloadTrieBuilder_07(): Unit {
        var trie = PayloadTrie<String>.builder().onlyWholeWords().addKeyword("ab").build()
        let emitColl_1: Collection<PayloadEmit<String>> = trie.parseText("babcbab ab cab cabcc@@")
        var it_1 = emitColl_1.iterator()
        var strRes1: String = ""
        for (obj in it_1) {
            strRes1 += obj.toString()
        }
        @Assert(strRes1,"8:9=ab->")
    }

    @TestCase
    public func testPayloadTrieBuilder_08(): Unit {
        var trie = PayloadTrie<String>.builder().addKeyword("ab").build()
        let emitColl_1: Collection<PayloadEmit<String>> = trie.parseText("@abcbab ab cab cabcc@@")
        var it_1 = emitColl_1.iterator()
        var strRes1: String = ""
        for (obj in it_1) {
            strRes1 += obj.toString()
        }
        @Assert(strRes1,"1:2=ab->5:6=ab->8:9=ab->12:13=ab->16:17=ab->")
    }

    @TestCase
    public func testPayloadTrieBuilder_09(): Unit {
        var trie = PayloadTrie<String>.builder().addKeyword("ab").build()
        let emitColl_1: Collection<PayloadEmit<String>> = trie.parseText("@abcbab ab cab cabcc@@")
        var it_1 = emitColl_1.iterator()
        var strRes1: String = ""
        for (obj in it_1) {
            strRes1 += obj.toString()
        }
        @Assert(strRes1,"1:2=ab->5:6=ab->8:9=ab->12:13=ab->16:17=ab->")
    }

    @TestCase
    public func testPayloadTrieBuilder_10(): Unit {
        var builder =
            PayloadTrie<String>.builder().addKeyword("dzxvm").addKeyword("dzxvmhelcx").onlyWholeWordsWhiteSpaceSeparated(
            )
        var trie = builder.build()
        let emitColl_1: Collection<PayloadEmit<String>> = trie.parseText(
            "- dzxvmhelcx dzxvmhelcx ,dzxvmhelcx ,mznvjwio ; dzxvmhelcx")
        var it_1 = emitColl_1.iterator()
        var strRes1: String = ""
        for (obj in it_1) {
            strRes1 += obj.toString()
        }
        @Assert(strRes1,"2:6=dzxvm->2:11=dzxvmhelcx->13:17=dzxvm->13:22=dzxvmhelcx->25:29=dzxvm->25:34=dzxvmhelcx->48:52=dzxvm->48:57=dzxvmhelcx->")
    }

    @TestCase
    public func testPayloadTrieBuilder_11(): Unit {
        var trie =
            PayloadTrie<String>.builder().stopOnHit().addKeyword("ab").addKeyword("cba").addKeyword("ababc").build()
        let emitColl_1: Collection<PayloadEmit<String>> = trie.parseText("ababcbab")
        var it_1 = emitColl_1.iterator()
        var strRes1: String = ""
        for (obj in it_1) {
            strRes1 += obj.toString()
        }
        @Assert(strRes1,"0:1=ab->")
    }

    @TestCase
    public func testPayloadTrieBuilder_12(): Unit {
        var trie = PayloadTrie<String>.builder().addKeyword("ab").addKeyword("cba").addKeyword("ababc").build()
        let emitColl_1: Collection<PayloadEmit<String>> = trie.parseText("AbABcbab")
        var it_1 = emitColl_1.iterator()
        var strRes1: String = ""
        for (obj in it_1) {
            strRes1 += obj.toString()
        }
        @Assert(strRes1,"4:6=cba->6:7=ab->")
    }

    @TestCase
    public func testPayloadTrieBuilder_13(): Unit {
        var trie =
            PayloadTrie<String>.builder().caseInsensitive().addKeyword("ab").addKeyword("cba").addKeyword("ababc").build(
            )
        let emitColl_1: Collection<PayloadEmit<String>> = trie.parseText("AbABcbab")
        var it_1 = emitColl_1.iterator()
        var strRes1: String = ""
        for (obj in it_1) {
            strRes1 += obj.toString()
        }
        @Assert(strRes1,"0:1=ab->2:3=ab->0:4=ababc->4:6=cba->6:7=ab->")
    }

    @TestCase
    public func testPayloadTrieBuilder_14(): Unit {
        var trie =
            PayloadTrie<String>.builder().removeOverlaps().addKeyword("ab").addKeyword("cba").addKeyword("ababc").build(
        )
        let emitColl_1: Collection<PayloadEmit<String>> = trie.parseText("ababcbab")
        var it_1 = emitColl_1.iterator()
        var strRes1: String = ""
        for (obj in it_1) {
            strRes1 += obj.toString()
        }
        @Assert(strRes1,"0:4=ababc->6:7=ab->")
    }
}
