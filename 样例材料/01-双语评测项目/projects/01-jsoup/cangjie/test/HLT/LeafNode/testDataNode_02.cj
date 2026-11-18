// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

@Test
public class ParserTest {
    @TestCase
    func testDataNode_02_01(): Unit {
        let datas = DataNode("#dataHello Cang!@#$%^&*()_+:<>?|jie Lang")
        let src = datas.setWholeData("*-*#$^--------")
        @Assert(14,src.toString().toRuneArray().size)
    }

    @TestCase
    func testDataNode_02_02(): Unit {
        let datas = DataNode("#dataHello Cang!@#$%^&*()_+:<>?|jie Lang")
        let src = datas.setWholeData("")
        @Assert(0,src.toString().toRuneArray().size)
    }

    @TestCase
    func testDataNode_02_03(): Unit {
        let datas = DataNode("#dataHello Cang!@#$%^&*()_+:<>?|jie Lang")
        let src = datas.setWholeData("Hello Cangjie Lang\n")
        @Assert(19,src.toString().toRuneArray().size)
    }

    @TestCase
    func testDataNode_02_04(): Unit {
        let datas = DataNode("#dataHello Cang!@#$%^&*()_+:<>?|jie Lang")
        let src = datas.setWholeData("你好仓颉！【】")
        @Assert(7,src.toString().toRuneArray().size)
    }
}
