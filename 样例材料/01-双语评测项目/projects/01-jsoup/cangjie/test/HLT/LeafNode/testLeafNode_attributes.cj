// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
//dependence:../util_test/createsourcedata.cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

@Test
public class LeafNodeTest {
    let sourceDataIns: SourceData = SourceData()
    var strRes: String = ""
    var htmlStr: String =
        "<div id=1>Text_1 <p>One</p> Text 2 <p>Two <p>Three <p type=\"text\" <span> span_text </span> testElements_textNodes> </div>"

    @TestCase
    func testLeafNode_attributes_01(): Unit {
        let doc: Document = Html4cj.parse(htmlStr)
        let els_1: Elements = doc.select("div")
        strRes = els_1.outerHtml()
        var ele_Res: ArrayList<TextNode> = els_1.textNodes()
        @Assert(ele_Res.size,2)
        var node_1: LeafNode = ele_Res[0]
        var attrs: Attributes = node_1.attributes()
        strRes = attrs.toString()
        @Assert(sourceDataIns.parseString(strRes),"#text=\"Text_1\"") // 同java
    }

    @TestCase
    func testElements_textNodes_02(): Unit {
        htmlStr = "<div id=1><p>One</p> Text 2 <script>script_data</script><noscript> data_noscript</noscript> <p type=\"text\" <span> span_text </span> testElements_dataNodes> <style><b>innerData 你礼貌吗？</b></style> outerData </div>"
        let doc: Document = Html4cj.parse(htmlStr)
        let els_1: Elements = doc.select("div,p,script,noscript,span,style")
        var ele_Res: ArrayList<DataNode> = els_1.dataNodes()
        @Assert(sourceDataIns.parseString(ele_Res.toString(),false),"[script_data, <b>innerData 你礼貌吗？</b>]")
        var node_1: LeafNode = ele_Res[0]
        var attrs: Attributes = node_1.attributes()
        strRes = attrs.toString()
        @Assert(sourceDataIns.parseString(strRes,false),"#data=\"script_data\"")
    }
}
