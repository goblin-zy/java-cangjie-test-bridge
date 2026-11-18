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
    var returnFlag: Int64 = 0
    var num: Int64 = 3

    @TestCase
    func testElements_toggleClass_01(): Unit {
        var coll: Collection<Element> = ArrayList<Element>()
        var ArrL_ele: ArrayList<Element> = ArrayList<Element>()
        for (i in 0..num) {
            ArrL_ele.add(Element(Tag.valueOf("span"), "eleURL_\$${i}"))
            ArrL_ele[i].attr("class", "abs:@?_\$${i}")
        }
        coll = ArrL_ele
        let ins_1: Elements = Elements(coll)
        @Assert(ins_1.hasAttr("class"),true)
        strRes = ins_1.attr("class")
        @Assert(strRes,"abs:@?_$0")
        ins_1.toggleClass("class") // class不存在
        strRes = ins_1.attr("class")
        @Assert(ins_1.hasClass("abs:@?_$0 class"),true)
        strRes = ins_1[1].toString()
        @Assert(sourceDataIns.parseString(strRes),"<spanclass=\"abs:@?_$1class\"></span>")
    }

    @TestCase
    func testElements_toggleClass_02(): Unit {
        strRes = ""
        let html_1: String =
            "<p>Hello</p> <div class=headline> <p attrK1=\"p_1\" style=\"display: ;\">Hello</p> <p id=\"同ID\" attrK1=\"p_2\"></p> <p id=\"同ID\" attrK1=\"p_3\">There</p> </div>"
        let doc: Document = Html4cj.parse(html_1)
        let els_1: Elements = doc.select(".headline").select("p")
        strRes = els_1[2].toString()
        @Assert(sourceDataIns.parseString(strRes),"<pid=\"同ID\"attrk1=\"p_3\">There</p>")
        @Assert(els_1.hasClass("cla_another"),false)
        els_1.toggleClass("cla_another") // cla_another不存在
        strRes = els_1[2].toString()
        @Assert(sourceDataIns.parseString(strRes),"<pid=\"同ID\"attrk1=\"p_3\"class=\"cla_another\">There</p>")
        els_1.toggleClass("cla_another") // cla_another已存在
        strRes = els_1[2].toString()
        @Assert(sourceDataIns.parseString(strRes),"<pid=\"同ID\"attrk1=\"p_3\">There</p>")
        els_1.toggleClass(" ")
        strRes = els_1[2].toString()
        @Assert(sourceDataIns.parseString(strRes),"<pid=\"同ID\"attrk1=\"p_3\"class=\"\">There</p>")
    }
}
