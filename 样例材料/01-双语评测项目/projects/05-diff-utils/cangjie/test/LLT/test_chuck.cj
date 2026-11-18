// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

import diffUtils4cj.*
import std.collection.*
import std.unittest.*
import std.unittest.testmacro.*

main(): Int64 {
    let chcnkTest = chcnkTest()
    chcnkTest.chcnkTest01()
    chcnkTest.chcnkTest02()
    chcnkTest.chcnkTest03()
    chcnkTest.chcnkTest04()
    chcnkTest.chcnkTest05()
    return 0
}

@Test
public class chcnkTest {
    @TestCase
    public func chcnkTest01(): Unit {
        var chunk: Chunk<Rune> = Chunk<Rune>(122, [r'q',r'c',r'e'])
        chunk.setLines(ArrayList<Rune>([r'q',r'c',r'e']))
        var res = 1
        unsafe {
            if (chunk.getLines().getRawArray() ==  [r'q',r'c',r'e']) {
                res =  0
            }
        }
        @Assert(res,0)
    }

    @TestCase
    public func chcnkTest02(): Unit {
        var chunk: Chunk<Rune> = Chunk<Rune>(87897, [r'a',r'c',r'e'])
        chunk.setLines(ArrayList<Rune>([r'g',r'c',r'e']))
        var res = 1
        unsafe {
            if (chunk.getPosition() ==  87897) {
                res =  0
            }
        }
        @Assert(res,0)
    }

    @TestCase
    public func chcnkTest03(): Unit {
        var chunk: Chunk<UInt64> = Chunk<UInt64>(99, [78,89889,2454564])
        var res = 1
        unsafe {
            if (chunk.last() == 99+3-1) {
                res =  0
            }
        }
        @Assert(res,0)
    }

    @TestCase
    public func chcnkTest04(): Unit {
        var chunk: Chunk<Int64> = Chunk<Int64>(11, [123,189,53,787,774,21])
        var sample =  "[position: 11, size: 6, lines: [123, 189, 53, 787, 774, 21]]"
        @Assert(sample,chunk.toString())
    }

    @TestCase
    public func chcnkTest05(): Unit {
        var chunk: Chunk<Int64> = Chunk<Int64>(3, [41,578,67])
        var target = ArrayList<Int64>([11,20,354,34,25,16,4327,53468])
        var res = 1
        try {
            chunk.verify(target)
        } catch (e: PatchFailedException) {
            res = 0
        }
        @Assert(res,0)
    }
}