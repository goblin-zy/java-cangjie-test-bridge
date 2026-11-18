// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

@Test
public class ParserTest {
    @TestCase
    func testSelector_04_01(): Unit {
        let dic = "<One:Two>One</One:Two><three:four>Two</three:four>"
        let sc = Html4cj.parse(dic)
        let src = sc.select("One|Two")
        @Assert(25,src.toString().size)
        @Assert(sc.toString().contains("</one:two><three:four>"),true)
    }

    @TestCase
    func testSelector_04_02(): Unit {
        let dic = "<One:Two>One</One:Two><three:four>Two</three:four>"
        let sc = Html4cj.parse(dic)
        let src = sc.selectFirst("One|Two").getOrThrow()
        @Assert(25,src.toString().size)
        @Assert(sc.toString().contains("</one:two><three:four>"),true)
    }

    @TestCase
    func testSelector_04_03(): Unit {
        let dic = "<div><abc:def id=1>Hello</abc:def></div> <abc:def class=bold id=2>There</abc:def>"
        let sc = Html4cj.parse(dic)
        let src = sc.select("abc|def")
        @Assert(82,src.toString().size)
        @Assert(sc.toString().contains("Hello"),true)
    }

    @TestCase
    func testSelector_04_04(): Unit {
        let dic = "<div><abc:def id=1>Hello</abc:def></div> <abc:def class=bold id=2>There</abc:def>"
        let sc = Html4cj.parse(dic)
        let src = sc.selectFirst("abc|def").getOrThrow()
        @Assert(34,src.toString().size)
        @Assert(sc.toString().contains("</div><abc:def class=\"bold\" id=\"2\">"),true)
    }
}
