// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
//dependence:../util_test/createsourcedata.cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

@Test
public class ElementsTest {
    let sourceDataIns: SourceData = SourceData()
    var strRes: String = ""
    var htmlStr: String =
        "<div id='pseudo'> <p><!-- test_1 --></p> <div id='type'> <!-- <span>1</span> --> </div> <<!-- span -->></span> <!-- </div> -->"
    var returnFlag: Int64 = -1

    @TestCase
    func testElements_comments_01(): Unit {
        let doc: Document = Html4cj.parse(htmlStr)
        let els_1: Elements = doc.select("div")
        strRes = els_1.outerHtml()
        var ele_Res: ArrayList<Comment> = els_1.comments()
        @Assert(ele_Res.size,3)
        strRes = ele_Res[0].getData()
        @Assert(sourceDataIns.parseString(strRes),"span") // 同java
        strRes = ele_Res[0].nodeName()
        @Assert(strRes,"#comment")
        strRes = ele_Res[1].getData()
        @Assert(sourceDataIns.parseString(strRes),"</div>")
        strRes = ele_Res[1].toString()
        @Assert(strRes,"<!-- </div> -->")
        strRes = ele_Res[2].getData()
        @Assert(sourceDataIns.parseString(strRes),"<span>1</span>")
    }

    @TestCase
    func testElements_comments_02(): Unit {
        let doc: Document = Html4cj.parse(htmlStr)
        let els_1: Elements = doc.select("p")
        var ele_Res: ArrayList<Comment> = els_1.comments()
        @Assert(ele_Res.size,1)
        strRes = ele_Res[0].getData()
        @Assert(sourceDataIns.parseString(strRes),"test_1") // 同java
        strRes = ele_Res[0].nodeName()
        @Assert(strRes,"#comment")
        strRes = ele_Res[0].toString()
        @Assert(strRes,"<!-- test_1 -->")
        var ele_Res2: ArrayList<Comment> = doc.select("span").comments()
        @Assert(ele_Res2.size,0)
    }
}
