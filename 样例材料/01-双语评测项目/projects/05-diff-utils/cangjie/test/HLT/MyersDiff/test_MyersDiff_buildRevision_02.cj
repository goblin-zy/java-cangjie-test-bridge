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
        测试场景:当前是snake，且下一级是Snake,且下一级snake的下1级节点不是None，orig为空,rev不为空，抛异常
    ***/
    public var orig=ArrayList<String>(["as","bg","rf","cd"])
    public var rev=ArrayList<String>(["as","bg","rf","cd"])
    public var snake01=Snake(1,1,Option<PathNode>.None)
    public var snake02=Snake(1,1,Option<PathNode>.Some(snake01))
    public var snake03=Snake(1,1,Option<PathNode>.Some(snake02))
    @TestCase
    func testMyersDiffBuildRevision021(): Unit {
        var myersDiff01=MyersDiff<String>()
        var flag=1
        try{
            myersDiff01.buildRevision(snake03,orig,rev)
        }catch(e:DifferentiationFailedException){

            if(e.toString().contains("DifferentiationFailedException: bad diffpath, found snake when looking for diff")){
                flag=0
            }
        }
        @Assert(flag,0)
    }

    @TestCase
    func testMyersDiffBuildRevision022(): Unit {
        var myersDiff02=MyersDiff<String>(SubEqualizer01<String>())
        var flag=1
        try{
            myersDiff02.buildRevision(snake03,orig,rev)
        }catch(e:DifferentiationFailedException){

            if(e.toString().contains("DifferentiationFailedException: bad diffpath, found snake when looking for diff")){
                flag=0
            }
        }
        @Assert(flag,0)
    }
}