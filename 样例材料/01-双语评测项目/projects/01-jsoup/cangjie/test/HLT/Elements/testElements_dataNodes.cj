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
        "<div id=1>Text_1 <p>One</p> Text 2 <p>Two <p>Three <p type=\"text\" <span> span_text </span> testElements_dataNodes> </div>"
    var returnFlag: Int64 = -1

    @TestCase
    func testElements_dataNodes_01(): Unit {
        var doc: Document = Html4cj.parse(htmlStr)
        var els_1: Elements = doc.select("div")
        strRes = els_1.outerHtml()
        var ele_Res: ArrayList<DataNode> = els_1.dataNodes()
        @Assert(ele_Res.size,0) // 同java
        htmlStr = "<div id=1><p>One</p> Text 2 <script>script_data</script><noscript> data_noscript</noscript> <p type=\"text\" <span> span_text </span> testElements_dataNodes> <style><b>innerData 你礼貌吗？</b></style> outerData </div>"
        doc = Html4cj.parse(htmlStr)
        els_1 = doc.select("div,p,script,noscript,span,style")
        ele_Res = els_1.dataNodes()
        @Assert(ele_Res.size,2)
        strRes = ele_Res[0].getWholeData()
        @Assert(sourceDataIns.parseString(strRes),"script_data") // 同java
        strRes = ele_Res[0].nodeName()
        @Assert(strRes,"#data")
        strRes = ele_Res[1].getWholeData()
        @Assert(sourceDataIns.parseString(strRes,false),"<b>innerData 你礼貌吗？</b>")
        strRes = ele_Res[1].toString()
        @Assert(sourceDataIns.parseString(strRes,false),"<b>innerData 你礼貌吗？</b>") //同java 不会转义
    }
}
