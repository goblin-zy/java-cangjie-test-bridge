// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

@Test
public class ParserTest {
    @TestCase
    func testXmlDecl_01_01(): Unit {
        let datas = XmlDeclaration("#dataHello Cang!@#$%^&*()_+:<>?|jie Lang", true)
        let src = datas.nodeName()
        @Assert(12,src.toString().toRuneArray().size)
    }

    @TestCase
    func testXmlDecl_01_02(): Unit {
        let datas = XmlDeclaration("#dataHello Cang!@#$%^&*()_+:<>?|jie Lang", true)
        let src = datas.name()
        @Assert(40,src.toString().toRuneArray().size)
    }

    @TestCase
    func testXmlDecl_01_03(): Unit {
        let datas = XmlDeclaration("你好仓颉！【】", false)
        let src = datas.name()
        @Assert(7,src.toString().toRuneArray().size)
    }

    @TestCase
    func testXmlDecl_01_04(): Unit {
        let datas = XmlDeclaration("你好仓颉！【】", false)
        let src = datas.getWholeDeclaration()
        @Assert(0,src.toString().toRuneArray().size)
    }

    @TestCase
    func testXmlDecl_01_05(): Unit {
        let datas = XmlDeclaration("你好仓颉！【】", false)
        let src = datas.toString()
        @Assert(11,src.toString().toRuneArray().size)
    }

    @TestCase
    func testXmlDecl_01_06(): Unit {
        let datas = XmlDeclaration("你好仓颉！【】", false)
        let src = datas.clone()
        @Assert(11,src.toString().toRuneArray().size)
    }
}
