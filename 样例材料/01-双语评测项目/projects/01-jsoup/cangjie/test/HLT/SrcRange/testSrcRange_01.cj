// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

@Test
public class ParserTest {
    @TestCase
    func testSrcRange_01_01(): Unit {
        let srcPositionIns_1: SrcPosition = SrcPosition(0, 0, 0)
        let srcPositionIns_2: SrcPosition = SrcPosition(1, 2, 3)
        let scre = SrcRange(srcPositionIns_1, srcPositionIns_2)
        let datas = DataNode("#dataHello Cang!@#$%^&*()_+:<>?|jie Lang")
        let src = scre.track(datas, true)
        @Assert(2,src.toString().size)
    }

    @TestCase
    func testSrcRange_01_02(): Unit {
        let srcPositionIns_1: SrcPosition = SrcPosition(0, 0, 0)
        let srcPositionIns_2: SrcPosition = SrcPosition(1, 2, 3)
        let scre = SrcRange(srcPositionIns_1, srcPositionIns_2)
        let datas = Comment("你好仓颉！【】")
        let src = scre.track(datas, true)
        @Assert(2,src.toString().size)
    }

    @TestCase
    func testSrcRange_01_03(): Unit {
        let srcPositionIns_1: SrcPosition = SrcPosition(0, 0, 0)
        let srcPositionIns_2: SrcPosition = SrcPosition(1, 2, 3)
        let scre = SrcRange(srcPositionIns_1, srcPositionIns_2)
        let datas = TextNode("  \nHello ")
        let src = scre.track(datas, true)
        @Assert(2,src.toString().size)
    }

    @TestCase
    func testSrcRange_01_04(): Unit {
        let srcPositionIns_1: SrcPosition = SrcPosition(0, 0, 0)
        let srcPositionIns_2: SrcPosition = SrcPosition(1, 2, 3)
        let scre = SrcRange(srcPositionIns_1, srcPositionIns_2)
        let datas = FormElement(Tag.valueOf("from"), "", None)
        let src = scre.track(datas, true)
        @Assert(2,src.toString().size)
    }

    @TestCase
    func testSrcRange_01_05(): Unit {
        let srcPositionIns_1: SrcPosition = SrcPosition(0, 0, 0)
        let srcPositionIns_2: SrcPosition = SrcPosition(1, 2, 3)
        let scre = SrcRange(srcPositionIns_1, srcPositionIns_2)
        let datas = PseudoTextElement(Tag.valueOf("from"), "", Attributes())
        let src = scre.track(datas, true)
        @Assert(2,src.toString().size)
    }
}
