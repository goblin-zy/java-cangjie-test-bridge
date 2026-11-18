// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

import diffUtils4cj.*
import std.collection.*

main(): Int64 {
    var chunk: Chunk<Int64> = Chunk<Int64>(122, [99,12,13])
    unsafe {
        if (chunk.getLines().getRawArray() ==  [99,12,13]) {
            return 0
        }
    }
    return 1
}