// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

import diffUtils4cj.*
import std.collection.*

main(): Int64 {
    var chunk: Chunk<Int64> = Chunk<Int64>(2, [3,4,5])
    var target = ArrayList<Int64>([1,2,3,4,5,6,7,8])
    try {
        chunk.verify(target)
    } catch (e: PatchFailedException) {
        return 1
    }
    return 0
}