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
    var boolRes: Bool = false
    var returnFlag: Int64 = 0
    var num: Int64 = 5
    let ins_1: Elements = Elements()
    let ins_2: Elements = Elements(10)

    @TestCase
    func testElements_hasAttr_01(): Unit {
        boolRes = ins_1.hasAttr("empty")
        @Assert(boolRes,false)
        boolRes = ins_2.hasAttr("empty")
        @Assert(boolRes,false)
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
        @Assert(ins_3.hasAttr("spankey_$3"),true)
        @Assert(ins_3.hasAttr("spanVal_$3"),false)
        @Assert(ins_3.hasAttr("Key_same"),true)
        @Assert(ins_3.hasAttr("key_same"),true)
        @Assert(ins_3.hasAttr("&中文&"),true)
        strRes = ins_3[1].toString()
        @Assert(sourceDataIns.parseString(strRes),"<spanspankey_$1=\"spanVal_$1\"key_same=\"spanVal_$1\"&中文&=\"@#^%&amp;?\"></span>")
        @Assert(returnFlag , 0)
    }

    @TestCase
    func testElements_hasAttr_02(): Unit {
        strRes = ""
        var ArrL_ele: ArrayList<Element> = ArrayList<Element>()
        for (i in 0..num) {
            ArrL_ele.add(Element(Tag.valueOf("span"), "eleURL_\$${i}"))
            ArrL_ele[i].attr("spanKey_\$${i}", "spanVal_\$${i}")
            ArrL_ele[i].attr("Key_same", "spanVal_\$${i}")
            ArrL_ele[i].attr("<$>", "@#^%&?")
        }
        var coll: Array<Element> = ArrL_ele.toArray()
        let eles_1: Elements = Elements(coll)
        @Assert(eles_1.hasAttr("spankey_$3"),true)
        @Assert(eles_1.hasAttr("KEY_SAME"),true)
        @Assert(eles_1.hasAttr("<$>"),true)
        @Assert(eles_1.hasAttr(""),false)
        @Assert(eles_1.hasAttr("&lt;$&gt;"),false)
        strRes = eles_1[4].toString()
        @Assert(sourceDataIns.parseString(strRes),"<spanspankey_$4=\"spanVal_$4\"key_same=\"spanVal_$4\"<$>=\"@#^%&amp;?\"></span>") //同java 属性键不会转义，value会转义
        @Assert(returnFlag , 0)
    }
}
