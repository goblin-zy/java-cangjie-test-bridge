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
        测试场景:下2级节点均不是snake，orig不为空,rev为空
    ***/
    public var rev=ArrayList<String>()
    public var orig=ArrayList<String>(["as","bg","rf","cd"])
    public var diffNode01=Snake(1,1,Option<PathNode>.None)
    public var diffNode02=DiffNode(1,1,Option<PathNode>.Some(diffNode01))
    public var diffNode03=DiffNode(1,1,Option<PathNode>.Some(diffNode02))
    public var diffNode04=DiffNode(1,1,Option<PathNode>.Some(diffNode03))
    @TestCase
    func testMyersDiffBuildRevision031(): Unit {
        var myersDiff01=MyersDiff<String>()
        var flag=1
        try{
           myersDiff01.buildRevision(diffNode04,orig,rev)
        }catch(e:IndexOutOfBoundsException){

            flag=0
        }
        @Assert(flag,0)
    }

    @TestCase
    func testMyersDiffBuildRevision032(): Unit {
        var myersDiff02=MyersDiff<String>(SubEqualizer01<String>())
        var flag=1
        try{
            myersDiff02.buildRevision(diffNode04,orig,rev)
        }catch(e:IndexOutOfBoundsException){

            flag=0
        }
        @Assert(flag,0)
    }
}