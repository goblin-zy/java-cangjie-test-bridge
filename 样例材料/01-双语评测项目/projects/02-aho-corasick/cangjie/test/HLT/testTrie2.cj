// 3rd_party_lib:ahocorasick4cj/build/ahoCorasick4cj
// 3rd_party_lib_ohos:ahocorasick4cj/build/aarch64-linux-ohos/ahoCorasick4cj
import ahoCorasick4cj.*
import std.unittest.*
import std.collection.*

@Test
public class AhoCorasickTest {
    @TestCase
    public func testTrie_01(): Unit {
        var builder = Trie.builder().ignoreOverlaps().addKeyword("ab").addKeyword("cba").addKeyword("ababc")
        var trie = builder.build()
        @Assert(trie.containsMatch( "ababcbab" ), true)
    }

    @TestCase
    public func testTrie_02(): Unit {
        var trie: Trie = Trie.builder().addKeywords(["hers", "his", "she", "he"]).build()
        var emitHandler: EmitHandlerImpl = EmitHandlerImpl()
        trie.parseText("ushers", emitHandler)
        let emits: Collection<Emit> = emitHandler.getEmits()
        @Assert(emits.size,3)
        var emitsIterator = emits.iterator()
        @Assert(emitsIterator.next().getOrThrow().toString(),"2:3=he")
        @Assert(emitsIterator.next().getOrThrow().toString(),"1:3=she")
        @Assert(emitsIterator.next().getOrThrow().toString(),"2:5=hers")
    }
}

public class EmitHandlerImpl <: EmitHandler {
    private var emits: ArrayList<Emit> = ArrayList<Emit>()

    public override func emit(emit: Emit): Bool {
        emits.add(emit)
        return true
    }

    public func getEmits(): ArrayList<Emit> {
        return this.emits
    }
}
