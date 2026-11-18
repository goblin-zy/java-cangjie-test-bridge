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
    func testDocumentOutputSettings_maxPaddingWidth_01(): Unit {
        intRes = ins_1.maxPaddingWidth()
        @Assert(intRes, 30)
        var ins_2: DocumentOutputSettings = ins_1.clone()
        @Assert(ins_2.maxPaddingWidth(), 30)
        ins_2 = ins_1.maxPaddingWidth(0)
        @Assert(ins_2.maxPaddingWidth(),0)
        ins_2 = ins_1.maxPaddingWidth(1)
        @Assert(ins_2.maxPaddingWidth(),1)
        ins_2 = ins_1.maxPaddingWidth(69)
        @Assert(ins_2.maxPaddingWidth(),69)
        ins_2 = ins_1.maxPaddingWidth(500) // 业务不对maxPaddingWidth设置上限
        @Assert(ins_2.maxPaddingWidth(),500)
    }

    @TestCase
    func testDocumentOutputSettings_maxPaddingWidth_02(): Unit {
        let ins_21: DocumentOutputSettings = DocumentOutputSettings()
        var ins_22: DocumentOutputSettings = ins_21.clone()
        @Assert(ins_22.maxPaddingWidth(), 30)
        try {
            ins_22 = ins_21.maxPaddingWidth(-1) // -1 为业务特殊值
        } catch (e1: IllegalArgumentException) {
            returnFlag = 1
        }
        @Assert(ins_22.maxPaddingWidth(), -1)
        try {
            ins_22 = ins_21.maxPaddingWidth(-6)
        } catch (e2: ValidationException) {
            @Assert(e2.toString().contains("Must be true"), true)
            returnFlag = 0
        }
        try {
            ins_22 = ins_21.maxPaddingWidth(Int64.Max) // 9223372036854775807
        } catch (e3: IllegalArgumentException) {
            returnFlag = 2
        }
        @Assert(ins_22.maxPaddingWidth(),Int64.Max)
        @Assert(returnFlag,0)
    }
}
