// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

import std.unittest.*
import std.unittest.testmacro.*
import std.collection.*
import diffUtils4cj.*

main(): Unit {
    var rev=ArrayList<String>()
    var orig=ArrayList<String>(["as","bg","rf","cd"])
    var diffNode01=Snake(1,1,Option<PathNode>.None)
    var diffNode02=DiffNode(1,1,Option<PathNode>.Some(diffNode01))
    var diffNode03=DiffNode(1,1,Option<PathNode>.Some(diffNode02))
    var diffNode04=DiffNode(1,1,Option<PathNode>.Some(diffNode03))
    var myersDiff01=MyersDiff<String>()
    var flag = 1
    try {
        myersDiff01.buildRevision(diffNode04,orig,rev)
    }
    catch (e: IndexOutOfBoundsException) {
        flag = 0
    }
    @Assert(flag,0)
}