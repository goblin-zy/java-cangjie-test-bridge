// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
//dependence:../util_test/createsourcedata.cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

@Test
public class AttributesTest {
    let ins_1: Attributes = Attributes()
    let sourceDataIns: SourceData = SourceData()
    var strRes: String = ""
    var returnFlag: Int64 = 0
    var str1 = sourceDataIns.getLargeString(500)

    @TestCase
    func testAttributes_removeData_01(): Unit {
        ins_1.putData("/cangjie", "data-/cangjie_V")
        ins_1.putData("data-中文键", "你好，山姆")
        ins_1.put("key_test", "你好，山姆")
        strRes = ins_1.getData("data-中文键").getOrThrow()
        ins_1.putData("\"Hello Cangjie\\f Lang", "转义字符")
        @Assert(ins_1.dataSize, 3)
        ins_1.removeData("data-中文键")
        @Assert(ins_1.dataSize, 2)
        ins_1.removeData("/cangjie")
        @Assert(ins_1.dataSize, 1)
        var resBool = ins_1.isEmpty()
        @Assert(resBool, false)
        try {
            ins_1.removeData("\"Hello CANGJIE\\f lang")
        } catch (e1: NoneValueException) {
            returnFlag = 1
        }
        @Assert(ins_1.dataSize, 1)
        resBool = ins_1.isEmpty()
        @Assert(resBool, false)
        ins_1.removeData("\"Hello Cangjie\\f Lang")
        @Assert(ins_1.dataSize, 0)
        @Assert(ins_1.size, 1)
        resBool = ins_1.isEmpty()
        @Assert(resBool, false)
        ins_1.removeData("key_test")
        resBool = ins_1.isEmpty()
        @Assert(resBool, false)
        ins_1.remove("key_test")
        resBool = ins_1.isEmpty()
        @Assert(resBool, true)
        @Assert(returnFlag, 0)
    }
}
