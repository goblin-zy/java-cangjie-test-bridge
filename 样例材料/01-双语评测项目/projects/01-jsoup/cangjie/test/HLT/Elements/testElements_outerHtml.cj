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
    var num: Int64 = 1
    let ins_1: Elements = Elements()
    let ins_2: Elements = Elements(10)

    @TestCase
    func testElements_outerHtml_01(): Unit {
        strRes = ins_1.outerHtml()
        @Assert(strRes,"")
        strRes = ins_2.outerHtml()
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
        strRes = ins_3.outerHtml()
        @Assert(sourceDataIns.parseString(strRes,false),"<span spankey_$0=\"spanVal_$0\" &中文&=\"@#^%&amp;?\"></span>")
        @Assert(strRes == ins_3.toString(),true)
        ins_3.html("<p>Hello</p>")
        strRes = ins_3.html()
        @Assert(sourceDataIns.parseString(strRes,true),"<p>Hello</p>")
        strRes = ins_3.outerHtml()
        @Assert(sourceDataIns.parseString(strRes,false),"<span spankey_$0=\"spanVal_$0\" &中文&=\"@#^%&amp;?\"><p>Hello</p></span>")
    }

    @TestCase
    func testElements_outerHtml_02(): Unit {
        strRes = ""
        let html_1: String =
            "<p>Hello</p> <div class=headline> <p attrK1=\"p_1\" style=\"display: ;\">Hello</p> <p id=\"同ID\" attrK1=\"p_2\">There</p> </div>"
        let doc: Document = Html4cj.parse(html_1)
        let els_1: Elements = doc.select(".headline").select("p")
        let str1: String = els_1.toString()
        strRes = els_1.html()
        @Assert(strRes,"Hello\nThere")
        strRes = els_1.outerHtml()
        @Assert(strRes == str1,true)
        els_1.html("\"&中文&\">\"@#^%&?\"")
        strRes = els_1.outerHtml()
        @Assert(sourceDataIns.parseString(strRes,false),"<p attrk1=\"p_1\" style=\"display: ;\">\"&amp;中文&amp;\"&gt;\"@#^%&amp;?\"</p><p id=\"同ID\" attrk1=\"p_2\">\"&amp;中文&amp;\"&gt;\"@#^%&amp;?\"</p>")
    }
}
