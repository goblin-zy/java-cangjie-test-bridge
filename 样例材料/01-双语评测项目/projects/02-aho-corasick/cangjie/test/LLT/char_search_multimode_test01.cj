// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

import ahoCorasick4cj.*
import std.unittest.*
import std.unittest.testmacro.*

main(): Int64 {
    let charSearchTest03 = CharSearchTest03()

    charSearchTest03.testCharSearch01()
    charSearchTest03.testCharSearch02()
    charSearchTest03.testCharSearch03()

    return 0
}

@Test
public class CharSearchTest03 {

    @TestCase
    public func testCharSearch01(): Unit {
        var trie = Trie.builder().ignoreOverlaps()
            .addKeyword("hot")
            .addKeyword("hot chocolate")
            .build()
        var emits = trie.parseText("hot chocolate")
        var iter = emits.iterator()
        for (i in iter) {
            println(i.toString())
        }
    }

    @TestCase
    public func testCharSearch02(): Unit {
        var trie = Trie.builder().onlyWholeWords()
            .addKeyword("sugar")
            .build()
        var emits = trie.parseText("sugarcane sugar canesugar")
        var iter = emits.iterator()
        for (i in iter) {
            println(i.toString())
        }
    }

    @TestCase
    public func testCharSearch03(): Unit {
        var trie = Trie.builder().ignoreCase()
            .addKeyword("casing")
            .build()
        var emits = trie.parseText("CaSiNg")
        var iter = emits.iterator()
        for (i in iter) {
            println(i.toString())
        }
    }
}
