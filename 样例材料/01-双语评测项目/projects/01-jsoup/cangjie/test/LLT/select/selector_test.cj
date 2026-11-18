// EXEC: cjc %import-path %L %l %f -g
// EXEC: ./main
import cangjie_tpc::html4cj.*
import std.collection.*
import std.unittest.*
import std.unittest.testmacro.*

main(): Int64 {
    let tester = SelectorTest()
    tester.testByTag()
    tester.byEscapedTag()
    tester.testById()
    tester.byEscapedId()
    tester.testByClass()
    tester.byEscapedClass()
    tester.testByClassCaseInsensitive()
    tester.testByAttribute()
    tester.testNamespacedTag()
    tester.testWildcardNamespacedTag()
    tester.testByAttributeStarting()
    tester.testByAttributeRegex()
    tester.testByAttributeRegexCharacterClass()
    tester.testByAttributeRegexCombined()
    tester.testCombinedWithContains()
    tester.testAllElements()
    tester.testAllWithClass()
    tester.testGroupOr()
    tester.testGroupOrAttribute()
    tester.descendant()
    tester.and()
    tester.deeperDescendant()
    tester.parentChildElement()
    tester.parentWithClassChild()
    tester.parentChildStar()
    tester.multiChildDescent()
    tester.caseInsensitive()
    tester.adjacentSiblings()
    tester.adjacentSiblingsWithId()
    tester.notAdjacent()
    tester.mixCombinator()
    tester.mixCombinatorGroup()
    tester.generalSiblings()
    tester.testCharactersInIdAndClass()
    tester.testSupportsLeadingCombinator()
    tester.testPseudoLessThan()
    tester.testPseudoGreaterThan()
    tester.testPseudoEquals()
    tester.testPseudoBetween()
    tester.testPseudoCombined()
    tester.testPseudoHas()
    tester.testNestedHas()
    tester.testPseudoContains()
    tester.testPsuedoContainsWithParentheses()
    tester.containsWholeText()
    tester.containsWholeOwnText()
    tester.containsOwn()
    tester.testMatches()
    tester.matchesOwn()
    tester.matchesWholeText()
    tester.matchesWholeOwnText()
    tester.testRelaxedTags()
    tester.notParas()
    tester.notAll()
    tester.notClass()
    tester.handlesCommasInSelector()
    tester.selectSupplementaryCharacter()
    tester.selectClassWithSpace()
    tester.selectSameElements()
    tester.attributeWithBrackets()
    tester.containsData()
    tester.containsWithQuote()
    tester.selectFirst()
    tester.selectFirstWithAnd()
    tester.selectFirstWithOr()
    tester.matchText()
    tester.nthLastChildWithNoParent()
    tester.splitOnBr()
    tester.matchTextAttributes()
    tester.findBetweenSpan()
    tester.startsWithBeginsWithSpace()
    tester.endsWithEndsWithSpaces()
    tester.html_mixed_case_simple_name()
    tester.html_mixed_case_wildcard_name()
    tester.html_lowercase_simple_name()
    tester.html_lowercase_wildcard_name()
    tester.trimSelector()
    tester.childElements()
    tester.selectFirstLevelChildrenOnly()
    tester.containsTextQueryIsNormalized()
    tester.selectorExceptionNotStringFormatException()
    0
}

/*
 * Tests that the selector selects correctly.
 */
@Test
public class SelectorTest {
    @TestCase
    public func testByTag(): Unit {
        // should be case insensitive
        let els: Elements = Html4cj.parse("<div id=1><div id=2><p>Hello</p></div></div><DIV id=3>").select("DIV")
        @Assert(3, els.size)
        @Assert("1", els[0].id())
        @Assert("2", els[1].id())
        @Assert("3", els[2].id())

        let none: Elements = Html4cj.parse("<div id=1><div id=2><p>Hello</p></div></div><div id=3>").select("span")
        @Assert(0, none.size)
    }

    @TestCase
    public func byEscapedTag(): Unit {
        // tested same result as js document.querySelector
        let doc: Document = Html4cj.parse("<p.p>One</p.p> <p\\p>Two</p\\p>")

        let one: Element = doc.expectFirst("p\\.p")
        @Assert("One", one.text())

        let two: Element = doc.expectFirst("p\\\\p")
        @Assert("Two", two.text())
    }

    @TestCase
    public func testById(): Unit {
        let els: Elements = Html4cj.parse("<div><p id=foo>Hello</p><p id=foo>Foo two!</p></div>").select("#foo")
        @Assert(2, els.size)
        @Assert("Hello", els[0].text())
        @Assert("Foo two!", els[1].text())

        let none: Elements = Html4cj.parse("<div id=1></div>").select("#foo")
        @Assert(0, none.size)
    }

    @TestCase
    public func byEscapedId(): Unit {
        let doc: Document = Html4cj.parse("<p id='i.d'>One</p> <p id='i\\d'>Two</p> <p id='one-two/three'>Three</p>")

        let one: Element = doc.expectFirst("#i\\.d")
        @Assert("One", one.text())

        let two: Element = doc.expectFirst("#i\\\\d")
        @Assert("Two", two.text())

        let thr: Element = doc.expectFirst("p#one-two\\/three")
        @Assert("Three", thr.text())
    }

    @TestCase
    public func testByClass(): Unit {
        let els: Elements = Html4cj.parse("<p id=0 class='ONE two'><p id=1 class='one'><p id=2 class='two'>").select(
            "P.One")
        @Assert(2, els.size)
        @Assert("0", els[0].id())
        @Assert("1", els[1].id())

        let none: Elements = Html4cj.parse("<div class='one'></div>").select(".foo")
        @Assert(0, none.size)

        let els2: Elements = Html4cj.parse("<div class='One-Two'></div>").select(".one-two")
        @Assert(1, els2.size)
    }

    @TestCase
    public func byEscapedClass(): Unit {
        let els: Element = Html4cj.parse("<p class='one.two#three'>One</p>")

        let one: Element = els.expectFirst("p.one\\.two\\#three")
        @Assert("One", one.text())
    }

    @TestCase
    public func testByClassCaseInsensitive(): Unit {
        let html: String = "<p Class=foo>One <p Class=Foo>Two <p class=FOO>Three <p class=farp>Four"
        let elsFromClass: Elements = Html4cj.parse(html).select("P.Foo")
        let elsFromAttr: Elements = Html4cj.parse(html).select("p[class=foo]")

        @Assert(elsFromAttr.size, elsFromClass.size)
        @Assert(3, elsFromClass.size)
        @Assert("Two", elsFromClass[1].text())
    }

