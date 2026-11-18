// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

import std.unittest.*
import std.unittest.testmacro.*
import std.collection.*
import diffUtils4cj.*



main(): Unit {
    var original=Chunk(2,ArrayList<Int64>([1,2,3]))
    var revised=Chunk(3,[3,4,5,7,8,6])
    let changeDelta=ChangeDelta(original,revised)
    var patch=Patch<Int64>()
    patch.addDelta(changeDelta)
    var target=ArrayList<Int64>([2, 7, 1, 7, 1, 2, 3, 8, 9])
    let result=patch.restore(target)
    var exp_result=ArrayList<Int64>([2, 7, 1, 1, 2, 3])
    @Assert(result,exp_result)
}