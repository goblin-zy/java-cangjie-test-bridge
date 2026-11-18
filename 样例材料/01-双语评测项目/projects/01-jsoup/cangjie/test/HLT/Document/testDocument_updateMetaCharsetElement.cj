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
    var boolRes: Bool = false
    var returnFlag: Int64 = 0

    @TestCase
    func testDocument_updateMetaCharsetElement_01(): Unit {
        let ins_1: Document = Document(baseURL[0]) // 空str
        boolRes = ins_1.updateMetaCharsetElement()
        @Assert(boolRes,false)
        let ins_2: Document = Document.createShell(baseURL[15]) // https协议，地址可达
        boolRes = ins_2.updateMetaCharsetElement()
        @Assert(boolRes,false)
        ins_2.updateMetaCharsetElement(true)
        @Assert(ins_2.updateMetaCharsetElement(),true)
        ins_2.updateMetaCharsetElement(false)
        @Assert(ins_2.updateMetaCharsetElement(),false)
        var html: String =
            "<!DOCTYPE html> <html> <head> <title>文档标题</title> </head> <body> <h1>我的第一个HTML页面</h1> <p>我的第一个段落。</p> </body> </html>"
        var doc: Document = Html4cj.parse(html)
        boolRes = doc.updateMetaCharsetElement()
        @Assert(boolRes,false)
    }
}
