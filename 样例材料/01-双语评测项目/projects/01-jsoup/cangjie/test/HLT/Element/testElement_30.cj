// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

@Test
public class NodeTest {
    @TestCase
    func testElement_30_01(): Unit {
        let cou = "<html><span><body><div><!-- a simple comment --></div><b>two</b></body></span></html>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("body").first().getOrThrow()
        var returntag = -1
        try {
            str.getElementById("")
        } catch (e: ValidationException) {
            @Assert(e.toString().contains("String must not be empty"), true)
            returntag = 1
        }
        @Assert(1,returntag)
    }

    @TestCase
    func testElement_30_02(): Unit {
        let cou = "<html><span><body><div><!-- a simple comment --></div><b>two</b></body></span></html>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("html").first().getOrThrow()
        let sc = str.getElementById("body")
        @Assert("None",sc.toString())
    }

    @TestCase
    func testElement_30_03(): Unit {
        let cou = "<html><span><body><中国><!-- a simple comment --></中国><b>two</b></body></span></html>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("html").first().getOrThrow()
        let sc = str.getElementById("中国")
        @Assert("None",sc.toString())
    }

    @TestCase
    func testElement_30_04(): Unit {
        let cou = "<html><span><body><￥%><!-- a simple comment --></￥%><b>two</b></body></span></html>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("span").first().getOrThrow()
        let sc = str.getElementById("￥%")
        @Assert("None",sc.toString())
    }

    @TestCase
    func testElement_30_05(): Unit {
        let cou = "<html><span><body><￥%><!-- a simple comment --></￥%><b>two</b></body></span></html>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("span").first().getOrThrow()
        let sc = str.getElementById("￥%")
        @Assert("None",sc.toString())
    }

    @TestCase
    func testElement_30_06(): Unit {
        let cou = "<html><span><body><中国><!-- a simple comment --></中国><b>two</b></body></span></html>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("body").first().getOrThrow()
        let sc = str.getElementById("中国")
        @Assert("None",sc.toString())
        let sc1 = str.getElementById("see")
        @Assert("None",sc1.toString())
    }
}
