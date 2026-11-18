// 3rd_party_lib:diffutils4cj/build/release/diffUtils4cj
// 3rd_party_lib_ohos:diffutils4cj/build/aarch64-linux-ohos/diffUtils4cj
// dependence: ../common_Values.cj
import std.unittest.*
import std.unittest.testmacro.*
import std.collection.*
import diffUtils4cj.*

@Test
public class TestMyersDiffB001{
    /***
        public func diff(original: Array<T>, revised: Array<T>): Patch<T>
        public init(equalizer: Equalizer<T>)
        public init()
        测试场景:original!=revised,original完全不等于revised
    ***/
    public var original=["value01","value02","value03","value04","value05","value06","value07"]
    public var revised=["value08","value09","value10","value11","value12","value13","value14"]
    @TestCase
    func testMyersDiffMyersDiff0141(): Unit {
        var myersDiff01=MyersDiff<String>()
        var pathch01=myersDiff01.diff(original,revised)
        var deltas01=pathch01.getDeltas()
        @Assert(deltas01.size,1)
        @Assert(deltas01[0] is ChangeDelta<String>,true)
        @Assert(deltas01[0].getOriginal().getLines(),ArrayList<String>(original))
        @Assert(deltas01[0].getRevised().getLines(),ArrayList<String>(revised))
    }
    @TestCase
    func testMyersDiffMyersDiff0142(): Unit {
        var myersDiff02=MyersDiff<String>(SubEqualizer01<String>())
        var pathch02=myersDiff02.diff(original,revised)
        var deltas02=pathch02.getDeltas()
        @Assert(deltas02.size,1)
        @Assert(deltas02[0] is ChangeDelta<String>,true)
        @Assert(deltas02[0].getOriginal().getLines(),ArrayList<String>(original))
        @Assert(deltas02[0].getRevised().getLines(),ArrayList<String>(revised))
    }
}