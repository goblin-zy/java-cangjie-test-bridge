// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

@Test
public class ParserTest {
    @TestCase
    func testSelector_16_01(): Unit {
        let dic = "<div id=1><div id=2><div id = 3></div></div></div><div id=4></div>"
        let sc = Html4cj.parse(dic)
        let src = sc.select("div > div")
        @Assert(58,src.toString().size)
        @Assert(sc.toString().contains("<div id=\"1\">"),true)
    }

    @TestCase
    func testSelector_16_02(): Unit {
        let dic = "<div id=1><div id=2><div id = 3></div></div></div><div id=4></div>"
        let sc = Html4cj.parse(dic)
        let src = sc.selectFirst("div > div").getOrThrow()
        @Assert(39,src.toString().size)
        @Assert(sc.toString().contains("<div id=\"2\">"),true)
    }

    @TestCase
    func testSelector_16_03(): Unit {
        let dic = "<h1 class=foo><a href=1 /></h1><h1 class=foo><a href=2 class=bar /></h1><h1><a href=3 /></h1>"
        let sc = Html4cj.parse(dic)
        let src = sc.select("h1 > a")
        @Assert(62,src.toString().size)
        @Assert(sc.toString().contains("<h1><a href=\"3\"></a></h1>"),true)
    }

    @TestCase
    func testSelector_16_04(): Unit {
        let dic = "<h1 class=foo><a href=1 /></h1><h1 class=foo><a href=2 class=bar /></h1><h1><a href=3 /></h1>"
        let sc = Html4cj.parse(dic)
        let src = sc.selectFirst("h1 > a").getOrThrow()
        @Assert(16,src.toString().size)
        @Assert(sc.toString().contains("<h1 class=\"foo\"><a href=\"2\" class=\"bar\"></a></h1>"),true)
    }
}
