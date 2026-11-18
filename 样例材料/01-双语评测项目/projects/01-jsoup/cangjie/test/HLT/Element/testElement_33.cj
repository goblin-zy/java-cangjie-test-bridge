// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

@Test
public class NodeTest {
    @TestCase
    func testElement_33_01(): Unit {
        let cou = "<div data-one=1 data-two=2 id=1><p data-one=3 id=2>Text</div><div>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("div").first().getOrThrow()
        let sc = str.getElementsByAttributeStarting(" data- ")
        @Assert(sc.toString().contains("data-one=\"3\""),true)
        @Assert(110,sc.toString().toRuneArray().size)
    }

    @TestCase
    func testElement_33_02(): Unit {
        let cou = "<div /mvp=1 data-two=2 id=1><p data-one=3 id=2>Text</div><div>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("div").first().getOrThrow()
        let sc = str.getElementsByAttributeStarting("/m")
        @Assert(0,sc.toString().toRuneArray().size)
    }

    @TestCase
    func testElement_33_03(): Unit {
        let cou = "<div DAONE=1 data-two=2 id=1><p data-one=3 id=2>Text</div><div>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("div").first().getOrThrow()
        let sc = str.getElementsByAttributeStarting("DAONE")
        @Assert(sc.toString().contains("<div daone=\"1\" data-two=\"2\" id"),true)
        @Assert(75,sc.toString().toRuneArray().size)
    }

    @TestCase
    func testElement_33_04(): Unit {
        let cou = "<div DAONE=1 data-two=2 id=1><p data-one=3 id=2>Text</div><div>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("div").first().getOrThrow()
        let sc = str.getElementsByAttributeStarting("op")
        @Assert(0,sc.toString().toRuneArray().size)
    }

    @TestCase
    func testElement_33_05(): Unit {
        let cou = "<div DAONE=1 data-two=2 id=1><p data-one=3 id=2>Text</div><div>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("div").first().getOrThrow()
        var returntag = -1
        try {
            str.getElementsByAttributeStarting("")
        } catch (e: ValidationException) {
            @Assert(e.toString().contains("String must not be empty"), true)
            returntag = 1
        }
        @Assert(1,returntag)
    }

    @TestCase
    func testElement_33_06(): Unit {
        let cou = "<div 你好=1 data-two=2 id=1><p data-one=3 id=2>Text</div><div>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("div").first().getOrThrow()
        let sc = str.getElementsByAttributeStarting("你好")
        @Assert(sc.toString().contains("<div 你好=\"1\" data-two=\"2\" "),true)
        @Assert(72,sc.toString().toRuneArray().size)
    }

    @TestCase
    func testElement_33_07(): Unit {
        let cou = "<div /#￥=1 data-two=2 id=1><p data-one=3 id=2>Text</div><div>"
        var doc = Html4cj.parse(cou)
        var str = doc.select("div").first().getOrThrow()
        let sc = str.getElementsByAttributeStarting("/#￥")
        @Assert(0,sc.toString().toRuneArray().size)
    }
}
