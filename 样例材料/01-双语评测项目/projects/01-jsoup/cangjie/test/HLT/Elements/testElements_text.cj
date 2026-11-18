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
    var num: Int64 = 3
    let ins_1: Elements = Elements()
    let ins_2: Elements = Elements(10)

    @TestCase
    func testElements_text_01(): Unit {
        strRes = ins_1.text()
        @Assert(strRes,"")
        strRes = ins_2.text()
        @Assert(strRes,"")
        var coll: Collection<Element> = ArrayList<Element>()
        var ArrL_ele: ArrayList<Element> = ArrayList<Element>()
        for (i in 0..num) {
            ArrL_ele.add(Element(Tag.valueOf("span"), "eleURL_\$${i}"))
            ArrL_ele[i].attr("VAL", "tagVal_\$${i}")
            ArrL_ele[i].attr("&中文&", "@#^%&?")
        }
        coll = ArrL_ele
        let ins_3: Elements = Elements(coll)
        @Assert(ins_3.hasText(),false)
        strRes = ins_3.text()
        @Assert(strRes,"")
        ins_3.attr("textVal", "<div class=headline> hello 此昂仓 </div>")
        strRes = ins_3.text()
        @Assert(ins_3.hasText(),false)
    }

    @TestCase
    func testElements_text_02(): Unit {
        strRes = ""
        let html_1: String =
            "<p>Hello</p> <div class=headline> <p attrK1=\"p_1\" style=\"display: ;\">Hello%*#仓颉%</p> <p id=\"同ID\" attrK1=\"p_2\"></p> <p id=\"同ID\" attrK1=\"p_3\">【<|=12|>】</p> </div>"
        let doc: Document = Html4cj.parse(html_1)
        let els_1: Elements = doc.select(".headline").select("p")
        @Assert(sourceDataIns.parseString(els_1[1].toString(),false),"<p id=\"同ID\" attrk1=\"p_2\"></p>")
        @Assert(els_1.hasText(),true)
        strRes = els_1.text()
        @Assert(strRes,"Hello%*#仓颉%  【<|=12|>】")
        els_1.attr("textVal", "<div class=headline> hello 此昂仓 </div>")
        strRes = els_1.text()
        @Assert(els_1.hasText(),true)
        @Assert(strRes,"Hello%*#仓颉%  【<|=12|>】")
    }

    @TestCase
    func testElements_text_03(): Unit {
        strRes = ""
        let html_1: String =
            "<p>Hello</p> <div class=headline> <p attrK1=\"p_1\">   \r </p> <p>   \\t </p> <p>  \n</p> </div>"
        let doc: Document = Html4cj.parse(html_1)
        let els_1: Elements = doc.select(".headline").select("p")
        @Assert(els_1.hasText(),true)
        strRes = els_1.text()
        @Assert(strRes,"\\t ")
        @Assert(strRes.toRuneArray().size,3)
        let els_2: Elements = doc.select("p")
        @Assert(els_2.hasText(),true)
        strRes = els_2.text()
        @Assert(strRes,"Hello  \\t ")
        @Assert(strRes.toRuneArray().size,10)
    }
}
