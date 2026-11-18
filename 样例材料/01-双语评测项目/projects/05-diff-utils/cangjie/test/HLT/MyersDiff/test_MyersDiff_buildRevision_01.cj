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
        测试场景:下1级节点是snake,orig,rev两者均为空
    ***/
    public var orig=ArrayList<String>()
    public var rev=ArrayList<String>()
    public var snake01=Snake(1,1,Option<PathNode>.None)
    public var diffNode01=DiffNode(1,1,Option<PathNode>.Some(snake01))
    @TestCase
    func testMyersDiffBuildRevision011(): Unit {
        var myersDiff01=MyersDiff<String>()
        var flag=1
        try{
            myersDiff01.buildRevision(diffNode01,orig,rev)
        }catch(e:IndexOutOfBoundsException){

            flag=0
        }
        @Assert(flag,0)
    }

    @TestCase
    func testMyersDiffBuildRevision012(): Unit {
        var myersDiff02=MyersDiff<String>(SubEqualizer01<String>())
        var flag=1
        try{
            myersDiff02.buildRevision(diffNode01,orig,rev)
        }catch(e:IndexOutOfBoundsException){

            flag=0
        }
        @Assert(flag,0)

    }
}