    @TestCase
    public func testByAttribute(): Unit {
        // Locale.setDefault(locale)
        let h: String = "<div Title=Foo /><div Title=Bar /><div Style=Qux /><div title=Balim /><div title=SLIM />" +
            "<div data-name='with spaces'/>"
        let doc: Document = Html4cj.parse(h)

        let withTitle: Elements = doc.select("[title]")
        @Assert(4, withTitle.size)

        let foo: Elements = doc.select("[TITLE=foo]")
        @Assert(1, foo.size)

        let foo2: Elements = doc.select("[title=\"foo\"]")
        @Assert(1, foo2.size)

        let foo3: Elements = doc.select("[title=\"Foo\"]")
        @Assert(1, foo3.size)

        let dataName: Elements = doc.select("[data-name=\"with spaces\"]")
        @Assert(1, dataName.size)
        @Assert("with spaces", dataName.first().getOrThrow().attr("data-name"))

        let not: Elements = doc.select("div[title!=bar]")
        @Assert(5, not.size)
        @Assert("Foo", not.first().getOrThrow().attr("title"))

        let starts: Elements = doc.select("[title^=ba]")
        @Assert(2, starts.size)
        @Assert("Bar", starts.first().getOrThrow().attr("title"))
        @Assert("Balim", starts.last().getOrThrow().attr("title"))

        let ends: Elements = doc.select("[title$=im]")
        @Assert(2, ends.size)
        @Assert("Balim", ends.first().getOrThrow().attr("title"))
        @Assert("SLIM", ends.last().getOrThrow().attr("title"))

        let contains: Elements = doc.select("[title*=i]")
        @Assert(2, contains.size)
        @Assert("Balim", contains.first().getOrThrow().attr("title"))
        @Assert("SLIM", contains.last().getOrThrow().attr("title"))
    }

    @TestCase
    public func testNamespacedTag(): Unit {
        let doc: Document = Html4cj.parse(
            "<div><abc:def id=1>Hello</abc:def></div> <abc:def class=bold id=2>There</abc:def>")
        let byTag: Elements = doc.select("abc|def")
        @Assert(2, byTag.size)
        @Assert("1", byTag.first().getOrThrow().id())
        @Assert("2", byTag.last().getOrThrow().id())

        let byAttr: Elements = doc.select(".bold")
        @Assert(1, byAttr.size)
        @Assert("2", byAttr.last().getOrThrow().id())

        let byTagAttr: Elements = doc.select("abc|def.bold")
        @Assert(1, byTagAttr.size)
        @Assert("2", byTagAttr.last().getOrThrow().id())

        let byContains: Elements = doc.select("abc|def:contains(e)")
        @Assert(2, byContains.size)
        @Assert("1", byContains.first().getOrThrow().id())
        @Assert("2", byContains.last().getOrThrow().id())
    }

    @TestCase
    public func testWildcardNamespacedTag(): Unit {
        let doc: Document = Html4cj.parse(
            "<div><abc:def id=1>Hello</abc:def></div> <abc:def class=bold id=2>There</abc:def>")
        let byTag: Elements = doc.select("*|def")
        @Assert(2, byTag.size)
        @Assert("1", byTag.first().getOrThrow().id())
        @Assert("2", byTag.last().getOrThrow().id())

        let byAttr: Elements = doc.select(".bold")
        @Assert(1, byAttr.size)
        @Assert("2", byAttr.last().getOrThrow().id())

        let byTagAttr: Elements = doc.select("*|def.bold")
        @Assert(1, byTagAttr.size)
        @Assert("2", byTagAttr.last().getOrThrow().id())

        let byContains: Elements = doc.select("*|def:contains(e)")
        @Assert(2, byContains.size)
        @Assert("1", byContains.first().getOrThrow().id())
        @Assert("2", byContains.last().getOrThrow().id())
    }

    @Skip
    @TestCase
    public func testWildcardNamespacedXmlTag(): Unit {
        let doc: Document = Html4cj.parse(
            "<div><Abc:Def id=1>Hello</Abc:Def></div> <Abc:Def class=bold id=2>There</abc:def>",
            "",
            Parser.xmlParser()
        )

        let byTag: Elements = doc.select("*|Def")
        @Assert(2, byTag.size)
        @Assert("1", byTag.first().getOrThrow().id())
        @Assert("2", byTag.last().getOrThrow().id())

        let byAttr: Elements = doc.select(".bold")
        @Assert(1, byAttr.size)
        @Assert("2", byAttr.last().getOrThrow().id())

        let byTagAttr: Elements = doc.select("*|Def.bold")
        @Assert(1, byTagAttr.size)
        @Assert("2", byTagAttr.last().getOrThrow().id())

        let byContains: Elements = doc.select("*|Def:contains(e)")
        @Assert(2, byContains.size)
        @Assert("1", byContains.first().getOrThrow().id())
        @Assert("2", byContains.last().getOrThrow().id())
    }

    @Skip
    @TestCase
    public func testWildCardNamespacedCaseVariations(): Unit {
        let doc: Document = Html4cj.parse("<One:Two>One</One:Two><three:four>Two</three:four>", "", Parser.xmlParser())
        let els1: Elements = doc.select("One|Two")
        let els2: Elements = doc.select("one|two")
        let els3: Elements = doc.select("Three|Four")
        let els4: Elements = doc.select("three|Four")

        @Assert(els1, els2)
        @Assert(els3, els4)
        @Assert("One", els1.text())
        @Assert(1, els1.size)
        @Assert("Two", els3.text())
        @Assert(1, els2.size)
    }

    @TestCase
    public func testByAttributeStarting(): Unit {
        // Locale.setDefault(locale)
        let doc: Document = Html4cj.parse(
            "<div id=1 ATTRIBUTE data-name=jsoup>Hello</div><p data-val=5 id=2>There</p><p id=3>No</p>")
        var withData: Elements = doc.select("[^data-]")
        @Assert(2, withData.size)
        @Assert("1", withData.first().getOrThrow().id())
        @Assert("2", withData.last().getOrThrow().id())

        withData = doc.select("p[^data-]")
        @Assert(1, withData.size)
        @Assert("2", withData.first().getOrThrow().id())

        @Assert(1, doc.select("[^attrib]").size)
    }

    @TestCase
    public func testByAttributeRegex(): Unit {
        let doc: Document = Html4cj.parse(
            "<p><img src=foo.png id=1><img src=bar.jpg id=2><img src=qux.JPEG id=3><img src=old.gif><img></p>")
        let imgs: Elements = doc.select("img[src~=(?i)\\.(png|jpe?g)]")
        @Assert(3, imgs.size)
        @Assert("1", imgs[0].id())
        @Assert("2", imgs[1].id())
        @Assert("3", imgs[2].id())
    }

