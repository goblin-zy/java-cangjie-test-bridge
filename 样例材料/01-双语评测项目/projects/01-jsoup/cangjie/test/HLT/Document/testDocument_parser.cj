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
    var boolRes: Bool = false

    @TestCase
    func testDocument_parser_01(): Unit {
        let ins_1: Document = Document(baseURL[0]) // 空str
        boolRes = ins_1.parser().isTrackPosition()
        @Assert(boolRes,false)
        let ins_2: Document = Document.createShell(baseURL[15]) // https协议，地址可达
        boolRes = ins_2.parser().isTrackPosition()
        @Assert(boolRes,false)
        ins_2.parser(Parser.xmlParser())
        @Assert(ins_2.parser().isTrackPosition(),false)
        var html: String =
            "<!DOCTYPE html> <html> <head> <title>文档标题</title> </head> <body> <h1>我的第一个HTML页面</h1> <p>我的第一个段落。</p> </body> </html>"
        var doc: Document = Html4cj.parse(html)
        boolRes = doc.parser().isTrackPosition()
        @Assert(boolRes,false)
        doc.parser(Parser.xmlParser())
        @Assert(doc.parser().isTrackPosition(),false)
        let doc2: Document = doc.parser(Parser.xmlParser())
        @Assert(doc2.nodeName(),"#document")
    }
}
