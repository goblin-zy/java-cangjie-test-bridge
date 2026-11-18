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
    var boolRes: Bool = false
    var returnFlag: Int64 = -1

    @TestCase
    func testDocumentOutputSettings_outline_01(): Unit {
        // 未经设置，得到为false
        boolRes = ins_1.outline()
        @Assert(boolRes, false)
        var ins_2: DocumentOutputSettings = ins_1.clone()
        ins_2 = ins_1.outline(12 > 3) // true
        @Assert(ins_2.outline(),true)
        ins_2 = ins_1.outline(false)
        @Assert(ins_2.outline() == false, true)
        var QuirksMode_1: QuirksMode = QuirksMode.quirks
        var QuirksMode_2: QuirksMode = QuirksMode.limitedQuirks
        var QuirksMode_3: QuirksMode = QuirksMode.quirks
        @Assert(QuirksMode_1 == QuirksMode_3, true)
        @Assert(QuirksMode_1 != QuirksMode_2, true)
        @Assert(QuirksMode_1.toString(),"quirks" )
    }
}