    @TestCase
    public func testByAttributeRegexCharacterClass(): Unit {
        let doc: Document = Html4cj.parse(
            "<p><img src=foo.png id=1><img src=bar.jpg id=2><img src=qux.JPEG id=3><img src=old.gif id=4></p>")
        let imgs: Elements = doc.select("img[src~=[o]]")
        @Assert(2, imgs.size)
        @Assert("1", imgs[0].id())
        @Assert("4", imgs[1].id())
    }

    @TestCase
    public func testByAttributeRegexCombined(): Unit {
        let doc: Document = Html4cj.parse("<div><table class=x><td>Hello</td></table></div>")
        let els: Elements = doc.select("div table[class~=x|y]")
        @Assert(1, els.size)
        @Assert("Hello", els.text())
    }

    @TestCase
    public func testCombinedWithContains(): Unit {
        let doc: Document = Html4cj.parse("<p id=1>One</p><p>Two +</p><p>Three +</p>")
        let els: Elements = doc.select("p#1 + :contains(+)")
        @Assert(1, els.size)
        @Assert("Two +", els.text())
        @Assert("p", els.first().getOrThrow().tagName())
    }

    @TestCase
    public func testAllElements(): Unit {
        let h: String = "<div><p>Hello</p><p><b>there</b></p></div>"
        let doc: Document = Html4cj.parse(h)
        let allDoc: Elements = doc.select("*")
        let allUnderDiv: Elements = doc.select("div *")
        @Assert(8, allDoc.size)
        @Assert(3, allUnderDiv.size)
        @Assert("p", allUnderDiv.first().getOrThrow().tagName())
    }

    @TestCase
    public func testAllWithClass(): Unit {
        let h: String = "<p class=first>One<p class=first>Two<p>Three"
        let doc: Document = Html4cj.parse(h)
        let ps: Elements = doc.select("*.first")
        @Assert(2, ps.size)
    }

    @TestCase
    public func testGroupOr(): Unit {
        let h: String = "<div title=foo /><div title=bar /><div /><p></p><img /><span title=qux>"
        let doc: Document = Html4cj.parse(h)
        let els: Elements = doc.select("p,div,[title]")

        @Assert(5, els.size)
        @Assert("div", els[0].tagName())
        @Assert("foo", els[0].attr("title"))
        @Assert("div", els[1].tagName())
        @Assert("bar", els[1].attr("title"))
        @Assert("div", els[2].tagName())
        @Assert(0, els[2].attr("title").size) // missing attributes come back as empty string
        @Assert(false,els[2].hasAttr("title"))
        @Assert("p", els[3].tagName())
        @Assert("span", els[4].tagName())
    }

    @TestCase
    public func testGroupOrAttribute(): Unit {
        let h: String = "<div id=1 /><div id=2 /><div title=foo /><div title=bar />"
        let els: Elements = Html4cj.parse(h).select("[id],[title=foo]")

        @Assert(3, els.size)
        @Assert("1", els[0].id())
        @Assert("2", els[1].id())
        @Assert("foo", els[2].attr("title"))
    }

    @TestCase
    public func descendant(): Unit {
        let h: String = "<div class=head><p class=first>Hello</p><p>There</p></div><p>None</p>"
        let doc: Document = Html4cj.parse(h)
        let root: Element = doc.getElementsByClass("HEAD").first().getOrThrow()

        let els: Elements = root.select(".head p")
        @Assert(2, els.size)
        @Assert("Hello", els[0].text())
        @Assert("There", els[1].text())

        let p: Elements = root.select("p.first")
        @Assert(1, p.size)
        @Assert("Hello", p[0].text())

        let empty: Elements = root.select("p .first") // self, not descend, should not match
        @Assert(0, empty.size)

        let aboveRoot: Elements = root.select("body div.head")
        @Assert(0, aboveRoot.size)
    }

    @TestCase
    public func and(): Unit {
        let h: String = "<div id=1 class='foo bar' title=bar name=qux><p class=foo title=bar>Hello</p></div"
        let doc: Document = Html4cj.parse(h)

        let div: Elements = doc.select("div.foo")
        @Assert(1, div.size)
        @Assert("div", div.first().getOrThrow().tagName())

        let p: Elements = doc.select("div .foo") // space indicates like "div *.foo"
        @Assert(1, p.size)
        @Assert("p", p.first().getOrThrow().tagName())

        let div2: Elements = doc.select("div#1.foo.bar[title=bar][name=qux]") // very specific!
        @Assert(1, div2.size)
        @Assert("div", div2.first().getOrThrow().tagName())

        let p2: Elements = doc.select("div *.foo") // space indicates like "div *.foo"
        @Assert(1, p2.size)
        @Assert("p", p2.first().getOrThrow().tagName())
    }

    @TestCase
    public func deeperDescendant(): Unit {
        let h: String =
            "<div class=head><p><span class=first>Hello</div><div class=head><p class=first><span>Another</span><p>Again</div>"
        let doc: Document = Html4cj.parse(h)
        let root: Element = doc.getElementsByClass("head").first().getOrThrow()

        let els: Elements = root.select("div p .first")
        @Assert(1, els.size)
        @Assert("Hello", els.first().getOrThrow().text())
        @Assert("span", els.first().getOrThrow().tagName())

        let aboveRoot: Elements = root.select("body p .first")
        @Assert(0, aboveRoot.size)
    }

    @TestCase
    public func parentChildElement(): Unit {
        let h: String = "<div id=1><div id=2><div id = 3></div></div></div><div id=4></div>"
        let doc: Document = Html4cj.parse(h)

        let divs: Elements = doc.select("div > div")
        @Assert(2, divs.size)
        @Assert("2", divs[0].id()) // 2 is child of 1
        @Assert("3", divs[1].id()) // 3 is child of 2

        let div2: Elements = doc.select("div#1 > div")
        @Assert(1, div2.size)
        @Assert("2", div2[0].id())
    }

    @TestCase
    public func parentWithClassChild(): Unit {
        let h: String = "<h1 class=foo><a href=1 /></h1><h1 class=foo><a href=2 class=bar /></h1><h1><a href=3 /></h1>"
        let doc: Document = Html4cj.parse(h)

        let allAs: Elements = doc.select("h1 > a")
        @Assert(3, allAs.size)
        @Assert("a", allAs.first().getOrThrow().tagName())

        let fooAs: Elements = doc.select("h1.foo > a")
        @Assert(2, fooAs.size)
        @Assert("a", fooAs.first().getOrThrow().tagName())

        let barAs: Elements = doc.select("h1.foo > a.bar")
        @Assert(1, barAs.size)
    }

