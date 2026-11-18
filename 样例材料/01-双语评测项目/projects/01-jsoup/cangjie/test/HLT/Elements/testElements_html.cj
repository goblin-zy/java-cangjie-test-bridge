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
    func testElements_html_01(): Unit {
        strRes = ins_1.html()
        @Assert(strRes,"")
        strRes = ins_2.html()
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
        strRes = ins_3[1].toString()
        @Assert(sourceDataIns.parseString(strRes,false),"<span spankey_$1=\"spanVal_$1\" &中文&=\"@#^%&amp;?\"></span>")
        ins_3.html("<p>Hello</p>")
        strRes = ins_3[1].toString()
        @Assert(sourceDataIns.parseString(strRes,false),"<span spankey_$1=\"spanVal_$1\" &中文&=\"@#^%&amp;?\"><p>Hello</p></span>")
        strRes = ins_3.html()
        @Assert(sourceDataIns.parseString(strRes,true),"<p>Hello</p><p>Hello</p><p>Hello</p>")
        ins_3.html("  ")
        strRes = ins_3[1].toString()
        @Assert(sourceDataIns.parseString(strRes,false),"<span spankey_$1=\"spanVal_$1\" &中文&=\"@#^%&amp;?\"> </span>")
        strRes = ins_3.html()
        @Assert(sourceDataIns.parseString(strRes,true),"")
        ins_3.html("《你\n好》")
        strRes = ins_3[1].toString()
        @Assert(sourceDataIns.parseString(strRes,false),"<span spankey_$1=\"spanVal_$1\" &中文&=\"@#^%&amp;?\">《你 好》</span>")
        strRes = ins_3.html()
        @Assert(sourceDataIns.parseString(strRes,false),"《你 好》《你 好》《你 好》")
    }

    @TestCase
    func testElements_html_02(): Unit {
        strRes = ""
        let html_1: String =
            "<p>Hello</p> <div class=headline> <p attrK1=\"p_1\" style=\"display: ;\">Hello</p> <p id=\"同ID\" attrK1=\"p_2\"></p> <p id=\"同ID\" attrK1=\"p_3\">There</p> </div>"
        let doc: Document = Html4cj.parse(html_1)
        let els_1: Elements = doc.select(".headline").select("p")
        strRes = els_1.html()
        @Assert(strRes,"Hello\n\nThere")
        els_1.html("\"&中文&\">\"@#^%&?\"")
        strRes = els_1[1].toString()
        @Assert(sourceDataIns.parseString(strRes,false),"<p id=\"同ID\" attrk1=\"p_2\">\"&amp;中文&amp;\"&gt;\"@#^%&amp;?\"</p>")
        strRes = els_1.html()
        let els_2: Elements = doc.select("p")
        strRes = els_2.html()
        @Assert(strRes,"Hello\n\"&amp;中文&amp;\"&gt;\"@#^%&amp;?\"\n\"&amp;中文&amp;\"&gt;\"@#^%&amp;?\"\n\"&amp;中文&amp;\"&gt;\"@#^%&amp;?\"")
    }
}
