// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

@Test
public class NodeTest {
    @TestCase
    func testNode_04_01(): Unit {
        var tag: Tag = Tag.valueOf("div")
        var noBase: Element = Element(tag, "")
        noBase.attr("foo", "bar")
        @Assert(2, noBase.attributesSize())
    }

    @TestCase
    func testNode_04_02(): Unit {
        var tag: Tag = Tag.valueOf("div")
        var noBase: Element = Element(tag, "")
        noBase.attr("FOO", "bw")
        noBase.attr("中文", "bq")
        noBase.attr("￥%", "qw")
        noBase.attr("/n", "qa")
        noBase.attr("", "b")
        noBase.attr("data-", "cc")
        noBase.attr("/666", "dd")
        @Assert(8, noBase.attributesSize())
    }

    @TestCase
    func testNode_04_03(): Unit {
        var tag: Tag = Tag.valueOf("div")
        var noBase: Element = Element(tag, "")
        noBase.attr("FOO", "DE")
        noBase.attr("中文", "￥")
        noBase.attr("￥%", "中文")
        noBase.attr("/n/", "qa")
        noBase.attr("", "b")
        noBase.attr("data-", "/n")
        noBase.attr("/666", "")
        noBase.attr("/n", "")
        @Assert(9, noBase.attributesSize())
    }

    @TestCase
    func testNode_04_04(): Unit {
        var tag: Tag = Tag.valueOf("div")
        var noBase: Element = Element(tag, "")
        noBase.attr("FOO", "DE")
        noBase.attr("中文", "￥")
        noBase.attr("￥%", "中文")
        noBase.attr("/n/", "qa")
        noBase.attr("", "b")
        noBase.attr("data-", "/n")
        noBase.attr("/666", "")
        noBase.attr("/n", "")
        noBase.attr("abs:666", "")

        @Assert(true, noBase.hasAttr("FOO"))
        @Assert(true, noBase.hasAttr("abs:666"))
        @Assert(true, noBase.hasAttr("￥%"))
        @Assert(true, noBase.hasAttr("中文"))
        @Assert(true, noBase.hasAttr(""))
        @Assert(false, noBase.hasAttr("CSS"))
    }

    @TestCase
    func testNode_04_05(): Unit {
        var tag: Tag = Tag.valueOf("div")
        var noBase: Element = Element(tag, "")
        noBase.attr("FOO", "DE")
        noBase.attr("中文", "￥")
        noBase.attr("￥%", "中文")
        noBase.attr("/n/", "qa")
        noBase.attr("", "b")
        noBase.attr("data-", "/n")
        noBase.attr("/666", "")
        noBase.attr("/n", "")
        noBase.attr("abs:666", "")
        @Assert(10, noBase.attributesSize())
        noBase.removeAttr("FOO")
        @Assert(9, noBase.attributesSize())
        noBase.removeAttr("abs:666")
        @Assert(8, noBase.attributesSize())
        noBase.removeAttr("￥%")
        @Assert(7, noBase.attributesSize())
        noBase.removeAttr("中文")
        @Assert(6, noBase.attributesSize())
        noBase.removeAttr("")
        @Assert(5, noBase.attributesSize())
        noBase.removeAttr("999")
        @Assert(5, noBase.attributesSize())
    }
}
