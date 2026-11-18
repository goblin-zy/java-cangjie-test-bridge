// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

import diffUtils4cj.*
import std.collection.*

main(): Int64 {
    var chunk: Chunk<Int64> = Chunk<Int64>(2, [1,3,5])
    var sample =  "[position: 2, size: 3, lines: [1, 3, 5]]"
    if (chunk.toString() == sample) {
        return 0
    }
    println(chunk.toString())
    return 1
}