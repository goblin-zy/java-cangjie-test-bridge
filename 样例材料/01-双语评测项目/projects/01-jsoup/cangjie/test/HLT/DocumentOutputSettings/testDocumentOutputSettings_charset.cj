// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
//dependence:../util_test/createsourcedata.cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

@Test
public class DocumentOutputSettingsTest {
    let ins_1: DocumentOutputSettings = DocumentOutputSettings()
    let sourceDataIns: SourceData = SourceData()
    var strRes: String = ""
    var returnFlag: Int64 = -1

    @TestCase
    func testDocumentOutputSettings_escapeMode_01(): Unit {
        // 未经设置字符集，或得到字符集为UTF-8
        strRes = ins_1.charset()
        @Assert(strRes, "UTF-8")
        var ins_2: DocumentOutputSettings = DocumentOutputSettings()
        ins_2 = ins_1.charset("UTF-16") // UTF-8
        @Assert(ins_2.charset() == "UTF-8", true)
        ins_2 = ins_1.charset(sourceDataIns.s2) // s2 = "Hello Cang!@#$%^&*()_+:<>?|jie Lang"
        @Assert(ins_2.charset(),"UTF-8")
        ins_2 = ins_1.charset(sourceDataIns.s5) // s5 = "你好仓颉！【】"
        @Assert(ins_2.charset(),"UTF-8")
        ins_2 = ins_1.charset(sourceDataIns.s7) // s7 多行String
        @Assert(ins_2.charset(),"UTF-8")
        ins_2 = ins_1.charset("\f\"\n") // 转义String
        @Assert(ins_2.charset(),"UTF-8")
        ins_2 = ins_1.charset("") // 空String
        @Assert(ins_2.charset(),"UTF-8")
        ins_2 = ins_1.charset("ASCII") // ASCII
        @Assert(ins_2.charset(),"ASCII")
    }
}
