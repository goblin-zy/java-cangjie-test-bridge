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
    func testElements_wrap_01(): Unit {
        strRes = ins_2.wrap("<p></p>").toString()
        @Assert(strRes,"") //同java
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
        strRes = ins_3.wrap("<p></p>").html()
        @Assert(strRes,"")
        ins_3.html("<p>Hello</p>")
        strRes = ins_3.wrap("<div></div>").outerHtml()
        @Assert(sourceDataIns.parseString(strRes,false),"<span spankey_$0=\"spanVal_$0\" &中文&=\"@#^%&amp;?\"><p>Hello</p></span>") //同java
        @Assert(returnFlag,0)
    }

    @TestCase
    func testElements_wrap_02(): Unit {
        strRes = ""
        let html_1: String =
            "<p>Hello</p> <div class=headline> <p attrK1=\"p_1\">Hello</p> <p attrK1=\"p_2\">There</p> </div>"
        let doc: Document = Html4cj.parse(html_1)
        var els_1: Elements = doc.select(".headline").select("p")
        strRes = els_1.html()
        @Assert(strRes,"Hello\nThere")
        strRes = els_1.wrap("<b></b>").outerHtml()
        @Assert(sourceDataIns.parseString(strRes,false),"<p attrk1=\"p_1\">Hello</p><p attrk1=\"p_2\">There</p>") //同java
        strRes = doc.select("b").toString()
        @Assert(sourceDataIns.parseString(strRes,false),"<b><p attrk1=\"p_1\">Hello</p></b><b><p attrk1=\"p_2\">There</p></b>")
        strRes = doc.body().html()
        @Assert(sourceDataIns.parseString(strRes,false),"<p>Hello</p><div class=\"headline\"><b><p attrk1=\"p_1\">Hello</p></b> <b><p attrk1=\"p_2\">There</p></b></div>")
    }

    @TestCase
    func testElements_wrap_03(): Unit {
        strRes = ""
        let html_1: String =
            "<p>Hello</p> <div class=headline> <p attrK1=\"p_1\">Hello</p> <p attrK1=\"p_2\">There</p> </div>"
        let doc: Document = Html4cj.parse(html_1)
        var els_1: Elements = doc.select(".headline").select("p")
        els_1.wrap("<B>")
        strRes = doc.select("b").toString()
        @Assert(sourceDataIns.parseString(strRes,false),"<b><p attrk1=\"p_1\">Hello</p></b><b><p attrk1=\"p_2\">There</p></b>")
        strRes = doc.body().html()
        @Assert(sourceDataIns.parseString(strRes,false),"<p>Hello</p><div class=\"headline\"><b><p attrk1=\"p_1\">Hello</p></b> <b><p attrk1=\"p_2\">There</p></b></div>")
        els_1.wrap("<Span>") // 二次设置
        strRes = doc.body().html()
        @Assert(sourceDataIns.parseString(strRes,false),"<p>Hello</p><div class=\"headline\"><b><span><p attrk1=\"p_1\">Hello</p></span></b> <b><span><p attrk1=\"p_2\">There</p></span></b></div>")
    }

    @TestCase
    func testElements_wrap_04(): Unit {
        strRes = ""
        let html_1: String = "<div class=headline> <p attrK1=\"p_1\">Hello</p> <p attrK1=\"p_2\">There</p> </div>"
        let doc: Document = Html4cj.parse(html_1)
        var els_1: Elements = doc.select(".headline").select("p")
        try {
            els_1.wrap("</B>")
            strRes = doc.select("b").toString()
        } catch (e1: IndexOutOfBoundsException) {
            @Assert(e1.toString().contains("IndexOutOfBoundsException: index: 0, size: 0"))
            returnFlag = 0
        }
        els_1.wrap("<Span>cangjie")
        strRes = doc.body().html()
        @Assert(sourceDataIns.parseString(strRes),"<divclass=\"headline\"><span>cangjie<pattrk1=\"p_1\">Hello</p></span><span>cangjie<pattrk1=\"p_2\">There</p></span></div>")
        @Assert(returnFlag,0)
    }

    @TestCase
    func testElements_wrap_05(): Unit {
        strRes = ""
        let html_1: String = "<div class=headline> <p attrK1=\"p_1\">Hello</p> <p id=\"p_2\">There</p> </div>"
        let doc: Document = Html4cj.parse(html_1)
        var els_1: Elements = doc.select("#p_2")
        try {
            els_1.wrap("")
            strRes = doc.body().html()
        } catch (e1: ValidationException) {
            @Assert(e1.toString().contains("String must not be empty"))
            returnFlag = 0
        }
        els_1.wrap("<span id=\"sp_1\"><i>go</i></span>")
        strRes = doc.body().html()
        @Assert(sourceDataIns.parseString(strRes,false),"<div class=\"headline\"> <p attrk1=\"p_1\">Hello</p><span id=\"sp_1\"><i>go<p id=\"p_2\">There</p></i></span></div>")
        @Assert(returnFlag,0)
    }
}