    @TestCase
    public func parentChildStar(): Unit {
        let h: String = "<div id=1><p>Hello<p><b>there</b></p></div><div id=2><span>Hi</span></div>"
        let doc: Document = Html4cj.parse(h)
        let divChilds: Elements = doc.select("div > *")
        @Assert(3, divChilds.size)
        @Assert("p", divChilds[0].tagName())
        @Assert("p", divChilds[1].tagName())
        @Assert("span", divChilds[2].tagName())
    }

    @TestCase
    public func multiChildDescent(): Unit {
        let h: String = "<div id=foo><h1 class=bar><a href=http://example.com/>One</a></h1></div>"
        let doc: Document = Html4cj.parse(h)
        let els: Elements = doc.select("div#foo > h1.bar > a[href*=example]")
        @Assert(1, els.size)
        @Assert("a", els.first().getOrThrow().tagName())
    }

    @TestCase
    public func caseInsensitive(): Unit {
        let h: String = "<dIv tItle=bAr><div>" // mixed case so a simple toLowerCase() on value doesn't catch
        let doc: Document = Html4cj.parse(h)

        @Assert(2, doc.select("DiV").size)
        @Assert(1, doc.select("DiV[TiTLE]").size)
        @Assert(1, doc.select("DiV[TiTLE=BAR]").size)
        @Assert(0, doc.select("DiV[TiTLE=BARBARELLA]").size)
    }

    @TestCase
    public func adjacentSiblings(): Unit {
        let h: String = "<ol><li>One<li>Two<li>Three</ol>"
        let doc: Document = Html4cj.parse(h)
        let sibs: Elements = doc.select("li + li")
        @Assert(2, sibs.size)
        @Assert("Two", sibs[0].text())
        @Assert("Three", sibs[1].text())
    }

    @TestCase
    public func adjacentSiblingsWithId(): Unit {
        let h: String = "<ol><li id=1>One<li id=2>Two<li id=3>Three</ol>"
        let doc: Document = Html4cj.parse(h)
        let sibs: Elements = doc.select("li#1 + li#2")
        @Assert(1, sibs.size)
        @Assert("Two", sibs[0].text())
    }

    @TestCase
    public func notAdjacent(): Unit {
        let h: String = "<ol><li id=1>One<li id=2>Two<li id=3>Three</ol>"
        let doc: Document = Html4cj.parse(h)
        let sibs: Elements = doc.select("li#1 + li#3")
        @Assert(0, sibs.size)
    }

    @TestCase
    public func mixCombinator(): Unit {
        let h: String = "<div class=foo><ol><li>One<li>Two<li>Three</ol></div>"
        let doc: Document = Html4cj.parse(h)
        let sibs: Elements = doc.select("body > div.foo li + li")

        @Assert(2, sibs.size)
        @Assert("Two", sibs[0].text())
        @Assert("Three", sibs[1].text())
    }

    @TestCase
    public func mixCombinatorGroup(): Unit {
        let h: String = "<div class=foo><ol><li>One<li>Two<li>Three</ol></div>"
        let doc: Document = Html4cj.parse(h)
        let els: Elements = doc.select(".foo > ol, ol > li + li")

        @Assert(3, els.size)
        @Assert("ol", els[0].tagName())
        @Assert("Two", els[1].text())
        @Assert("Three", els[2].text())
    }

    @TestCase
    public func generalSiblings(): Unit {
        let h: String = "<ol><li id=1>One<li id=2>Two<li id=3>Three</ol>"
        let doc: Document = Html4cj.parse(h)
        let els: Elements = doc.select("#1 ~ #3")
        @Assert(1, els.size)
        @Assert("Three", els.first().getOrThrow().text())
    }

    // for http://github.com/jhy/jsoup/issues#issue/10
    @TestCase
    public func testCharactersInIdAndClass(): Unit {
        // using CSS spec for identifiers (id and class): a-z0-9, -, _. NOT . (which is OK in html spec, but not css)
        let h: String = "<div><p id='a1-foo_bar'>One</p><p class='b2-qux_bif'>Two</p></div>"
        let doc: Document = Html4cj.parse(h)

        let el1: Element = doc.getElementById("a1-foo_bar").getOrThrow()
        @Assert("One", el1.text())
        let el2: Element = doc.getElementsByClass("b2-qux_bif").first().getOrThrow()
        @Assert("Two", el2.text())

        let el3: Element = doc.select("#a1-foo_bar").first().getOrThrow()
        @Assert("One", el3.text())
        let el4: Element = doc.select(".b2-qux_bif").first().getOrThrow()
        @Assert("Two", el4.text())
    }

    // for http://github.com/jhy/jsoup/issues#issue/13
    @TestCase
    public func testSupportsLeadingCombinator(): Unit {
        var h: String = "<div><p><span>One</span><span>Two</span></p></div>"
        var doc: Document = Html4cj.parse(h)

        let p: Element = doc.select("div > p").first().getOrThrow()
        let spans: Elements = p.select("> span")
        @Assert(2, spans.size)
        @Assert("One", spans.first().getOrThrow().text())

        // make sure doesn't get nested
        h = "<div id=1><div id=2><div id=3></div></div></div>"
        doc = Html4cj.parse(h)
        let div: Element = doc.select("div").select(" > div").first().getOrThrow()
        @Assert("2", div.id())
    }

    @TestCase
    public func testPseudoLessThan(): Unit {
        let doc: Document = Html4cj.parse("<div><p>One</p><p>Two</p><p>Three</>p></div><div><p>Four</p>")
        let ps: Elements = doc.select("div p:lt(2)")
        @Assert(3, ps.size)
        @Assert("One", ps[0].text())
        @Assert("Two", ps[1].text())
        @Assert("Four", ps[2].text())
    }

    @TestCase
    public func testPseudoGreaterThan(): Unit {
        let doc: Document = Html4cj.parse("<div><p>One</p><p>Two</p><p>Three</p></div><div><p>Four</p>")
        let ps: Elements = doc.select("div p:gt(0)")
        @Assert(2, ps.size)
        @Assert("Two", ps[0].text())
        @Assert("Three", ps[1].text())
    }

