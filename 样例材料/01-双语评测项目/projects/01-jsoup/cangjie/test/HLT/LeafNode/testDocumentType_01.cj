// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

@Test
public class ParserTest {
    @TestCase
    func testDocumentType_01_01(): Unit {
        let sc = DocumentType.SYSTEM_KEY
        @Assert(6,sc.size)
        let sc1 = DocumentType.PUBLIC_KEY
        @Assert(6,sc1.toRuneArray().size)
    }

    @TestCase
    func testDocumentType_01_02(): Unit {
        let sc = DocumentType("html", "-//IETF//DTD HTML//", "")
        sc.setPubSysKey("")
        @Assert(37,sc.toString().toRuneArray().size)
    }

    @TestCase
    func testDocumentType_01_03(): Unit {
        let sc = DocumentType("html", "-//IETF//DTD HTML//", "")
        sc.setPubSysKey("*--------------")
        @Assert(53,sc.toString().toRuneArray().size)
    }

    @TestCase
    func testDocumentType_01_04(): Unit {
        let sc = DocumentType("html", "-//IETF//DTD HTML//", "")
        sc.setPubSysKey("你好仓颉！【】")
        @Assert(45,sc.toString().toRuneArray().size)
    }

    @TestCase
    func testDocumentType_01_05(): Unit {
        let sc = DocumentType("html", "-//IETF//DTD HTML//", "")
        sc.setPubSysKey("Hello Cangjie Lang\n")
        @Assert(57,sc.toString().toRuneArray().size)
    }
}
