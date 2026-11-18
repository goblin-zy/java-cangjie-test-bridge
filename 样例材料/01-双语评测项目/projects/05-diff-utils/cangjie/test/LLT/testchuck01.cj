// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

import diffUtils4cj.*
import std.collection.*

main(): Int64 {
    var chunk: Chunk<String> = Chunk<String>(12, ["test"])
    if (chunk.getPosition() == 12) {
        return 0
    }
    return 1
}