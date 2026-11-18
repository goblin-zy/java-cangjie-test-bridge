// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

@Test
public class ParserTest {
    @TestCase
    func testSelector_15_01(): Unit {
        let dic = "<div><p>One</p><p>Two</p><p>Three</p></div><div><p>Four</p>"
        let sc = Html4cj.parse(dic)
        let src = sc.select("div p:gt(0)")
        @Assert(23,src.toString().size)
        @Assert(sc.toString().contains("<p>One</p>"),true)
    }

    @TestCase
    func testSelector_15_02(): Unit {
        let dic = "<div><p>One</p><p>Two</p><p>Three</p></div><div><p>Four</p>"
        let sc = Html4cj.parse(dic)
        let src = sc.selectFirst("div p:gt(0)").getOrThrow()
        @Assert(10,src.toString().size)
        @Assert(sc.toString().contains("<p>Two</p>"),true)
    }

    @TestCase
    func testSelector_15_03(): Unit {
        let dic = "<div><p>One</p><p>Two</p><p>Three</>p></div><div><p>Four</p>"
        let sc = Html4cj.parse(dic)
        let src = sc.select("div p:eq(0)")
        @Assert(22,src.toString().size)
        @Assert(sc.toString().contains("<p>Threep&gt;</p>"),true)
    }

    @TestCase
    func testSelector_15_04(): Unit {
        let dic = "<div><p>One</p><p>Two</p><p>Three</>p></div><div><p>Four</p>"
        let sc = Html4cj.parse(dic)
        let src = sc.selectFirst("div p:eq(0)").getOrThrow()
        @Assert(10,src.toString().size)
        @Assert(sc.toString().contains("<p>Four</p>"),true)
    }
}
