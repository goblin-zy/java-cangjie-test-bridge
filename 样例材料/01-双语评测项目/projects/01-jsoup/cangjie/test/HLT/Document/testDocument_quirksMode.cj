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
    func testDocument_quirksMode_01(): Unit {
        let ins_1: Document = Document(baseURL[0]) // 空str
        strRes = ins_1.quirksMode().toString()
        @Assert(strRes,"noQuirks")
        let ins_2: Document = Document.createShell(baseURL[15]) // https协议，地址可达
        strRes = ins_2.quirksMode().toString()
        @Assert(strRes,"noQuirks")
        ins_2.quirksMode(quirks)
        @Assert(ins_2.quirksMode().toString(),"quirks")
        var html: String =
            "<!DOCTYPE html> <html> <head> <title>文档标题</title> </head> <body> <h1>我的第一个HTML页面</h1> <p>我的第一个段落。</p> </body> </html>"
        var doc: Document = Html4cj.parse(html)
        strRes = doc.quirksMode().toString()
        @Assert(strRes,"noQuirks")
        doc.quirksMode(limitedQuirks)
        @Assert(doc.quirksMode().toString(),"limitedQuirks")
        doc.quirksMode(noQuirks)
        @Assert(doc.quirksMode().toString(),"noQuirks")
    }
}
