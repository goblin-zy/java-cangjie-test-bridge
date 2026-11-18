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
    var num: Int64 = 5
    let ins_1: Elements = Elements()
    let ins_2: Elements = Elements(10)

    @TestCase
    func testElements_eachAttr_01(): Unit {
        let arrL_1: ArrayList<String> = ins_1.eachAttr("empty")
        @Assert(arrL_1.size,0)
        let arrL_2: ArrayList<String> = ins_2.eachAttr("empty")
        @Assert(arrL_2.size,0)
        var coll: Collection<Element> = ArrayList<Element>()
        var ArrL_ele: ArrayList<Element> = ArrayList<Element>()
        for (i in 0..num) {
            ArrL_ele.add(Element(Tag.valueOf("span"), "eleURL_\$${i}"))
            ArrL_ele[i].attr("spanKey_\$${i}", "spanVal_\$${i}")
            ArrL_ele[i].attr("Key_same", "spanVal_\$${i}")
            ArrL_ele[i].attr("&中文&", "@#^%&?")
        }
        coll = ArrL_ele
        let ins_3: Elements = Elements(coll)
        let arrL_3: ArrayList<String> = ins_3.eachAttr("spankey_$3")
        @Assert(arrL_3.size,1)
        strRes = arrL_3[0]
        @Assert(strRes,"spanVal_$3")
        var arrL_4: ArrayList<String> = ins_3.eachAttr("Key_same")
        @Assert(arrL_4.size,5)
        strRes = arrL_4[3]
        @Assert(strRes,"spanVal_$3")
        arrL_4 = ins_3.eachAttr("&中文&")
        @Assert(arrL_4.size,5)
        strRes = arrL_4[4]
        @Assert(strRes,"@#^%&?")
        strRes = ins_3[1].toString()
        @Assert(sourceDataIns.parseString(strRes),"<spanspankey_$1=\"spanVal_$1\"key_same=\"spanVal_$1\"&中文&=\"@#^%&amp;?\"></span>")
        @Assert(returnFlag , 0)
    }

    @TestCase
    func testElements_eachAttr_02(): Unit {
        strRes = ""
        var ArrL_ele: ArrayList<Element> = ArrayList<Element>()
        for (i in 0..num) {
            ArrL_ele.add(Element(Tag.valueOf("span"), "eleURL_\$${i}"))
            ArrL_ele[i].attr("spanKey_\$${i}", "spanVal_\$${i}")
            if (i % 2 == 0) {
                ArrL_ele[i].attr("Key_same", "spanVal_\$${i}")
            }
            if (i % 3 == 0) {
                ArrL_ele[i].attr("<=$>", "@#^%&?")
            }
        }
        var coll: Array<Element> = ArrL_ele.toArray()
        let ins_1: Elements = Elements(coll)
        var arrL_1: ArrayList<String> = ins_1.eachAttr("spankey_")
        @Assert(arrL_1.size,0)
        arrL_1 = ins_1.eachAttr("")
        @Assert(arrL_1.size,0)
        arrL_1 = ins_1.eachAttr("KEY_SAME") //多元素含相同属性
        @Assert(arrL_1.size,3)
        for (attr in arrL_1) {
            strRes += attr
        }
        @Assert(strRes,"spanVal_$0spanVal_$2spanVal_$4")
        arrL_1 = ins_1.eachAttr("<=$>")
        @Assert(arrL_1.size,2)
        strRes = ""
        for (attr in arrL_1) {
            strRes += attr
        }
        @Assert(strRes,"@#^%&?@#^%&?")
        arrL_1 = ins_1.eachAttr(" <=$> ")
        @Assert(arrL_1.size,0)
    }

    @TestCase
    func testElements_eachAttr_03(): Unit {
        strRes = ""
        let html_1: String =
            "<p>Hello</p> <div class=headline> <p attrK1=\"p_1\" style=\"display: ;\">Hello</p> <p id=\"同ID\" attrK1=\"p_2\"></p> <p id=\"同ID\" attrK1=\"p_3\">There</p> </div>"
        let doc: Document = Html4cj.parse(html_1)
        let els_1: Elements = doc.select(".headline").select("p")
        @Assert(els_1.eachAttr("class").size,0)
        var arrL_1: ArrayList<String> = els_1.eachAttr("id")
        @Assert(arrL_1.size,2)
        strRes = ""
        for (attr in arrL_1) {
            strRes += attr
        }
        @Assert(strRes,"同ID同ID")
        arrL_1 = els_1.eachAttr("attrk1")
        @Assert(arrL_1.size,3)
        strRes = ""
        for (attr in arrL_1) {
            strRes += attr
        }
        @Assert(strRes,"p_1p_2p_3")
    }
}
