// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

@Test
public class ParserTest {
    @TestCase
    func testSelector_08_01(): Unit {
        let dic = "<div id=1 ATTRIBUTE data-name=jsoup>Hello</div><p data-val=5 id=2>There</p><p id=3>No</p>"
        let sc = Html4cj.parse(dic)
        let src = sc.select("[^data-]")
        @Assert(87,src.toString().size)
        @Assert(sc.toString().contains("<div id=\"1\" attribute data-name=\"jsoup\">"),true)
    }

    @TestCase
    func testSelector_08_02(): Unit {
        let dic = "<div id=1 ATTRIBUTE data-name=jsoup>Hello</div><p data-val=5 id=2>There</p><p id=3>No</p>"
        let sc = Html4cj.parse(dic)
        let src = sc.selectFirst("[^data-]").getOrThrow()
        @Assert(54,src.toString().size)
        @Assert(sc.toString().contains("attribute data-name"),true)
    }

    @TestCase
    func testSelector_08_03(): Unit {
        let dic = "<div id=1 ATTRIBUTE data-name=jsoup>Hello</div><p data-val=5 id=2>There</p><p id=3>No</p>"
        let sc = Html4cj.parse(dic)
        let src = sc.select("[^attrib]")
        @Assert(54,src.toString().size)
        @Assert(sc.toString().contains("<p id=\"3\">No</p>"),true)
    }

    @TestCase
    func testSelector_08_04(): Unit {
        let dic = "<div id=1 ATTRIBUTE data-name=jsoup>Hello</div><p data-val=5 id=2>There</p><p id=3>No</p>"
        let sc = Html4cj.parse(dic)
        let src = sc.selectFirst("[^attrib]").getOrThrow()
        @Assert(54,src.toString().size)
        @Assert(sc.toString().contains("<p data-val=\"5\" id=\"2\">There</p>"),true)
    }
}
