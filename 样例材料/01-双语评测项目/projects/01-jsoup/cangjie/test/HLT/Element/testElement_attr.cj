// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
//dependence:../util_test/createsourcedata.cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

@Test
public class ElementTest {
    let ins_1: Attribute = Attribute("Attribute_K1", "中文值【哈喽！】")
    var strRes: String = ""
    var intRes: Int64 = -1
    let sourceDataIns: SourceData = SourceData()
    let tuple_res: (Array<String>, ArrayList<String>, HashSet<String>) = sourceDataIns.generateSourceDataWithString()
    var returnFlag: Int64 = -1

    @TestCase
    func testElement_attr_01(): Unit {
        let ele_1: Element = Element("STYLE")
        @Assert(ele_1.nodeName(), "STYLE")
        var attrs_1: Attributes = Attributes()
        var ele_res: Element = Element("res")
        ele_res = ele_1.attr(tuple_res[0][1], true) // tuple_res[0][1] ="\"Hello Cangjie Lang\""
        @Assert(ele_res.normalName(), "style")
        attrs_1 = ele_res.attributes()
        @Assert(attrs_1.toString().trimAscii(), "HelloCangjieLang")
        ele_res = ele_1.attr("key_1", "value_1")
        attrs_1 = ele_res.attributes()
        @Assert(attrs_1.toString().trimAscii(), "HelloCangjieLang key_1=\"value_1\"")
        ele_res = ele_1.attr("key_1", true) // 当前键key_1已存在，替换这条属性，其值为None
        attrs_1 = ele_res.attributes()
        @Assert(attrs_1.toString().trimAscii(), "HelloCangjieLang key_1")
        strRes = attrs_1.get("key_1")
        @Assert(strRes, "") // 替换这条属性，其值为None
        ele_res = ele_1.attr("key_1", false) // 删除这条属性
        attrs_1 = ele_res.attributes()
        @Assert(attrs_1.toString(), " HelloCangjieLang")
    }

    @TestCase
    func testElement_attr_02(): Unit {
        let ele_1: Element = Element(Tag.valueOf("Title"), "https://www.baidu.com/", None)
        strRes = ele_1.attributes().toString()
        @Assert(strRes, "")
        var attrs_1: Attributes = Attributes()
        var ele_res: Element = Element("res")
        ele_res = ele_1.attr("中文键_test", true)
        attrs_1 = ele_res.attributes()
        @Assert(attrs_1.toString().trimAscii(), "中文键_test")
        ele_res = ele_1.attr("data-key", true)
        attrs_1 = ele_res.attributes()
        @Assert(attrs_1.toString().trimAscii(), "中文键_test data-key")
        ele_res = ele_1.attr("/-key1", true)
        attrs_1 = ele_res.attributes()
        @Assert(attrs_1.toString().trimAscii(), "中文键_test data-key")
        strRes = ele_res.baseUri()
        @Assert(strRes, "https://www.baidu.com/")
        intRes = ele_res.childNodeSize()
        @Assert(intRes, 0)
    }

    @TestCase
    func testElement_attr_03(): Unit {
        var attrs_1: Attributes = Attributes()
        attrs_1.put("id", "hello")
        attrs_1.put("class", "html")
        attrs_1.put("仓颉", "Cangjie_!")
        let ele_1: Element = Element(Tag.valueOf("Title"), "https://www.baidu.com/", attrs_1)
        strRes = ele_1.attributes().toString()
        @Assert(strRes, " id=\"hello\" class=\"html\" 仓颉=\"Cangjie_!\"")
        var ele_res: Element = Element("res")
        ele_res = ele_1.attr("中文键_test", true)
        attrs_1 = ele_res.attributes()
        @Assert(attrs_1.toString().trimAscii(), "id=\"hello\" class=\"html\" 仓颉=\"Cangjie_!\" 中文键_test")
        ele_res = ele_1.attr("data-key", true)
        attrs_1 = ele_res.attributes()
        @Assert(attrs_1.toString().trimAscii(), "id=\"hello\" class=\"html\" 仓颉=\"Cangjie_!\" 中文键_test data-key")
        ele_res = ele_1.attr("/-key1", true)
        attrs_1 = ele_res.attributes()
        @Assert(attrs_1.toString().trimAscii(), "id=\"hello\" class=\"html\" 仓颉=\"Cangjie_!\" 中文键_test data-key")
    }

    @TestCase
    func testElement_attr_04(): Unit {
        let ele_1: Element = Element(Tag.valueOf("T ag_$1"), None)
        @Assert(ele_1.baseUri(), "")
        @Assert(ele_1.normalName(), "t ag_$1")
        var attrs_1: Attributes = Attributes()
        var ele_res: Element = Element("res")
        ele_res = ele_1.attr("%<#@!>%_test", true)
        attrs_1 = ele_res.attributes()
        @Assert(attrs_1.toString().trimAscii(), "%<#@!>%_test")
        let ele_2: Element = Element(Tag.valueOf("中文T ag\u{4f60}"), "https://www.百度baidu.com/",)
        @Assert(ele_2.baseUri(), "https://www.百度baidu.com/")
        @Assert(ele_2.normalName(), "中文t ag你")
        ele_res = ele_2.attr("【\u{4f60}好>>Cangjie】", true)
        attrs_1 = ele_res.attributes()
        @Assert(attrs_1.toString().trimAscii(), "【你好>>Cangjie】")
    }

    @TestCase
    func testElement_attr_05(): Unit {
        returnFlag = 0
        var attrs_1: Attributes = Attributes()
        var attrs_res: Attributes = Attributes()
        attrs_1.put("id", "hello")
        attrs_1.put("class", "html")
        attrs_1.put("/key", "inner")
        attrs_1.put(" ", "空")
        attrs_1.put("中文键", "你好")
        attrs_1.putData("仓颉", "Cangjie_!")
        let ele_1: Element = Element(Tag.valueOf("Title"), "https://www.baidu.com/", attrs_1)
        attrs_res = ele_1.attributes()
        @Assert(attrs_res.size, 7) // 6+1 含默认的内部属性
        var ele_res: Element = Element("res")
        ele_res = ele_1.removeAttr("中文键")
        attrs_res = ele_res.attributes()
        @Assert(attrs_res.size,6)
        try {
            attrs_res.get("中文键")
        } catch (e1: NoneValueException) {
            @Assert(e1.toString().contains("NoneValueException"), true)
        }
        @Assert(ele_1.attributes().dataSize,1)
        ele_res = ele_1.removeAttr("data-仓颉")
        @Assert(ele_res.attributes().size,5)
        @Assert(ele_1.attributes().dataSize,0)
        ele_res = ele_1.removeAttr(" ")
        @Assert(ele_res.attributes().size,4)
        ele_res = ele_1.removeAttr("/key")
        @Assert(ele_res.attributes().size,3)
        try {
            ele_1.removeAttr("key_不存在")
        } catch (e1: NoneValueException) {
            @Assert(e1.toString().contains("NoneValueException"), true)
            returnFlag = 1
        }
        ele_res = ele_1.clearAttributes()
        @Assert(ele_res.attributes().size,0)
        @Assert(ele_res.attributes().toString(),"")
        var attrs_res2: Attributes = Attributes()
        let ele_2: Element = Element(Tag.valueOf("Title"), "https://", attrs_res2)
        @Assert(ele_2.attributes().toString(),"")
        ele_2.clearAttributes()
        @Assert(returnFlag ,0)
    }
}
