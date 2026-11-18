// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

@Test
public class ParserTest {
    @TestCase
    func testXmlDecl_02_01(): Unit {
        let datas = XmlDeclaration("  <head> <meta charset=\"utf-8\"> <title>SoupTest</title> </head>", true)
        let src = datas.nodeName()
        @Assert(12,src.toString().size)
    }

    @TestCase
    func testXmlDecl_02_02(): Unit {
        let datas = XmlDeclaration("  <head> <meta charset=\"utf-8\"> <title>SoupTest</title> </head>", true)
        let src = datas.name()
        @Assert(63,src.toString().size)
    }

    @TestCase
    func testXmlDecl_02_03(): Unit {
        let datas = XmlDeclaration("", true)
        let src = datas.name()
        @Assert(0,src.toString().size)
    }

    @TestCase
    func testXmlDecl_02_04(): Unit {
        let datas = XmlDeclaration("  <head> <meta charset=\"utf-8\"> <title>SoupTest</title> </head>", true)
        let src = datas.getWholeDeclaration()
        @Assert(0,src.toString().size)
    }

    @TestCase
    func testXmlDecl_02_05(): Unit {
        let datas = XmlDeclaration("  <head> <meta charset=\"utf-8\"> <title>SoupTest</title> </head>", false)
        let src = datas.toString()
        @Assert(67,src.toString().size)
    }

    @TestCase
    func testXmlDecl_02_06(): Unit {
        let datas = XmlDeclaration("  <head> <meta charset=\"utf-8\"> <title>SoupTest</title> </head>", false)
        let src = datas.clone()
        @Assert(67,src.toString().size)
    }
}
