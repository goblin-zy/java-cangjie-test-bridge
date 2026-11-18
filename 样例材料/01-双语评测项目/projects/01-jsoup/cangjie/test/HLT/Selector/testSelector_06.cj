// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

@Test
public class ParserTest {
    @TestCase
    func testSelector_06_01(): Unit {
        let dic =
            "<p>Excl</p><div class=headline><p>Hello</p><p>There</p></div><div class=headline><h1>Headline</h1></div>"
        let sc = Html4cj.parse(dic)
        let src = sc.select(".headline")
        @Assert(106,src.toString().size)
        @Assert(sc.toString().contains("<div class=\"headline\">"),true)
    }

    @TestCase
    func testSelector_06_02(): Unit {
        let dic =
            "<p>Excl</p><div class=headline><p>Hello</p><p>There</p></div><div class=headline><h1>Headline</h1></div>"
        let sc = Html4cj.parse(dic)
        let src = sc.selectFirst(".headline").getOrThrow()
        @Assert(57,src.toString().size)
        @Assert(sc.toString().contains("<p>Excl</p>"),true)
    }

    @TestCase
    func testSelector_06_03(): Unit {
        let dic = "<div><abc:def id=1>Hello</abc:def></div> <abc:def class=bold id=2>There</abc:def>"
        let sc = Html4cj.parse(dic)
        let src = sc.select(".bold")
        @Assert(47,src.toString().size)
        @Assert(sc.toString().contains("There"),true)
    }

    @TestCase
    func testSelector_06_04(): Unit {
        let dic = "<div><abc:def id=1>Hello</abc:def></div> <abc:def class=bold id=2>There</abc:def>"
        let sc = Html4cj.parse(dic)
        let src = sc.selectFirst(".bold").getOrThrow()
        @Assert(47,src.toString().size)
        @Assert(sc.toString().contains("</div><abc:def class=\"bold\" id=\"2\">"),true)
    }
}
