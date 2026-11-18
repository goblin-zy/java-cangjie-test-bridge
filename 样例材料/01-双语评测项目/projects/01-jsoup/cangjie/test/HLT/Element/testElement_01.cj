// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

@Test
public class NodeTest {
    @TestCase
    func testElement_01_01(): Unit {
        var tag: Tag = Tag.valueOf("cc")
        var attr: Attributes = Attributes()
        attr.put("relHref", "/foo")
        attr.put("absHref", "http://bar/qux")
        var noBase: Element = Element(tag, "", attr)
        let scc = "relHref"
        let str = noBase.tagName(scc)
        @Assert(false,noBase!=str)
    }

    @TestCase
    func testElement_01_02(): Unit {
        var tag: Tag = Tag.valueOf("cc")
        var attr: Attributes = Attributes()
        attr.put("rel", "/foo")
        attr.put("absHref", "http://bar/qux")
        var noBase: Element = Element(tag, "", attr)
        let scc = "中文值【哈喽！】/"
        let str = noBase.tagName(scc)
        @Assert(scc,str.tagName())
    }

    @TestCase
    func testElement_01_03(): Unit {
        var tag: Tag = Tag.valueOf("cc")
        var attr: Attributes = Attributes()
        attr.put("rel", "/foo")
        attr.put("absHref", "http://bar/qux")
        var noBase: Element = Element(tag, "", attr)
        let scc = """
                Hello,
                Cangjie Lang
            """
        let str = noBase.tagName(scc)
        @Assert(false,noBase!=str)
    }

    @TestCase
    func testElement_01_04(): Unit {
        var tag: Tag = Tag.valueOf("cc")
        var attr: Attributes = Attributes()
        attr.put("rel", "/foo")
        attr.put("absHref", "http://bar/qux")
        var noBase: Element = Element(tag, "", attr)
        let scc = "Hello Cang!@#$%^&*()_+:<>?|jie Lang"
        let str = noBase.tagName(scc)
        @Assert(false,noBase!=str)
    }

    @TestCase
    func testElement_01_05(): Unit {
        var tag: Tag = Tag.valueOf("cc")
        var attr: Attributes = Attributes()
        attr.put("rel", "/foo")
        attr.put("absHref", "http://bar/qux")
        var noBase: Element = Element(tag, "", attr)
        let scc = ""
        var returntag = -1
        try {
            noBase.tagName(scc)
        } catch (e: ValidationException) {
            @Assert(e.toString().contains("The 'tagName' parameter must not be empty."), true)
            returntag = 1
        }
        @Assert(1,returntag)
    }
}
