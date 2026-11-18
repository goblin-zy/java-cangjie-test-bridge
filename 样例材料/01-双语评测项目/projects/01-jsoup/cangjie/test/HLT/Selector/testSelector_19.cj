// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*
import std.time.*

@Test
public class ParserTest {
    @TestCase
    func testSelector_19_01(): Unit {
        let dic = "<div title=foo /><div title=bar /><div /><p></p><img /><span title=qux>"
        let sc = Html4cj.parse(dic)
        let src = sc.select("p,div,[title]")
        @Assert(93,src.toString().size)
        @Assert(sc.toString().contains("<div title=\"foo\"></div>"),true)
    }

    @TestCase
    func testSelector_19_02(): Unit {
        let dic = "<div title=foo /><div title=bar /><div /><p></p><img /><span title=qux>"
        let sc = Html4cj.parse(dic)
        let src = sc.selectFirst("p,div,[title]").getOrThrow()
        @Assert(23,src.toString().size)
        @Assert(sc.toString().contains("<p></p><img><span title=\"qux\"></span>"),true)
    }

    @TestCase
    func testSelector_19_03(): Unit {
        let dic = "<div id=1 /><div id=2 /><div title=foo /><div title=bar />"
        let sc = Html4cj.parse(dic)
        let src = sc.select("[id],[title=foo]")
        @Assert(61,src.toString().size)
        @Assert(sc.toString().contains("<div title=\"bar\"></div>"),true)
    }

    @TestCase
    func testSelector_19_04(): Unit {
        let dic = "<div id=1 /><div id=2 /><div title=foo /><div title=bar />"
        let sc = Html4cj.parse(dic)
        let src = sc.selectFirst("[id],[title=foo]").getOrThrow()
        @Assert(18,src.toString().size)
        @Assert(sc.toString().contains("<div id=\"2\"></div>"),true)
    }
}
