// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

@Test
public class ParserTest {
    @TestCase
    func testSelector_01_01(): Unit {
        let sc = Element("<package><meta>One</meta><opf:meta>Two</opf:meta></package>")
        let src = Selector.select("*", sc)
        @Assert(123,src.toString().size)
        @Assert(sc.toString().contains("<<package><meta>One</meta><opf:meta>Two</opf:meta></package>></<package><meta>One</meta><opf:meta>Two</opf:meta></package>>"),true)
    }

    @TestCase
    func testSelector_01_02(): Unit {
        let sc = Element("<package><meta>One</meta><opf:meta>Two</opf:meta></package>")
        let src = Selector.selectFirst("*", sc).getOrThrow()
        @Assert(123,src.toString().size)
        @Assert(sc.toString().contains("<<package><meta>One</meta><opf:meta>Two</opf:meta></package>></<package><meta>One</meta><opf:meta>Two</opf:meta></package>>"),true)
    }

    @TestCase
    func testSelector_01_03(): Unit {
        let sc = Element("<div><p>Hello</p><p><b>there</b></p></div>")
        let src = Selector.select("*", sc)
        @Assert(89,src.toString().size)
        @Assert(sc.toString().contains("<<div><p>Hello</p><p><b>there</b></p></div>></<div><p>Hello</p><p><b>there</b></p></div>>"),true)
    }

    @TestCase
    func testSelector_01_04(): Unit {
        let sc = Element("<div><p>Hello</p><p><b>there</b></p></div>")
        let src = Selector.selectFirst("*", sc).getOrThrow()
        @Assert(89,src.toString().size)
        @Assert(sc.toString().contains("<<div><p>Hello</p><p><b>there</b></p></div>></<div><p>Hello</p><p><b>there</b></p></div>>"),true)
    }
}
