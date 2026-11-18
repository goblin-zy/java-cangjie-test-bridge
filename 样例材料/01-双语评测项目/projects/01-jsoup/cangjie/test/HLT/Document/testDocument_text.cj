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
    func testDocument_text_01(): Unit {
        let ins_1: Document = Document(baseURL[0]) // 空str
        try {
            ins_1.text(" ")
        } catch (e1: IllegalArgumentException) {
            returnFlag = 1
        }
        var ele_1 = ins_1.text(sourceDataIns.arrLStr_Base[4]) //你好仓颉！【】
        strRes = ele_1.toString()
        @Assert(sourceDataIns.parseString(strRes) ,"<html><body>你好仓颉！【】</body></html>")
        strRes = ""
        let ins_2: Document = Document.createShell(baseURL[15]) // https协议，地址可达
        var ele_2: Element = ins_2.text("Hello Cang!@#$%^&*()_+:<>?|jie Lang")
        strRes = ele_2.toString()
        @Assert(sourceDataIns.parseString(strRes),"<html><head></head><body>HelloCang!@#$%^&amp;*()_+:&lt;&gt;?|jieLang</body></html>") //同java
        @Assert(returnFlag , 0)
    }

    @TestCase
    func testDocument_text_02(): Unit {
        strRes = ""
        var html_1: String = sourceDataIns.generateHTMLStr()[3] //  "<head> <meta charset=\"utf-16\"> <title>SoupTest</title> </head> </html>"
        var doc_1: Document = Html4cj.parse(html_1)
        let ele_1 = doc_1.text("\"Cang_jie\"")
        strRes = ele_1.toString()
        @Assert(sourceDataIns.parseString(strRes),"<html><head><metacharset=\"utf-16\"><title>SoupTest</title></head><body>\"Cang_jie\"</body></html>")
        let ele_2 = doc_1.text("转\n义")
        strRes = ele_2.toString()
        @Assert(sourceDataIns.parseString(strRes),"<html><head><metacharset=\"utf-16\"><title>SoupTest</title></head><body>转义</body></html>")
        let ele_3 = doc_1.text("HELLO^_^Cangjie")
        strRes = ele_3.toString()
        @Assert(sourceDataIns.parseString(strRes),"<html><head><metacharset=\"utf-16\"><title>SoupTest</title></head><body>HELLO^_^Cangjie</body></html>")
        let ele_4 = doc_1.text("<-1>")
        strRes = ele_4.toString()
        @Assert(sourceDataIns.parseString(strRes),"<html><head><metacharset=\"utf-16\"><title>SoupTest</title></head><body>&lt;-1&gt;</body></html>")
        let ele_5 = doc_1.text("</(?)>")
        strRes = ele_5.toString()
        @Assert(sourceDataIns.parseString(strRes),"<html><head><metacharset=\"utf-16\"><title>SoupTest</title></head><body>&lt;/(?)&gt;</body></html>")
        let ele_6 = doc_1.text("</    H>")
        strRes = ele_6.toString()
        @Assert(sourceDataIns.parseString(strRes),"<html><head><metacharset=\"utf-16\"><title>SoupTest</title></head><body>&lt;/H&gt;</body></html>")
    }
}
