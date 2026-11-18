// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

@Test
public class ParserTest {
    @TestCase
    func testSelector_14_01(): Unit {
        let dic = "<div><table class=x><td>Hello</td></table></div>"
        let sc = Html4cj.parse(dic)
        let src = sc.select("div table[class~=x|y]")
        @Assert(78,src.toString().size)
        @Assert(sc.toString().contains("<table class=\"x\">"),true)
    }

    @TestCase
    func testSelector_14_02(): Unit {
        let dic = "<div><table class=x><td>Hello</td></table></div>"
        let sc = Html4cj.parse(dic)
        let src = sc.selectFirst("div table[class~=x|y]").getOrThrow()
        @Assert(78,src.toString().size)
        @Assert(sc.toString().contains("td>Hello</td>"),true)
    }

    @TestCase
    func testSelector_14_03(): Unit {
        let dic = "<p><img src=foo.png id=1><img src=bar.jpg id=2><img src=qux.JPEG id=3><img src=old.gif id=4></p>"
        let sc = Html4cj.parse(dic)
        let src = sc.select("img[src~=[o]]")
        @Assert(53,src.toString().size)
        @Assert(sc.toString().contains("<p><img src=\"foo.png\""),true)
    }

    @TestCase
    func testSelector_14_04(): Unit {
        let dic = "<p><img src=foo.png id=1><img src=bar.jpg id=2><img src=qux.JPEG id=3><img src=old.gif id=4></p>"
        let sc = Html4cj.parse(dic)
        let src = sc.selectFirst("img[src~=[o]]").getOrThrow()
        @Assert(26,src.toString().size)
        @Assert(sc.toString().contains("id=\"2\"><img src=\"qux.JPEG\""),true)
    }
}
