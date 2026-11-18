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
    var htmlStr: String =
        "<div id=1>Text_1 <p>One</p> Text 2 <p>Two <p>Three <p type=\"text\" <span> span_text </span> testElements_textNodes> </div>"
    var returnFlag: Int64 = -1

    @TestCase
    func testElements_textNodes_01(): Unit {
        let doc: Document = Html4cj.parse(htmlStr)
        let els_1: Elements = doc.select("div")
        strRes = els_1.outerHtml()
        var ele_Res: ArrayList<TextNode> = els_1.textNodes()
        @Assert(ele_Res.size,2)
        strRes = ele_Res[0].text()
        @Assert(sourceDataIns.parseString(strRes),"Text_1") // 同java
        strRes = ele_Res[0].nodeName()
        @Assert(strRes,"#text")
        strRes = ele_Res[1].text()
        @Assert(sourceDataIns.parseString(strRes,false),"Text 2")
        strRes = ele_Res[1].toString()
        @Assert(sourceDataIns.parseString(strRes,false),"Text 2")
    }

    @TestCase
    func testElements_textNodes_02(): Unit {
        let doc: Document = Html4cj.parse(htmlStr)
        let els_1: Elements = doc.select("p")
        var ele_Res: ArrayList<TextNode> = els_1.textNodes()
        @Assert(ele_Res.size,4)
        strRes = ele_Res[0].text()
        @Assert(sourceDataIns.parseString(strRes),"One")
        strRes = ele_Res[1].nodeName()
        @Assert(strRes,"#text")
        strRes = ele_Res[2].toString()
        @Assert(strRes,"Three")
        strRes = ele_Res[3].toString()
        @Assert(sourceDataIns.parseString(strRes,false),"testElements_textNodes&gt;")
        var ele_Res2: ArrayList<TextNode> = doc.select("span").textNodes()
        @Assert(ele_Res2.size,1)
        strRes = ele_Res2[0].text()
        @Assert(sourceDataIns.parseString(strRes),"span_text")
        var ele_Res3: ArrayList<TextNode> = doc.select("p[type=\"text\"]").textNodes()
        @Assert(ele_Res3.size,1)
        strRes = ele_Res3[0].text()
        @Assert(sourceDataIns.parseString(strRes,false),"testElements_textNodes>") // 同java
        var ele_Res4: ArrayList<TextNode> = doc.select("p ~ span").textNodes()
        @Assert(ele_Res4.size,0)
    }
}
