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
    charSearchTest03.testCharSearch04()
    charSearchTest03.testCharSearch05()
    charSearchTest03.testCharSearch06()
    charSearchTest03.testCharSearch07()
    charSearchTest03.testCharSearch08()
    charSearchTest03.testCharSearch09()
    charSearchTest03.testCharSearch10()
    charSearchTest03.testCharSearch11()
    charSearchTest03.testCharSearch12()
    charSearchTest03.testCharSearch13()
    charSearchTest03.testCharSearch14()
    charSearchTest03.testCharSearch15()
    charSearchTest03.testCharSearch16()

    return 0
}

@Test
public class CharSearchTest03 {

    @TestCase
    public func testCharSearch01(): Unit {
        var builder = Trie.builder()
        var trie = builder.addKeyword("你").addKeyword("好").addKeyword("she").addKeyword("he").build()
        var emits = trie.parseText("大三阶段了侃大山")
        var iter = emits.iterator()
        for (i in iter) {
            println(i.toString())
        }
    }

    @TestCase
    public func testCharSearch03(): Unit {
        var builder = Trie.builder()
        var trie = builder.addKeyword("chelishi").addKeyword("wni").addKeyword("hao").addKeyword("cangzhe").build()
        var emits = trie.parseText("jicangzhe chelishi wwwni,nih ao")
        var iter = emits.iterator()
        for (i in iter) {
            println(i.toString())
        }
    }

    @TestCase
    public func testCharSearch02(): Unit {
        var builder = Trie.builder()
        var trie = builder.addKeyword("你").addKeyword("好").addKeyword("仓").addKeyword("颉").build()
        var emits = trie.parseText("你好中国，加油仓颉")
        var iter = emits.iterator()
        for (i in iter) {
            println(i.toString())
        }
    }

    @TestCase
    public func testCharSearch04(): Unit {
        var builder = Trie.builder()
        var trie = builder.addKeyword("").build()
        var emits = trie.parseText("")
        var iter = emits.iterator()
        for (i in iter) {
            println(i.toString())
        }
    }

    @TestCase
    public func testCharSearch05(): Unit {
        var builder = Trie.builder()
        var trie = builder.addKeyword("").addKeyword("").build()
        var emits = trie.parseText("你")
        var iter = emits.iterator()
        for (i in iter) {
            println(i.toString())
        }
    }

    @TestCase
    public func testCharSearch06(): Unit {
        var builder = Trie.builder()
        var trie = builder.addKeyword("").addKeyword("").addKeyword("").build()
        var emits = trie.parseText("你好")
        var iter = emits.iterator()
        for (i in iter) {
            println(i.toString())
        }
    }

    @TestCase
    public func testCharSearch07(): Unit {
        var builder = Trie.builder()
        var trie = builder.addKeyword("abc").addKeyword("dfe").build()
        var emits = trie.parseText("faj,mzxnvz,mxndfeqkslgjabc")
        var iter = emits.iterator()
        for (i in iter) {
            println(i.toString())
        }
    }

    @TestCase
    public func testCharSearch08(): Unit {
        var builder = Trie.builder()
        var trie = builder.addKeyword("abc").build()
        var emits = trie.parseText("faj,mzxnvz,mxndfeqkslgjabc")
        var iter = emits.iterator()
        for (i in iter) {
            println(i.toString())
        }
    }

    @TestCase
    public func testCharSearch09(): Unit {
        var builder = Trie.builder()
        var trie = builder.addKeyword("666778").build()
        var emits = trie.parseText("42312137574564156667781231588wqwew")
        var iter = emits.iterator()
        for (i in iter) {
            println(i.toString())
        }
    }

    @TestCase
    public func testCharSearch10(): Unit {
        var builder = Trie.builder()
        var trie = builder.addKeyword("shi").build()
        var emits = trie.parseText("dasfashgzxkjvmzxndashijdknmx")
        var iter = emits.iterator()
        for (i in iter) {
            println(i.toString())
        }
    }

    @TestCase
    public func testCharSearch11(): Unit {
        var builder = Trie.builder()
        var trie = builder.addKeyword("十二").build()
        var emits = trie.parseText("事兒時而市二十二是")
        var iter = emits.iterator()
        for (i in iter) {
            println(i.toString())
        }
    }

    @TestCase
    public func testCharSearch12(): Unit {
        var builder = Trie.builder()
        var trie = builder.addKeyword("shier").build()
        var emits = trie.parseText("dasm,nzxmvshier.sa,nd")
        var iter = emits.iterator()
        for (i in iter) {
            println(i.toString())
        }
    }

    @TestCase
    public func testCharSearch13(): Unit {
        var builder = Trie.builder()
        var trie = builder.addKeyword("shi").addKeyword("san").build()
        var emits = trie.parseText("dasdasdasfshizx.,jcsan")
        var iter = emits.iterator()
        for (i in iter) {
            println(i.toString())
        }
    }

    @TestCase
    public func testCharSearch14(): Unit {
        var builder = Trie.builder()
        var trie = builder.addKeyword("shisi").build()
        var emits = trie.parseText("xz.jagajgspjlkn")
        var iter = emits.iterator()
        for (i in iter) {
            println(i.toString())
        }
    }

    @TestCase
    public func testCharSearch15(): Unit {
        var builder = Trie.builder()
        var trie = builder.addKeyword("你").build()
        var emits = trie.parseText("你你你你你，加油仓颉")
        var iter = emits.iterator()
        for (i in iter) {
            println(i.toString())
        }
    }

    @TestCase
    public func testCharSearch16(): Unit {
        var builder = Trie.builder()
        var trie = builder.addKeyword("你").addKeyword("好").build()
        var emits = trie.parseText("中国你好，加油仓颉")
        var iter = emits.iterator()
        for (i in iter) {
            println(i.toString())
        }
    }

}
