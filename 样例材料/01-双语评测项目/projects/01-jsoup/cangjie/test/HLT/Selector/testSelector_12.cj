// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

@Test
public class ParserTest {
    @TestCase
    func testSelector_12_01(): Unit {
        let dic = "<div Title=Foo /><div Title=Bar /><div Style=Qux /><div title=Balim /><div title=SLIM />" +
            "<div data-name='with spaces'/>"
        let sc = Html4cj.parse(dic)
        let src = sc.select("[title$=im]")
        @Assert(50,src.toString().size)
        @Assert(sc.toString().contains("<div data-name=\"with spaces\"></div>"),true)
    }

    @TestCase
    func testSelector_12_02(): Unit {
        let dic = "<div Title=Foo /><div Title=Bar /><div Style=Qux /><div title=Balim /><div title=SLIM />" +
            "<div data-name='with spaces'/>"
        let sc = Html4cj.parse(dic)
        let src = sc.selectFirst("[title$=im]").getOrThrow()
        @Assert(25,src.toString().size)
        @Assert(sc.toString().contains("<div style=\"Qux\"></div>"),true)
    }

    @TestCase
    func testSelector_12_03(): Unit {
        let dic = "<p Class='SomeText AnotherText'>One</p>"
        let sc = Html4cj.parse(dic)
        let src = sc.select("[class$=AnotherText]")
        @Assert(39,src.toString().size)
        @Assert(sc.toString().contains("SomeText AnotherText"),true)
    }

    @TestCase
    func testSelector_12_04(): Unit {
        let dic = "<p Class='SomeText AnotherText'>One</p>"
        let sc = Html4cj.parse(dic)
        let src = sc.selectFirst("[class$=AnotherText]").getOrThrow()
        @Assert(39,src.toString().size)
        @Assert(sc.toString().contains("<p class=\"SomeText AnotherText\">One</p>"),true)
    }
}
