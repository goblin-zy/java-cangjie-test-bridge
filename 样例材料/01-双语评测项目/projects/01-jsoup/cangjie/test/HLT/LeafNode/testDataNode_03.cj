// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

@Test
public class ParserTest {
    @TestCase
    func testDataNode_03_01(): Unit {
        let datas = DataNode("<head> <meta charset=\"utf-16\"> <title>SoupTest</title> </head> </html>")
        let src = datas.clone()
        @Assert(70,src.toString().toRuneArray().size)
    }

    @TestCase
    func testDataNode_03_02(): Unit {
        let datas = DataNode(
            "<!DOCTYPE html> <html> <head> <script language=\"javascript\"> document.location = \"http://www.baidu.com\"; </script> </head> </html>"
        )
        let src = datas.clone()
        @Assert(130,src.toString().toRuneArray().size)
    }

    @TestCase
    func testDataNode_03_03(): Unit {
        let datas = DataNode("你好仓颉！【】")
        let src = datas.clone()
        @Assert(7,src.toString().toRuneArray().size)
    }

    @TestCase
    func testDataNode_03_04(): Unit {
        let datas = DataNode("Hello Cangjie Lang\n")
        let src = datas.clone()
        @Assert(19,src.toString().toRuneArray().size)
    }
}
