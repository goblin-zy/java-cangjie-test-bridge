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
    func testDocument_head_01(): Unit {
        let ins_1: Document = Document(baseURL[0]) // 空str
        var head_1: Element = ins_1.head()
        @Assert(head_1.toString(),"<head></head>")
        let ins_2: Document = Document.createShell(baseURL[15]) // https协议，地址可达
        var head_2: Element = ins_2.head()
        @Assert(head_2.toString(),"<head></head>")
        var html: String =
            "<!DOCTYPE html> <html> <head> <title>文档标题</title> </head> <body> <h1>我的第一个HTML页面</h1> <p>我的第一个段落。</p> </body> </html>"
        var doc: Document = Html4cj.parse(html)
        var head_3: Element = doc.head()
        strRes = head_3.toString()
        @Assert(sourceDataIns.parseString(strRes),"<head><title>文档标题</title></head>")
    }

    @TestCase
    func testDocument_head_02(): Unit {
        var html_1: String = sourceDataIns.generateHTMLStr()[5] // head后标签不封闭
        var doc_1: Document = Html4cj.parse(html_1)
        var head_1: Element = doc_1.head()
        strRes = head_1.toString()
        @Assert(sourceDataIns.parseString(strRes),"<head><metacharset=\"ASCII\"><title>SoupTest</title></head>")
        var html_2: String = sourceDataIns.generateHTMLStr()[6] // head前标签不封闭
        var doc_2: Document = Html4cj.parse(html_2)
        var head_2: Element = doc_2.head()
        strRes = head_2.toString()
        @Assert(sourceDataIns.parseString(strRes),"<head><metacharset=\"utf-8\"><title>SoupTest</title></head>")
    }

    @TestCase
    func testDocument_head_03(): Unit {
        var html_1: String =
            "<!DOCTYPE html> <html> <HEAD> <P ID=\"ID_P\"> <SPAN CLASS=\"CLA_1\"> HELLO </SPAN> </P> </HEAD> </html>" // 全大写
        var doc_1: Document = Html4cj.parse(html_1)
        var head_1: Element = doc_1.head()
        strRes = head_1.toString() // <head></head>
        @Assert(sourceDataIns.parseString(strRes),"<head></head>") //html语法有效，soup获得头信息为空，同java
        var html_2: String = sourceDataIns.generateHTMLStr()[10] // 不符合html语法
        var doc_2: Document = Html4cj.parse(html_2)
        var head_2: Element = doc_2.head()
        strRes = head_2.toString()
        @Assert(sourceDataIns.parseString(strRes),"<head></head>")
    }
}
