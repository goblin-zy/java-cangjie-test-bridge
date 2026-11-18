// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

import diffUtils4cj.*
import std.collection.*
import std.unittest.*
import std.unittest.testmacro.*

main(): Int64 {
    let patchTest = deltaTest()
    patchTest.deltaTest01()
    patchTest.deltaTest02()
    patchTest.deltaTest03()
    patchTest.deltaTest04()
    return 0
}

@Test
public class deltaTest {
    
    @TestCase
    public func deltaTest01(): Unit {
        var original: Chunk<String> = Chunk<String>(12, ["test"])
        var revised: Chunk<String> = Chunk<String>(55, ["test2"])
        var delta = ChangeDelta<String>(original, revised)
        var str = delta.toString()
        @Assert(str,"[ChangeDelta, position: 12, lines: [test] to [test2]]")
    }

    @TestCase
    public func deltaTest02(): Unit {
        var original: Chunk<String> = Chunk<String>(12, ["test"])
        var revised: Chunk<String> = Chunk<String>(55, ["test2"])
        var delta = InsertDelta<String>(original, revised)
        var str = delta.toString()
        @Assert(str,"[InsertDelta, position: 12, lines: [test2]]")
    }

    @TestCase
    public func deltaTest03(): Unit {
        var original: Chunk<String> = Chunk<String>(12, ["test"])
        var revised: Chunk<String> = Chunk<String>(55, ["test2"])
        var delta = DeleteDelta<String>(original, revised)
        var str = delta.toString()
        @Assert(str,"[DeleteDelta, position: 12, lines: [test]]")
    }

    @TestCase
    public func deltaTest04(): Unit {
        var c1: Chunk<String> = Chunk<String>(12, ["test"])
        var c2: Chunk<String> = Chunk<String>(55, ["test2"])
        var delta = DeleteDelta<String>(c1, c2)
        var c3: Chunk<String> = Chunk<String>(987, ["test"])
        var delta2 = DeleteDelta<String>(c1, c3)
        @Assert(false,delta.equals(delta2))
    }
}