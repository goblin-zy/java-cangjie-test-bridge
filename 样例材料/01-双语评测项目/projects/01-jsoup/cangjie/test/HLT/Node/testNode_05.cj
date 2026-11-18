// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

@Test
public class NodeTest {
    @TestCase
    func testNode_05_01(): Unit {
        var tag: Tag = Tag.valueOf("div")
        var noBase: Element = Element(tag, "")
        noBase.attr("foo", "bar")
        noBase.clearAttributes()
        @Assert(0, noBase.attributesSize())
    }

    @TestCase
    func testNode_05_02(): Unit {
        var tag: Tag = Tag.valueOf("div")
        var noBase: Element = Element(tag, "")
        noBase.attr("foo", "bar")
        noBase.attr("FOO", "DE")
        noBase.attr("中文", "￥")
        noBase.attr("￥%", "中文")
        noBase.attr("/n/", "qa")
        noBase.attr("", "b")
        noBase.attr("data-", "/n")
        noBase.attr("/666", "")
        noBase.attr("/n", "")
        noBase.attr("abs:666", "")
        noBase.clearAttributes()
        @Assert(0, noBase.attributesSize())
    }

    @TestCase
    func testNode_05_03(): Unit {
        var tag: Tag = Tag.valueOf("div")
        var noBase: Element = Element(tag, "")
        let src = noBase.baseUri()
        @Assert("", src)
    }

    @TestCase
    func testNode_05_04(): Unit {
        var doc = Html4cj.parse("<div id=1 class=one><p id=2 class=two>One", "http://example.com/")
        var d = doc.selectFirst("div").getOrThrow()
        let src = d.baseUri()
        @Assert("http://example.com/", src)
    }

    @TestCase
    func testNode_05_05(): Unit {
        var doc = Html4cj.parse("<div id=1 class=one><p id=2 class=two>One", "http://example.com/")
        var d = doc.selectFirst("div").getOrThrow()
        d.setBaseUri("http://foo/2/")
        @Assert("http://foo/2/", d.baseUri())
        d.setBaseUri("HTTP://FOO/2/")
        @Assert("HTTP://FOO/2/", d.baseUri())

        d.setBaseUri("$%#&中午")
        @Assert("$%#&中午", d.baseUri())
        d.setBaseUri("")
        @Assert("", d.baseUri())
        let sc: String =
            "https://www.google.com/search?as_q=you+have+to+write+a+really+really+long+search+to+get+to+2000+characters.+like+seriously%2C+you +have+no+idea+how+long+it+has+to+be&as_epq=2000+characters+is+absolutely+freaking+enorous。+You+can+fit+soooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo+2000+字符+绝对+绝对+吓人+巨大+是+绝对+2000+字符。 +我的+手+累了+累了+打字+这个+很多+字符。+我+做了%27t+甚至+实现+如何+长+它+过去+去+去+拿+去+打字+他们+ all.&as_oq=Argh!+So+many+characters.+I%27m+bored+now%2C+so+I%27ll+just+copy+and+paste.+I%27m+bored+now%2C+so +I%27ll+just+copy+and+paste.I%27m+bored+now%2C+so+I%27ll+just+copy+and+paste.I%27m+bored+now%2C+so+I %27ll+just+copy+and+paste.I%27m+bored+now%2C+so+I%27ll+just+copy+and+paste.I%27m+bored+now%2C+so+I%27ll +just+copy+and+paste.I%27m+无聊+现在%2C+so+I%27ll+just+copy+and+paste。I%27m+无聊+现在%2C+so+I%27ll+just+copy+and+paste.I%27m+无聊+now%2C+so+I%27ll+just+copy+and+paste.I% 27m+无聊+现在%2C+so+I%27ll+just+copy+and+paste.I%27m+无聊+now%2C+so+I%27ll+just+copy+and+paste.I%27m+无聊+现在%2C+so+I%27ll+just+copy+and+paste.I%27m+无聊+now%2C+so+I%27ll+just+copy+and+paste.I%27m+无聊+现在%2C+so+I%27ll+just+copy+and+paste.I%27m+bored+now%2C+so+I%27ll+just+copy+and+paste.I%27m+bored+now% 2C+so+I%27ll+just+copy+and+paste.I%27m+bored+now%2C+so+I%27ll+just+copy+and+paste.I%27m+bored+now%2C+ so+I%27ll+just+copy+and+paste.I%27m+bored+now%2C+so+I%27ll+just+copy+and+paste.I%27m+bored+now%2C+so+ I%27ll+just+copy+and+paste.I%27m+bored+now%2C+so+I%27ll+just+copy+and+paste.I%27m+bored+now%2C+so+I% 27ll+just+copy+and+paste.I%27m+bored+now%2C+so+I%27ll+just+copy+and+paste.I%27m+bored+now%2C+so+I%27ll+只需+复制+和+粘贴。I%27m+无聊+现在%2C+so+I%27ll+just+copy+and+paste.&as_eq=It+has+to+be+freaking+enormously+freaking+enorous&as_nlo=123&as_nhi=456&lr=lang_hu&cr=countryAD&as_qdr= m&as_sitesearch=stackoverflow.com&as_occt=title&safe=active&tbs=rl%3A1%2Crls%3A0&as_filetype=xls&as_rights=(cc_publicdomain%7Ccc_attribute%7Ccc_sharealike%7Ccc_nonderived).-(cc_noncommercial)&gswl"
        d.setBaseUri(sc)
        @Assert(sc, d.baseUri())
    }
}
