// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

import std.unittest.*
import std.unittest.testmacro.*
import std.collection.*
import diffUtils4cj.*


main(): Unit {
    var original=Chunk(123,ArrayList<Int64>([1,2,3,4,5,6]))
    var revised=Chunk(123,[7,8,9,10,11,12])
    let insertDelta=InsertDelta(original,revised)
    let re_act=insertDelta.toString()
    let re_exp="[InsertDelta, position: ${original.getPosition()}, lines: ${revised.getLines()}]"
    @Assert(re_act,re_exp)
}
