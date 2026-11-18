// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

@Test
public class NodeTest {
    @TestCase
    func testNode_06_01(): Unit {
        var doc = Html4cj.parse("<a id=1 href='/FOO'>One</a> <a id=2 href='https://jsoup.org/'>Two</a>")
        var str = doc.select("#2").first().getOrThrow()
        let sc = str.absUrl("href")
        @Assert("https://jsoup.org/",sc)
        var str1 = doc.select("#1").first().getOrThrow()
        let sc1 = str1.absUrl("href")
        @Assert("",sc1)
    }

    @TestCase
    func testNode_06_02(): Unit {
        var doc = Html4cj.parse("<a href='password'>One/a><a href='/var/log/messages'>Two</a>", "file:/etc/")
        var str = doc.select("a").first().getOrThrow()
        let sc = str.absUrl("href")
        @Assert("file:///etc/password",sc)
    }

    @TestCase
    func testNode_06_03(): Unit {
        var doc = Html4cj.parse("<a href='./one/two.html'>One</a>", "http://example.com")
        var str = doc.select("a").first().getOrThrow()
        let sc = str.absUrl("href")
        @Assert("http://example.com/one/two.html",sc)
    }

    @TestCase
    func testNode_06_04(): Unit {
        var doc = Html4cj.parse("<a HREF='./one/two.html'>One</a>", "http://example.com")
        var str = doc.select("a").first().getOrThrow()
        let sc = str.absUrl("HREF")
        @Assert("http://example.com/one/two.html",sc)
    }

    @TestCase
    func testNode_06_05(): Unit {
        var doc = Html4cj.parse("<a 中文='./one/two.html'>One</a>", "http://example.com")
        var str = doc.select("a").first().getOrThrow()
        let sc = str.absUrl("中文")
        @Assert("http://example.com/one/two.html",sc)
    }

    @TestCase
    func testNode_06_06(): Unit {
        var doc = Html4cj.parse("<a %#&='./one/two.html'>One</a>", "http://example.com")
        var str = doc.select("a").first().getOrThrow()
        let sc = str.absUrl("%#&")
        @Assert("http://example.com/one/two.html",sc)
    }

    @TestCase
    func testNode_06_07(): Unit {
        var returntag = -1
        var doc = Html4cj.parse("<a os='./one/two.html'>One</a>", "http://example.com")
        var str = doc.select("a").first().getOrThrow()
        try {
            str.absUrl("")
        } catch (e: ValidationException) {
            @Assert(e.toString().contains("String must not be empty"), true)
            returntag = 1
        }
        @Assert(1,returntag)
    }

    @TestCase
    func testNode_06_08(): Unit {
        var doc = Html4cj.parse("<a os='./one/two.html'>One</a>", "http://example.com")
        var str = doc.select("a").first().getOrThrow()
        let sc = str.absUrl("op")
        @Assert("",sc)
    }
}
