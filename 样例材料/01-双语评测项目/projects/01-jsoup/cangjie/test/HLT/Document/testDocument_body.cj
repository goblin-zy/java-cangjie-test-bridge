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
    func testDocument_body_01(): Unit {
        let ins_1: Document = Document(baseURL[0]) // 空str
        var body_1: Element = ins_1.body()
        @Assert(body_1.toString(),"<body></body>")
        let ins_2: Document = Document.createShell(baseURL[15]) // https协议，地址可达
        var body_2: Element = ins_2.body()
        @Assert(body_2.toString(),"<body></body>")
        var html: String =
            "<!DOCTYPE html> <html> <head> <title>文档标题</title> </head> <body> <h1>我的第一个HTML页面</h1> <p>我的第一个段落。</p> </body> </html>"
        var doc: Document = Html4cj.parse(html)
        var body_3: Element = doc.body()
        strRes = body_3.toString()
        @Assert(sourceDataIns.parseString(strRes),"<body><h1>我的第一个HTML页面</h1><p>我的第一个段落。</p></body>")
        @Assert(returnFlag , 0)
    }

    @TestCase
    func testDocument_body_02(): Unit {
        var html_1: String = sourceDataIns.generateHTMLStr()[7] // body后标签不封闭
        var doc_1: Document = Html4cj.parse(html_1)
        var body_1: Element = doc_1.body()
        strRes = body_1.toString()
        @Assert(sourceDataIns.parseString(strRes),"<body><pid=\"id_P\"><spanclass=\"cla_1\">hello</span></p></body>")
        var html_2: String = sourceDataIns.generateHTMLStr()[8] // body前标签不封闭
        var doc_2: Document = Html4cj.parse(html_2)
        var body_2: Element = doc_2.body()
        strRes = body_2.toString()
        @Assert(sourceDataIns.parseString(strRes),"<body><pid=\"id_P\"><spanclass=\"cla_1\">hello</span></p></body>")
    }

    @TestCase
    func testDocument_body_03(): Unit {
        strRes = ""
        var html_1: String = sourceDataIns.generateHTMLStr()[14] // 标签含大小写
        var doc_1: Document = Html4cj.parse(html_1)
        var body_1: Element = doc_1.body()
        strRes = body_1.toString()
        @Assert(sourceDataIns.parseString(strRes),"<body><pid=\"id_p\"><spanclass=\"cla_1\">hello</span></p></body>")
        var html_2: String = sourceDataIns.generateHTMLStr()[15] // 无效标签 <body> <输入type=\"text\"> <范围> 打我呀 </范围> </body>
        var doc_2: Document = Html4cj.parse(html_2)
        var body_2: Element = doc_2.body()
        strRes = body_2.toString() // 
        @Assert(sourceDataIns.parseString(strRes),"<body>&lt;输入type=\"text\"&gt;&lt;范围&gt;打我呀<!--/范围--></body>")
    }
}
