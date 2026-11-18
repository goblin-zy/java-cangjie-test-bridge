// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

import std.unittest.*
import std.unittest.testmacro.*
import std.collection.*
import diffUtils4cj.*

main(): Int64 {
    var diffNode01=DiffNode(1,1,Option<PathNode>.None)
    @Assert(diffNode01.isSnake(), false)
    return 0
}