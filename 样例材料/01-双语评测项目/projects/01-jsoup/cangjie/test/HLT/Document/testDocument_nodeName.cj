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
    func testDocument_nodeName_01(): Unit {
        let ins_1: Document = Document(baseURL[0]) // 空str
        strRes = ins_1.nodeName()
        @Assert(strRes,"#document")
        let ins_2: Document = Document.createShell(baseURL[15]) // https协议，地址可达
        strRes = ins_2.nodeName()
        @Assert(strRes,"#document")
        var html: String =
            "<!DOCTYPE html> <html> <head> <title>文档标题</title> </head> <body> <h1>我的第一个HTML页面</h1> <p>我的第一个段落。</p> </body> </html>"
        var doc: Document = Html4cj.parse(html)
        strRes = doc.nodeName()
        @Assert(strRes,"#document")
        strRes = doc.outerHtml()
        @Assert(sourceDataIns.parseString(strRes),"<!doctypehtml><html><head><title>文档标题</title></head><body><h1>我的第一个HTML页面</h1><p>我的第一个段落。</p></body></html>")
    }

    @TestCase
    func testDocument_nodeName_02(): Unit {
        strRes = ""
        var html_1: String = sourceDataIns.generateHTMLStr()[3]
        var doc_1: Document = Html4cj.parse(html_1)
        strRes = doc_1.nodeName()
        @Assert(strRes,"#document")
        strRes = doc_1.outerHtml()
        @Assert(sourceDataIns.parseString(strRes),"<html><head><metacharset=\"utf-16\"><title>SoupTest</title></head><body></body></html>")
        let ele_1 = doc_1.text("HELLO^_^Cangjie")
        strRes = ele_1.toString()
        @Assert(sourceDataIns.parseString(strRes),"<html><head><metacharset=\"utf-16\"><title>SoupTest</title></head><body>HELLO^_^Cangjie</body></html>")
        strRes = doc_1.outerHtml()
        @Assert(sourceDataIns.parseString(strRes),"<html><head><metacharset=\"utf-16\"><title>SoupTest</title></head><body>HELLO^_^Cangjie</body></html>")
    }
}
