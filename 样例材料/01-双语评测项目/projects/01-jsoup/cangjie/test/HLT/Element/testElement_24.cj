// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

@Test
public class NodeTest {
    @TestCase
    func testElement_24_01(): Unit {
        let cou = "<html><span><body><￥%><!-- a simple comment --></￥%></body></span></html>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("html").first().getOrThrow()
        let sc = str.siblingElements()
        @Assert("",sc.toString())
    }

    @TestCase
    func testElement_24_02(): Unit {
        let cou = "<html><span><body><￥%><!-- a simple comment --></￥%></body></span></html>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("span").first().getOrThrow()
        let sc = str.siblingElements()
        @Assert("",sc.toString())
    }

    @TestCase
    func testElement_24_03(): Unit {
        let cou = "<html><span><body><os><!-- a simple comment --></os></body></span></html>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("os").first().getOrThrow()
        let sc = str.siblingElements()
        @Assert("",sc.toString())
    }

    @TestCase
    func testElement_24_04(): Unit {
        let cou = "<html><span><body><os><!-- a simple comment --></os></body></span></html>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("os").first().getOrThrow()
        let sc = str.nextElementSibling()
        @Assert("None",sc.toString())
    }

    @TestCase
    func testElement_24_05(): Unit {
        let cou = "<html><span><body><￥%><!-- a simple comment --></￥%></body></span></html>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("html").first().getOrThrow()
        let sc = str.nextElementSibling()
        @Assert("None",sc.toString())
    }

    @TestCase
    func testElement_24_06(): Unit {
        let cou = "<html><span><body><￥%><!-- a simple comment --></￥%></body></span></html>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("span").first().getOrThrow()
        let sc = str.nextElementSibling()
        @Assert("None",sc.toString())
    }
}
