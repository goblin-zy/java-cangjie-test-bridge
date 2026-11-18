// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

@Test
public class ParserTest {
    @TestCase
    func testDataNode_01_01(): Unit {
        let datas = DataNode("#dataHello Cang!@#$%^&*()_+:<>?|jie Lang")
        let src = datas.nodeName()
        @Assert(5,src.toString().size)
        let src1 = datas.getWholeData()
        @Assert(40,src1.toString().size)
    }

    @TestCase
    func testDataNode_01_02(): Unit {
        let datas = DataNode("")
        let src = datas.nodeName()
        @Assert(5,src.toString().size)
        let src1 = datas.getWholeData()
        @Assert(0,src1.toString().size)
    }

    @TestCase
    func testDataNode_01_03(): Unit {
        let datas = DataNode("#dataHello Cang!@#$%^&*()_+:<>?|jie Lang Hello Cangjie Lang\n")
        let src = datas.nodeName()
        @Assert(5,src.toString().size)
        let src1 = datas.getWholeData()
        @Assert(60,src1.toString().size)
    }
}
