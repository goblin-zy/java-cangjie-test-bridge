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
    func testDocument_charset_01(): Unit {
        let ins_1: Document = Document(baseURL[0]) // 空str
        var charset_1: String = ins_1.charset()
        @Assert(charset_1,"UTF-8")
        let ins_2: Document = Document.createShell(baseURL[15]) // https协议，地址可达
        var charset_2: String = ins_2.charset()
        @Assert(charset_2,"UTF-8")
        var html: String =
            "<!DOCTYPE html> <html> <head> <title>文档标题</title> </head> <body> <h1>我的第一个HTML页面</h1> <p>我的第一个段落。</p> </body> </html>"
        var doc: Document = Html4cj.parse(html)
        var charset_3: String = doc.charset()
        @Assert(charset_3,"UTF-8")
        doc.charset("utf-16")
        charset_3 = doc.charset()
        @Assert(charset_3,"UTF-8")
        @Assert(returnFlag , 0)
    }

    @TestCase
    func testDocument_charset_02(): Unit {
        var html_1: String = sourceDataIns.generateHTMLStr()[3] 
        var doc_1: Document = Html4cj.parse(html_1)
        var charset_1: String = doc_1.charset()
        @Assert(charset_1,"UTF-8")
        doc_1.charset("中文")
        charset_1 = doc_1.charset()
        @Assert(charset_1,"UTF-8")
        var html_2: String = sourceDataIns.generateHTMLStr()[5] 
        var doc_2: Document = Html4cj.parse(html_2)
        var charset_2: String = doc_2.charset()
        @Assert(charset_2,"UTF-8") // 同Java
        doc_2.charset("^&%$%#(*&(*&(*&(*&))))")
        charset_2 = doc_2.charset()
        @Assert(charset_2,"UTF-8")
    }
}
