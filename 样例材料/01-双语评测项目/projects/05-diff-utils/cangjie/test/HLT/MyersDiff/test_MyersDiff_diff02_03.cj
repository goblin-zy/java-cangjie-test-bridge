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
        public func diff(original: ArrayList<T>, revised: ArrayList<T>): Patch<T>
        public init(equalizer: Equalizer<T>)
        public init()
        测试场景:original!=revised,original有revised中没有的元素,original没有revised中有的元素
    ***/
    public var original=ArrayList<String>(["value01","value02","value03","old","value04","value05","value06","value07"])
    public var revised=ArrayList<String>(["value02","value03","value04","value05","value06","new","value07","value08"])
    @TestCase
    func testMyersDiffMyersDiff0231(): Unit {
        var myersDiff01=MyersDiff<String>()
        var pathch01=myersDiff01.diff(original,revised)
        var deltas01=pathch01.getDeltas()
        @Assert(deltas01.size,4)
        @Assert(deltas01[0] is DeleteDelta<String>,true)
        @Assert(deltas01[0].getOriginal().getLines(),ArrayList<String>(["value01"]))
        @Assert(deltas01[0].getRevised().getLines(),ArrayList<String>([]))

        @Assert(deltas01[1] is DeleteDelta<String>,true)
        @Assert(deltas01[1].getOriginal().getLines(),ArrayList<String>(["old"]))
        @Assert(deltas01[1].getRevised().getLines(),ArrayList<String>([]))

        @Assert(deltas01[2] is InsertDelta<String>,true)
        @Assert(deltas01[2].getOriginal().getLines(),ArrayList<String>([]))
        @Assert(deltas01[2].getRevised().getLines(),ArrayList<String>(["new"]))

        @Assert(deltas01[3] is InsertDelta<String>,true)
        @Assert(deltas01[3].getOriginal().getLines(),ArrayList<String>([]))
        @Assert(deltas01[3].getRevised().getLines(),ArrayList<String>(["value08"]))
    }
    @TestCase
    func testMyersDiffMyersDiff0232(): Unit {
        var myersDiff02=MyersDiff<String>(SubEqualizer01<String>())
        var pathch02=myersDiff02.diff(original,revised)
        var deltas02=pathch02.getDeltas()
        @Assert(deltas02.size,4)

        @Assert(deltas02[0] is DeleteDelta<String>,true)
        @Assert(deltas02[0].getOriginal().getLines(),ArrayList<String>(["value01"]))
        @Assert(deltas02[0].getRevised().getLines(),ArrayList<String>([]))

        @Assert(deltas02[1] is DeleteDelta<String>,true)
        @Assert(deltas02[1].getOriginal().getLines(),ArrayList<String>(["old"]))
        @Assert(deltas02[1].getRevised().getLines(),ArrayList<String>([]))

        @Assert(deltas02[2] is InsertDelta<String>,true)
        @Assert(deltas02[2].getOriginal().getLines(),ArrayList<String>([]))
        @Assert(deltas02[2].getRevised().getLines(),ArrayList<String>(["new"]))

        @Assert(deltas02[3] is InsertDelta<String>,true)
        @Assert(deltas02[3].getOriginal().getLines(),ArrayList<String>([]))
        @Assert(deltas02[3].getRevised().getLines(),ArrayList<String>(["value08"]))
    }
}
