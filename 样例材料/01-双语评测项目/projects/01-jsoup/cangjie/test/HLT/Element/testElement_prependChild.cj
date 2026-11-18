// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
//dependence:../util_test/createsourcedata.cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

@Test
public class ElementTest {
    var strRes: String = ""
    var intRes: Int64 = -1
    let sourceDataIns: SourceData = SourceData()
    let root_1: Element = Element(Tag.valueOf("Title"), "https://www.baidu.com/", None)
    let ele_super1: Element = Element(Tag.valueOf("ele_super1"), "https://www.baidu.com/", None)
    let ele_sub1: Element = Element(Tag.valueOf("ele_sub1"), "", None)
    var attrs_2: Attributes = Attributes()
    let ele_sub2: Element = Element(Tag.valueOf("ele_sub2"), "https://www.baidu.com/", attrs_2)
    let ele_sub3: Element = Element(Tag.valueOf("T ag_$1"), None)

    @TestCase
    func testElement_prependChild_01(): Unit {
        let ele_Root1: Element = Element("ROOT_1")
        @Assert(ele_Root1.attributes().toString(),"")
        @Assert(ele_Root1.childNodeSize(),0)
        var ele_res: Element = Element("res")
        ele_res = ele_Root1.empty()
        @Assert(ele_res.childNodeSize(),0)
        ele_res = ele_Root1.prependChild(ele_Root1)
        @Assert(ele_Root1.childNodeSize(),1)
        @Assert(ele_Root1.child(0).normalName(),"root_1")
        ele_res = root_1.prependChild(ele_sub1)
        @Assert(ele_res.normalName(),"title")
        @Assert(ele_res.childNodeSize(),1)
        ele_super1.appendChild(ele_sub1)
        ele_res = ele_super1.prependChild(ele_sub2)
        @Assert(ele_res.normalName(),"ele_super1")
        @Assert(ele_res.childNodeSize(),2)
        ele_res = ele_super1.prependChild(ele_sub1)
        @Assert(ele_res.childNodeSize(),2)
        ele_res = ele_super1.empty()
        @Assert(ele_res.childNodeSize(),0)
        ele_sub1.prependChild(ele_sub3)
        @Assert(ele_sub3.parentElement().getOrThrow() == ele_sub1,true)
        @Assert(ele_sub1.childNodeSize(),1)
    }
}
