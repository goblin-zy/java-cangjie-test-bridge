// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

import diffUtils4cj.*
import std.collection.*

main(): Int64 {
    var node0: Snake = Snake(0,0,Option<PathNode>.None)
    var node1: DiffNode = DiffNode(1,5,node0)
    if(node1.toString() == "[(1,5)(0,0)]") {
        return 0
    }
    return 1
}