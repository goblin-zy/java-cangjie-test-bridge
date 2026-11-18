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
    var returnFlag: Int64 = 0
    let root_1: Element = Element(Tag.valueOf("Title"), "https://www.baidu.com/", None)
    let ele_super1: Element = Element(Tag.valueOf("ele_super1"), "https://www.baidu.com/", None)
    let ele_sub1: Element = Element(Tag.valueOf("ele_sub1"), "", None)
    var attrs_2: Attributes = Attributes()
    let ele_sub2: Element = Element(Tag.valueOf("ele_sub2"), "https://www.baidu.com/", attrs_2)
    let ele_sub3: Element = Element(Tag.valueOf("T ag_$1"), None)
    let eleArr: Array<Node> = [root_1, ele_super1, ele_sub1]
    let eleArrL: ArrayList<Node> = ArrayList<Node>([root_1, ele_sub1, ele_sub2, ele_sub3])

    @TestCase
    func testElement_insertChildren_01(): Unit {
        let ele_Root1: Element = Element("ROOT_1")
        @Assert(ele_Root1.attributes().toString(),"")
        @Assert(ele_Root1.childNodeSize(),0)
        var ele_res: Element = Element("res")
        try {
            ele_res = ele_Root1.insertChildren(0, Array<Node>()) // children 为空 无异常
        } catch (e1: IllegalArgumentException) {
            returnFlag = 1
        }
        @Assert(ele_Root1.childNodeSize(),0)
        var eleArrL_2: ArrayList<Node> = ArrayList<Node>()
        for (i in 0..62) {
            eleArrL_2.add(Element(Tag.valueOf("Tag_${i+1}"), "https://www.baidu.com/", None))
        }
        ele_res = ele_Root1.prependChildren(eleArr)
        @Assert(ele_Root1.childNodeSize(),3)
        ele_res = ele_Root1.insertChildren(0, eleArrL_2)
        @Assert(ele_Root1.childNodeSize(),65)
        @Assert(ele_Root1.child(0).normalName(), "tag_1")
        @Assert(ele_res.child(64) == ele_sub1, true)
        @Assert(returnFlag,0)
    }

    @TestCase
    func testElement_insertChildren_02(): Unit {
        let ele_super1: Element = Element(Tag.valueOf("ele_super1"), "https://www.baidu.com/", None)
        let ele_sub1: Element = Element(Tag.valueOf("ele_sub1"), "", None)
        var attrs_2: Attributes = Attributes()
        let ele_sub2: Element = Element(Tag.valueOf("ele_sub2"), "https://www.baidu.com/", attrs_2)
        let ele_sub3: Element = Element(Tag.valueOf("T ag_$1"), None)
        let eleArrL: ArrayList<Node> = ArrayList<Node>([ele_sub2, ele_sub3])
        let ele_Root1: Element = Element("ROOT_1")
        ele_Root1.appendChild(ele_sub1)
        ele_Root1.insertChildren(0, eleArrL)
        @Assert(ele_Root1.childNodeSize(),3)
        @Assert(ele_Root1.child(2).normalName(), "ele_sub1")
        ele_Root1.insertChildren(1, eleArrL)
        @Assert(ele_Root1.childNodeSize(),3)
        ele_sub1.appendChild(ele_super1)
        try {
            ele_sub1.insertChildren(-6, eleArrL)
        } catch (e1: ValidationException) {
            @Assert(e1.toString().contains("Insert position out of bounds."), true)
            returnFlag = 0
        }
        try {
            ele_sub1.insertChildren(6, eleArrL)
        } catch (e1: ValidationException) {
            @Assert(e1.toString().contains("Insert position out of bounds."), true)
            returnFlag = 0
        }
        try {
            ele_sub1.insertChildren(-1, eleArrL)
        } catch (e1: IllegalArgumentException) {
            returnFlag = 1
        }
        @Assert(ele_sub1.childNodeSize(),3)
        @Assert(returnFlag,0)
    }
}
