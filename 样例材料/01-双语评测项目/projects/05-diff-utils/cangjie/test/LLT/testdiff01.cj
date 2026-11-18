// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

import diffUtils4cj.*
import std.collection.*

main(): Int64 {
    var patch:  Patch<String>= DiffUtils.diff(ArrayList<String>(["hhh"]), ArrayList<String>(["hhh", "jjj", "kkk"]))
    if (patch.getDeltas().isEmpty()) {
        return 1
    }
    if (1 != patch.getDeltas().size) {
        return 1
    }
    var  delta = patch.getDeltas().get(0).getOrThrow()
    if (!(delta is InsertDelta<String>)) {
        return 1
    }
    if(!delta.getOriginal().getLines().isEmpty()) {
        return 1
    }
    unsafe {
        if(delta.getRevised().getLines().getRawArray() != ["jjj", "kkk"]) {
            return 1
        }
    }
    return 0
}