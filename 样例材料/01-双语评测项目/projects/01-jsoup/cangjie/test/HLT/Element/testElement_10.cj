// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

@Test
public class NodeTest {
    @TestCase
    func testElement_10_01(): Unit {
        let cou = "<html><span><body><￥%><!-- a simple comment --></￥%></body></span></html>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("html").first().getOrThrow()
        let sc = str.selectFirst(TestEvaluator())
        @Assert(sc.toString().contains("<span>&lt;￥%&gt;<!-- a simple comment --><!--/￥%--></span>"),true)
        @Assert(sc.toString().toRuneArray().size,113)
    }

    @TestCase
    func testElement_10_02(): Unit {
        let cou = "<html><span><body><￥%><!-- a simple comment --></￥%></body></span></html>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("html").first().getOrThrow()
        var returntag = -1
        try {
            str.expectFirst("")
        } catch (e: ValidationException) {
            @Assert(e.toString().contains("String must not be empty"), true)
            returntag = 1
        }
        @Assert(1,returntag)
    }

    @TestCase
    func testElement_10_03(): Unit {
        let cou = "<html><span><body><￥%><!-- a simple comment --></￥%></body></span></html>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("html").first().getOrThrow()
        var returntag = -1
        try {
            str.expectFirst("se")
        } catch (e: ValidationException) {
            @Assert(e.toString().contains("No elements matched the query 'se' on element 'html'."), true)
            returntag = 1
        }
        @Assert(1,returntag)
    }

    @TestCase
    func testElement_10_04(): Unit {
        let cou = "<html><span><body><￥%><!-- a simple comment --></￥%></body></span></html>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("html").first().getOrThrow()
        var returntag = -1
        try {
            str.expectFirst("￥%")
        } catch (e: SelectorParseException) {
            @Assert(e.toString().contains("Could not parse query '￥%': unexpected token at '￥%'"), true)
            returntag = 1
        }
        @Assert(1,returntag)
    }

    @TestCase
    func testElement_10_05(): Unit {
        let cou = "<html><span><body><中国><!-- a simple comment --></中国></body></span></html>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("html").first().getOrThrow()
        var returntag = -1
        try {
            str.expectFirst("中国")
        } catch (e: ValidationException) {
            @Assert(e.toString().contains("No elements matched the query '中国' on element 'html'."), true)
            returntag = 1
        }
        @Assert(1,returntag)
    }
}
class TestEvaluator <: Evaluator {
    init() {
        super()
    }

    public override func matches(root: ?Element, element: Element): Bool {
        if (element is Element) {}
        match (root) {
            case Some(v) =>
                if (v.toString().isEmpty()) {
                    return true
                }
                return true
            case None => return false
        }
    }

    public func toString(): String {
        return ""
    }
}
