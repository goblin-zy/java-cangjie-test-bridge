// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

import diffUtils4cj.*
import std.collection.*

main(): Int64 {
    try {
        throw(PatchFailedException())
    } catch(e: PatchFailedException) {
         if(e.message == "") {
            return 0
        }
        return 1
    }
}