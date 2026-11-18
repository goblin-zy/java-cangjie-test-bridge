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
    func testElements_clone_01(): Unit {
        let doc: Document = Html4cj.parse(htmlStr)
        let els_1: Elements = doc.select("div#pseudo")
        var ele_Res: Elements = els_1.clone()
        @Assert(ele_Res == els_1,false) // false
        @Assert(ele_Res != els_1,true)
        strRes = ele_Res[0].child(0).tagName()
        @Assert(strRes,"p")
        strRes = ele_Res[0].child(1).siblingElements().first().getOrThrow().toString()
        @Assert(sourceDataIns.parseString(strRes,false),"<p>test_1</p>")
        htmlStr = "<div id='pseudo'> <p>test_1</p> </div> <div id='type'> <span>1</span> </div>"
        let doc2: Document = Html4cj.parse(htmlStr)
        let els_2: Elements = doc2.select("div#pseudo")
        var ele_Res2: Elements = els_2.clone()
        strRes = ele_Res2.toString()
        @Assert(sourceDataIns.parseString(strRes,false),"<div id=\"pseudo\"> <p>test_1</p></div>")
        strRes = ele_Res2[0].children().first().getOrThrow().toString()
        @Assert(sourceDataIns.parseString(strRes,false),"<p>test_1</p>")
        @Assert(assertOptionNone<Element>(ele_Res2.next().first()),true)
    }
}
