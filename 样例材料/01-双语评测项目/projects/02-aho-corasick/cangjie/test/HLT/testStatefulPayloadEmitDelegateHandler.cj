// 3rd_party_lib:ahocorasick4cj/build/ahoCorasick4cj
// 3rd_party_lib_ohos:ahocorasick4cj/build/aarch64-linux-ohos/ahoCorasick4cj
import ahoCorasick4cj.*
import std.unittest.*
import std.collection.*

@Test
public class AhoCorasickTest {
    @TestCase
    func testStatefulPayloadEmitDelegateHandler_01(): Unit {
        var trie: Trie = Trie.builder().addKeywords(["hers", "his", "she", "he"]).stopOnHit().build()
        var testEmitHandler: StatefulEmitHandler = AbstractStatefulEmitHandlerImpl<String>()
        trie.parseText("ushers", testEmitHandler)
        let emits: Collection<Emit> = testEmitHandler.getEmits()
        @Assert(emits.size,1)
        var emit = emits.toArray().get(0)
        @Assert(emit.getOrThrow().toString(),"1:3=she")
    }

    @TestCase
    func testStatefulPayloadEmitDelegateHandler_02(): Unit {
        var trie: Trie = Trie.builder().addKeywords(["hers", "his", "she", "he"]).stopOnHit().build()
        let emits: Collection<Emit> = trie.parseText("ushers")
        @Assert(emits.size,1)
        var emit = emits.toArray().get(0)
        @Assert(emit.getOrThrow().toString(),"2:3=he")
    }
}

public class AbstractStatefulEmitHandlerImpl<T> <: AbstractStatefulEmitHandler<T> {
    var first: Bool = true
    public override func emit(emit: Emit): Bool {
        if (first) {
            first = false
            return false
        }
        addEmit(emit)
        return true
    }
}
