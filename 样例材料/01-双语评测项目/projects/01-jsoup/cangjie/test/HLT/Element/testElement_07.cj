// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

@Test
public class NodeTest {
    @TestCase
    func testElement_07_01(): Unit {
        let cou = "<html><span><body><div><!-- a simple comment --><div></body></span></html>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("html").first().getOrThrow()
        let sc = str.dataNodes()
        var sc1 = ""
        for (i in 0..sc.size) {
            sc1 = sc[i].toString()
        }
        @Assert("",sc1)
    }

    @TestCase
    func testElement_07_02(): Unit {
        let cou = "<html><span><body><div><!-- a simple comment --><div></body></span></html>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("body").first().getOrThrow()
        let sc = str.dataNodes()
        var sc1 = ""
        for (i in 0..sc.size) {
            sc1 = sc[i].toString()
        }
        @Assert("",sc1)
    }

    @TestCase
    func testElement_07_03(): Unit {
        let cou = "<html><span><body><div><!-- a simple comment --><div></body></span></html>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("div").first().getOrThrow()
        let sc = str.dataNodes()
        var sc1 = ""
        for (i in 0..sc.size) {
            sc1 = sc[i].toString()
        }
        @Assert("",sc1)
    }

    @TestCase
    func testElement_07_04(): Unit {
        let cou = "<html><span><body><div><!-- a simple comment --><div></body></span></html>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("span").first().getOrThrow()
        let sc = str.dataNodes()
        var sc1 = ""
        for (i in 0..sc.size) {
            sc1 = sc[i].toString()
        }
        @Assert("",sc1)
    }
}
