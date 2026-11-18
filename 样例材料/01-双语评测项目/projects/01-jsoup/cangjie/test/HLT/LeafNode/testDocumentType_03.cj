// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

@Test
public class ParserTest {
    @TestCase
    func testDocumentType_03_01(): Unit {
        let sc = DocumentType("*-----------", "Hello Cang!@#$%^&*()_+:<>?|jie Lang", "你好仓颉！【】")
        let src = sc.name()
        @Assert(12,src.toString().toRuneArray().size)
    }

    @TestCase
    func testDocumentType_03_02(): Unit {
        let sc = DocumentType("*-----------", "Hello Cang!@#$%^&*()_+:<>?|jie Lang", "你好仓颉！【】")
        let src = sc.publicId()
        @Assert(35,src.toString().toRuneArray().size)
    }

    @TestCase
    func testDocumentType_03_03(): Unit {
        let sc = DocumentType("*-----------", "Hello Cang!@#$%^&*()_+:<>?|jie Lang", "你好仓颉！【】")
        let src = sc.systemId()
        @Assert(7,src.toString().toRuneArray().size)
    }

    @TestCase
    func testDocumentType_03_04(): Unit {
        let sc = DocumentType("*-----------", "Hello Cang!@#$%^&*()_+:<>?|jie Lang", "你好仓颉！【】")
        let src = sc.nodeName()
        @Assert(8,src.toString().toRuneArray().size)
    }
}
