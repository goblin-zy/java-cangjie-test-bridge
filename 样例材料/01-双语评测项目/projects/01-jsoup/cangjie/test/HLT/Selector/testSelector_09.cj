// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

@Test
public class ParserTest {
    @TestCase
    func testSelector_09_01(): Unit {
        let dic = "<div Title=Foo /><div Title=Bar /><div Style=Qux /><div title=Balim /><div title=SLIM />" +
            "<div data-name='with spaces'/>"
        let sc = Html4cj.parse(dic)
        let src = sc.select("[TITLE=foo]")
        @Assert(23,src.toString().size)
        @Assert(sc.toString().contains("<div data-name=\"with spaces\"></div>"),true)
    }

    @TestCase
    func testSelector_09_02(): Unit {
        let dic = "<div Title=Foo /><div Title=Bar /><div Style=Qux /><div title=Balim /><div title=SLIM />" +
            "<div data-name='with spaces'/>"
        let sc = Html4cj.parse(dic)
        let src = sc.selectFirst("[TITLE=foo]").getOrThrow()
        @Assert(23,src.toString().size)
        @Assert(sc.toString().contains("<div title=\"Bar\"></div>"),true)
    }

    @TestCase
    func testSelector_09_03(): Unit {
        let dic = "<div Title=Foo /><div Title=Bar /><div Style=Qux /><div title=Balim /><div title=SLIM />" +
            "<div data-name='with spaces'/>"
        let sc = Html4cj.parse(dic)
        let src = sc.select("[title=\"foo\"]")
        @Assert(23,src.toString().size)
        @Assert(sc.toString().contains("<div title=\"SLIM\"></div>"),true)
    }

    @TestCase
    func testSelector_09_04(): Unit {
        let dic = "<div Title=Foo /><div Title=Bar /><div Style=Qux /><div title=Balim /><div title=SLIM />" +
            "<div data-name='with spaces'/>"
        let sc = Html4cj.parse(dic)
        let src = sc.selectFirst("[title=\"foo\"]").getOrThrow()
        @Assert(23,src.toString().size)
        @Assert(sc.toString().contains("<div style=\"Qux\"></div>"),true)
    }
}
