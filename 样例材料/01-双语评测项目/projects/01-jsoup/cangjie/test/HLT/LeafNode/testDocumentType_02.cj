// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

@Test
public class ParserTest {
    @TestCase
    func testDocumentType_02_01(): Unit {
        let sc = DocumentType("html", "-//IETF//DTD HTML//", "")
        let src = sc.name()
        @Assert(4,src.toString().size)
    }

    @TestCase
    func testDocumentType_02_02(): Unit {
        let sc = DocumentType("html", "-//IETF//DTD HTML//", "")
        let src = sc.publicId()
        @Assert(19,src.toString().size)
    }

    @TestCase
    func testDocumentType_02_03(): Unit {
        let sc = DocumentType("html", "-//IETF//DTD HTML//", "")
        let src = sc.systemId()
        @Assert(0,src.toString().size)
    }

    @TestCase
    func testDocumentType_02_04(): Unit {
        let sc = DocumentType("html", "-//IETF//DTD HTML//", "")
        let src = sc.nodeName()
        @Assert(8,src.toString().size)
    }
}
