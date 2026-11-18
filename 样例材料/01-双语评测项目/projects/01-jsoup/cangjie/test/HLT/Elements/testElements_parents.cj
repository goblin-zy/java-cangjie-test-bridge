// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
//dependence:../util_test/createsourcedata.cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

@Test
public class ElementsTest {
    let sourceDataIns: SourceData = SourceData()
    let baseURL: ArrayList<String> = sourceDataIns.generateBaseURL()
    var strRes: String = ""
    var htmlStr: String =
        "<html> <head></head> <body> <div id='pseudo'> <p>test_1</p> <div id='type'> <span>1</span> </div> </div> </body> </html>"
    var returnFlag: Int64 = -1

    @TestCase
    func testElements_parents_01(): Unit {
        let doc: Document = Html4cj.parse(htmlStr)
        let els_1: Elements = doc.select("div#pseudo").select("p")
        strRes = els_1.outerHtml()
        @Assert(sourceDataIns.parseString(strRes,false),"<p>test_1</p>")
        var ele_Res: Elements = els_1.parents()
        strRes = ele_Res[0].tagName()
        @Assert(strRes,"div")
        strRes = ele_Res.first().getOrThrow().child(0).text()
        @Assert(sourceDataIns.parseString(strRes,false),"test_1")
        strRes = ele_Res.last().getOrThrow().child(0).outerHtml()
        @Assert(sourceDataIns.parseString(strRes,false),"<head></head>")
        let els_2: Elements = doc.select("BODY")
        strRes = els_2.outerHtml()
        var ele_Res2: Elements = els_2.parents()
        strRes = ele_Res2.first().getOrThrow().child(0).toString()
        @Assert(sourceDataIns.parseString(strRes,false),"<head></head>")
        strRes = ele_Res2.last().getOrThrow().nodeName()
        @Assert(sourceDataIns.parseString(strRes,false),"html")
    }

    @TestCase
    func testElements_parents_02(): Unit {
        let doc: Document = Html4cj.parse(htmlStr)
        let els_1: Elements = doc.select("div#type").select("span")
        var ele_Res: Elements = els_1.parents()
        strRes = ele_Res.first().getOrThrow().id()
        @Assert(sourceDataIns.parseString(strRes,false),"type")
        let els_2: Elements = doc.select("html")
        var ele_Res2: Elements = els_2.parents()
        @Assert(assertOptionNone<Element>(ele_Res2.first()),true)
    }
}
