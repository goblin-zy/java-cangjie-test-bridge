// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

import diffUtils4cj.*
import std.collection.*
import std.unittest.*
import std.unittest.testmacro.*

main(): Int64 {
    let deltaTest = deltaTest()
    deltaTest.deltaTest01()
    deltaTest.deltaTest02()
    deltaTest.deltaTest03()
    deltaTest.deltaTest04()
    deltaTest.deltaTest05()
    return 0
}

@Test
public class deltaTest {
    @TestCase
    public func deltaTest01(): Unit {
        var original: Chunk<String> = Chunk<String>(99, ["中文测试"])
        var revised: Chunk<String> = Chunk<String>(1, ["test"])
        var delta = ChangeDelta<String>(original, revised)
        var res = match(delta.getType()){
            case DeltaType.CHANGE =>  0
            case _ =>  1
        }
        @Assert(res,0)
    }

    @TestCase
    public func deltaTest02(): Unit {
        var original: Chunk<String> = Chunk<String>(1552, ["test"])
        var revised: Chunk<String> = Chunk<String>(984, ["中文测试"])
        var delta = DeleteDelta<String>(original, revised)
        var res = match(delta.getType()){
            case DeltaType.DELETE =>  0
            case _ =>  1
        }
        @Assert(res,0)
    }

    @TestCase
    public func deltaTest03(): Unit {
        var original: Chunk<String> = Chunk<String>(12, ["%$#(("])
        var revised: Chunk<String> = Chunk<String>(55, ["test"])
        var delta = DeleteDelta<String>(original, revised)
        var res = match(delta.getType()){
            case DeltaType.DELETE =>  0
            case _ =>  1
        }
        @Assert(res,0)
    }

    @TestCase
    public func deltaTest04(): Unit {
        var original: Chunk<String> = Chunk<String>(12, ["中文测试"])
        var revised: Chunk<String> = Chunk<String>(55, ["测测TEST"])
        var delta = InsertDelta<String>(original, revised)
        var res = match(delta.getType()){
            case DeltaType.INSERT =>  0
            case _ =>  1
        }
        @Assert(res,0)
    }

    @TestCase
    public func deltaTest05(): Unit {
        var original: Chunk<String> = Chunk<String>(12, ["^&%&^%&^"])
        var revised: Chunk<String> = Chunk<String>(55, ["测试TEST"])
        var delta = InsertDelta<String>(original, revised)
        var res = match(delta.getType()){
            case DeltaType.INSERT =>  0
            case _ =>  1
        }
        @Assert(res,0)
    }
}