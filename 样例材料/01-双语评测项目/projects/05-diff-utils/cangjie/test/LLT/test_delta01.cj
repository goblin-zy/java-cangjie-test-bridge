// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

import diffUtils4cj.*
import std.collection.*

main(): Int64 {
    var original: Chunk<String> = Chunk<String>(12, ["test"])
    var revised: Chunk<String> = Chunk<String>(55, ["test2"])
    var delta = ChangeDelta<String>(original, revised)
    match(delta.getType()){
        case DeltaType.CHANGE => return 0
        case _ => return 1
    }
}