    @TestCase
    public func testPseudoEquals(): Unit {
        let doc: Document = Html4cj.parse("<div><p>One</p><p>Two</p><p>Three</>p></div><div><p>Four</p>")
        let ps: Elements = doc.select("div p:eq(0)")
        @Assert(2, ps.size)
        @Assert("One", ps[0].text())
        @Assert("Four", ps[1].text())

        let ps2: Elements = doc.select("div:eq(0) p:eq(0)")
        @Assert(1, ps2.size)
        @Assert("One", ps2[0].text())
        @Assert("p", ps2[0].tagName())
    }

    @TestCase
    public func testPseudoBetween(): Unit {
        let doc: Document = Html4cj.parse("<div><p>One</p><p>Two</p><p>Three</>p></div><div><p>Four</p>")
        let ps: Elements = doc.select("div p:gt(0):lt(2)")
        @Assert(1, ps.size)
        @Assert("Two", ps[0].text())
    }

    @TestCase
    public func testPseudoCombined(): Unit {
        let doc: Document = Html4cj.parse(
            "<div class='foo'><p>One</p><p>Two</p></div><div><p>Three</p><p>Four</p></div>")
        let ps: Elements = doc.select("div.foo p:gt(0)")
        @Assert(1, ps.size)
        @Assert("Two", ps[0].text())
    }

    @TestCase
    public func testPseudoHas(): Unit {
        let doc: Document = Html4cj.parse(
            "<div id=0><p><span>Hello</span></p></div> <div id=1><span class=foo>There</span></div> <div id=2><p>Not</p></div>"
        )

        let divs1: Elements = doc.select("div:has(span)")
        @Assert(2, divs1.size)
        @Assert("0", divs1[0].id())
        @Assert("1", divs1[1].id())

        let divs2: Elements = doc.select("div:has([class])")
        @Assert(1, divs2.size)
        @Assert("1", divs2[0].id())

        let divs3: Elements = doc.select("div:has(span, p)")
        @Assert(3, divs3.size)
        @Assert("0", divs3[0].id())
        @Assert("1", divs3[1].id())
        @Assert("2", divs3[2].id())

        let els1: Elements = doc.body().select(":has(p)")
        @Assert(3, els1.size) // body, div, div
        @Assert("body", els1.first().getOrThrow().tagName())
        @Assert("0", els1[1].id())
        @Assert("2", els1[2].id())

        let els2: Elements = doc.body().select(":has(> span)")
        @Assert(2,els2.size) // p, div
        @Assert("p",els2.first().getOrThrow().tagName())
        @Assert("1", els2[1].id())
    }

    @TestCase
    public func testNestedHas(): Unit {
        let doc: Document = Html4cj.parse("<div><p><span>One</span></p></div> <div><p>Two</p></div>")
        var divs: Elements = doc.select("div:has(p:has(span))")
        @Assert(1, divs.size)
        @Assert("One", divs.first().getOrThrow().text())

        // test matches in has
        divs = doc.select("div:has(p:matches((?i)two))")
        @Assert(1, divs.size)
        @Assert("div", divs.first().getOrThrow().tagName())
        @Assert("Two", divs.first().getOrThrow().text())

        // test contains in has
        divs = doc.select("div:has(p:contains(two))")
        @Assert(1, divs.size)
        @Assert("div", divs.first().getOrThrow().tagName())
        @Assert("Two", divs.first().getOrThrow().text())
    }

    @TestCase
    public func testPseudoContains(): Unit {
        // Locale.setDefault(locale)
        let doc: Document = Html4cj.parse(
            "<div><p>The Rain.</p> <p class=light>The <i>RAIN</i>.</p> <p>Rain, the.</p></div>")

        let ps1: Elements = doc.select("p:contains(Rain)")
        @Assert(3, ps1.size)

        let ps2: Elements = doc.select("p:contains(the rain)")
        @Assert(2, ps2.size)
        @Assert("The Rain.", ps2.first().getOrThrow().html())
        @Assert("The <i>RAIN</i>.", ps2.last().getOrThrow().html())

        let ps3: Elements = doc.select("p:contains(the Rain):has(i)")
        @Assert(1, ps3.size)
        @Assert("light", ps3.first().getOrThrow().className())

        let ps4: Elements = doc.select(".light:contains(rain)")
        @Assert(1, ps4.size)
        @Assert("light", ps3.first().getOrThrow().className())

        let ps5: Elements = doc.select(":contains(rain)")
        @Assert(8, ps5.size) // html, body, div,...

        let ps6: Elements = doc.select(":contains(RAIN)")
        @Assert(8, ps6.size)
    }

    @TestCase
    public func testPsuedoContainsWithParentheses(): Unit {
        let doc: Document = Html4cj.parse("<div><p id=1>This (is good)</p><p id=2>This is bad)</p>")

        let ps1: Elements = doc.select("p:contains(this (is good))")
        @Assert(1, ps1.size)
        @Assert("1", ps1.first().getOrThrow().id())

        let ps2: Elements = doc.select("p:contains(this is bad\\))")
        @Assert(1, ps2.size)
        @Assert("2", ps2.first().getOrThrow().id())
    }

    @TestCase
    func containsWholeText(): Unit {
        var doc: Document = Html4cj.parse("<div><p> jsoup\n The <i>HTML</i> Parser</p><p>jsoup The HTML Parser</div>")
        let ps: Elements = doc.select("p")

        let es1: Elements = doc.select("p:containsWholeText( jsoup\n The HTML Parser)")
        let es2: Elements = doc.select("p:containsWholeText(jsoup The HTML Parser)")
        @Assert(1, es1.size)
        @Assert(1, es2.size)
        @Assert(ps[0], es1.first().getOrThrow())
        @Assert(ps[1], es2.first().getOrThrow())

        @Assert(0, doc.select("div:containsWholeText(jsoup the html parser)").size)
        @Assert(0, doc.select("div:containsWholeText(jsoup\n the html parser)").size)

        doc = Html4cj.parse("<div><p></p><p> </p><p>.  </p>")
        let blanks: Elements = doc.select("p:containsWholeText(  )")
        @Assert(1, blanks.size)
        @Assert(".  ", blanks.first().getOrThrow().wholeText())
    }

    @TestCase
    func containsWholeOwnText(): Unit {
        var doc: Document = Html4cj.parse(
            "<div><p> jsoup\n The <i>HTML</i> Parser</p><p>jsoup The HTML Parser<br></div>")
        let ps: Elements = doc.select("p")

        let es1: Elements = doc.select("p:containsWholeOwnText( jsoup\n The  Parser)")
        let es2: Elements = doc.select("p:containsWholeOwnText(jsoup The HTML Parser\n)")
        @Assert(1, es1.size)
        @Assert(1, es2.size)
        @Assert(ps[0], es1.first().getOrThrow())
        @Assert(ps[1], es2.first().getOrThrow())

        @Assert(0, doc.select("div:containsWholeOwnText(jsoup the html parser)").size)
        @Assert(0, doc.select("div:containsWholeOwnText(jsoup\n the  parser)").size)

        doc = Html4cj.parse("<div><p></p><p> </p><p>.  </p>")
        let blanks: Elements = doc.select("p:containsWholeOwnText(  )")
        @Assert(1, blanks.size)
        @Assert(".  ", blanks.first().getOrThrow().wholeText())
    }

