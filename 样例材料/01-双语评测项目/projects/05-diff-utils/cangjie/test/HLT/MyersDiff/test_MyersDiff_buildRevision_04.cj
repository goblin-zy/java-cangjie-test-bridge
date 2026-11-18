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
        public func buildRevision(path: PathNode, orig: ArrayList<T>, rev: ArrayList<T>): Patch<T>
        public init(equalizer: Equalizer<T>)
        public init()
        测试场景:下2级节点均不是snake，orig,rev均不为空
    ***/
    public var orig=ArrayList<String>(["as","rf","cd","bg"])
    public var rev=ArrayList<String>(["as","bg","rf","cd"])
    public var diffNode01=Snake(1,1,Option<PathNode>.None)
    public var diffNode02=DiffNode(1,1,Option<PathNode>.Some(diffNode01))
    public var diffNode03=DiffNode(1,1,Option<PathNode>.Some(diffNode02))
    public var diffNode04=DiffNode(1,1,Option<PathNode>.Some(diffNode03))
    @TestCase
    func testMyersDiffBuildRevision041(): Unit {
        var myersDiff01=MyersDiff<String>()
        var patch01=myersDiff01.buildRevision(diffNode03,orig,rev)
        var deltas01=patch01.getDeltas()
        @Assert(deltas01.size,1)
        @Assert(deltas01[0] is ChangeDelta<String>,true)
        @Assert(deltas01[0].getOriginal().getLines(),ArrayList<String>([]))
        @Assert(deltas01[0].getRevised().getLines(),ArrayList<String>([]))
    }

    @TestCase
    func testMyersDiffBuildRevision042(): Unit {
        var myersDiff02=MyersDiff<String>(SubEqualizer01<String>())
        var patch02=myersDiff02.buildRevision(diffNode03,orig,rev)
        var deltas02=patch02.getDeltas()
        @Assert(deltas02.size,1)
        @Assert(deltas02[0] is ChangeDelta<String>,true)
        @Assert(deltas02[0].getOriginal().getLines(),ArrayList<String>([]))
        @Assert(deltas02[0].getRevised().getLines(),ArrayList<String>([]))
    }
}