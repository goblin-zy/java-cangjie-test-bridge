// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

@Test
public class NodeTest {
    @TestCase
    func testElement_02_01(): Unit {
        var tag: Tag = Tag.valueOf("cc")
        var attr: Attributes = Attributes()
        attr.put("relHref", "/foo")
        attr.put("absHref", "http://bar/qux")
        var noBase: Element = Element(tag, "", attr)
        let scc = "relHref"
        let str = noBase.id(scc)
        @Assert(false,noBase!=str)
    }

    @TestCase
    func testElement_02_02(): Unit {
        var tag: Tag = Tag.valueOf("cc")
        var noBase: Element = Element(tag, "")
        let scc = "中文值【哈喽！】/"
        let str = noBase.id(scc)
        @Assert(false,noBase!=str)
    }

    @TestCase
    func testElement_02_03(): Unit {
        var tag: Tag = Tag.valueOf("cc")
        var noBase: Element = Element(tag, "")
        let scc = """
                Hello,
                Cangjie Lang
            """
        let str = noBase.id(scc)
        @Assert(false,noBase!=str)
    }

    @TestCase
    func testElement_02_04(): Unit {
        var tag: Tag = Tag.valueOf("cc")
        var noBase: Element = Element(tag, "")
        let scc = ""
        let str = noBase.id(scc)
        @Assert(false,noBase!=str)
    }
}
