// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

@Test
public class ParserTest {
    @TestCase
    func testSelector_03_01(): Unit {
        let dic = "<div><abc:def id=1>Hello</abc:def></div> <abc:def class=bold id=2>There</abc:def>"
        let sc = Html4cj.parse(dic)
        let src = sc.select("*|def")
        @Assert(82,src.toString().size)
        @Assert(sc.toString().contains("</div><abc:def class=\"bold\" id=\"2\">"),true)
    }

    @TestCase
    func testSelector_03_02(): Unit {
        let dic = "<div><abc:def id=1>Hello</abc:def></div> <abc:def class=bold id=2>There</abc:def>"
        let sc = Html4cj.parse(dic)
        let src = sc.selectFirst("*|def").getOrThrow()
        @Assert(34,src.toString().size)
        @Assert(sc.toString().contains("<abc:def id=\"1\">"),true)
    }

    @TestCase
    func testSelector_03_03(): Unit {
        let dic = "<package><meta>One</meta><opf:meta>Two</opf:meta></package>"
        let sc = Html4cj.parse(dic)
        let src = sc.select("*|meta")
        @Assert(34,src.toString().size)
        @Assert(sc.toString().contains("Two"),true)
    }

    @TestCase
    func testSelector_03_04(): Unit {
        let dic = "<package><meta>One</meta><opf:meta>Two</opf:meta></package>"
        let sc = Html4cj.parse(dic)
        let src = sc.selectFirst("*|meta").getOrThrow()
        @Assert(6,src.toString().size)
        @Assert(sc.toString().contains("<opf:meta>"),true)
    }
}
