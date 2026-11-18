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

    @TestCase
    func testElement_appendChildren_01(): Unit {
        let ele_Root1: Element = Element("ROOT_1")
        @Assert(ele_Root1.attributes().toString(),"")
        @Assert(ele_Root1.childNodeSize(),0)
        var ele_res: Element = Element("res")
        ele_res = ele_Root1.appendChildren(Array<Node>()) // children 为空 无异常，同java
        @Assert(ele_Root1.childNodeSize(),0)
        var eleArrL_2: ArrayList<Node> = ArrayList<Node>()
        for (i in 0..81) {
            eleArrL_2.add(Element(Tag.valueOf("Tag_${i+1}"), "https://www.baidu.com/", None))
        }
        ele_res = ele_Root1.appendChildren(eleArrL_2)
        @Assert(ele_Root1.childNodeSize(),81)
        @Assert(eleArrL_2[eleArrL_2.size -2].normalName(), "tag_${eleArrL_2.size -1}")
        @Assert(returnFlag,0)
    }

    @TestCase
    func testElement_appendChildren_02(): Unit {
        let ele_super1: Element = Element(Tag.valueOf("ele_super1"), "https://www.baidu.com/", None)
        let ele_sub1: Element = Element(Tag.valueOf("ele_sub1"), "", None)
        var attrs_2: Attributes = Attributes()
        let ele_sub2: Element = Element(Tag.valueOf("ele_sub2"), "https://www.baidu.com/", attrs_2)
        let ele_sub3: Element = Element(Tag.valueOf("T ag_$1"), None)
        let eleArr: Array<Node> = [root_1, ele_super1, ele_sub1]
        let eleArr2: Array<Node> = [ele_sub3, ele_sub3, ele_sub3]
        let ele_Root1: Element = Element("ROOT_1")
        @Assert(ele_Root1.attributes().toString(),"")
        @Assert(ele_Root1.childNodeSize(),0)
        ele_Root1.appendChildren(eleArr)
        @Assert(ele_Root1.childNodeSize(),3)
        ele_super1.appendChild(ele_sub1)
        @Assert(ele_super1.childNodeSize(),1)
        @Assert(ele_super1.child(0) == ele_sub1 ,true )
        ele_super1.appendChild(ele_sub1)
        @Assert(ele_super1.childNodeSize(),1)
        try {
            ele_super1.appendChildren(eleArr) // 异常，同java
        } catch (e1: IndexOutOfBoundsException) {
            @Assert(e1.toString().contains("IndexOutOfBoundsException: index: 1, size: 0"), true)
        }
        try {
            ele_sub1.appendChildren(eleArr2) //批量添加相同节点 异常，同java
        } catch (e1: IndexOutOfBoundsException) {
            @Assert(e1.toString().contains("IndexOutOfBoundsException: index: 0, size: 0"), true)
            returnFlag = 0
        }
        ele_sub1.appendChild(ele_sub2) //当前为子节点
        @Assert(ele_sub1.childNodeSize(),1)
        try {
            ele_sub1.appendChildren(ArrayList<Node>()) // children 为空 无异常，同java
        } catch (e1: IllegalArgumentException) {
            returnFlag = 1
        }

        try {
            ele_sub3.appendChildren(HashSet<Node>()) // children 为空 无异常，同java
        } catch (e1: IllegalArgumentException) {
            returnFlag = 2
        }
        @Assert(returnFlag,0)
    }
}
