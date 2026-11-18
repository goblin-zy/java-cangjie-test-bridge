// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

@Test
public class NodeTest {
    @TestCase
    func testNode_03_01(): Unit {
        var tag: Tag = Tag.valueOf("cc")
        var attr: Attributes = Attributes()
        attr.put("relHref", "/foo")
        attr.put("absHref", "http://bar/qux")
        var noBase: Element = Element(tag, "", attr)
        let str = noBase.attributes().get("relHref")
        @Assert(str,"/foo")
    }

    @TestCase
    func testNode_03_02(): Unit {
        var tag: Tag = Tag.valueOf("cc")
        var attr: Attributes = Attributes()
        attr.put("rel", "/foo")
        attr.put("absHref", "http://bar/qux")
        var noBase: Element = Element(tag, "", attr)
        let str = noBase.attributes().get("REL")
        @Assert(str,"")
    }

    @TestCase
    func testNode_03_03(): Unit {
        var tag: Tag = Tag.valueOf("cc")
        var attr: Attributes = Attributes()
        attr.put("rels", "中文值【哈喽！】/")
        attr.put("absHref", "http://bar/qux")
        var noBase: Element = Element(tag, "", attr)
        let str = noBase.attributes().get("rels")
        @Assert(str,"中文值【哈喽！】/")
    }

    @TestCase
    func testNode_03_04(): Unit {
        var tag: Tag = Tag.valueOf("cc")
        var attr: Attributes = Attributes()
        attr.put("rels", "中文值【哈喽！】/")
        attr.put("absHref", "http://bar/qux")
        var noBase: Element = Element(tag, "", attr)
        let str = noBase.attributes().get("")
        @Assert(str,"")
    }

    @TestCase
    func testNode_03_05(): Unit {
        var tag: Tag = Tag.valueOf("cc")
        var attr: Attributes = Attributes()
        attr.put("rels", "中文值【哈喽！】/")
        attr.put("absHref", "http://bar/qux")
        var noBase: Element = Element(tag, "", attr)
        let str = noBase.attributesSize()
        @Assert(str,3)
    }

    @TestCase
    func testNode_03_06(): Unit {
        var tag: Tag = Tag.valueOf("cc")
        var attr: Attributes = Attributes()
        var noBase: Element = Element(tag, "", attr)
        let str = noBase.attributesSize()
        @Assert(str,1)
    }

    @TestCase
    func testNode_03_07(): Unit {
        var doc = Html4cj.parse("<p></p>")
        var p = doc.selectFirst("p").getOrThrow()
        let str = p.attributesSize()
        @Assert(str,0)
    }
}
