// 3rd_party_lib:ahocorasick4cj/build/ahoCorasick4cj
// 3rd_party_lib_ohos:ahocorasick4cj/build/aarch64-linux-ohos/ahoCorasick4cj
import ahoCorasick4cj.*
import std.unittest.*
import std.collection.*

@Test
public class AhoCorasickTest {
    @TestCase
    func testPayloadTrie_01(): Unit {
        let p1: Payload<String> = Payload<String>("Alpha", "greek:Alpha")
        let p2: Payload<String> = Payload<String>("Beta", "greek:Beta")
        let p3: Payload<String> = Payload<String>("Gamma", "greek:Gamma")
        let arr: ArrayList<Payload<String>> = ArrayList<Payload<String>>()
        arr.add(p1)
        arr.add(p2)
        arr.add(p3)
        var trie = PayloadTrie<String>.builder().addKeywords(arr).build()
        var tokens = trie.tokenize("Hear: Alpha team first, Beta from the rear, Gamma in reserve")
        @Assert(tokens.size, 7)
        var it_1 = tokens.iterator()
        var strRes1: String = ""
        for (obj in it_1) {
            strRes1 = strRes1 + obj.getFragment() + "->"
        }
        @Assert(strRes1,"Hear: ->Alpha-> team first, ->Beta-> from the rear, ->Gamma-> in reserve->")
    }

    @TestCase
    func testPayloadTrie_02(): Unit {
        let p1: Payload<String> = Payload<String>("Alpha", "greek:Alpha")
        let p2: Payload<String> = Payload<String>("Beta", "greek:Beta")
        let p3: Payload<String> = Payload<String>("Gamma", "greek:Gamma")
        let arr: ArrayList<Payload<String>> = ArrayList<Payload<String>>()
        arr.add(p1)
        arr.add(p2)
        arr.add(p3)
        var trie = PayloadTrie<String>.builder().addKeywords(arr).build()
        var tokens = trie.tokenize("Alpha Beta Gamma")
        @Assert(tokens.size, 5)
    }

    @TestCase
    func testPayloadTrie_03(): Unit {
        var trie = PayloadTrie<String>.builder().ignoreOverlaps().onlyWholeWords().ignoreCase().addKeyword("").build()
        var tokens = trie.tokenize(
            "Try a natural lip and subtle bronzer to keep all the focus on those big bright eyes with NARS Eyeshadow Duo in Rated R And the winner is... Boots No7 Advanced Renewal Anti-ageing Glycolic Peel Kit ($25 amazon.com) won most-appealing peel."
        )
        @Assert(tokens.size, 1)
    }

    @TestCase
    func testPayloadTrie_04(): Unit {
        var trie = PayloadTrie<String>.builder().addKeyword("abc", "alpha:abc").build()
        var firstMatch = trie.firstMatch("abc").getOrThrow()
        @Assert(firstMatch.toString(), "0:2=abc->")
    }

    @TestCase
    func testPayloadTrie_05(): Unit {
        var trie = PayloadTrie<String>.builder().addKeyword("abc", "alpha:hhh").build()
        var firstMatch = trie.firstMatch(" " + "abc").getOrThrow()
        @Assert(firstMatch.toString(), "1:3=abc->")
    }

    @TestCase
    func testPayloadTrie_06(): Unit {
        var trie = PayloadTrie<String>.builder().addKeyword("abc", "alpha:hhh").build()
        var firstMatch = trie.firstMatch("ab")
        var sBool2: Bool = true
        if (let None <- firstMatch) {
            sBool2 = false
        }
        @Assert(sBool2,false)
    }
}
