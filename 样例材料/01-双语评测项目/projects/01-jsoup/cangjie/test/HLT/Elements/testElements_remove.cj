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
    var returnFlag: Int64 = -1
    var num: Int64 = 2

    @TestCase
    func testElements_remove_01(): Unit {
        var coll: Collection<Element> = ArrayList<Element>()
        var ArrL_ele: ArrayList<Element> = ArrayList<Element>()
        for (i in 0..num) {
            ArrL_ele.add(Element(Tag.valueOf("span"), "eleURL_\$${i}"))
            ArrL_ele[i].attr("Key_same", "spanVal_\$${i}")
            ArrL_ele[i].attr("&中文&", "@#^%&?")
        }
        coll = ArrL_ele
        let ins_3: Elements = Elements(coll)
        strRes = ins_3.html()
        @Assert(strRes,"")
        try {
            ins_3.remove()
            strRes = ins_3.toString()
        } catch (e1: ValidationException) {
            @Assert(e1.toString().contains("Object must not be null"))
            returnFlag = 0
        }
        @Assert(returnFlag , 0)
    }

    @TestCase
    func testElements_remove_02(): Unit {
        strRes = ""
        let html_1: String =
            "<div class=headline> <p class=\"p_1\"><b>Hello</b><b>你好</b></p> <p id=\"p_2\">There</p> </div>"
        let doc: Document = Html4cj.parse(html_1)
        var els_1: Elements = doc.select(".headline").select("b")
        els_1.remove()
        strRes = doc.body().html() // 同java
        @Assert(sourceDataIns.parseString(strRes,false),"<div class=\"headline\"> <p class=\"p_1\"></p> <p id=\"p_2\">There</p></div>")
        els_1 = doc.select(".p_1")
        els_1.remove()
        strRes = doc.body().html()
        @Assert(sourceDataIns.parseString(strRes,false),"<div class=\"headline\"> <p id=\"p_2\">There</p></div>")
        els_1 = doc.select(".headline")
        els_1.remove()
        strRes = doc.body().html()
        @Assert(sourceDataIns.parseString(strRes,false),"")
    }
}
