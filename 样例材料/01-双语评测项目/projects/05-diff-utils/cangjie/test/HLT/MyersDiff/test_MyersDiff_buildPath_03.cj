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
        public func buildPath(orig:  ArrayList<T>, rev:  ArrayList<T>): PathNode
        public init(equalizer: Equalizer<T>)
        public init()
        测试场景:rev，orig非空,且内容不同
    ***/
    public var rev=ArrayList<String>(["as01","bg01","rf01"])
    public var orig=ArrayList<String>(["as","bg","rf","cd"])
    @TestCase
    func testMyersDiffBuildPath031(): Unit {
        var myersDiff01=MyersDiff<String>()
        var pathNode01=myersDiff01.buildPath(orig,rev)
        @Assert(pathNode01.toString(),"[(4,3)(0,0)]")
    }
    @TestCase
    func testMyersDiffBuildPath032(): Unit {
        var myersDiff02=MyersDiff<String>(SubEqualizer01<String>())
        var pathNode02=myersDiff02.buildPath(orig,rev)
        @Assert(pathNode02.toString(),"[(4,3)(0,0)]")
    }
}