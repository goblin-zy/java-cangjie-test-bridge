// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

@Test
public class ParserTest {
    @TestCase
    func testSelector_17_01(): Unit {
        let dic = "<ol><li>One<li>Two<li>Three</ol>"
        let sc = Html4cj.parse(dic)
        let src = sc.select("li + li")
        @Assert(27,src.toString().toRuneArray().size)
        @Assert(sc.toString().contains("<li>One</li>"),true)
    }

    @TestCase
    func testSelector_17_02(): Unit {
        let dic = "<ol><li>One<li>Two<li>Three</ol>"
        let sc = Html4cj.parse(dic)
        let src = sc.selectFirst("li + li").getOrThrow()
        @Assert(12,src.toString().toRuneArray().size)
        @Assert(sc.toString().contains("<li>Two</li>"),true)
    }

    @TestCase
    func testSelector_17_03(): Unit {
        let dic = "<div k" + "𡃁" + "='" + "𡃁" + "'>^" + "𡃁" + "$/div>"
        let sc = Html4cj.parse(dic)
        let src = sc.select("div[k" + "𡃁" + "]")
        @Assert(32,src.toString().toRuneArray().size)
        @Assert(sc.toString().contains("<div k𡃁=\"𡃁\">"),true)
    }

    @TestCase
    func testSelector_17_04(): Unit {
        let dic = "<div k" + "𡃁" + "='" + "𡃁" + "'>^" + "𡃁" + "$/div>"
        let sc = Html4cj.parse(dic)
        let src = sc.selectFirst("div[k" + "𡃁" + "]").getOrThrow()
        @Assert(32,src.toString().toRuneArray().size)
        @Assert(sc.toString().contains("^𡃁$/div&gt;"),true)
    }
}
