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
    var htmlStr: String = generateHTMLStr(4)
    var returnFlag: Int64 = -1

    @TestCase
    func testElements_eq_01(): Unit {
        let doc: Document = Html4cj.parse(htmlStr)
        let els_1: Elements = doc.select("div#pseudo").select("p")
        strRes = els_1.outerHtml()
        @Assert(sourceDataIns.parseString(strRes,false),"<p>test_1</p><p>test_2</p><p>test_3</p><p>test_4</p>")
        var ele_Res: Elements = els_1.eq(0)
        strRes = ele_Res.first().getOrThrow().toString()
        @Assert(sourceDataIns.parseString(strRes,false),"<p>test_1</p>")
        strRes = ele_Res.last().getOrThrow().toString()
        @Assert(sourceDataIns.parseString(strRes,false),"<p>test_1</p>")
        strRes = ele_Res.parents()[0].tagName()
        @Assert(sourceDataIns.parseString(strRes,false),"div")
    }

    @TestCase
    func testElements_eq_02(): Unit {
        let doc: Document = Html4cj.parse(htmlStr)
        let els_1: Elements = doc.select("div#type").select("SPAN")
        @Assert(els_1.size,4)
        try {
            var ele_Res: Elements = els_1.eq(-1)
            @Assert(ele_Res.elementArr.size,0)
        } catch (e1: IndexOutOfBoundsException) {
            @Assert(e1.toString().contains("IndexOutOfBoundsException: index: -1, size: 4"))
            returnFlag = 0
        }
        try {
            var ele_Res: Elements = els_1.eq(4)
            @Assert(ele_Res.html(),"")
        } catch (e1: IllegalArgumentException) {
            returnFlag = 1
        }
        try {
            var ele_Res: Elements = els_1.eq(100)
            strRes = ele_Res.outerHtml()
            @Assert(strRes,"")
        } catch (e1: IllegalArgumentException) {
            returnFlag = 2
        }
        @Assert(returnFlag , 0)
    }
}
