// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

import ahoCorasick4cj.*
import std.unittest.*
import std.unittest.testmacro.*

main(): Int64 {
    let charSearchTest06 = CharSearchTest06()

    charSearchTest06.testCharSearch01()

    return 0
}

@Test
public class CharSearchTest06 {

    @TestCase
    public func testCharSearch01(): Unit {
        var trie = PayloadTrie<Word>.builder()
            .addKeyword("hers", Word("f"))
            .addKeyword("his", Word("m"))
            .addKeyword("she", Word("f"))
            .addKeyword("he", Word("m"))
            .addKeyword("nonbinary", Word("nb"))
            .addKeyword("transgender", Word("tg"))
            .build()
        var emits: Collection<PayloadEmit<Word>> = trie.parseText("ushers")
        var iter: Iterator<PayloadEmit<Word>> = emits.iterator()
        for (i in iter) {
            println(i.toString() + i.getPayload().getOrThrow().gender)
        }
    }
}

class Word {
    protected var gender: String
    public init(gender: String) {
        this.gender = gender
    }
}
