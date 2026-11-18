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
    let ins_1: Elements = Elements()
    let ins_2: Elements = Elements(10)

    @TestCase
    func testElements_removeAttr_01(): Unit {
        strRes = ins_1.removeAttr("empty").toString()
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
        @Assert(ins_3.size,3)
        strRes = ins_3.attr("spankey_$2")
        @Assert(strRes,"spanVal_$2")
        ins_3.removeAttr("spankey_$2")
        strRes = ins_3.attr("spankey_$2") //删除之后再次获取
        @Assert(strRes,"")
        @Assert(ins_3.size,3)
        @Assert(ins_3.hasAttr("spankey_$2"),false)
        strRes = ins_3[1].toString()
        @Assert(sourceDataIns.parseString(strRes),"<spanspankey_$1=\"spanVal_$1\"&中文&=\"@#^%&amp;?\"></span>")
    }

    @TestCase
    func testElements_removeAttr_02(): Unit {
        strRes = ""
        let html_1: String =
            "<p>Hello</p> <div class=headline> <p attrK1=\"p_1\" style=\"display: ;\">Hello</p> <p id=\"同ID\" attrK1=\"p_2\"></p> <p id=\"同ID\" attrK1=\"p_3\">There</p> </div>"
        let doc: Document = Html4cj.parse(html_1)
        let els_1: Elements = doc.select(".headline").select("p")
        let resEle: Elements = els_1.removeAttr("attrK1")
        @Assert(resEle == els_1,true)
        @Assert(resEle.size,3)
        let resEle_2: Elements = els_1.removeAttr("")
        @Assert(resEle_2.elementArr.size,3)
        @Assert(resEle != els_1,false)
        @Assert(resEle.size,3)
        els_1.removeAttr("style")
        @Assert(els_1.hasAttr("style"),false)
        strRes = els_1[2].toString()
        @Assert(sourceDataIns.parseString(strRes),"<pid=\"同ID\">There</p>")
    }
}
