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
        测试场景:仅rev为空
    ***/
    public var rev=ArrayList<String>()
    public var orig=ArrayList<String>(["as","bg","rf","cd"])
    @TestCase
    func testMyersDiffBuildPath021(): Unit {
        var myersDiff01=MyersDiff<String>()
        var pathNode01=myersDiff01.buildPath(orig,rev)
        @Assert(pathNode01.toString(),"[(4,0)(0,0)]")

    }
    @TestCase
    func testMyersDiffBuildPath022(): Unit {
        var myersDiff02=MyersDiff<String>(SubEqualizer01<String>())
        var pathNode02=myersDiff02.buildPath(orig,rev)
        @Assert(pathNode02.toString(),"[(4,0)(0,0)]")
    }
}
