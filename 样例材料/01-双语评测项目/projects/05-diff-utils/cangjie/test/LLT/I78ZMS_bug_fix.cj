// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

import std.unittest.*
import std.unittest.testmacro.*
import std.collection.*
import diffUtils4cj.*

main(): Int64 {
    testMyersDiffMyersDiff0141()
    testMyersDiffMyersDiff0142()
    return 0
}

func testMyersDiffMyersDiff0141(): Unit {
    var original=["value01","value02","value03","value04","value05","value06","value07"]
    var revised=["value08","value09","value10","value11","value12","value13","value14"]
    var myersDiff01=MyersDiff<String>()
    var pathch01=myersDiff01.diff(original,revised)
    var deltas01=pathch01.getDeltas()
    @Assert(deltas01.size,1)
    @Assert(deltas01[0] is ChangeDelta<String>,true)
    @Assert(deltas01[0].getOriginal().getLines(),ArrayList<String>(original))
    @Assert(deltas01[0].getRevised().getLines(),ArrayList<String>(revised))
}

func testMyersDiffMyersDiff0142(): Unit {
    var original=["value01","value02","value03","value04","value05","value06","value07"]
    var revised=["value08","value09","value10","value11","value12","value13","value14"]
    var myersDiff02=MyersDiff<String>(SubEqualizer01<String>())
    var pathch02=myersDiff02.diff(original,revised)
    var deltas02=pathch02.getDeltas()
    @Assert(deltas02.size,1)
    @Assert(deltas02[0] is ChangeDelta<String>,true)
    @Assert(deltas02[0].getOriginal().getLines(),ArrayList<String>(original))
    @Assert(deltas02[0].getRevised().getLines(),ArrayList<String>(revised))
}


class SubEqualizer01<T> <: Equalizer<T> where T <: Equal<T>{
    public func equals(original: T, revised: T): Bool {
        return original == revised
    }
}