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
    var returnFlag: Int64 = 0

    @TestCase
    func testDocument_outputSettings_01(): Unit {
        let ins_1: Document = Document(baseURL[0]) // 空str
        strRes = ins_1.outputSettings().charset()
        @Assert(strRes,"UTF-8")
        let ins_2: Document = Document.createShell(baseURL[15]) // https协议，地址可达
        strRes = ins_2.outputSettings().charset()
        @Assert(strRes,"UTF-8")
        ins_2.outputSettings(DocumentOutputSettings())
        @Assert(ins_2.outputSettings().syntax().toString(),"htmlSyntax")
        var html: String =
            "<!DOCTYPE html> <html> <head> <title>文档标题</title> </head> <body> <h1>我的第一个HTML页面</h1> <p>我的第一个段落。</p> </body> </html>"
        var doc: Document = Html4cj.parse(html)
        strRes = doc.outputSettings().charset()
        @Assert(strRes,"UTF-8")
        let documentOutputSettings: DocumentOutputSettings = DocumentOutputSettings().syntax(Syntax.xmlSyntax)
        doc.outputSettings(documentOutputSettings)
        @Assert(doc.outputSettings().syntax().toString(),"xmlSyntax")
    }
}
