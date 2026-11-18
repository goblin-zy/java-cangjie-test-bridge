// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

import diffUtils4cj.*
import std.collection.*

main(): Int64 {
    var patch:  Patch<String>= DiffUtils.diff(ArrayList<String>(), ArrayList<String>())
    if (patch.getDeltas().isEmpty()) {
        return 0
    }
    return 0
}