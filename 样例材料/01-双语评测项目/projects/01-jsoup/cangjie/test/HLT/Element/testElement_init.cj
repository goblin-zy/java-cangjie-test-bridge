// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

@Test
public class ElementTest {
    let ins_1: Attribute = Attribute("Attribute_K1", "中文值【哈喽！】")
    var strRes: String = ""
    var intRes: Int64 = -1
    var tagArr: Array<String> = ["head", "script", "style", "font", "br", " In Put", "address", "button"]
    var returnFlag: Int64 = -1

    @TestCase
    func testElement_01_01(): Unit {
        let ele_1: Element = Element(tagArr[1])
        @Assert(ele_1.attributes().isEmpty(),false)
        @Assert(ele_1.attributes().size,1) // 1  同java 默认会有一个/baseUri内部属性
        strRes = ele_1.attributes().toString()
        strRes = ele_1.baseUri()
        @Assert(strRes, "")
        intRes = ele_1.childNodeSize()
        @Assert(intRes, 0)
        strRes = ele_1.nodeName()
        @Assert(strRes, "script")
        strRes = ele_1.tagName()
        @Assert(strRes, "script")
        strRes = ele_1.normalName()
        @Assert(strRes, "script")
        strRes = ele_1.tag().toString()
        @Assert(strRes, "script")
        @Assert(ele_1.isBlock(), true)
        strRes = ele_1.id()
        @Assert(strRes, "")
        let ele_2: Element = Element(tagArr[5]) // tag名非规范
        @Assert(ele_2.isBlock(), false)
        @Assert(ele_2.nodeName(), "In Put")
        @Assert(ele_2.tagName(), "In Put")
        @Assert(ele_2.normalName(), "in put")
    }

    @TestCase
    func testElement_01_02(): Unit {
        let ele_1: Element = Element(Tag.valueOf(tagArr[1]), "")
        let ele_2: Element = Element(Tag.valueOf(tagArr[1]).toString())
        strRes = ele_1.attributes().toString()
        strRes = ele_1.baseUri()
        @Assert(strRes, "")
        intRes = ele_1.childNodeSize()
        @Assert(intRes, 0)
        strRes = ele_1.nodeName()
        @Assert(strRes, "script")
        strRes = ele_1.tagName()
        @Assert(strRes, "script")
        strRes = ele_1.normalName()
        @Assert(strRes, "script")
        strRes = ele_1.tag().toString()
        @Assert(strRes, "script")
        @Assert(ele_1.isBlock(), true)
        strRes = ele_1.id()
        @Assert(strRes, "")
        @Assert(ele_1.normalName(), ele_2.normalName())
        @Assert(ele_1 == ele_2, false) // == 比对地址值
        let ele_3: Element = Element(Tag.valueOf(tagArr[5]), "    ") // tag名非规范
        @Assert(ele_3.isBlock(), false)
        @Assert(ele_3.nodeName(), "In Put")
        @Assert(ele_3.tagName(), "In Put")
        @Assert(ele_3.normalName(), "in put")
    }

    @TestCase
    func testElement_01_03(): Unit {
        let attrs_1: Attributes = Attributes()
        attrs_1.put("id", "hello")
        attrs_1.put("class", "html")
        attrs_1.put("仓颉", "Cangjie_!")
        let ele_1: Element = Element(Tag.valueOf("T ag_$1"), "", attrs_1)
        let ele_2: Element = Element(Tag.valueOf(tagArr[7]), " ", Attributes())
        @Assert(ele_1.attributes().size,4)
        strRes = ele_1.attributes().toString()
        @Assert(strRes, " id=\"hello\" class=\"html\" 仓颉=\"Cangjie_!\"")
        strRes = ele_1.baseUri()
        @Assert(strRes, "")
        intRes = ele_1.childNodeSize()
        @Assert(intRes, 0)
        strRes = ele_1.nodeName()
        @Assert(strRes, "T ag_$1")
        strRes = ele_1.tagName()
        @Assert(strRes, "T ag_$1")
        strRes = ele_1.normalName()
        @Assert(strRes, "t ag_$1")
        strRes = ele_1.tag().toString()
        @Assert(strRes, "T ag_$1")
        @Assert(ele_1.isBlock(), false)
        strRes = ele_1.id()
        @Assert(strRes, "hello")
        @Assert(ele_2.id(), "")
        @Assert(ele_1.normalName() != ele_2.normalName() ,true )
        @Assert(ele_1 != ele_2, true)
        let ele_3: Element = Element(Tag.valueOf(tagArr[5]), "https://www.baidu.com/", None)
        @Assert(ele_3.isBlock(), false)
        @Assert(ele_3.normalName(), "in put")
        @Assert(ele_3.baseUri(), "https://www.baidu.com/")
    }

    @TestCase
    func testElement_01_04(): Unit {
        returnFlag = -1
        let attrs_1: Attributes = Attributes()
        attrs_1.put("id", "hello")
        attrs_1.put("class", "html")
        try {
            let ele_1: Element = Element(Tag.valueOf("T ag_$1"), None, attrs_1)
            @Assert(ele_1.baseUri(), "")
            @Assert(ele_1.id(), "hello")
        } catch (e1: IllegalArgumentException) {
            returnFlag = 1
        }
        try {
            Element(Tag.valueOf(" "), "https://www.baidu.com/", attrs_1)
        } catch (e2: ValidationException) {
            @Assert(e2.toString().contains("String must not be empty"), true)
            returnFlag = 0
        }
        try {
            let ele_3: Element = Element(Tag.valueOf("中文T ag"), None, None)
            @Assert(ele_3.baseUri(), "")
            @Assert(ele_3.id(), "")
            @Assert(ele_3.normalName(), "中文t ag")
        } catch (e3: IllegalArgumentException) {
            returnFlag = 2
        }
        @Assert(returnFlag ,0)
    }

    @TestCase
    func testElement_01_05(): Unit {
        returnFlag = -1
        try {
            let ele_1: Element = Element(Tag.valueOf("T ag_$1"), None)
            @Assert(ele_1.baseUri(), "")
            @Assert(ele_1.id(), "")
            @Assert(ele_1.normalName(), "t ag_$1")
        } catch (e1: IllegalArgumentException) {
            returnFlag = 1
        }
        try {
            Element(Tag.valueOf(" "), "https://www.baidu.com/")
        } catch (e2: ValidationException) {
            @Assert(e2.toString().contains("String must not be empty"), true)
            returnFlag = 0
        }
        try {
            let ele_3: Element = Element(Tag.valueOf("中文T ag\u{4f60}"), "https://www.百度baidu.com/",)
            @Assert(ele_3.baseUri(), "https://www.百度baidu.com/")
            @Assert(ele_3.id(), "")
            @Assert(ele_3.normalName(), "中文t ag你")
        } catch (e3: IllegalArgumentException) {
            returnFlag = 2
        }
        @Assert(returnFlag ,0)
    }
}
