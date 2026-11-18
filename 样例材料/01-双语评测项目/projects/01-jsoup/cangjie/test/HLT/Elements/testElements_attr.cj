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
    func testElements_attr_01(): Unit {
        strRes = ins_1.attr("empty")
        @Assert(strRes,"")
        strRes = ins_2.attr("empty")
        @Assert(strRes,"")
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
        strRes = ins_3.attr("spankey_$3")
        @Assert(strRes,"spanVal_$3")
        strRes = ins_3.attr("Key_same") //多元素含相同属性
        @Assert(strRes,"spanVal_$0")
        strRes = ins_3.attr("KEY_saME") //大小写
        @Assert(strRes,"spanVal_$0")
        strRes = ins_3.attr("&中文&") //中文键
        @Assert(strRes,"@#^%&?")
        strRes = ins_3[1].toString()
        @Assert(sourceDataIns.parseString(strRes),"<spanspankey_$1=\"spanVal_$1\"key_same=\"spanVal_$1\"&中文&=\"@#^%&amp;?\"></span>")
        @Assert(returnFlag , 0)
    }

    @TestCase
    func testElements_attr_02(): Unit {
        strRes = ""
        var ArrL_ele: ArrayList<Element> = ArrayList<Element>()
        for (i in 0..num) {
            ArrL_ele.add(Element(Tag.valueOf("span"), "eleURL_\$${i}"))
            ArrL_ele[i].attr("spanKey_\$${i}", "spanVal_\$${i}")
            ArrL_ele[i].attr("Key_same", "spanVal_\$${i}")
            ArrL_ele[i].attr("<$>", "@#^%&?")
        }
        var coll: Array<Element> = ArrL_ele.toArray()
        let ins_3: Elements = Elements(coll)
        strRes = ins_3.attr("spankey_$3")
        @Assert(strRes,"spanVal_$3")
        strRes = ins_3.attr(" ")
        @Assert(strRes,"")
        strRes = ins_3.attr("Key_same") //多元素含相同属性
        @Assert(strRes,"spanVal_$0")
        strRes = ins_3.attr("KEY_SAME") //大小写
        @Assert(strRes,"spanVal_$0")
        strRes = ins_3.attr("&中文&") //中文键
        @Assert(strRes,"")
        strRes = ins_3[4].toString()
        @Assert(sourceDataIns.parseString(strRes),"<spanspankey_$4=\"spanVal_$4\"key_same=\"spanVal_$4\"<$>=\"@#^%&amp;?\"></span>") //同java 属性键不会转义，value会转义
        @Assert(returnFlag , 0)
    }

    @TestCase
    func testElements_attr_03(): Unit {
        strRes = ""
        let html_1: String =
            "<p>Hello</p> <div class=headline> <p attrK1=\"p_1\" style=\"display: ;\">Hello</p> <p id=\"同ID\" attrK1=\"p_2\"></p> <p id=\"同ID\" attrK1=\"p_3\">There</p> </div>"
        let doc: Document = Html4cj.parse(html_1)
        let els_1: Elements = doc.select(".headline").select("p")
        strRes = els_1.attr("class") // 无属性为class
        @Assert(strRes,"")
        strRes = els_1.attr("id")
        @Assert(strRes,"同ID")
        strRes = els_1.attr("attrk1")
        @Assert(strRes,"p_1")
        strRes = els_1.attr("style")
        @Assert(strRes,"display: ;")
        strRes = els_1[2].toString()
        @Assert(sourceDataIns.parseString(strRes),"<pid=\"同ID\"attrk1=\"p_3\">There</p>")
    }
}
