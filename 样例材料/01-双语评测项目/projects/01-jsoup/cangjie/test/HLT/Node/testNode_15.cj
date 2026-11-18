// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

@Test
public class NodeTest {
    @TestCase
    func testNode_15_01(): Unit {
        var doc = Html4cj.parse("<p>One <em>four</em><b>two</b> three</p>")
        var str = doc.select("p").first().getOrThrow()
        var cou: StringBuilder = StringBuilder()
        str.html(cou)
        @Assert("One <em>four</em><b>two</b> three",cou.toString())
    }

    @TestCase
    func testNode_15_02(): Unit {
        var doc = Html4cj.parse("<p>One <em>four</em><b>two</b> three</p>")
        var cous: StringBuilder = StringBuilder()
        var strs = doc.select("em").first().getOrThrow()
        strs.html(cous)
        @Assert("four",cous.toString())
    }

    @TestCase
    func testNode_15_03(): Unit {
        var doc = Html4cj.parse("<div><!-- a simple comment -->")
        var str = doc.childNode(0)
        var cous: StringBuilder = StringBuilder()
        str.html(cous)
        @Assert("<head></head>\n<body>\n <div>\n  <!-- a simple comment -->\n </div>\n</body>",cous.toString())
    }

    @TestCase
    func testNode_15_04(): Unit {
        var doc = Html4cj.parse("<div><!-- a simple comment -->")
        var str = doc.childNode(0)
        let sc = str.sourceRange().toString()
        @Assert("-1,-1:-1--1,-1:-1",sc)
    }

    @TestCase
    func testNode_15_05(): Unit {
        var doc = Html4cj.parse("<p>One <em>four</em><b>two</b> three</p>")
        var str = doc.select("em").first().getOrThrow()
        let sc = str.sourceRange().toString()
        @Assert("-1,-1:-1--1,-1:-1",sc)
    }

    @TestCase
    func testNode_15_06(): Unit {
        var doc = Html4cj.parse("<p>One <em>four</em><b>two</b> three</p>")
        var str = doc.select("em").first().getOrThrow()
        let sc = str.clone()
        @Assert(false,sc == str)
        @Assert(true,sc != str)
    }

    @TestCase
    func testNode_15_07(): Unit {
        var doc = Html4cj.parse("<div><!-- a simple comment -->")
        var str = doc.childNode(0)
        let sc = str.clone()
        @Assert(false,sc == str)
        @Assert(true,sc != str)
    }
}
