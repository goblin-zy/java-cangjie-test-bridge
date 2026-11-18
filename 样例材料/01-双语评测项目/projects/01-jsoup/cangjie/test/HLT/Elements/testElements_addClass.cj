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
    func testElements_addClass_01(): Unit {
        var coll: Collection<Element> = ArrayList<Element>()
        var ArrL_ele: ArrayList<Element> = ArrayList<Element>()
        for (i in 0..num) {
            ArrL_ele.add(Element(Tag.valueOf("span"), "eleURL_\$${i}"))
            ArrL_ele[i].attr("spanKey_\$${i}", "spanVal_\$${i}")
            if (i % 2 == 0) {
                ArrL_ele[i].attr("Key_same", "spanVal_\$${i}")
            }
            ArrL_ele[i].attr("&中文&", "@#^%&?")
            ArrL_ele[i].attr("<$>", "@>=￥?")
        }
        coll = ArrL_ele
        let ins_1: Elements = Elements(coll)
        ins_1.addClass(" ")
        @Assert(ins_1.hasAttr(" "),false)
        @Assert(ins_1.hasAttr("class"),true)
        strRes = ins_1[1].toString()
        @Assert(sourceDataIns.parseString(strRes),"<spanspankey_$1=\"spanVal_$1\"&中文&=\"@#^%&amp;?\"<$>=\"@>=￥?\"class=\"\"></span>") // & 转义 >=不转 同java
        ins_1.addClass("cla_$^>>=")
        strRes = ins_1[1].toString()
        @Assert(sourceDataIns.parseString(strRes),"<spanspankey_$1=\"spanVal_$1\"&中文&=\"@#^%&amp;?\"<$>=\"@>=￥?\"class=\"cla_$^>>=\"></span>")
        ins_1.addClass("多个class连缀")
        strRes = ins_1[1].toString()
        @Assert(sourceDataIns.parseString(strRes),"<spanspankey_$1=\"spanVal_$1\"&中文&=\"@#^%&amp;?\"<$>=\"@>=￥?\"class=\"cla_$^>>=多个class连缀\"></span>")
    }

    @TestCase
    func testElements_addClass_02(): Unit {
        strRes = ""
        let html_1: String =
            "<p>Hello</p> <div class=headline> <p attrK1=\"p_1\" style=\"display: ;\">Hello</p> <p id=\"同ID\" attrK1=\"p_2\"></p> <p id=\"同ID\" attrK1=\"p_3\">There</p> </div>"
        let doc: Document = Html4cj.parse(html_1)
        let els_1: Elements = doc.select(".headline").select("p")
        strRes = els_1[2].toString() 
        @Assert(sourceDataIns.parseString(strRes),"<pid=\"同ID\"attrk1=\"p_3\">There</p>")
        els_1.addClass("class")
        strRes = els_1[2].toString() // 添加class属性后
        @Assert(sourceDataIns.parseString(strRes),"<pid=\"同ID\"attrk1=\"p_3\"class=\"class\">There</p>")
        els_1.addClass(html_1)
        strRes = els_1[2].toString() // 添加class属性为html
        let resStr: String = """
                            <pid=\"同ID\"attrk1=\"p_3\"class=\"class<p>Hello</p><divclass=headline><pattrK1=&quot;p_1&quot;style=&quot;display:;&quot;>Hello</p><pid=&quot;同ID&quot;
                            attrK1=&quot;p_2&quot;></p><pid=&quot;同ID&quot;attrK1=&quot;p_3&quot;>There</p></div>\">There</p>
                            """
        @Assert(sourceDataIns.parseString(strRes),sourceDataIns.parseString(resStr))
    }
}
