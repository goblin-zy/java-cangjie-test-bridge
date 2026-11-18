package cangjie_tpc::html4cj

@Test
public class CssTest {
    let html: Document
    let htmlString: String

    public init() {
        let sb: StringBuilder = StringBuilder("<html><head></head><body>")
        sb.append("<div id='pseudo'>")
        for (i in 1..=10) {
            sb.append("<p>${i}</p>")
        }
        sb.append("</div>")
        sb.append("<div id='type'>")
        for (i in 1..=10) {
            sb.append("<p>${i}</p>")
            sb.append("<span>${i}</span>")
            sb.append("<em>${i}</em>")
            sb.append("<svg>${i}</svg>")
        }
        sb.append("</div>")
        sb.append("<span id='onlySpan'><br /></span>")
        sb.append("<p class='empty'><!-- Comment only is still empty! --></p>")
        sb.append("<div id='only'>")
        sb.append("Some text before the <em>only</em> child in this div")
        sb.append("</div>")
        sb.append("</body></html>")
        htmlString = sb.toString()
        html = Html4cj.parse(htmlString)
    }

    @TestCase
    public func firstChild(): Unit {
        check(html.select("#pseudo :first-child"), "1")
        check(html.select("html:first-child"))
    }

    @TestCase
    public func lastChild(): Unit {
        check(html.select("#pseudo :last-child"), "10")
        check(html.select("html:last-child"))
    }

    @TestCase
    public func nthChild_simple(): Unit {
        for (i in 1..=10) {
            check(html.select("#pseudo :nth-child(${i})"), i.toString())
        }
    }

    @TestCase
    public func nthOfType_unknownTag(): Unit {
        for (i in 1..=10) {
            check(html.select("#type svg:nth-of-type(${i})"), i.toString())
        }
    }

    @TestCase
    public func nthLastChild_simple(): Unit {
        for (i in 1..=10) {
            check(html.select("#pseudo :nth-last-child(${i})"), (11 - i).toString())
        }
    }

    @TestCase
    public func nthOfType_simple(): Unit {
        for (i in 1..=10) {
            check(html.select("#type p:nth-of-type(${i})"), i.toString())
        }
    }

    @TestCase
    public func nthLastOfType_simple(): Unit {
        for (i in 1..=10) {
            check(
                html.select("#type :nth-last-of-type(${i})"),
                (11 - i).toString(),
                (11 - i).toString(),
                (11 - i).toString(),
                (11 - i).toString()
            )
        }
    }

    @TestCase
    public func nthChild_advanced(): Unit {
        check(html.select("#pseudo :nth-child(-5)"))
        check(html.select("#pseudo :nth-child(odd)"), "1", "3", "5", "7", "9")
        check(html.select("#pseudo :nth-child(2n-1)"), "1", "3", "5", "7", "9")
        check(html.select("#pseudo :nth-child(2n+1)"), "1", "3", "5", "7", "9")
        check(html.select("#pseudo :nth-child(2n+3)"), "3", "5", "7", "9")
        check(html.select("#pseudo :nth-child(even)"), "2", "4", "6", "8", "10")
        check(html.select("#pseudo :nth-child(2n)"), "2", "4", "6", "8", "10")
        check(html.select("#pseudo :nth-child(3n-1)"), "2", "5", "8")
        check(html.select("#pseudo :nth-child(-2n+5)"), "1", "3", "5")
        check(html.select("#pseudo :nth-child(+5)"), "5")
    }

    @TestCase
    public func nthOfType_advanced(): Unit {
        check(html.select("#type :nth-of-type(-5)"))
        check(html.select("#type p:nth-of-type(odd)"), "1", "3", "5", "7", "9")
        check(html.select("#type em:nth-of-type(2n-1)"), "1", "3", "5", "7", "9")
        check(html.select("#type p:nth-of-type(2n+1)"), "1", "3", "5", "7", "9")
        check(html.select("#type span:nth-of-type(2n+3)"), "3", "5", "7", "9")
        check(html.select("#type p:nth-of-type(even)"), "2", "4", "6", "8", "10")
        check(html.select("#type p:nth-of-type(2n)"), "2", "4", "6", "8", "10")
        check(html.select("#type p:nth-of-type(3n-1)"), "2", "5", "8")
        check(html.select("#type p:nth-of-type(-2n+5)"), "1", "3", "5")
        check(html.select("#type :nth-of-type(+5)"), "5", "5", "5", "5")
    }

