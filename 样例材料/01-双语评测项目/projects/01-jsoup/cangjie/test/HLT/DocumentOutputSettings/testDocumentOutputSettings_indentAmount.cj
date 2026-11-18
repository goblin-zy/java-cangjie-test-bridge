// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
//dependence:../util_test/createsourcedata.cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*
import std.math.*

@Test
public class DocumentOutputSettingsTest {
    let ins_1: DocumentOutputSettings = DocumentOutputSettings()
    let sourceDataIns: SourceData = SourceData()
    var intRes: Int64 = -1
    var returnFlag: Int64 = -1

    @TestCase
    func testDocumentOutputSettings_indentAmount_01(): Unit {
        intRes = ins_1.indentAmount()
        @Assert(intRes, 1)
        var ins_2: DocumentOutputSettings = ins_1.clone()
        @Assert(ins_2.indentAmount(), 1)
        ins_2 = ins_1.indentAmount(0)
        @Assert(ins_2.indentAmount(),0)
        ins_2 = ins_1.indentAmount(1)
        @Assert(ins_2.indentAmount(),1)
        ins_2 = ins_1.indentAmount(30)
        @Assert(ins_2.indentAmount(),30)
        ins_2 = ins_1.indentAmount(500) // 业务不对indentAmount设置上限
        @Assert(ins_2.indentAmount(),500)
    }

    @TestCase
    func testDocumentOutputSettings_indentAmount_02(): Unit {
        let ins_21: DocumentOutputSettings = DocumentOutputSettings()
        var ins_22: DocumentOutputSettings = ins_21.clone()
        @Assert(ins_22.indentAmount(), 1)
        try {
            ins_22 = ins_21.indentAmount(-1)
        } catch (e1: ValidationException) {
            @Assert(e1.toString().contains("ValidationException: Must be true"), true)
            returnFlag = 0
        }
        try {
            ins_22 = ins_21.indentAmount(Int64.Max) 
        } catch (e2: IllegalArgumentException) {
            returnFlag = 1
        }
        @Assert(ins_22.indentAmount(),Int64.Max)
        @Assert(returnFlag,0)
    }
}
