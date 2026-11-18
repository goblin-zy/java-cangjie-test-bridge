// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

import diffUtils4cj.*
import std.collection.*

main(): Int64 {
    var original: Chunk<String> = Chunk<String>(1, ["test"])
    var revised: Chunk<String> = Chunk<String>(0, ["test2"])
    var delta = InsertDelta<String>(original, revised)
    var newOriginal: Chunk<String> = Chunk<String>(5, ["NEW"])
    delta.setOriginal(newOriginal)
    if (delta.getOriginal().equals(newOriginal)) {
        return 0
    }
    return 1
}