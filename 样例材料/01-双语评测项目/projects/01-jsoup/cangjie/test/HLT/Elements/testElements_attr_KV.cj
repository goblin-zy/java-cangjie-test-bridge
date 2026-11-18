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
    var num: Int64 = 3
    let ins_1: Elements = Elements()
    let ins_2: Elements = Elements(10)

    @TestCase
    func testElements_attr_KV_01(): Unit {
        strRes = ins_1.attr("attrK_1", "attrV_1").toString()
        @Assert(strRes,"")
        @Assert(ins_1.size,0)
        strRes = ins_2.attr("&中文&", "@#^%&?").toString()
        @Assert(strRes,"")
        @Assert(ins_2.size,0)
        var coll: Collection<Element> = ArrayList<Element>()
        var ArrL_ele: ArrayList<Element> = ArrayList<Element>()
        for (i in 0..num) {
            ArrL_ele.add(Element(Tag.valueOf("span"), "eleURL_\$${i}"))
        }
        coll = ArrL_ele
        let ins_3: Elements = Elements(coll)
        strRes = ins_3.attr("Key_same", "属性值也相同").toString()
        @Assert(sourceDataIns.parseString(strRes),"<spankey_same=\"属性值也相同\"></span><spankey_same=\"属性值也相同\"></span><spankey_same=\"属性值也相同\"></span>")
        strRes = ins_3.attr("KEY_SAME", "属性键含大小写").toString()
        @Assert(sourceDataIns.parseString(strRes),"<spankey_same=\"属性键含大小写\"></span><spankey_same=\"属性键含大小写\"></span><spankey_same=\"属性键含大小写\"></span>")
    }

    @TestCase
    func testElements_attr_KV_02(): Unit {
        strRes = ""
        var ArrL_ele: ArrayList<Element> = ArrayList<Element>()
        for (i in 0..num) {
            ArrL_ele.add(Element(Tag.valueOf("div_${i}"), "eleURL_\$${i}"))
        }
        var coll: Array<Element> = ArrL_ele.toArray()
        let ins_3: Elements = Elements(coll)
        ins_3.attr("abs:", "=><_$^")
        ins_3.attr("@#\r^%\n&?", "属性键转义")
        ins_3.attr("<$>", "<div class=headline>")
        strRes = ins_3.last().getOrThrow().toString()
        @Assert(sourceDataIns.parseString(strRes),"<div_2abs:=\"=><_$^\"@#^%&?=\"属性键转义\"<$>=\"<divclass=headline>\"></div_2>")
        strRes = ins_3.first().getOrThrow().toString()
        @Assert(sourceDataIns.parseString(strRes),"<div_0abs:=\"=><_$^\"@#^%&?=\"属性键转义\"<$>=\"<divclass=headline>\"></div_0>")
    }

    @TestCase
    func testElements_attr_KV_03(): Unit {
        strRes = ""
        let html_1: String = "<p>Hello</p> <div class=headline> <p class = \"cla\">Hello</p> <p></p> <p>There</p> </div>"
        let doc: Document = Html4cj.parse(html_1)
        let els_1: Elements = doc.select(".headline").select("p")
        strRes = els_1.first().getOrThrow().toString()
        @Assert(sourceDataIns.parseString(strRes),"<pclass=\"cla\">Hello</p>")
        els_1.attr("id", "同ID")
        strRes = els_1.first().getOrThrow().toString()
        @Assert(sourceDataIns.parseString(strRes),"<pclass=\"cla\"id=\"同ID\">Hello</p>")
    }
}