    @TestCase
    public func nthLastChild_advanced(): Unit {
        check(html.select("#pseudo :nth-last-child(-5)"))
        check(html.select("#pseudo :nth-last-child(odd)"), "2", "4", "6", "8", "10")
        check(html.select("#pseudo :nth-last-child(2n-1)"), "2", "4", "6", "8", "10")
        check(html.select("#pseudo :nth-last-child(2n+1)"), "2", "4", "6", "8", "10")
        check(html.select("#pseudo :nth-last-child(2n+3)"), "2", "4", "6", "8")
        check(html.select("#pseudo :nth-last-child(even)"), "1", "3", "5", "7", "9")
        check(html.select("#pseudo :nth-last-child(2n)"), "1", "3", "5", "7", "9")
        check(html.select("#pseudo :nth-last-child(3n-1)"), "3", "6", "9")
        check(html.select("#pseudo :nth-last-child(-2n+5)"), "6", "8", "10")
        check(html.select("#pseudo :nth-last-child(+5)"), "6")
    }

    @TestCase
    public func nthLastOfType_advanced(): Unit {
        check(html.select("#type :nth-last-of-type(-5)"))
        check(html.select("#type p:nth-last-of-type(odd)"), "2", "4", "6", "8", "10")
        check(html.select("#type em:nth-last-of-type(2n-1)"), "2", "4", "6", "8", "10")
        check(html.select("#type p:nth-last-of-type(2n+1)"), "2", "4", "6", "8", "10")
        check(html.select("#type span:nth-last-of-type(2n+3)"), "2", "4", "6", "8")
        check(html.select("#type p:nth-last-of-type(even)"), "1", "3", "5", "7", "9")
        check(html.select("#type p:nth-last-of-type(2n)"), "1", "3", "5", "7", "9")
        check(html.select("#type p:nth-last-of-type(3n-1)"), "3", "6", "9")
        check(html.select("#type span:nth-last-of-type(-2n+5)"), "6", "8", "10")
        check(html.select("#type :nth-last-of-type(+5)"), "6", "6", "6", "6")
    }

    @TestCase
    public func firstOfType(): Unit {
        check(html.select("div:not(#only) :first-of-type"), "1", "1", "1", "1", "1")
    }

    @TestCase
    public func lastOfType(): Unit {
        check(html.select("div:not(#only) :last-of-type"), "10", "10", "10", "10", "10")
    }

    @TestCase
    public func empty(): Unit {
        let sel: Elements = html.select(":empty")
        @Assert(3, sel.size)
        @Assert("head", sel[0].tagName())
        @Assert("br", sel[1].tagName())
        @Assert("p", sel[2].tagName())
    }

    @TestCase
    public func onlyChild(): Unit {
        let sel: Elements = html.select("span :only-child")
        @Assert(1, sel.size)
        @Assert("br", sel[0].tagName())
        check(html.select("#only :only-child"), "only")
    }

    @TestCase
    public func onlyOfType(): Unit {
        let sel: Elements = html.select(":only-of-type")
        println(html.childNode(0).nodeName())
        println(html.childNode(0).parent()().nodeName())
        let s = html.childNode(0).parent()()
        let s1 = s is Document
        println(s1)
        println("---")
        for (s in sel) {
            println(s.tagName())
        }
        @Assert(6, sel.size)
        @Assert("head", sel[0].tagName())
        @Assert("body", sel[1].tagName())
        @Assert("span", sel[2].tagName())
        @Assert("br", sel[3].tagName())
        @Assert("p", sel[4].tagName())
        @Assert(sel[4].hasClass("empty"))
        @Assert("em", sel[5].tagName())
    }

    protected func check(result: Elements, expectedContent: Array<String>) {
        // "Number of elements"
        @Assert(expectedContent.size, result.size)
        for (i in 0..expectedContent.size) {
            // "Expected element"
            @Assert(expectedContent[i], result[i].ownText())
        }
    }

    @TestCase
    public func root(): Unit {
        let sel: Elements = html.select(":root")
        @Assert(1, sel.size)
        @Assert(Tag.valueOf("html"), sel[0].tag())
        let sel2: Elements = html.select("body").select(":root")
        @Assert(1, sel2.size)
        @Assert(Tag.valueOf("body"), sel2[0].tag())
    }
}
