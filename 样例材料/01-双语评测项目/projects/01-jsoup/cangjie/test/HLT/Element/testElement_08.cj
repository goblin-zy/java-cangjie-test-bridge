// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

@Test
public class NodeTest {
    @TestCase
    func testElement_08_01(): Unit {
        let cou = "<html><span><body><div><!-- a simple comment --><div></body></span></html>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("html").first().getOrThrow()
        let sc = str.select("html")
        @Assert(sc.toString().contains("<!-- a simple comment -->"),true)
        @Assert(sc.toString().toRuneArray().size,127)
    }

    @TestCase
    func testElement_08_02(): Unit {
        let cou = "<html><span><body><div><!-- a simple comment --><div></body></span></html>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("html").first().getOrThrow()
        let sc = str.select("span")
        @Assert(sc.toString().contains("<!-- a simple comment -->"),true)
        @Assert(sc.toString().toRuneArray().size,70)
    }

    @TestCase
    func testElement_08_03(): Unit {
        let cou = "<html><span><body><div><!-- a simple comment --><div></body></span></html>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("html").first().getOrThrow()
        let sc = str.select("body")
        @Assert(sc.toString().contains("<!-- a simple comment -->"),true)
        @Assert(sc.toString().toRuneArray().size,90)
    }

    @TestCase
    func testElement_08_04(): Unit {
        let cou = "<html><span><body><div><!-- a simple comment --><div></body></span></html>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("html").first().getOrThrow()
        let sc = str.select("div")
        @Assert(sc.toString().contains("a simple comment -->"),true)
        @Assert(sc.toString().toRuneArray().size,64)
    }

    @TestCase
    func testElement_08_05(): Unit {
        let cou = "<html><span><body><中文><!-- a simple comment --></中文></body></span></html>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("html").first().getOrThrow()
        let sc = str.select("中文")
        @Assert(sc.toString(),"")
        @Assert(sc.toString().toRuneArray().size,0)
    }

    @TestCase
    func testElement_08_06(): Unit {
        let cou = "<html><span><body><中文><!-- a simple comment --></中文></body></span></html>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("html").first().getOrThrow()
        var returntag = -1
        try {
            str.select("")
        } catch (e: ValidationException) {
            @Assert(e.message, "String must not be empty")
            returntag = 1
        }
        @Assert(1,returntag)
    }

    @TestCase
    func testElement_08_07(): Unit {
        let cou = "<html><span><body><￥%><!-- a simple comment --></￥%></body></span></html>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("html").first().getOrThrow()
        var returntag = -1
        try {
            str.select("￥%")
        } catch (e: SelectorParseException) {
            @Assert(e.message, "Could not parse query '￥%': unexpected token at '￥%'")
            returntag = 1
        }
        @Assert(1,returntag)
    }

    @TestCase
    func testElement_08_08(): Unit {
        let cou = "<html><span><body><￥%><!-- a simple comment --></￥%></body></span></html>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("html").first().getOrThrow()
        let sc = str.select(TestEvaluator())
        @Assert(sc.toString().contains("<span>&lt;￥%&gt;<!-- a simple comment --><!--/￥%--></span>"),true)
        @Assert(sc.toString().toRuneArray().size,255)
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