    @TestCase
    public func containsOwn(): Unit {
        // Locale.setDefault(locale)
        let doc: Document = Html4cj.parse("<p id=1>Hello <b>there</b> igor</p>")
        let ps: Elements = doc.select("p:containsOwn(Hello IGOR)")
        @Assert(1, ps.size)
        @Assert("1", ps.first().getOrThrow().id())

        @Assert(0, doc.select("p:containsOwn(there)").size)

        let doc2: Document = Html4cj.parse("<p>Hello <b>there</b> IGOR</p>")
        @Assert(1, doc2.select("p:containsOwn(igor)").size)
    }

    @TestCase
    public func testMatches(): Unit {
        let doc: Document = Html4cj.parse(
            "<p id=1>The <i>Rain</i></p> <p id=2>There are 99 bottles.</p> <p id=3>Harder (this)</p> <p id=4>Rain</p>")

        let p1: Elements = doc.select("p:matches(The rain)") // no match, case sensitive
        @Assert(0, p1.size)

        let p2: Elements = doc.select("p:matches((?i)the rain)") // case insense. should include root, html, body
        @Assert(1, p2.size)
        @Assert("1", p2.first().getOrThrow().id())

        let p4: Elements = doc.select("p:matches((?i)^rain$)") // bounding
        @Assert(1, p4.size)
        @Assert("4", p4.first().getOrThrow().id())

        let p5: Elements = doc.select("p:matches(\\d+)")
        @Assert(1, p5.size)
        @Assert("2", p5.first().getOrThrow().id())

        let p6: Elements = doc.select("p:matches(\\w+\\s+\\(\\w+\\))") // test bracket matching
        @Assert(1, p6.size)
        @Assert("3", p6.first().getOrThrow().id())

        let p7: Elements = doc.select("p:matches((?i)the):has(i)") // multi
        @Assert(1, p7.size)
        @Assert("1", p7.first().getOrThrow().id())
    }

    @TestCase
    public func matchesOwn(): Unit {
        let doc: Document = Html4cj.parse("<p id=1>Hello <b>there</b> now</p>")

        let p1: Elements = doc.select("p:matchesOwn((?i)hello now)")
        @Assert(1, p1.size)
        @Assert("1", p1.first().getOrThrow().id())

        @Assert(0, doc.select("p:matchesOwn(there)").size)
    }

    @TestCase
    public func matchesWholeText(): Unit {
        let doc: Document = Html4cj.parse("<p id=1>Hello <b>there</b>\n now</p><p id=2> </p><p id=3></p>")

        let p1: Elements = doc.select("p:matchesWholeText((?i)hello there\n now)")
        @Assert(1, p1.size)
        @Assert("1", p1.first().getOrThrow().id())

        @Assert(1, doc.select("p:matchesWholeText(there\n now)").size)
        @Assert(0, doc.select("p:matchesWholeText(There\n now)").size)

        let p2: Elements = doc.select("p:matchesWholeText(^\\s+$)")
        @Assert(1, p2.size)
        @Assert("2", p2.first().getOrThrow().id())

        let p3: Elements = doc.select("p:matchesWholeText(^$)")
        @Assert(1, p3.size)
        @Assert("3", p3.first().getOrThrow().id())
    }

    @TestCase
    public func matchesWholeOwnText(): Unit {
        let doc: Document = Html4cj.parse("<p id=1>Hello <b>there</b>\n now</p><p id=2> </p><p id=3><i>Text</i></p>")

        let p1: Elements = doc.select("p:matchesWholeOwnText((?i)hello \n now)")
        @Assert(1, p1.size)
        @Assert("1", p1.first().getOrThrow().id())

        @Assert(0, doc.select("p:matchesWholeOwnText(there\n now)").size)

        let p2: Elements = doc.select("p:matchesWholeOwnText(^\\s+$)")
        @Assert(1, p2.size)
        @Assert("2", p2.first().getOrThrow().id())

        let p3: Elements = doc.select("p:matchesWholeOwnText(^$)")
        @Assert(1, p3.size)
        @Assert("3", p3.first().getOrThrow().id())
    }

    @TestCase
    public func testRelaxedTags(): Unit {
        let doc: Document = Html4cj.parse("<abc_def id=1>Hello</abc_def> <abc-def id=2>There</abc-def>")

        let el1: Elements = doc.select("abc_def")
        @Assert(1, el1.size)
        @Assert("1", el1.first().getOrThrow().id())

        let el2: Elements = doc.select("abc-def")
        @Assert(1, el2.size)
        @Assert("2", el2.first().getOrThrow().id())
    }

    @TestCase
    public func notParas(): Unit {
        let doc: Document = Html4cj.parse("<p id=1>One</p> <p>Two</p> <p><span>Three</span></p>")

        let el1: Elements = doc.select("p:not([id=1])")
        @Assert(2, el1.size)
        @Assert("Two", el1.first().getOrThrow().text())
        @Assert("Three", el1.last().getOrThrow().text())

        let el2: Elements = doc.select("p:not(:has(span))")
        @Assert(2, el2.size)
        @Assert("One", el2.first().getOrThrow().text())
        @Assert("Two", el2.last().getOrThrow().text())
    }

    @TestCase
    public func notAll(): Unit {
        let doc: Document = Html4cj.parse("<p>Two</p> <p><span>Three</span></p>")

        let el1: Elements = doc.body().select(":not(p)") // should just be the span
        @Assert(2, el1.size)
        @Assert("body", el1.first().getOrThrow().tagName())
        @Assert("span", el1.last().getOrThrow().tagName())
    }

    @TestCase
    public func notClass(): Unit {
        let doc: Document = Html4cj.parse("<div class=left>One</div><div class=right id=1><p>Two</p></div>")

        let el1: Elements = doc.select("div:not(.left)")
        @Assert(1, el1.size)
        @Assert("1", el1.first().getOrThrow().id())
    }

