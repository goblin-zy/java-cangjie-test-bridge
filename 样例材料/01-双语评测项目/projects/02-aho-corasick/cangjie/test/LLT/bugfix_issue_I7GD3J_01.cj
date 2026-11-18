// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

import ahoCorasick4cj.*
import std.unittest.*
import std.unittest.testmacro.*
import std.collection.*

main(): Int64 {
    let ahoCorasickTest = AhoCorasickTest()
    ahoCorasickTest.testStatefulPayloadEmitDelegateHandler_01()
    return 0
}

@Test
public class AhoCorasickTest {

    @TestCase
    func testStatefulPayloadEmitDelegateHandler_01(): Unit {
        var trie: Trie = Trie.builder()
            .addKeywords(["hers", "his", "she", "he"])
            .stopOnHit()
            .build()
        var testEmitHandler: StatefulEmitHandler = AbstractStatefulEmitHandlerImpl<String>()
        trie.parseText( "ushers", testEmitHandler)
        let emits: Collection<Emit> = testEmitHandler.getEmits()
        @Assert(emits.size,1)
        var emit = emits.iterator()
        println(emit.next().getOrThrow().toString())

    }
}

public class AbstractStatefulEmitHandlerImpl<T> <: AbstractStatefulEmitHandler<T> {
    var first: Bool = true

    public override func emit(emit: Emit): Bool {
        if(first) {
            first = false
            return false
        }
        addEmit(emit)
        return true
    }
    
}
