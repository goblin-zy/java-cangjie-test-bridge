// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

import diffUtils4cj.*
import std.collection.*

main(): Int64 {
    var original: Chunk<String> = Chunk<String>(12, ["test"])
    var revised: Chunk<String> = Chunk<String>(5, ["test2"])
    var delta = DeleteDelta<String>(original, revised)
    match(delta.getType()){
        case DeltaType.DELETE => return 0
        case _ => return 1
    }
}