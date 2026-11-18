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
    var returnFlag: Int64 = 0
    var num: Int64 = 3

    @TestCase
    func testElements_removeClass_01(): Unit {
        var coll: Collection<Element> = ArrayList<Element>()
        var ArrL_ele: ArrayList<Element> = ArrayList<Element>()
        for (i in 0..num) {
            ArrL_ele.add(Element(Tag.valueOf("span"), "eleURL_\$${i}"))
            ArrL_ele[i].attr("class", "@#^%?_\$${i}")
        }
        coll = ArrL_ele
        let ins_1: Elements = Elements(coll)
        @Assert(ins_1.hasAttr("class"),true)
        let arrL: ArrayList<String> = ins_1.eachAttr("class")
        for (str in arrL) {
            strRes += str
        }
        @Assert(strRes,"@#^%?_$0@#^%?_$1@#^%?_$2")
        ins_1.addClass("cla_another")
        @Assert(ins_1.hasClass("cla_another"),true)
        strRes = ins_1[1].toString()
        @Assert(sourceDataIns.parseString(strRes),"<spanclass=\"@#^%?_$1cla_another\"></span>")
        ins_1.removeClass("cla_another")
        strRes = ins_1[1].toString()
        @Assert(sourceDataIns.parseString(strRes),"<spanclass=\"@#^%?_$1\"></span>")
        @Assert(ins_1.hasClass("cla_another"),false)
    }

    @TestCase
    func testElements_removeClass_02(): Unit {
        strRes = ""
        let html_1: String =
            "<p>Hello</p> <div class=headline> <p attrK1=\"p_1\" style=\"display: ;\">Hello</p> <p id=\"同ID\" attrK1=\"p_2\"></p> <p id=\"同ID\" attrK1=\"p_3\">There</p> </div>"
        let doc: Document = Html4cj.parse(html_1)
        let els_1: Elements = doc.select(".headline").select("p")
        strRes = els_1[2].toString()
        @Assert(sourceDataIns.parseString(strRes),"<pid=\"同ID\"attrk1=\"p_3\">There</p>")
        els_1.removeClass("cla_another")
        @Assert(els_1.hasClass("cla_another"),false)
        els_1.addClass("class")
        strRes = els_1[2].toString() // 添加class属性后
        @Assert(sourceDataIns.parseString(strRes),"<pid=\"同ID\"attrk1=\"p_3\"class=\"class\">There</p>")
        els_1.removeClass("CLASS") // 区分大小写
        @Assert(els_1.hasClass("class"),true)
        strRes = els_1[2].toString()
        @Assert(sourceDataIns.parseString(strRes),"<pid=\"同ID\"attrk1=\"p_3\"class=\"class\">There</p>")
        els_1.removeClass(" ")
        @Assert(els_1.hasClass(" "),false)
        strRes = els_1[2].toString()
        @Assert(sourceDataIns.parseString(strRes),"<pid=\"同ID\"attrk1=\"p_3\"class=\"class\">There</p>")
    }
}
