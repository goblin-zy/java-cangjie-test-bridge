// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

import diffUtils4cj.*
import std.collection.*

main(): Int64 {
    var original: Chunk<String> = Chunk<String>(2, ["test"])
    var revised: Chunk<String> = Chunk<String>(4, ["test2"])
    var delta = InsertDelta<String>(original, revised)
    var original2: Chunk<String> = Chunk<String>(1, ["test"])
    var delta2 = InsertDelta<String>(original2, revised)
    var newRevised: Chunk<String> = Chunk<String>(5, ["new", "revised"])
    if (DeltaComparator<String>.deltaComparator(delta,delta2) != Ordering.GT) {
        println("err1")
        println(DeltaComparator<String>.deltaComparator(delta,delta2))
        return 1
    }
    delta2.setOriginal(revised)
    if (DeltaComparator<String>.deltaComparator(delta,delta2) != Ordering.LT) {
        println("err2")
        println(DeltaComparator<String>.deltaComparator(delta,delta2))
        return 1
    }
    delta2.setOriginal(original)
    if (DeltaComparator<String>.deltaComparator(delta,delta2) != Ordering.EQ) {
        println("err3")
        println(DeltaComparator<String>.deltaComparator(delta,delta2))
        return 1
    }
    return 0
}