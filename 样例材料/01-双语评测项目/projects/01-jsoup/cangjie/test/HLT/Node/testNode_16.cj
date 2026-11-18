// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

@Test
public class NodeTest {
    @TestCase
    func testNode_16_01(): Unit {
        var doc = Html4cj.parse("<p>One <em>four</em><b>two</b> three</p>")
        var doc1 = Html4cj.parse("<a href='./one/two.html'>One</a>", "http://example.com")
        var str1 = doc1.select("a").first().getOrThrow()
        doc.select("p").first().getOrThrow().appendChild(str1)
        doc.select("b").first().getOrThrow().append("<div>ssc</div>")
        var str3 = doc.select("div").first().getOrThrow()
        let sc = str3.hashCode()
        // @Assert(6040636637288769661,sc)
        @PowerAssert(str3.hashCode() != str3.clone().hashCode()) //经克隆的两对象相互独立，内容不同
        @PowerAssert(str3.hashCode() != str3.shallowClone().hashCode())
    }

    @TestCase
    func testNode_16_02(): Unit {
        var doc = Html4cj.parse("<div><!-- a simple comment -->")
        var str = doc.childNode(0)
        let sc = str.hashCode()
        @PowerAssert(0!=sc)
    }

    @TestCase
    func testNode_16_03(): Unit {
        var doc = Html4cj.parse("<div><!-- a simple comment -->")
        var str = doc.childNode(0)
        var sec: StringBuilder = StringBuilder()
        let sc = str.hasSameValue(sec)
        @Assert(false,sc)
    }

    @TestCase
    func testNode_16_04(): Unit {
        var doc = Html4cj.parse("<div><!-- a simple comment -->")
        var str = doc.childNode(0)
        var str1 = doc.childNode(0)
        let sc = str.hasSameValue(str1)
        @Assert(true,sc)
    }

    @TestCase
    func testNode_16_05(): Unit {
        var doc = Html4cj.parse("<p>One <em>four</em><b>two</b> three</p>")
        var str = doc.select("p").first().getOrThrow()
        var str1 = doc.select("b").first().getOrThrow()
        let sc = str.hasSameValue(str1)
        @Assert(false,sc)
    }

    @TestCase
    func testNode_16_06(): Unit {
        var doc = Html4cj.parse("<p>One <em>four</em><b>two</b> three</p>")
        var str = doc.select("em").first().getOrThrow()
        var str1 = doc.select("b").first().getOrThrow()
        let sc = str.hasSameValue(str1)
        @Assert(false,sc)
    }

    @TestCase
    func testNode_16_07(): Unit {
        var doc = Html4cj.parse("<p>One <em>four</em><b>two</b> three</p>")
        var str = doc.select("em").first().getOrThrow()
        let sc = str.shallowClone()
        @Assert(false,sc == str)
    }

    @TestCase
    func testNode_16_08(): Unit {
        var doc = Html4cj.parse("<div><!-- a simple comment -->")
        var str = doc.childNode(0)
        let sc = str.shallowClone()
        @Assert(false,sc == str)
    }
}
