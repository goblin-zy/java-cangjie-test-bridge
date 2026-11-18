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
    func testDocument_title_01(): Unit {
        let ins_1: Document = Document(baseURL[0]) // 空str
        var title_1: String = ins_1.title()
        @Assert(title_1,"")
        let ins_2: Document = Document.createShell(baseURL[15]) // https协议，地址可达
        var title_2: String = ins_2.title()
        @Assert(title_2,"")
        var html: String =
            "<!DOCTYPE html> <html> <head> <title>文档标题</title> </head> <body> <h1>我的第一个HTML页面</h1> <p>我的第一个段落。</p> </body> </html>"
        var doc: Document = Html4cj.parse(html)
        var title_3: String = doc.title()
        @Assert(title_3,"文档标题")
        doc.title("utf-16")
        title_3 = doc.title()
        @Assert(title_3,"utf-16")
        @Assert(returnFlag , 0)
    }

    @TestCase
    func testDocument_title_02(): Unit {
        var html_1: String = sourceDataIns.generateHTMLStr()[3]
        var doc_1: Document = Html4cj.parse(html_1)
        var title_1: String = doc_1.title()
        @Assert(title_1,"SoupTest")
        doc_1.title(sourceDataIns.arrLStr_Base[14]) //多行str
        title_1 = doc_1.title()
        @Assert(title_1,"插值==>你好仓颉！【】:: Hello, Cangjie Lang")
        var html_2: String = sourceDataIns.generateHTMLStr()[5]
        var doc_2: Document = Html4cj.parse(html_2)
        var title_2: String = doc_2.title()
        @Assert(title_2,"SoupTest")
        doc_2.title("^&%$%#(*&(*&(*&(*&))))")
        title_2 = doc_2.title()
        @Assert(title_2,"^&%$%#(*&(*&(*&(*&))))")
        doc_2.title("   \" \" ")
        title_2 = doc_2.title()
        @Assert(title_2,"\" \"")
    }
}
