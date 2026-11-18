package cjmustache.test

import cjmustache.*

import std.unittest.*
import std.unittest.testmacro.*
import std.io.*
import std.math.*
import std.collection.*
import std.convert.*

@Test
public class EscapersTest {
    private static let strList: Array<Array<String>> = [
        ["&",  "&amp;"],
        ["'",  "&#39;"],
        ["\"", "&quot;"],
        ["<",  "&lt;"],
        [">",  "&gt;"],
        ["`",  "&#x60;"],
        ["=",  "&#x3D;"]
    ]
    @TestCase
    public func escaper1Test() {
        let escaper1 = SimpleEscaper(strList)
        @Expect(escaper1.escape("&'\"<>`="),
        "&amp;&#39;&quot;&lt;&gt;&#x60;&#x3D;")

        let escaper2 = SimpleEscaper([["中", "凉"], ["张", "宫"], 
        ["李", "此"], ["华", "方"]])
        @Expect(escaper2.escape("中张李华"), "凉宫此方")
    }

    @TestCase
    public func simpleTest() {
        let escaper1 = Escapers.simple(strList)
        @Expect(escaper1.toString(), 
        "Escaper[{'34', '&quot;'},{'38', '&amp;'},{'39', '&#39;'},{'60', '&lt;'},{'61', '&#x3D;'},{'62', '&gt;'},{'96', '&#x60;'},]")

        let escaper2 = Escapers.simple([["中", "凉"], ["张", "宫"], 
        ["李", "此"], ["华", "方"]])
        @Expect(escaper2.escape("中张李华"), "凉宫此方")
    }


    @TestCase
    public func escaper2Test() {
        let escaper = NoneEscaper()
        @Expect(escaper.escape("").
        equalsIgnoreAsciiCase(""))
        @Expect(escaper.escape("foo").
        equalsIgnoreAsciiCase("foo"))
    }

    @TestCase
    public func Lookup7bitEscapercreateTableTest() {
        let mappings1 = [["A", 'a'], ["B", 'b'], ["C", "c"]]
        let table1 = Lookup7bitEscaper.
        createTable(mappings1).getOrThrow()
        @Expect((table1[Int64(b'A')].getOrThrow()).
        equalsIgnoreAsciiCase("a"))
        @Expect((table1[Int64(b'B')].getOrThrow()).
        equalsIgnoreAsciiCase("b"))
        @Expect((table1[Int64(b'C')].getOrThrow()).
        equalsIgnoreAsciiCase("c"))

        let mappings2 = [["中", "a"]]
        @ExpectThrows[NoneValueException](
            Lookup7bitEscaper.createTable(mappings2).
            getOrThrow()
        )
    }

    @TestCase
    public func Lookup7bitEscaperescapeChar() {
        let mappings1 = [["A", 'a'], ["B", 'b'], ["C", "c"]]
        let table1 = Lookup7bitEscaper.createTable(mappings1).
        getOrThrow()
        @Expect((Lookup7bitEscaper.escapeChar(table1, r'A').
        getOrThrow()).equalsIgnoreAsciiCase("a"))
        @Expect((Lookup7bitEscaper.escapeChar(table1, r'B').
        getOrThrow()).equalsIgnoreAsciiCase("b"))
        @Expect((Lookup7bitEscaper.escapeChar(table1, r'C').
        getOrThrow()).equalsIgnoreAsciiCase("c"))
        @ExpectThrows[NoneValueException](
            Lookup7bitEscaper.escapeChar(table1, r'李').
            getOrThrow()
        )
    }

    @TestCase
    public func Lookup7bitEscaperescape1() {
        let mappings1 = [["A", 'a'], ["B", 'b'], ["C", "c"]]
        let table1 = Lookup7bitEscaper.createTable(mappings1).
        getOrThrow()
        let sb = StringBuilder()
        let bas = ByteBuffer()
        let bf = BufferedOutputStream(bas)
        let escaper = Lookup7bitEscaper(table1)
        escaper.escape(sb, bf, "AAA#BBB#CCC")
        bf.flush()
        let ans = "aaa#bbb#ccc"
        @Expect(sb.toString(), ans)
        @Expect(String.fromUtf8(readToEnd(bas)), ans)
    }

    @TestCase
    public func Lookup7bitEscaperescape2() {
        let mappings1 = [["A", 'a'], ["B", 'b'], ["C", "c"]]
        let table1 = Lookup7bitEscaper.createTable(mappings1).
        getOrThrow()
        let sb = StringBuilder()
        let bas = ByteBuffer()
        let bf = BufferedOutputStream(bas)
        let escaper = Lookup7bitEscaper(table1)
        escaper.escape(sb, bf, "A##A#B##B#C##C")
        bf.flush()
        let ans = "a##a#b##b#c##c"
        @Expect(sb.toString(), ans)
        @Expect(String.fromUtf8(readToEnd(bas)), ans)
    }

    @TestCase
    public func Lookup7bitEscaperescape3() {
        let mappings1 = [["A", 'a'], ["B", 'b'], ["C", "c"]]
        let table1 = Lookup7bitEscaper.createTable(mappings1).
        getOrThrow()
        let escaper = Lookup7bitEscaper(table1)
        let ret = escaper.escape("A##A#B##B#C##C")
        let ans = "a##a#b##b#c##c"
        @Expect(ret, ans)
    }

    @TestCase
    public func Lookup7bitEscapertoString() {
        let mappings1 = [["A", 'a'], ["B", 'b'], ["C", "c"]]
        let table1 = Lookup7bitEscaper.createTable(mappings1).
        getOrThrow()
        let escaper = Lookup7bitEscaper(table1)
        @Expect(escaper.toString(), 
        "Escaper[{'65', 'a'},{'66', 'b'},{'67', 'c'},]")
    }
}