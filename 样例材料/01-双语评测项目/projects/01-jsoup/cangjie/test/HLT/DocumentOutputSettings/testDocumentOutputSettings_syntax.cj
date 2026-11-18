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
    func testDocumentOutputSettings_syntax_01(): Unit {
        // 未经设置输出语法，得到输出语法为 htmlSyntax
        var syntax_1: Syntax = ins_1.syntax()
        strRes = syntax_1.toString()
        @Assert(strRes, "htmlSyntax")
        var ins_2: DocumentOutputSettings = DocumentOutputSettings()
        ins_2 = ins_1.syntax(xmlSyntax)
        @Assert(syntax_1 == htmlSyntax, true)
        @Assert(syntax_1 != xmlSyntax, true)
        strRes = ins_2.syntax().toString()
        @Assert(strRes, "xmlSyntax")
        syntax_1 = ins_1.syntax(Syntax.htmlSyntax).syntax()
        @Assert(syntax_1 != htmlSyntax, false)
        @Assert(syntax_1 == Syntax.xmlSyntax, false)
        @Assert(syntax_1.toString(), "htmlSyntax")
    }
}
