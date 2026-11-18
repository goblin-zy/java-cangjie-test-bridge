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
    let ins_1: Elements = Elements()
    let ins_2: Elements = Elements(10)

    @TestCase
    func testElements_unwrap_01(): Unit {
        strRes = ins_2.unwrap().toString()
        @Assert(strRes,"")
        var coll: Collection<Element> = ArrayList<Element>()
        var ArrL_ele: ArrayList<Element> = ArrayList<Element>()
        for (i in 0..num) {
            ArrL_ele.add(Element(Tag.valueOf("span"), "eleURL_\$${i}"))
            ArrL_ele[i].attr("spanKey_\$${i}", "spanVal_\$${i}")
            ArrL_ele[i].attr("&中文&", "@#^%&?")
        }
        coll = ArrL_ele
        let ins_3: Elements = Elements(coll)
        strRes = ins_3.html()
        @Assert(strRes,"")
        try {
            strRes = ins_3.unwrap().html()
        } catch (e1: ValidationException) {
            @Assert(e1.toString().contains("Object must not be null"))
            returnFlag = 0
        }
        @Assert(returnFlag,0)
    }

    @TestCase
    func testElements_unwrap_02(): Unit {
        strRes = ""
        let html_1: String = "<div class=headline> <p attrK1=\"p_1\">Hello</p> <p attrK1=\"p_2\">There</p> </div>"
        let doc: Document = Html4cj.parse(html_1)
        var els_1: Elements = doc.select(".headline").select("p")
        els_1.wrap("<b></b>")
        strRes = doc.body().html()
        @Assert(sourceDataIns.parseString(strRes,false),"<div class=\"headline\"><b><p attrk1=\"p_1\">Hello</p></b> <b><p attrk1=\"p_2\">There</p></b></div>")
        els_1.unwrap()
        strRes = doc.body().html()
        @Assert(sourceDataIns.parseString(strRes,false),"<div class=\"headline\"><b>Hello</b> <b>There</b></div>")
    }

    @TestCase
    func testElements_unwrap_03(): Unit {
        strRes = ""
        let html_1: String = "<div class=headline> <p attrK1=\"p_1\">Hello</p> <p id=\"p_2\">There</p> </div>"
        let doc: Document = Html4cj.parse(html_1)
        var els_1: Elements = doc.select(".headline") //无父节点
        els_1.unwrap()
        strRes = doc.body().html() // 同java
        @Assert(sourceDataIns.parseString(strRes,false),"<p attrk1=\"p_1\">Hello</p><p id=\"p_2\">There</p>")
    }

    @TestCase
    func testElements_unwrap_04(): Unit {
        strRes = ""
        let html_1: String =
            "<div class=headline> <p class=\"p_1\"><b>Hello</b><b>你好</b></p> <p id=\"p_2\">There</p> </div>"
        let doc: Document = Html4cj.parse(html_1)
        var els_1: Elements = doc.select(".headline").select("b")
        els_1.unwrap()
        strRes = doc.body().html()
        @Assert(sourceDataIns.parseString(strRes),"<divclass=\"headline\"><pclass=\"p_1\">Hello你好</p><pid=\"p_2\">There</p></div>")
        try {
            els_1.unwrap() // 同java
            strRes = doc.body().html()
        } catch (e1: ValidationException) {
            @Assert(e1.toString().contains("Object must not be null"))
            returnFlag = 0
        }
        @Assert(returnFlag,0)
    }
}
