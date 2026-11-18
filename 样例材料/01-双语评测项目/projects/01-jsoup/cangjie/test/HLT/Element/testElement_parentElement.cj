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
    var returnFlag: Int64 = -1

    @TestCase
    func testElement_02_01(): Unit {
        let ele_1: Element = Element("STYLE")
        @Assert(ele_1.nodeName(), "STYLE")
        var ele_res: Element = Element("res")
        try {
            ele_res = ele_1.parentElement().getOrThrow()
        } catch (e1: NoneValueException) {
            @Assert(e1.toString().contains("NoneValueException"), true)
            returnFlag = 0
        }
        @Assert(ele_1.root() == ele_1,true)
        var attrs_1: Attributes = Attributes()
        let ele_super1: Element = Element(Tag.valueOf("ele_super1"), "https://www.baidu.com/", None)
        ele_res = ele_super1.appendChild(ele_1)
        attrs_1 = ele_res.attributes()
        @Assert(attrs_1.toString(), "")
        ele_res = ele_1.parentElement().getOrThrow()
        strRes = ele_res.normalName()
        @Assert(strRes, "ele_super1")
        @Assert(ele_res == ele_super1,true)
        let ele_sub1: Element = Element(Tag.valueOf("Title"), "https://www.bai百度du.com/", None)
        var attrs_2: Attributes = Attributes()
        attrs_2.put("id", "hello")
        attrs_2.put("data-key1", "html")
        attrs_2.putData("-仓颉", "Cangjie_!")
        let ele_sub2: Element = Element(Tag.valueOf("ele_sub2"), "https://www.baidu.com/", attrs_1)
        ele_res = ele_1.appendChild(ele_sub1)
        ele_res = ele_1.appendChild(ele_sub2)
        intRes = ele_res.childrenSize()
        @Assert(intRes, 2)
        intRes = ele_1.childNodeSize()
        @Assert(intRes, 2)
        ele_res = ele_1.child(1)
        @Assert(ele_res == ele_sub2,true)
        strRes = ele_res.normalName()
        @Assert(strRes, "ele_sub2")
        ele_res = ele_sub1.parentElement().getOrThrow()
        strRes = ele_res.normalName()
        @Assert(strRes, "style")
        @Assert(returnFlag, 0)
    }

    @TestCase
    func testElement_02_02(): Unit {
        var ele_res: Element = Element("res")
        let ele_1: Element = Element(Tag.valueOf("Title"), "https://www.baidu.com/", None)
        let ele_super1: Element = Element(Tag.valueOf("ele_super1"), "https://www.baidu.com/", None)
        let ele_sub1: Element = Element(Tag.valueOf("ele_sub1"), "", None)
        var attrs_2: Attributes = Attributes()
        attrs_2.put("id", "hello")
        attrs_2.put("key1", "html")
        attrs_2.put("-仓颉", "Cangjie_!")
        let ele_sub2: Element = Element(Tag.valueOf("ele_sub2"), "https://www.baidu.com/", attrs_2)
        let eleIt_1 = ele_sub2.dataset()
        try {
            eleIt_1.next().getOrThrow()
        } catch (e1: NoneValueException) {
            @Assert(e1.toString().contains("NoneValueException"), true)
            returnFlag = 0
        }
        let ele_sub3: Element = Element(Tag.valueOf("T ag_$1"), None)
        ele_1.appendChild(ele_super1)
        @Assert(ele_1.parentElement(), None)
        ele_res = ele_super1.parentElement().getOrThrow()
        strRes = ele_res.normalName()
        @Assert(strRes, "title")
        @Assert(ele_res == ele_1,true)
        @Assert(ele_super1.root() == ele_1,true)
        ele_1.appendChild(ele_sub1)
        ele_1.appendChild(ele_sub2)
        ele_sub2.appendChild(ele_sub3)
        @Assert(ele_sub3.root() == ele_1,true)
        intRes = ele_1.childNodeSize()
        @Assert(intRes, 3)
        @Assert(ele_sub2.childNodeSize(), 1)
        @Assert(ele_sub3.parentElement().getOrThrow() == ele_sub2, true)
        ele_res = ele_sub3.parentElement().getOrThrow().parentElement().getOrThrow()
        strRes = ele_res.normalName()
        @Assert(strRes, "title")
        @Assert(ele_res.baseUri(), "https://www.baidu.com/")
        @Assert(ele_res == ele_1 ,true)
        @Assert(returnFlag, 0)
    }

    @TestCase
    func testElement_02_03(): Unit {
        returnFlag = -1
        strRes = ""
        var ele_res: Element = Element("res")
        let ele_1: Element = Element(Tag.valueOf("Title"), "https://www.baidu.com/", None)
        let ele_super1: Element = Element(Tag.valueOf("ele_super1"), "https://www.baidu.com/", None)
        let ele_sub1: Element = Element(Tag.valueOf("ele_sub1"), "", None)
        var attrs_2: Attributes = Attributes()
        attrs_2.put("id", "hello")
        attrs_2.put("data-key1", "html")
        attrs_2.putData("-仓颉", "Cangjie_!")
        let ele_sub2: Element = Element(Tag.valueOf("ele_sub2"), "https://www.baidu.com/", attrs_2)
        let ele_sub3: Element = Element(Tag.valueOf("T ag_$1"), None)
        let eleIt_1 = ele_sub2.dataset()
        strRes = eleIt_1.next().getOrThrow()[0] // data-key1
        @Assert(strRes, "data-key1")
        ele_1.appendChild(ele_super1)
        ele_1.appendChild(ele_sub1)
        ele_1.appendChild(ele_sub2)
        ele_1.appendChild(ele_sub3)
        @Assert(ele_sub3.root() == ele_1,true)
        intRes = ele_1.childNodeSize()
        @Assert(intRes, 4)
        ele_res = ele_1.child(0)
        @Assert(ele_res == ele_super1,true)
        ele_res = ele_1.child(2)
        @Assert(ele_res == ele_sub2,true)
        @Assert(ele_res.tag().toString(),"ele_sub2")
        try {
            ele_res = ele_1.child(36)
        } catch (e1: IndexOutOfBoundsException) {
            @Assert(e1.toString().contains("IndexOutOfBoundsException: index: 36, size: 4"), true)
        }
        try {
            ele_res = ele_1.child(-1)
        } catch (e1: IndexOutOfBoundsException) {
            @Assert(e1.toString().contains("IndexOutOfBoundsException: index: -1, size: 4"), true)
            returnFlag = 0
        }
        @Assert(returnFlag, 0)
    }

    @TestCase
    func testElement_02_04(): Unit {
        var ele_res: Element = Element("res")
        let ele_1: Element = Element(Tag.valueOf("Title"), "https://www.baidu.com/", None)
        let ele_sub1: Element = Element(Tag.valueOf("ele_sub1"), "", None)
        let ele_sub2: Element = Element(Tag.valueOf("T ag_$1"), None)
        ele_1.appendChild(ele_sub1)
        ele_1.appendChild(ele_sub2)
        intRes = ele_1.childNodeSize()
        @Assert(intRes, 2)
        ele_sub1.appendChild(ele_sub1)
        @Assert(ele_sub2.parentElement().getOrThrow() == ele_1, true)
        ele_sub1.appendChild(ele_sub2)
        @Assert(ele_sub2.parentElement().getOrThrow() == ele_sub1, true)
        ele_res = ele_sub2.appendChild(ele_sub1.parentElement().getOrThrow())
        @Assert(ele_sub2.childNodeSize(), 1)
        @Assert(ele_res.normalName(), "t ag_$1")
    }
}
