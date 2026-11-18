// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
//dependence:../util_test/createsourcedata.cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

@Test
public class LeafNodeTest {
    let sourceDataIns: SourceData = SourceData()
    var boolRes: Bool = false
    var strRes: String = ""
    var htmlStr: String =
        "<div id=1>Text_1 <p>One</p> Text 2 <p>Two <p>Three <p type=\"text\" <span> span_text </span> testElements_textNodes> </div>"
    var returnFlag: Int64 = 0

    @TestCase
    func testLeafNode_hasAttr_01(): Unit {
        let doc: Document = Html4cj.parse(htmlStr)
        let els_1: Elements = doc.select("div")
        strRes = els_1.outerHtml()
        var ele_Res: ArrayList<TextNode> = els_1.textNodes()
        @Assert(ele_Res.size,2)
        var node_1: LeafNode = ele_Res[0]
        boolRes = node_1.hasAttr("text")
        @Assert(boolRes,false)
        boolRes = node_1.hasAttr("该属性不存在")
        @Assert(boolRes,false)
        node_1.attr("text", "new Value")
        strRes = node_1.attr("text")
        @Assert(sourceDataIns.parseString(strRes,false),"new Value")
        node_1.attr("该属性不存在", "hello")
        boolRes = node_1.hasAttr("该属性不存在")
        @Assert(boolRes,true)
        node_1.removeAttr("删不掉")
        boolRes = node_1.hasAttr("该属性不存在")
        @Assert(boolRes,true)
        node_1.removeAttr("该属性不存在")
        boolRes = node_1.hasAttr("该属性不存在")
        @Assert(boolRes,false)
    }

    @TestCase
    func testLeafNode_hasAttr_02(): Unit {
        htmlStr = "<div id=1><p>One</p> Text 2 <script>script_data</script><noscript> data_noscript</noscript> <p type=\"text\" <span> span_text </span> testElements_dataNodes> <style><b>innerData 你礼貌吗？</b></style> outerData </div>"
        let doc: Document = Html4cj.parse(htmlStr)
        let els_1: Elements = doc.select("div,p,script,noscript,span,style")
        var ele_Res: ArrayList<DataNode> = els_1.dataNodes()
        @Assert(sourceDataIns.parseString(ele_Res.toString(),false),"[script_data, <b>innerData 你礼貌吗？</b>]")
        var node_1: LeafNode = ele_Res[0]
        try {
            boolRes = node_1.hasAttr(" ")
        } catch (e1: NoneValueException) {
            returnFlag = 1
        }
        node_1.attr("text", "new Value")
        strRes = node_1.attr("text")
        @Assert(sourceDataIns.parseString(strRes,false),"new Value")
        try {
            node_1.removeAttr(" ",)
        } catch (e1: IllegalArgumentException) {
            returnFlag = 2
        }
        node_1.attr("data", "data_attr")
        @Assert(node_1.attributes().size ,3)
        strRes = node_1.attributes().toString()
        @Assert(sourceDataIns.parseString(strRes,false),"#data=\"script_data\" text=\"new Value\" data=\"data_attr\"")
        node_1.empty() // 返回当前实例，不会清空属性
        strRes = node_1.attributes().toString()
        @Assert(sourceDataIns.parseString(strRes,false),"#data=\"script_data\" text=\"new Value\" data=\"data_attr\"")
        @Assert(returnFlag ,0)
    }
}
