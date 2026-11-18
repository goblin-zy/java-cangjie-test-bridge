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
    var attr1: Attribute = Attribute("Attribute_K1", "Attribute_V1")
    var attr2: Attribute = Attribute("中文键", "At{?>}tribute_V2")
    var attr3: Attribute = Attribute("Att\\nribute_K1", "%<test>%")
    var attr4: Attribute = Attribute("str1", "start:>${str1}")
    var attr5: Attribute = Attribute("data-key", "data_data")
    var attr6: Attribute = Attribute("/-key", "内部键")

    @TestCase
    func testAttributes_removeIgnoreCase_01(): Unit {
        strRes = ins_1.put(attr1).toString()
        @Assert(strRes.trimAscii(), "Attribute_K1=\"Attribute_V1\"")
        var str2 = ins_1.get("Attribute_K1")
        @Assert(str2, "Attribute_V1")
        ins_1.put(attr2)
        ins_1.put(attr3)
        ins_1.put(attr4)
        ins_1.put(attr5)
        ins_1.put(attr6)
        @Assert(ins_1.dataSize, 1)
        @Assert(ins_1.size, 6)
        ins_1.put(attr6)
        @Assert(ins_1.size, 6)
        ins_1.removeIgnoreCase("Attribute_K1")
        @Assert(ins_1.size, 5)
        ins_1.removeIgnoreCase("中文键")
        @Assert(ins_1.size, 4)
        ins_1.removeIgnoreCase("sTR1")
        @Assert(ins_1.size, 3)
        @Assert(ins_1.dataSize, 1)
        ins_1.removeIgnoreCase("DATA-KEY")
        @Assert(ins_1.size, 2)
        @Assert(ins_1.dataSize, 0)
        try {
            ins_1.removeIgnoreCase("/-key")
        } catch (e1: NoneValueException) {
            returnFlag = 1
        }
        try {
            ins_1.removeIgnoreCase("KEY_NOTEXIST") // key不存在，业务不配置显式异常
        } catch (e2: NoneValueException) {
            returnFlag = 2
        }
        var resBool = ins_1.isEmpty()
        @Assert(resBool, false)
        @Assert(returnFlag, 0)
    }
}
