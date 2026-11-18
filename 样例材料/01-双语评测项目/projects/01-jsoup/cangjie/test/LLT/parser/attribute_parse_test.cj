// EXEC: cjc %import-path %L %l %f
// EXEC: ./main
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.unittest.testmacro.*
import std.fs.*
import std.collection.*

main(): Int64 {
    let tester = AttributeParseTest()
    tester.parsesRoughAttributeString()
    tester.handlesNewLinesAndReturns()
    tester.parsesEmptyString()
    tester.canStartWithEq()
    tester.strictAttributeUnescapes()
    tester.moreAttributeUnescapes()
    tester.parsesBooleanAttributes()
    tester.dropsSlashFromAttributeName()
    0
}

@Test
public class AttributeParseTest {
    @TestCase
    public func parsesRoughAttributeString(): Unit {
        // 1
        let html: String = "<a id=\"123\" class=\"baz = 'bar'\" style = 'border: 2px'qux zim foo = 12 mux=18 />"

        // should be: <id=123>, <class=baz = 'bar'>, <qux=>, <zim=>, <foo=12>, <mux.=18>
        let el: Element = Html4cj.parse(html).getElementsByTag("a").elementArr[0]
        let attr: Attributes = el.attributes()
        @Assert(7, attr.size)
        @Assert("123", attr.get("id"))
        @Assert("baz = 'bar'", attr.get("class"))
        @Assert("border: 2px", attr.get("style"))
        @Assert("", attr.get("qux"))
        @Assert("", attr.get("zim"))
        @Assert("12", attr.get("foo"))
        @Assert("18", attr.get("mux"))

        println("Pass1")
    }

    @TestCase
    public func handlesNewLinesAndReturns(): Unit {
        // 2
        let html: String = "<a\r\nfoo='bar\r\nqux'\r\nbar\r\n=\r\ntwo>One</a>"
        let el: Element = Html4cj.parse(html).select("a").first().getOrThrow()
        @Assert(2, el.attributes().size)
        @Assert("bar\r\nqux", el.attr("foo"))

        // currently preserves newlines in quoted attributes. todo confirm if should.
        @Assert("two", el.attr("bar"))

        println("Pass2")
    }

    @TestCase
    public func parsesEmptyString(): Unit {
        // 3
        let html: String = "<a />"
        let el: Element = Html4cj.parse(html).getElementsByTag("a").elementArr[0]
        let attr: Attributes = el.attributes()
        @Assert(0, attr.size)

        println("Pass3")
    }

    @TestCase
    public func canStartWithEq(): Unit {
        // 4
        let html: String = "<a =empty />"

        // TODO this is the weirdest thing in the spec - why not consider this an attribute with an empty name, not where name is '='?
        // am I reading it wrong? https://html.spec.whatwg.org/multipage/parsing.html#before-attribute-name-state
        let el: Element = Html4cj.parse(html).getElementsByTag("a").elementArr[0]
        let attr: Attributes = el.attributes()
        @Assert(1, attr.size)
        @Assert(attr.hasKey("=empty"))
        @Assert("", attr.get("=empty"))

        println("Pass4")
    }

    @TestCase
    public func strictAttributeUnescapes(): Unit {
        // 5
        let html: String = "<a id=1 href='?foo=bar&mid&lt=true'>One</a> <a id=2 href='?foo=bar&lt;qux&lg=1'>Two</a>"
        let els: Elements = Html4cj.parse(html).select("a")
        @Assert("?foo=bar&mid&lt=true", els.first().getOrThrow().attr("href"))
        @Assert("?foo=bar<qux&lg=1", els.last().getOrThrow().attr("href"))

        println("Pass5")
    }

    @TestCase
    public func moreAttributeUnescapes(): Unit {
        // 6
        let html: String = "<a href='&wr_id=123&mid-size=true&ok=&wr'>Check</a>"
        let els: Elements = Html4cj.parse(html).select("a")
        @Assert("&wr_id=123&mid-size=true&ok=&wr", els.first().getOrThrow().attr("href"))

        println("Pass6")
    }

    @TestCase
    public func parsesBooleanAttributes(): Unit {
        // 7
        let html: String = "<a normal=\"123\" boolean empty=\"\"></a>"
        let el: Element = Html4cj.parse(html).select("a").first().getOrThrow()
        @Assert("123", el.attr("normal"))
        @Assert("", el.attr("boolean"))
        @Assert("", el.attr("empty"))
        let attributes: ArrayList<Attribute> = el.attributes().asList()

        // "There should be 3 attribute present"
        @Assert(3, attributes.size)

        // vets boolean syntax
        @Assert(html, el.outerHtml())

        println("Pass7")
    }

    @TestCase
    public func dropsSlashFromAttributeName(): Unit {
        // 8
        let html: String = "<img /onerror='doMyJob'/>"
        var doc: Document = Html4cj.parse(html)

        // "SelfClosingStartTag ignores last character"
        @Assert(false, doc.select("img[onerror]").elementArr.isEmpty())
        let str = doc.body().html()
        @Assert("<img onerror=${'"'}doMyJob${'"'}>", str)
        doc = Html4cj.parse(html, "", Parser.xmlParser())
        @Assert("<img onerror=${'"'}doMyJob${'"'} />", doc.html())
        
        println("Pass8")
    }
}