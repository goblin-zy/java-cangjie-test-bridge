// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

import diffUtils4cj.*
import std.collection.*

main(): Int64 {
    var chunk: Chunk<Int64> = Chunk<Int64>(122, [99,12,13])
    chunk.setLines(ArrayList<Int64>([0,1,2,4]))
    unsafe {
        if (chunk.getLines().getRawArray() ==  [0,1,2,4]) {
            return 0
        }
    }
    return 1
}