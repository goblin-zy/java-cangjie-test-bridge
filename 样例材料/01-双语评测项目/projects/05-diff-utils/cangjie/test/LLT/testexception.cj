// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

import diffUtils4cj.*
import std.collection.*

main(): Int64 {
    try {
        throw(DifferentiationFailedException("ok"))
    } catch(e: DifferentiationFailedException) {
        if(e.message == "ok") {
            return 0
        }
        return 1
    }
}