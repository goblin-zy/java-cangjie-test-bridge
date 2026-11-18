// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
//dependence:../util_test/createsourcedata.cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

@Test
public class DocumentTest {
    let sourceDataIns: SourceData = SourceData()
    let baseURL: ArrayList<String> = sourceDataIns.generateBaseURL()
    var strRes: String = ""

    @TestCase
    func testDocument_documentType_01(): Unit {
        let ins_1: Document = Document(baseURL[0]) // 空str
        var documentType_1: ?DocumentType = ins_1.documentType()
        @Assert(assertOptionNone<DocumentType>(documentType_1),true)
        var documentType_2: ?DocumentType = ins_1.documentType()
        try {
            documentType_2.getOrThrow()
        } catch (e1: NoneValueException) {
            @Assert(e1.toString(), "NoneValueException")
        }
        var html: String = "<!-- comment -->  <!doctype html><p>One</p>"
        var doc: Document = Html4cj.parse(html)
        var documentType_3: DocumentType = doc.documentType().getOrThrow()
        strRes = documentType_3.name()
        @Assert("html", strRes)
    }
}
