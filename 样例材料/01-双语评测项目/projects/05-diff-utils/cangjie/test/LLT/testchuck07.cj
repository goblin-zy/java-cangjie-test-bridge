// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

import diffUtils4cj.*
import std.collection.*

main(): Int64 {
    var chunk1: Chunk<Int64> = Chunk<Int64>(1, [])
    var chunk2: Chunk<Int64> = Chunk<Int64>(1, [])
    var chunk3: Chunk<Int64> = Chunk<Int64>(2, [22])
    var chunk4: Chunk<Int64> = Chunk<Int64>(2, [1,3,5])
    if (!chunk1.equals(chunk2)) {
        return 1
    }
    if (chunk3.equals(chunk4)) {
        return 1
    }
    return 0
}