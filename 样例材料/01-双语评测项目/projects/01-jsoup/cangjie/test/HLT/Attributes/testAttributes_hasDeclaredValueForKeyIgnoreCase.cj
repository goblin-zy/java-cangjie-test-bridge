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
    var resBool: Bool = false
    var returnFlag: Int64 = 0
    var str1 = sourceDataIns.getLargeString(500)
    var attr1: Attribute = Attribute("Attribute_K1", "Attribute_V1")
    var attr2: Attribute = Attribute("中文键", "At{?>}tribute_V2")
    var attr3: Attribute = Attribute("Att\\nribute_K1", "%<test>%")
    var attr4: Attribute = Attribute("str1", "start:>${str1}")
    var attr5: Attribute = Attribute("data-key", "data_data")
    var attr6: Attribute = Attribute("/-key", "内部键")
    var attr7: Attribute = Attribute("属性值为None", None)

    @TestCase
    func testAttributes_hasDeclaredValueForKeyIgnoreCase_01(): Unit {
        ins_1.put(attr1)
        ins_1.put(attr2)
        ins_1.put(attr3)
        ins_1.put(attr4)
        ins_1.put(attr5)
        ins_1.put(attr6)
        @Assert(ins_1.dataSize, 1)
        @Assert(ins_1.size, 6)
        resBool = ins_1.hasDeclaredValueForKeyIgnoreCase("Attribute_K1")
        @Assert(resBool, true)
        resBool = ins_1.hasDeclaredValueForKeyIgnoreCase("中文键")
        @Assert(resBool, true)
        resBool = ins_1.hasDeclaredValueForKeyIgnoreCase("sTR1")
        @Assert(resBool, true)
        resBool = ins_1.hasDeclaredValueForKeyIgnoreCase("DATA-KEY")
        @Assert(resBool, true)
        ins_1.put("属性值为None", None)
        @Assert(ins_1.size, 7)
        resBool = ins_1.hasDeclaredValueForKeyIgnoreCase("属性值为None")
        @Assert(resBool, false)
        try {
            resBool = ins_1.hasDeclaredValueForKeyIgnoreCase("/-key")
        } catch (e1: NoneValueException) {
            returnFlag = 1
        }
        @Assert(resBool, true)
        try {
            resBool = ins_1.hasDeclaredValueForKeyIgnoreCase("KEY_NOTEXIST") // key不存在，业务不配置显式异常
        } catch (e2: NoneValueException) {
            returnFlag = 2
        }
        @Assert(resBool, false)
        @Assert(returnFlag, 0)
    }
}
