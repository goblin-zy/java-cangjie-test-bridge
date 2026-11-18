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
    func testElements_tagName_01(): Unit {
        strRes = ins_1.tagName("empty").toString()
        @Assert(strRes,"")
        strRes = ins_2.attr("empty").toString()
        @Assert(strRes,"")
        var coll: Collection<Element> = ArrayList<Element>()
        var ArrL_ele: ArrayList<Element> = ArrayList<Element>()
        for (i in 0..num) {
            ArrL_ele.add(Element(Tag.valueOf("span"), "eleURL_\$${i}"))
            ArrL_ele[i].attr("tagName", "tagVal_\$${i}")
            ArrL_ele[i].attr("&中文&", "@#^%&?")
        }
        coll = ArrL_ele
        let ins_3: Elements = Elements(coll)
        strRes = ins_3[1].toString()
        @Assert(sourceDataIns.parseString(strRes),"<spantagname=\"tagVal_$1\"&中文&=\"@#^%&amp;?\"></span>")
        var resEle: Elements = ins_3.tagName("span")
        strRes = resEle[1].toString()
        @Assert(sourceDataIns.parseString(strRes),"<spantagname=\"tagVal_$1\"&中文&=\"@#^%&amp;?\"></span>")
        resEle = ins_3.tagName("Tag_New")
        strRes = resEle[1].toString()
        @Assert(sourceDataIns.parseString(strRes),"<tag_newtagname=\"tagVal_$1\"&中文&=\"@#^%&amp;?\"></tag_new>")
    }

    @TestCase
    func testElements_tagName_02(): Unit {
        strRes = ""
        var ArrL_ele: ArrayList<Element> = ArrayList<Element>()
        for (i in 0..num) {
            ArrL_ele.add(Element(Tag.valueOf("你好"), "eleURL_\$${i}"))
            ArrL_ele[i].attr("class", "cla_\$${i}")
            ArrL_ele[i].attr("<$>", "@#^%&?")
        }
        var coll: Array<Element> = ArrL_ele.toArray()
        let ins_1: Elements = Elements(coll)
        var resEle: Elements = ins_1.tagName("<>")
        strRes = resEle[1].toString()
        @Assert(sourceDataIns.parseString(strRes,false),"<<> class=\"cla_$1\" <$>=\"@#^%&amp;?\"></<>>")
        resEle = ins_1.tagName("KEY_SAME")
        strRes = resEle[1].toString()
        @Assert(sourceDataIns.parseString(strRes,false),"<key_same class=\"cla_$1\" <$>=\"@#^%&amp;?\"></key_same>")
        resEle = ins_1.tagName("@#^%*!?")
        strRes = resEle[1].toString()
        @Assert(sourceDataIns.parseString(strRes,false),"<@#^%*!? class=\"cla_$1\" <$>=\"@#^%&amp;?\"></@#^%*!?>")
    }

    @TestCase
    func testElements_tagName_03(): Unit {
        strRes = ""
        let html_1: String =
            "<p>Hello</p> <div class=headline> <p attrK1=\"p_1\" style=\"display: ;\">Hello</p> <p id=\"同ID\" attrK1=\"p_2\"></p> <p id=\"同ID\" attrK1=\"p_3\">There</p> </div>"
        let doc: Document = Html4cj.parse(html_1)
        let els_1: Elements = doc.select(".headline").select("p")
        @Assert(sourceDataIns.parseString(els_1[1].toString(),false),"<p id=\"同ID\" attrk1=\"p_2\"></p>")
        var resEle: Elements = els_1.tagName("<p>Hello</p>")
        strRes = resEle[1].toString()
        @Assert(sourceDataIns.parseString(strRes,false),"<<p>hello</p> id=\"同ID\" attrk1=\"p_2\"></<p>hello</p>>")
        resEle = els_1.tagName("di\tv")
        strRes = resEle[1].toString()
        @Assert(sourceDataIns.parseString(strRes,true),"<divid=\"同ID\"attrk1=\"p_2\"></div>") //同java
        resEle = els_1.tagName("di\rv")
        strRes = resEle[1].toString()
        @Assert(strRes.toRuneArray().size,35)
        @Assert(strRes.contains("id=\"同ID\" attrk1=\"p_2\">"),true)
        try {
            resEle = els_1.tagName(" ")
            strRes = resEle[1].toString()
        } catch (e1: ValidationException) {
            @Assert(e1.toString().contains("String must not be empty"),true)
            returnFlag = 0
        }
        @Assert(returnFlag,0)
    }
}
