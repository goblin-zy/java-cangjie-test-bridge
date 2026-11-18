// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

import diffUtils4cj.*
import std.collection.*
import std.unittest.*
import std.unittest.testmacro.*

main(): Int64 {
    let test = RowTest()
    test.rowtest01()
    test.rowtest02()
    test.rowtest03()
    return 0
}

@Test
public class RowTest {
    
    @TestCase
    public func rowtest01(): Unit {
        var tag = Tag.INSERT
        var row = DiffRow (tag,"","asdsa")
        var tag_old = row.getTag()
        var tag_new = Tag.DELETE
        row.setTag(tag_new)
        @Assert(tag_old.toString(), "INSERT")
        @Assert(tag_new.toString(), "DELETE")
    }

    @TestCase
    public func rowtest02(): Unit {
        var tag = Tag.DELETE
        var row = DiffRow (tag,"old","")
        var oldline_old = row.getOldLine()
        row.setOldLine("new")
        @Assert(oldline_old, "old")
        @Assert(row.getOldLine(), "new")
    }

    @TestCase
    public func rowtest03(): Unit {
        var tag = Tag.CHANGE
        var row = DiffRow (tag,"","old")
        var oldline_old = row.getNewLine()
        row.setNewLine("new")
        @Assert(oldline_old, "old")
        @Assert(row.getNewLine(), "new")
    }
}