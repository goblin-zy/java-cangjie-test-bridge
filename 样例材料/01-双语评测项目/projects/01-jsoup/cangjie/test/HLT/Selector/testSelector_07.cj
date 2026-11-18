// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

@Test
public class ParserTest {
    @TestCase
    func testSelector_07_01(): Unit {
        let dic = "<p name='1,2'>One</p><div>Two</div><ol><li>123</li><li>Text</li></ol>"
        let sc = Html4cj.parse(dic)
        let src = sc.select("[name=1,2]")
        @Assert(21,src.toString().size)
        @Assert(sc.toString().contains("<p name=\"1,2\">One</p>"),true)
    }

    @TestCase
    func testSelector_07_02(): Unit {
        let dic = "<p name='1,2'>One</p><div>Two</div><ol><li>123</li><li>Text</li></ol>"
        let sc = Html4cj.parse(dic)
        let src = sc.selectFirst("[name=1,2]").getOrThrow()
        @Assert(21,src.toString().size)
        @Assert(sc.toString().contains("<li>123</li>"),true)
    }

    @TestCase
    func testSelector_07_03(): Unit {
        let dic = "<div Title=Foo /><div Title=Bar /><div Style=Qux /><div title=Balim /><div title=SLIM />" +
            "<div data-name='with spaces'/>"
        let sc = Html4cj.parse(dic)
        let src = sc.select("[title]")
        @Assert(98,src.toString().size)
        @Assert(sc.toString().contains("<div data-name=\"with spaces\"></div>"),true)
    }

    @TestCase
    func testSelector_07_04(): Unit {
        let dic = "<div Title=Foo /><div Title=Bar /><div Style=Qux /><div title=Balim /><div title=SLIM />" +
            "<div data-name='with spaces'/>"
        let sc = Html4cj.parse(dic)
        let src = sc.selectFirst("[title]").getOrThrow()
        @Assert(23,src.toString().size)
        @Assert(sc.toString().contains("<div style=\"Qux\"></div>"),true)
    }
}
