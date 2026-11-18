// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

import diffUtils4cj.*
import std.collection.*

main(): Int64 {
    var patch:  Patch<Int64>= DiffUtils.diff(ArrayList<Int64>([1,2,3,4]), ArrayList<Int64>([1,1,3,4]))
    if (patch.getDeltas().isEmpty()) {
        return 1
    }
    if (1 != patch.getDeltas().size) {
        return 1
    }
    var  delta = patch.getDeltas().get(0).getOrThrow()
    if (!(delta is ChangeDelta<Int64>)) {
        return 1
    }
    unsafe {
        if(delta.getOriginal().getLines().getRawArray() != [2]) {
            return 1
        }
        if(delta.getRevised().getLines().getRawArray() != [1]) {
            return 1
        }
    }
    return 0
}