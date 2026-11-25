package cangjie_tpc::html4cj
import std.unittest.*
import std.unittest.testmacro.*


@Test
class SelectorTranslationTest {

    @TestCase
    func testByTag(): Unit {
        let els = Html4cj.parse("<div id=1><div id=2><p>Hello</p></div></div><DIV id=3>").select("DIV")
        @Assert(Int64(3), els.size)
        @Assert("1", els[0].id())
        @Assert("2", els[1].id())
        @Assert("3", els[2].id())
        let none = Html4cj.parse("<div id=1><div id=2><p>Hello</p></div></div><div id=3>").select("span")
        @Assert(Int64(0), none.size)
    }
    @TestCase
    func byEscapedTag(): Unit {
        let doc = Html4cj.parse("<p.p>One</p.p> <p\\p>Two</p\\p>")
        let one = doc.expectFirst("p\\.p")
        @Assert("One", one.text())
        let two = doc.expectFirst("p\\\\p")
        @Assert("Two", two.text())
    }
    @TestCase
    func testById(): Unit {
        let els = Html4cj.parse("<div><p id=foo>Hello</p><p id=foo>Foo two!</p></div>").select("#foo")
        @Assert(Int64(2), els.size)
        @Assert("Hello", els[0].text())
        @Assert("Foo two!", els[1].text())
        let none = Html4cj.parse("<div id=1></div>").select("#foo")
        @Assert(Int64(0), none.size)
    }
    @TestCase
    func byEscapedId(): Unit {
        let doc = Html4cj.parse("<p id='i.d'>One</p> <p id='i\\d'>Two</p> <p id='one-two/three'>Three</p>")
        let one = doc.expectFirst("#i\\.d")
        @Assert("One", one.text())
        let two = doc.expectFirst("#i\\\\d")
        @Assert("Two", two.text())
        let third = doc.expectFirst("p#one-two\\/three")
        @Assert("Three", third.text())
    }
    @TestCase
    func testByClass(): Unit {
        let els = Html4cj.parse("<p id=0 class='ONE two'><p id=1 class='one'><p id=2 class='two'>").select("P.One")
        @Assert(Int64(2), els.size)
        @Assert("0", els[0].id())
        @Assert("1", els[1].id())
        let none = Html4cj.parse("<div class='one'></div>").select(".foo")
        @Assert(Int64(0), none.size)
        let els2 = Html4cj.parse("<div class='One-Two'></div>").select(".one-two")
        @Assert(Int64(1), els2.size)
    }
}