    @TestCase
    public func handlesCommasInSelector(): Unit {
        let doc: Document = Html4cj.parse("<p name='1,2'>One</p><div>Two</div><ol><li>123</li><li>Text</li></ol>")

        let ps: Elements = doc.select("[name=1,2]")
        @Assert(1, ps.size)

        let containers: Elements = doc.select("div, li:matches([0-9,]+)")
        @Assert(2, containers.size)
        @Assert("div", containers[0].tagName())
        @Assert("li", containers[1].tagName())
        @Assert("123", containers[1].text())
    }

    @TestCase
    public func selectSupplementaryCharacter(): Unit {
        let s: String = "\u{210C1}"
        let doc: Document = Html4cj.parse("<div k" + s + "='" + s + "'>^" + s + "$/div>")
        @Assert("div", doc.select("div[k" + s + "]").first().getOrThrow().tagName())
        @Assert("div", doc.select("div:containsOwn(" + s + ")").first().getOrThrow().tagName())
    }

    @TestCase
    public func selectClassWithSpace(): Unit {
        let html: String = "<div class=\"value\">class without space</div>\n<div class=\"value \">class with space</div>"

        let doc: Document = Html4cj.parse(html)

        var found: Elements = doc.select("div[class=value ]")
        @Assert(2, found.size)
        @Assert("class without space", found[0].text())
        @Assert("class with space", found[1].text())

        found = doc.select("div[class=\"value \"]")
        @Assert(2, found.size)
        @Assert("class without space", found[0].text())
        @Assert("class with space", found[1].text())

        found = doc.select("div[class=\"value\\ \"]")
        @Assert(0, found.size)
    }

    @TestCase
    public func selectSameElements(): Unit {
        let html: String = "<div>one</div><div>one</div>"

        let doc: Document = Html4cj.parse(html)
        let els: Elements = doc.select("div")
        @Assert(2, els.size)

        let subSelect: Elements = els.select(":contains(one)")
        @Assert(2, subSelect.size)
    }

    @TestCase
    public func attributeWithBrackets(): Unit {
        let html: String = "<div data='End]'>One</div> <div data='[Another)]]'>Two</div>"
        let doc: Document = Html4cj.parse(html)
        @Assert("One", doc.select("div[data='End]']").first().getOrThrow().text())
        @Assert("Two", doc.select("div[data='[Another)]]']").first().getOrThrow().text())
        @Assert("One", doc.select("div[data=\"End]\"]").first().getOrThrow().text())
        @Assert("Two", doc.select("div[data=\"[Another)]]\"]").first().getOrThrow().text())
    }

    @TestCase
    public func containsData(): Unit {
        // Locale.setDefault(locale)
        let html: String = "<p>function</p><script>FUNCTION</script><style>item</style><span><!-- comments --></span>"
        let doc: Document = Html4cj.parse(html)
        let body: Element = doc.body()

        let dataEls1: Elements = body.select(":containsData(function)")
        let dataEls2: Elements = body.select("script:containsData(function)")
        let dataEls3: Elements = body.select("span:containsData(comments)")
        let dataEls4: Elements = body.select(":containsData(o)")
        let dataEls5: Elements = body.select("style:containsData(ITEM)")

        @Assert(2, dataEls1.size) // body and script
        @Assert(1, dataEls2.size)
        @Assert(dataEls1.last().getOrThrow(), dataEls2.first().getOrThrow())
        @Assert("<script>FUNCTION</script>", dataEls2.outerHtml())
        @Assert(1, dataEls3.size)
        @Assert("span", dataEls3.first().getOrThrow().tagName())
        @Assert(3, dataEls4.size)
        @Assert("body", dataEls4.first().getOrThrow().tagName())
        @Assert("script", dataEls4[1].tagName())
        @Assert("span", dataEls4[2].tagName())
        @Assert(1, dataEls5.size)
    }

    @TestCase
    public func containsWithQuote(): Unit {
        let html: String = "<p>One'One</p><p>One'Two</p>"
        let doc: Document = Html4cj.parse(html)
        let els: Elements = doc.select("p:contains(One\\'One)")
        @Assert(1, els.size)
        @Assert("One'One", els.text())
    }

    @TestCase
    public func selectFirst(): Unit {
        let html: String = "<p>One<p>Two<p>Three"
        let doc: Document = Html4cj.parse(html)
        @Assert("One", doc.selectFirst("p").getOrThrow().text())
    }

    @TestCase
    public func selectFirstWithAnd(): Unit {
        let html: String = "<p>One<p class=foo>Two<p>Three"
        let doc: Document = Html4cj.parse(html)
        @Assert("Two", doc.selectFirst("p.foo").getOrThrow().text())
    }

    @TestCase
    public func selectFirstWithOr(): Unit {
        let html: String = "<p>One<p>Two<p>Three<div>Four"
        let doc: Document = Html4cj.parse(html)
        @Assert("One", doc.selectFirst("p, div").getOrThrow().text())
    }

    @TestCase
    public func matchText(): Unit {
        let html: String = "<p>One<br>Two</p>"
        let doc: Document = Html4cj.parse(html)
        doc.outputSettings().prettyPrint(false)
        let origHtml: String = doc.html()

        let one: Elements = doc.select("p:matchText:first-child")
        @Assert("One", one.first().getOrThrow().text())

        let two: Elements = doc.select("p:matchText:last-child")
        @Assert("Two", two.first().getOrThrow().text())

        @Assert(origHtml, doc.html())

        @Assert("Two", doc.select("p:matchText + br + *").text())
    }

    @TestCase
    public func nthLastChildWithNoParent(): Unit {
        let el: Element = Element("p").text("Orphan")
        let els: Elements = el.select("p:nth-last-child(1)")
        @Assert(0, els.size)
    }

    @TestCase
    public func splitOnBr(): Unit {
        let html: String = "<div><p>One<br>Two<br>Three</p></div>"
        let doc: Document = Html4cj.parse(html)

        let els: Elements = doc.select("p:matchText")
        @Assert(3, els.size)
        @Assert("One", els[0].text())
        @Assert("Two", els[1].text())
        @Assert("Three", els[2].toString())
    }

    @TestCase
    public func matchTextAttributes(): Unit {
        let doc: Document = Html4cj.parse("<div><p class=one>One<br>Two<p class=two>Three<br>Four")
        let els: Elements = doc.select("p.two:matchText:last-child")

        @Assert(1, els.size)
        @Assert("Four", els.text())
    }

    @TestCase
    public func findBetweenSpan(): Unit {
        let doc: Document = Html4cj.parse("<p><span>One</span> Two <span>Three</span>")
        let els: Elements = doc.select("span ~ p:matchText") // the Two becomes its own p, sibling of the span

        // todo - think this should really be 'p:matchText span ~ p'. The :matchText should behave as a modifier to expand the nodes.
        @Assert(1, els.size)
        @Assert("Two", els.text())
    }

