// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

import ahoCorasick4cj.*
import std.unittest.*
import std.time.*
import std.unittest.testmacro.*

main(): Int64 {
    let charSearchTest01 = CharSearchTest01()

    charSearchTest01.testCharSearch()
    charSearchTest01.testCharSearch02()

    return 0
}

@Test
public class CharSearchTest01 {

    @TestCase
    public func testCharSearch(): Unit {
        var trie = Trie.builder()
                .addKeyword("she")
                .addKeyword("he")
                .addKeyword("his")
                .addKeyword("hers")
                .build()
        var emit: Emit = trie.firstMatch("ushers").getOrThrow()
        println(emit.getStart())
        println(emit.getEnd())
        println(emit.getKeyword())
        @Assert(emit.getKeyword(), "he")
    }

    @TestCase
    public func testCharSearch02(): Unit {
        var trie = Trie.builder()
                .addKeyword("this")
                .addKeyword("there")
                .addKeyword("them")
                .addKeyword("thi")
                .build()
        var emit: Emit = trie.firstMatch("asjdmthsithiss").getOrThrow()
        println(emit.getStart())
        println(emit.getEnd())
        println(emit.getKeyword())
        @Assert(emit.getKeyword(), "thi")
    }

}
