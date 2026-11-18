// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

@Test
public class NodeTest {
    @TestCase
    func testNode_02_01(): Unit {
        var doc = Html4cj.parse("<a href=/foo>Hello</a>", "https://jsoup.org/")
        var a = doc.select("a").first().getOrThrow()
        let str = a.attr("href")
        @Assert(str,"/foo")
    }

    @TestCase
    func testNode_02_02(): Unit {
        var doc = Html4cj.parse("<a href=/foo>Hello</a>", "https://jsoup.org/")
        var a = doc.select("a").first().getOrThrow()
        let str = a.attr("HREF")
        @Assert(str,"/foo")
    }

    @TestCase
    func testNode_02_03(): Unit {
        var doc = Html4cj.parse("<a href=/foo>Hello</a>", "https://jsoup.org/")
        var a = doc.select("a").first().getOrThrow()
        let str = a.attr("os")
        @Assert(str,"")
    }

    @TestCase
    func testNode_02_04(): Unit {
        var doc = Html4cj.parse("<a href=/foo>Hello</a>", "https://jsoup.org/")
        var a = doc.select("a").first().getOrThrow()
        let str = a.attr("")
        @Assert(str,"")
    }

    @TestCase
    func testNode_02_05(): Unit {
        var doc = Html4cj.parse("<a href=/foo>Hello</a>", "https://jsoup.org/")
        var a = doc.select("a").first().getOrThrow()
        let str = a.attr("abc:os")
        @Assert(str,"")
    }

    @TestCase
    func testNode_02_06(): Unit {
        var doc = Html4cj.parse("<a href=/foo>Hello</a>", "https://jsoup.org/")
        var a = doc.select("a").first().getOrThrow()
        let str = a.attr("中文值【哈喽！】/")
        @Assert(str,"")
    }
}
