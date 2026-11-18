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
    func testElements_before_01(): Unit {
        strRes = ins_1.before("<p>Hello</p>").toString()
        @Assert(strRes,"")
        strRes = ins_2.before("<p>Hello</p>").html()
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
            strRes = ins_3.before("<p>你好呀</p>").html()
        } catch (e1: ValidationException) {
            @Assert(e1.toString().contains("Object must not be null"),true)
        }
        ins_3.html("<p>Hello</p>")
        strRes = ins_3.html()
        @Assert(sourceDataIns.parseString(strRes,true),"<p>Hello</p>")
        try {
            strRes = ins_3.before("<p>你好呀</p>").html()
        } catch (e1: ValidationException) {
            @Assert(e1.toString().contains("Object must not be null"),true)
            returnFlag = 0
        }
        @Assert(returnFlag,0)
    }

    @TestCase
    func testElements_before_02(): Unit {
        strRes = ""
        let html_1: String =
            "<p>Hello</p> <div class=headline> <p attrK1=\"p_1\" style=\"display: ;\">Hello</p> <p id=\"同ID\" attrK1=\"p_2\">There</p> </div>"
        let doc: Document = Html4cj.parse(html_1)
        var els_1: Elements = doc.select(".headline").select("p")
        strRes = els_1.html()
        @Assert(strRes,"Hello\nThere")
        strRes = els_1.before("<p>你好呀</p>").outerHtml()
        @Assert(sourceDataIns.parseString(strRes,false),"<p attrk1=\"p_1\" style=\"display: ;\">Hello</p><p id=\"同ID\" attrk1=\"p_2\">There</p>") //同java
        els_1 = doc.select("p")
        strRes = els_1.before("<p>你好呀</p>").outerHtml()
        @Assert(sourceDataIns.parseString(strRes,false),"<p>Hello</p><p>你好呀</p><p attrk1=\"p_1\" style=\"display: ;\">Hello</p><p>你好呀</p><p id=\"同ID\" attrk1=\"p_2\">There</p>")
        strRes = els_1.before("").html()
        @Assert(sourceDataIns.parseString(strRes,false),"Hello你好呀Hello你好呀There")
        strRes = els_1.before("<span>-120!</span>").outerHtml() //无法再添加前节点，同java
        @Assert(sourceDataIns.parseString(strRes,false),"<p>Hello</p><p>你好呀</p><p attrk1=\"p_1\" style=\"display: ;\">Hello</p><p>你好呀</p><p id=\"同ID\" attrk1=\"p_2\">There</p>")
    }
}
