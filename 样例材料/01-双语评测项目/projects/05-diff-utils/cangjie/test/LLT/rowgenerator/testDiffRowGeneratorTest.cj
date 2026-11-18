// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

import diffUtils4cj.*
import std.collection.*
import std.unittest.*
import std.unittest.testmacro.*
import std.math.*

main(): Int64 {
    let test = RowTest()
    test.testGenerator_Default()
    test.testGenerator_InlineDiff()
    test.testGenerator_IgnoreWhitespaces()
    test.testignoreBlankLines()
    test.testInlineOldTag()
    test.testInlineNewTag()
    test.testInlineOldCssClass()
    test.testInlineNewCssClass()
    test.testwrapInTag()
    return 0
}

@Test
public class RowTest {
    
    @TestCase
    public func testGenerator_Default(): Unit {
        var first = "anything \n \nother"
        var second ="anything\n\nother"

        var generator = Builder()
            .columnWidth(Int64.Max) // do not wrap
            .build()
        var rows = generator.generateDiffRows(split(first), split(second))
        print(rows)

        @Assert(3, rows.size)
    }

    @TestCase
    public func testGenerator_InlineDiff(): Unit {
        var first = "anything \n \nother"
        var second ="anything\n\nother"
        var generator = Builder()
            .showInlineDiffs(true)
            .columnWidth(Int64.Max) // do not wrap
            .build();
        var rows = generator.generateDiffRows(split(first), split(second));
        print(rows);

        @Assert(3, rows.size)
        @Assert(true, rows.get(0).getOrThrow().getOldLine().indexOf("<span").getOrThrow() > 0)
    }

    @TestCase
    public func testGenerator_IgnoreWhitespaces(): Unit {
        var first = "anything \n \nother\nmore lines";
        var second ="anything\n\nother\nsome more lines";
        var generator = Builder()
            .ignoreWhiteSpaces(true)
            .columnWidth(Int64.Max) // do not wrap
            .build();
        var rows = generator.generateDiffRows(split(first), split(second))
        print(rows)

        @Assert(4, rows.size)
        @Assert(rows.get(0).getOrThrow().getTag().toString(), "EQUAL")
        @Assert(rows.get(1).getOrThrow().getTag().toString(), "EQUAL")
        @Assert(rows.get(2).getOrThrow().getTag().toString(), "EQUAL")
        @Assert(rows.get(3).getOrThrow().getTag().toString(), "CHANGE")
    }

    @TestCase
    public func testignoreBlankLines(): Unit {
        var first = "anything \n    \nother\nmore lines";
        var second ="anything\n\nother\nsome more lines";
        var generator = Builder()
            .ignoreBlankLines(true)
            .columnWidth(Int64.Max) // do not wrap
            .build();
        var rows = generator.generateDiffRows(split(first), split(second))
        print(rows)

        @Assert(4, rows.size)
        @Assert(rows.get(0).getOrThrow().getTag().toString(), "CHANGE")
        @Assert(rows.get(1).getOrThrow().getTag().toString(), "CHANGE")
        @Assert(rows.get(2).getOrThrow().getTag().toString(), "EQUAL")
        @Assert(rows.get(3).getOrThrow().getTag().toString(), "CHANGE")
    }

    @TestCase
    public func testInlineOldTag(): Unit {
        var first = "anything \n \nother"
        var second ="anything\n\nother"
        var generator = Builder()
            .InlineOldTag("old")
            .columnWidth(Int64.Max) // do not wrap
            .build();
        var rows = generator.generateDiffRows(split(first), split(second));
        print(rows);
        @Assert(3, rows.size)
    }

    @TestCase
    public func testInlineNewTag(): Unit {
        var first = "anything \n \nother"
        var second ="anything\n\nother"
        var generator = Builder()
            .InlineNewTag("new")
            .columnWidth(Int64.Max) // do not wrap
            .build();
        var rows = generator.generateDiffRows(split(first), split(second));
        print(rows);
        @Assert(3, rows.size)
    }

    @TestCase
    public func testInlineOldCssClass(): Unit {
        var first = "anything \n \nother"
        var second ="anything\n\nother"
        var generator = Builder()
            .InlineOldCssClass("oldclass")
            .columnWidth(Int64.Max) // do not wrap
            .build();
        var rows = generator.generateDiffRows(split(first), split(second));
        print(rows);
        @Assert(3, rows.size)
    }

    @TestCase
    public func testInlineNewCssClass(): Unit {
        var first = "anything \n \nother"
        var second ="anything\n\nother"
        var generator = Builder()
            .InlineNewCssClass("newclass")
            .columnWidth(Int64.Max) // do not wrap
            .build();
        var rows = generator.generateDiffRows(split(first), split(second));
        print(rows)
        @Assert(3, rows.size)
    }

    @TestCase
    public func testwrapInTag(): Unit {
        var str = DiffRowGenerator.wrapInTag("testline","testtag","testclass")
        print(str)
        let res: String = "<testtag class=\"testclass\">testline</testtag>"
        @Assert(str, res)
    }

    private func split(content: String): ArrayList<String> {
        return ArrayList<String>(content.split("\n"));
    }

    private func print(diffRows: ArrayList<DiffRow>): Unit {
        for (row in diffRows) {
            println(row)
        }
    }

}