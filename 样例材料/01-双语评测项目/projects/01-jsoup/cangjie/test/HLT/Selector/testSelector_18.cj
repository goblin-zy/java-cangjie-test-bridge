// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

@Test
public class ParserTest {
    @TestCase
    func testSelector_18_01(): Unit {
        let dic = "<ol><li id=1>One<li id=2>Two<li id=3>Three</ol>"
        let sc = Html4cj.parse(dic)
        let src = sc.select("#1 ~ #3")
        @Assert(21,src.toString().size)
        @Assert(sc.toString().contains("<li id=\"1\">One</li>"),true)
    }

    @TestCase
    func testSelector_18_02(): Unit {
        let dic = "<ol><li id=1>One<li id=2>Two<li id=3>Three</ol>"
        let sc = Html4cj.parse(dic)
        let src = sc.selectFirst("#1 ~ #3").getOrThrow()
        @Assert(21,src.toString().size)
        @Assert(sc.toString().contains("<li id=\"2\">Two</li>"),true)
    }

    @TestCase
    func testSelector_18_03(): Unit {
        let dic = "<div><p>One <a class=big>Two</a> Three</p><p>Another</p>"
        let sc = Html4cj.parse(dic)
        let src = sc.select("p ~ p")
        @Assert(14,src.toString().size)
        @Assert(sc.toString().contains("<p>Another</p>"),true)
    }

    @TestCase
    func testSelector_18_04(): Unit {
        let dic = "<div><p>One <a class=big>Two</a> Three</p><p>Another</p>"
        let sc = Html4cj.parse(dic)
        let src = sc.selectFirst("p ~ p").getOrThrow()
        @Assert(14,src.toString().size)
        @Assert(sc.toString().contains("<p>One <a class=\"big\">Two</a> Three</p>"),true)
    }
}
