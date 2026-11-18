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
    func testDocumentOutputSettings_prettyPrint_01(): Unit {
        // 未经设置，得到为true
        boolRes = ins_1.prettyPrint()
        @Assert(boolRes, true)
        var ins_2: DocumentOutputSettings = ins_1.clone()
        ins_2 = ins_1.prettyPrint(false)
        @Assert(ins_2.prettyPrint() == false, true)
        ins_2 = ins_1.prettyPrint(12 > 3) // true
        @Assert(ins_2.prettyPrint(),true)
    }
}
