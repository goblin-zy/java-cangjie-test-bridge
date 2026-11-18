// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

import diffUtils4cj.*
import std.collection.*
import std.unittest.*
import std.unittest.testmacro.*

main(): Int64 {
    let test = RowTest()
    test.testwrapInTag1()
    test.testwrapInTag2()
    test.testwrapInTag3()
    test.testwrapInTag4()
    return 0
}

@Test
public class RowTest {
    @TestCase
    public func testwrapInTag1(): Unit {
        var str = DiffRowGenerator.wrapInTag("testline","testtag",None)
        let res: String = "<testtag>testline</testtag>"
        @Assert(str, res)
    }

    @TestCase
    public func testwrapInTag2(): Unit {
        var str = DiffRowGenerator.wrapInTag("testline","testtag","")
        println(str)
        let res: String = "<testtag class=\"\">testline</testtag>"
        @Assert(str, res)
    }

    @TestCase
    public func testwrapInTag3(): Unit {
        var arr = ArrayList<String>(["one","two","three","four"])
        var str = DiffRowGenerator.wrapInTag(arr, 1, 3, "testtag", "").toString()
        println(str)
        let res: String = "[one, <testtag class=\"\">, two, </testtag>, three, four]"
        @Assert(str.toString(), res)
    }

    @TestCase
    public func testwrapInTag4(): Unit {
        var arr = ArrayList<String>(["one","two","three","four"])
        var str = DiffRowGenerator.wrapInTag(arr, 1, 3, "testtag", None).toString()
        println(str)
        let res: String = "[one, <testtag>, two, </testtag>, three, four]"
        @Assert(str, res)
    }
}