// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

@Test
public class NodeTest {
    @TestCase
    func testNode_01_01(): Unit {
        var tag: Tag = Tag.valueOf("a")
        var attr: Attributes = Attributes()
        attr.put("relHref", "/foo")
        attr.put("absHref", "http://bar/qux")
        var noBase: Element = Element(tag, "", attr)
        let ele_1 = noBase.nodeName()
        let ele_2 = noBase.normalName()
        @Assert(ele_1,"a")
        @Assert(ele_2,"a")
    }

    @TestCase
    func testNode_01_02(): Unit {
        var tag: Tag = Tag.valueOf("cc")
        var attr: Attributes = Attributes()
        attr.put("relHref", "/foo")
        attr.put("absHref", "http://bar/qux")
        var noBase: Element = Element(tag, "", attr)
        let ele_1 = noBase.nodeName()
        let ele_2 = noBase.normalName()
        @Assert(ele_1,"cc")
        @Assert(ele_2,"cc")
    }

    @TestCase
    func testNode_01_03(): Unit {
        var tag: Tag = Tag.valueOf("cc")
        var attr: Attributes = Attributes()
        attr.put("relHref", "/foo")
        attr.put("absHref", "http://bar/qux")
        var noBase: Element = Element(tag, "", attr)
        let ele_1 = noBase.hasParent()
        @Assert(ele_1,false)
    }

    @TestCase
    func testNode_01_04(): Unit {
        var orphan: Element = Element("span").text("Hello!")
        var wrapped: Element = orphan.wrap("<div></div> There!")
        @Assert(orphan, wrapped)
        let ele_1 = orphan.hasParent()
        @Assert(ele_1,true)
    }
}
