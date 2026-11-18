// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

import ahoCorasick4cj.*
import std.unittest.*
import std.unittest.testmacro.*

main(): Int64 {
    let charSearchTest01 = CharSearchTest01()
    charSearchTest01.testCharSearch01()
    charSearchTest01.testCharSearch02()
    charSearchTest01.testCharSearch03()
    return 0
}

@Test
public class CharSearchTest01 {

    @TestCase
    public func testCharSearch01(): Unit {
        var builder = Trie.builder()
        var trie = builder.addKeyword("shier").build()
        var emits = trie.parseText("dasm,nzxmvshier.sa,nd")
        var iter = emits.iterator()
        for (i in iter) {
            println(i.toString())
        }
    }

    @TestCase
    public func testCharSearch02(): Unit {
        var builder = Trie.builder()
        var trie = builder.addKeyword("shisi").build()
        var emits = trie.parseText("xz.jagajgspjlkn")
        var iter = emits.iterator()
        for (i in iter) {
            println(i.toString())
        }
    }

    @TestCase
    public func testCharSearch03(): Unit {
        var builder = Trie.builder()
        var trie = builder.addKeyword("你").addKeyword("好").build()
        var emits = trie.parseText("中国你好，加油仓颉")
        var iter = emits.iterator()
        for (i in iter) {
            println(i.toString())
        }
    }
}
