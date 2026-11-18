// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

@Test
public class ParserTest {
    @TestCase
    func testSelector_05_01(): Unit {
        let dic = "<div><p id=foo>Hello</p><p id=foo>Foo two!</p></div>"
        let sc = Html4cj.parse(dic)
        let src = sc.select("#foo")
        @Assert(46,src.toString().size)
        @Assert(sc.toString().contains(">Foo two!</p>"),true)
    }

    @TestCase
    func testSelector_05_02(): Unit {
        let dic = "<div><p id=foo>Hello</p><p id=foo>Foo two!</p></div>"
        let sc = Html4cj.parse(dic)
        let src = sc.selectFirst("#foo").getOrThrow()
        @Assert(21,src.toString().size)
        @Assert(sc.toString().contains("<p id=\"foo\">Hello</p>"),true)
    }

    @TestCase
    func testSelector_05_03(): Unit {
        let dic = "<div><p id='a1-foo_bar'>One</p><p class='b2-qux_bif'>Two</p></div>"
        let sc = Html4cj.parse(dic)
        let src = sc.select("#a1-foo_bar")
        @Assert(26,src.toString().size)
        @Assert(sc.toString().contains("<p class=\"b2-qux_bif\">Two</p>"),true)
    }

    @TestCase
    func testSelector_05_04(): Unit {
        let dic = "<div><p id='a1-foo_bar'>One</p><p class='b2-qux_bif'>Two</p></div>"
        let sc = Html4cj.parse(dic)
        let src = sc.selectFirst("#a1-foo_bar").getOrThrow()
        @Assert(26,src.toString().size)
        @Assert(sc.toString().contains("a1-foo_bar"),true)
    }
}
