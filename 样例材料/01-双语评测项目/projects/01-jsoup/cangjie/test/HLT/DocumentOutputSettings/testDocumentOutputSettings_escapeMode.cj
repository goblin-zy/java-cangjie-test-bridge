// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
//dependence:../util_test/createsourcedata.cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

@Test
public class DocumentOutputSettingsTest {
    let ins_1: DocumentOutputSettings = DocumentOutputSettings()
    var strRes: String = ""
    var returnFlag: Int64 = -1

    @TestCase
    func testDocumentOutputSettings_escapeMode_01(): Unit {
        // 未经设置，获取文档的当前HTML转义模式
        var escapeMode_1: EscapeMode = ins_1.escapeMode()
        strRes = escapeMode_1.toString()
        @Assert(strRes, "base")
        var ins_2: DocumentOutputSettings = DocumentOutputSettings()
        ins_2 = ins_1.escapeMode(EscapeMode.xhtml)
        @Assert(escapeMode_1 == base, true)
        @Assert(escapeMode_1 != EscapeMode.xhtml, true)
        strRes = ins_2.escapeMode().toString()
        @Assert(strRes, "xhtml")
        escapeMode_1 = ins_1.escapeMode(EscapeMode.extended).escapeMode()
        @Assert(escapeMode_1 != extended, false)
        @Assert(escapeMode_1 == EscapeMode.xhtml, false)
        @Assert(escapeMode_1.toString(), "extended")
    }
}
