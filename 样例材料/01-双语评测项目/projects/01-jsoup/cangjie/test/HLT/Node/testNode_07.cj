// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

@Test
public class NodeTest {
    @TestCase
    func testNode_07_01(): Unit {
        var returntag = -1
        var doc = Html4cj.parse("<a id=1 href='/foo'>One</a> <a id=2 href='https://jsoup.org/'>Two</a>")
        var str = doc.select("#2").first().getOrThrow()
        let sc = str.childNodes()
        @Assert(1,sc.size)
        try {
            str.childNode(-3)
        } catch (e: IndexOutOfBoundsException) {
            @Assert(e.toString().contains("IndexOutOfBoundsException"), true)
            returntag = 1
        }
        @Assert(1,returntag)
        try {
            str.childNode(-1)
        } catch (e: IndexOutOfBoundsException) {
            @Assert(e.toString().contains("IndexOutOfBoundsException"), true)
            returntag = 2
        }
        @Assert(2,returntag)
        let sc1 = str.childNode(0)
        @Assert(0,sc1.attributesSize())
        try {
            str.childNode(2)
        } catch (e: IndexOutOfBoundsException) {
            @Assert(e.toString().contains("IndexOutOfBoundsException"), true)
            returntag = 3
        }
        @Assert(3,returntag)
        try {
            str.childNode(1)
        } catch (e: IndexOutOfBoundsException) {
            @Assert(e.toString().contains("IndexOutOfBoundsException"), true)
            returntag = 4
        }
        @Assert(4,returntag)
    }

    @TestCase
    func testNode_07_02(): Unit {
        var wrapper: Element = Element("div")
        wrapper.append("<p>Prior Content</p>")
        wrapper.append("<p>two Content</p>")
        wrapper.append("<p>three Content</p>")
        @Assert(3,wrapper.childNodeSize())

        let str = wrapper.childNodesCopy()
        @Assert(3,str.size)
        let str1 = wrapper.childNodeSize()
        @Assert(3,str1)
        wrapper.empty()
        let str2 = wrapper.childNodeSize()
        @Assert(0,str2)
    }

    @TestCase
    func testNode_07_03(): Unit {
        var returntag = -1
        var wrapper: Element = Element("div")
        wrapper.append("<p>one Content</p>")
        wrapper.append("<p>two Content</p>")
        wrapper.append("<p>three Content</p>")
        @Assert(3,wrapper.childNodeSize())
        try {
            wrapper.parent().getOrThrow()
        } catch (e: NoneValueException) {
            @Assert(e.toString().contains("NoneValueException"), true)
            returntag = 1
        }
        @Assert(1,returntag)
    }

    @TestCase
    func testNode_07_04(): Unit {
        var doc = Html4cj.parse("<a id=1 href='/foo'>One</a> <a id=2 href='https://jsoup.org/'>Two</a>")
        var str = doc.select("#2").first().getOrThrow()
        let str2 = str.parent().getOrThrow()
        @Assert(3,str2.childNodeSize())
        let str3 = str.parentNode().getOrThrow()
        @Assert(3,str3.childNodeSize())
    }

    @TestCase
    func testNode_07_05(): Unit {
        var doc = Html4cj.parse("<a id=1 href='/foo'>One</a> <a id=2 href='https://jsoup.org/'>Two</a>")
        var str = doc.select("#2").first().getOrThrow()
        let str2 = str.root()
        @Assert(1,str2.childNodeSize())
    }

    @TestCase
    func testNode_07_06(): Unit {
        var returntag = -1
        var wrapper: Element = Element("div")
        wrapper.append("<p>one Content</p>")
        try {
            wrapper.root()
        } catch (e: NoneValueException) {
            @Assert(e.toString().contains("NoneValueException"), true)
            returntag = 1
        }
        @Assert(-1,returntag)
    }
}