    @TestCase
    public func startsWithBeginsWithSpace(): Unit {
        let doc: Document = Html4cj.parse("<small><a href=\" mailto:abc@def.net\">(abc@def.net)</a></small>")
        let els: Elements = doc.select("a[href^=' mailto']")

        @Assert(1, els.size)
    }

    @TestCase
    public func endsWithEndsWithSpaces(): Unit {
        let doc: Document = Html4cj.parse("<small><a href=\" mailto:abc@def.net \">(abc@def.net)</a></small>")
        let els: Elements = doc.select("a[href$='.net ']")

        @Assert(1, els.size)
    }

    // https://github.com/jhy/jsoup/issues/1257
    private let mixedCase: String = "<html xmlns:n=\"urn:ns\"><n:mixedCase>text</n:mixedCase></html>"
    private let lowercase: String = "<html xmlns:n=\"urn:ns\"><n:lowercase>text</n:lowercase></html>"

    @TestCase
    public func html_mixed_case_simple_name(): Unit {
        let doc: Document = Html4cj.parse(mixedCase, "", Parser.htmlParser())
        @Assert(0, doc.select("mixedCase").size)
    }

    @TestCase
    public func html_mixed_case_wildcard_name(): Unit {
        let doc: Document = Html4cj.parse(mixedCase, "", Parser.htmlParser())
        @Assert(1, doc.select("*|mixedCase").size)
    }

    @TestCase
    public func html_lowercase_simple_name(): Unit {
        let doc: Document = Html4cj.parse(lowercase, "", Parser.htmlParser())
        @Assert(0, doc.select("lowercase").size)
    }

    @TestCase
    public func html_lowercase_wildcard_name(): Unit {
        let doc: Document = Html4cj.parse(lowercase, "", Parser.htmlParser())
        @Assert(1, doc.select("*|lowercase").size)
    }

    @Skip
    @TestCase
    public func xml_mixed_case_simple_name(): Unit {
        let doc: Document = Html4cj.parse(mixedCase, "", Parser.xmlParser())
        @Assert(0, doc.select("mixedCase").size)
    }

    @Skip
    @TestCase
    public func xml_mixed_case_wildcard_name(): Unit {
        let doc: Document = Html4cj.parse(mixedCase, "", Parser.xmlParser())
        @Assert(1, doc.select("*|mixedCase").size)
    }

    @Skip
    @TestCase
    public func xml_lowercase_simple_name(): Unit {
        let doc: Document = Html4cj.parse(lowercase, "", Parser.xmlParser())
        @Assert(0, doc.select("lowercase").size)
    }

    @Skip
    @TestCase
    public func xml_lowercase_wildcard_name(): Unit {
        let doc: Document = Html4cj.parse(lowercase, "", Parser.xmlParser())
        @Assert(1, doc.select("*|lowercase").size)
    }

    @TestCase
    public func trimSelector(): Unit {
        // https://github.com/jhy/jsoup/issues/1274
        let doc: Document = Html4cj.parse("<p><span>Hello")
        let els: Elements = doc.select(" p span ")
        @Assert(1, els.size)
        @Assert("Hello", els.first().getOrThrow().text())
    }

    @Skip
    @TestCase
    public func xmlWildcardNamespaceTest(): Unit {
        // https://github.com/jhy/jsoup/issues/1208
        let doc: Document = Html4cj.parse(
            "<ns1:MyXmlTag>1111</ns1:MyXmlTag><ns2:MyXmlTag>2222</ns2:MyXmlTag>",
            "",
            Parser.xmlParser()
        )
        let select: Elements = doc.select("*|MyXmlTag")
        @Assert(2, select.size)
        @Assert("1111", select[0].text())
        @Assert("2222", select[1].text())
    }

    @TestCase
    public func childElements(): Unit {
        // https://github.com/jhy/jsoup/issues/1292
        let html: String = "<body><span id=1>One <span id=2>Two</span></span></body>"
        let doc: Document = Html4cj.parse(html)

        let outer: Element = doc.selectFirst("span").getOrThrow()
        let span: Element = outer.selectFirst("span").getOrThrow()
        let inner: Element = outer.selectFirst("* span").getOrThrow()

        @Assert("1", outer.id())
        @Assert("1", span.id())
        @Assert("2", inner.id())
        @Assert(outer, span)
        @Assert(outer != inner)
    }

    @TestCase
    public func selectFirstLevelChildrenOnly(): Unit {
        // testcase for https://github.com/jhy/jsoup/issues/984
        let html: String = "<div><span>One <span>Two</span></span> <span>Three <span>Four</span></span>"
        let doc: Document = Html4cj.parse(html)

        let div: Element = doc.selectFirst("div").getOrThrow()

        // assertNotNull(div)
        
        // want to select One and Three only - the first level children
        let spans: Elements = div.select(":root > span")
        @Assert(2, spans.size)
        @Assert("One Two", spans[0].text())
        @Assert("Three Four", spans[1].text())
    }

    @Skip
    @TestCase
    public func wildcardNamespaceMatchesNoNamespace(): Unit {
        // https://github.com/jhy/jsoup/issues/1565
        let xml: String = "<package><meta>One</meta><opf:meta>Two</opf:meta></package>"
        let doc: Document = Html4cj.parse(xml, "", Parser.xmlParser())

        let metaEls: Elements = doc.select("meta")
        @Assert(1, metaEls.size)
        @Assert("One", metaEls[0].text())

        let nsEls: Elements = doc.select("*|meta")
        @Assert(2, nsEls.size)
        @Assert("One", nsEls[0].text())
        @Assert("Two", nsEls[1].text())
    }

    @TestCase
    func containsTextQueryIsNormalized(): Unit {
        let doc: Document = Html4cj.parse("<p><p id=1>Hello  there now<em>!</em>")
        let a: Elements = doc.select("p:contains(Hello   there  now!)")
        let b: Elements = doc.select(":containsOwn(hello   there  now)")
        let c: Elements = doc.select("p:contains(Hello there now)")
        let d: Elements = doc.select(":containsOwn(hello There now)")
        let e: Elements = doc.select("p:contains(HelloThereNow)")

        @Assert(1, a.size)
        @Assert(a, b)
        @Assert(a, c)
        @Assert(a, d)
        @Assert(0, e.size)
        @Assert(a != e)
    }

    @TestCase
    public func selectorExceptionNotStringFormatException(): Unit {
        // let ex: SelectorParseException = SelectorParseException("%&")
        // @Assert("%&", ex.message)
    }
}
