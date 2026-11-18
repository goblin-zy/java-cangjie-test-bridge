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
    var num: Int64 = 1

    @TestCase
    func testElements_select_01(): Unit {
        var coll: Collection<Element> = ArrayList<Element>()
        var ArrL_ele: ArrayList<Element> = ArrayList<Element>()
        for (i in 0..num) {
            ArrL_ele.add(Element(Tag.valueOf("span"), "eleURL_\$${i}"))
            ArrL_ele[i].attr("Key_same", "spanVal_\$${i}")
            ArrL_ele[i].attr("&中文&", "@#^%&?")
        }
        coll = ArrL_ele
        let ins_3: Elements = Elements(coll)
        var ele_Res: Elements = ins_3.select("span")
        strRes = ele_Res.toString()
        @Assert(sourceDataIns.parseString(strRes,false),"<span key_same=\"spanVal_$0\" &中文&=\"@#^%&amp;?\"></span>")
        ele_Res = ins_3.select("SPAN")
        strRes = ele_Res.toString()
        @Assert(sourceDataIns.parseString(strRes,false),"<span key_same=\"spanVal_$0\" &中文&=\"@#^%&amp;?\"></span>")
        try {
            let ele_Res2 = ins_3.select(" ")
            strRes = ele_Res2.toString()
        } catch (e1: SelectorParseException) {
            @Assert(e1.toString().contains("Could not parse query '': unexpected token at ''"))
            returnFlag = 0
        }
        @Assert(returnFlag , 0)
    }

    @TestCase
    func testElements_select_02(): Unit {
        strRes = ""
        let html_1: String =
            "<div class=headline> <p class=\"p_1\"><b>Hello</b><b>你好</b></p> <p id=\"p_2\">There</p> </div>"
        let doc: Document = Html4cj.parse(html_1)
        let els_1: Elements = doc.select(".headline")
        var ele_Res: Elements = els_1.select("b")
        strRes = ele_Res.outerHtml()
        @Assert(sourceDataIns.parseString(strRes,false),"<b>Hello</b><b>你好</b>")
        ele_Res = els_1.select(".p_1")
        strRes = ele_Res.outerHtml()
        @Assert(sourceDataIns.parseString(strRes,false),"<p class=\"p_1\"><b>Hello</b><b>你好</b></p>")
        ele_Res = els_1.select("p#p_2")
        strRes = ele_Res.outerHtml()
        @Assert(sourceDataIns.parseString(strRes,false),"<p id=\"p_2\">There</p>")
        ele_Res = els_1.select("div[class]")
        strRes = ele_Res.outerHtml()
        @Assert(sourceDataIns.parseString(strRes,false),"<div class=\"headline\"> <p class=\"p_1\"><b>Hello</b><b>你好</b></p> <p id=\"p_2\">There</p></div>")
        ele_Res = els_1.select("p[id=\"p_2\"]")
        strRes = ele_Res.outerHtml()
        @Assert(sourceDataIns.parseString(strRes,false),"<p id=\"p_2\">There</p>")
        ele_Res = els_1.select("p > b")
        strRes = ele_Res.outerHtml()
        @Assert(sourceDataIns.parseString(strRes,false),"<b>Hello</b><b>你好</b>")
        try {
            ele_Res = els_1.select("$仓颉$") //不存在
            strRes = ele_Res.outerHtml()
        } catch (e1: SelectorParseException) {
            @Assert(e1.toString().contains("Could not parse query '$仓颉$': unexpected token at '$仓颉$'"))
            returnFlag = 0
        }
        @Assert(returnFlag , 0)
    }
}
