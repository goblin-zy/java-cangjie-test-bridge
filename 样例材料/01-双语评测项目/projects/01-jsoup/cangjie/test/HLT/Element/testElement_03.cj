// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

@Test
public class NodeTest {
    @TestCase
    func testElement_03_01(): Unit {
        var tag: Tag = Tag.valueOf("cc")
        var noBase: Element = Element(tag, "")
        let scc = "relHref"
        let scc1 = ##"你好\n"##
        let str = noBase.attr(scc, scc1)
        @Assert(false,noBase!=str)
    }

    @TestCase
    func testElement_03_02(): Unit {
        var tag: Tag = Tag.valueOf("cc")
        var noBase: Element = Element(tag, "")
        let scc = ""
        let scc1 = ##"你好\n"##
        let str = noBase.attr(scc, scc1)
        @Assert(false,noBase!=str)
    }

    @TestCase
    func testElement_03_03(): Unit {
        var tag: Tag = Tag.valueOf("cc")
        var noBase: Element = Element(tag, "")
        let scc = """
                Hello,
                Cangjie Lang
            """
        let scc1 = ##"你好\n"##
        let str = noBase.attr(scc, scc1)
        @Assert(false,noBase!=str)
    }

    @TestCase
    func testElement_03_04(): Unit {
        var tag: Tag = Tag.valueOf("cc")
        var noBase: Element = Element(tag, "")
        let scc = "$%#$@$$"
        let scc1 = ""
        let str = noBase.attr(scc, scc1)
        @Assert(false,noBase!=str)
    }
}
