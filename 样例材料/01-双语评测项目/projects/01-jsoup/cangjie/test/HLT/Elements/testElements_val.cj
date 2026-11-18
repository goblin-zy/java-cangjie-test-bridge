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
    func testElements_val_01(): Unit {
        var coll: Collection<Element> = ArrayList<Element>()
        var ArrL_ele: ArrayList<Element> = ArrayList<Element>()
        for (i in 0..num) {
            ArrL_ele.add(Element(Tag.valueOf("input"), "eleURL_\$${i}"))
            ArrL_ele[i].attr("class", "abs:@?_\$${i}")
        }
        coll = ArrL_ele
        let ins_1: Elements = Elements(coll)
        strRes = ins_1.val()
        @Assert(strRes,"")
        ins_1.val("val_input")
        strRes = ins_1.val()
        @Assert(strRes,"val_input")
        strRes = ins_1[1].toString()
        @Assert(sourceDataIns.parseString(strRes),"<inputclass=\"abs:@?_$1\"value=\"val_input\">")
    }
    @TestCase
    func testElements_val_02(): Unit {
        var coll: Collection<Element> = ArrayList<Element>()
        var ArrL_ele: ArrayList<Element> = ArrayList<Element>()
        for (i in 0..num) {
            ArrL_ele.add(Element(Tag.valueOf("textarea"), "eleURL_\$${i}"))
            ArrL_ele[i].attr("cols", "${20+i}")
        }
        coll = ArrL_ele
        let ins_1: Elements = Elements(coll)
        strRes = ins_1.val()
        @Assert(strRes,"")
        ins_1.val("val_textarea:大家好啊>>^现在开_始干饭^")
        strRes = ins_1.val()
        @Assert(strRes,"val_textarea:大家好啊>>^现在开_始干饭^")
        strRes = ins_1[1].toString()
        @Assert(sourceDataIns.parseString(strRes),"<textareacols=\"21\">val_textarea:大家好啊&gt;&gt;^现在开_始干饭^</textarea>")
        ins_1.val("  ")
        strRes = ins_1.val()
        @Assert(strRes,"")
    }

    @TestCase
    func testElements_val_03(): Unit {
        strRes = ""
        let html_1: String =
            "<p>Hello</p> <div class=headline> <p attrK1=\"p_1\" style=\"display: ;\">Hello</p> <p id=\"同ID\" attrK1=\"p_2\"></p> <p id=\"同ID\" attrK1=\"p_3\">There</p> </div>"
        let doc: Document = Html4cj.parse(html_1)
        let els_1: Elements = doc.select(".headline").select("p")
        strRes = els_1[2].toString()
        @Assert(sourceDataIns.parseString(strRes),"<pid=\"同ID\"attrk1=\"p_3\">There</p>")
        @Assert(els_1.hasAttr("input"),false)
        @Assert(els_1.hasAttr("textarea"),false)
        strRes = els_1.val()
        @Assert(strRes,"")
        els_1.val("val_withoutform:大家好啊^现在开_始干饭?？^")
        strRes = els_1.val()
        @Assert(strRes,"val_withoutform:大家好啊^现在开_始干饭?？^")
        strRes = els_1[2].toString()
        @Assert(sourceDataIns.parseString(strRes),"<pid=\"同ID\"attrk1=\"p_3\"value=\"val_withoutform:大家好啊^现在开_始干饭?？^\">There</p>")
    }
}
