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
    var resInt: Int64 = -1
    var str1 = sourceDataIns.getLargeString(500)
    var attr1: Attribute = Attribute("Attribute_K1", "Attribute_V1")
    var attr2: Attribute = Attribute("中文键", "At{?>}tribute_V2")
    var attr3: Attribute = Attribute("Att\\nribute_K1", "%<test>%")
    var attr4: Attribute = Attribute("str1", "start:>${str1}")
    var attr5: Attribute = Attribute("data-key", "data_data")
    var attr6: Attribute = Attribute("/-key", "内部键")

    @TestCase
    func testAttributes_put_ViaAttribute_01(): Unit {
        strRes = ins_1.put(attr1).toString() // 
        @Assert(strRes.trimAscii(), "Attribute_K1=\"Attribute_V1\"")
        var str2 = ins_1.get("Attribute_K1")
        @Assert(str2, "Attribute_V1")
        ins_1.put(attr2)
        ins_1.put(attr3)
        ins_1.put(attr5)
        @Assert(ins_1.dataSize, 1)
        @Assert(ins_1.size, 4)
        ins_1.put(attr6)
        @Assert(ins_1.size, 5)
        ins_1.put(attr4)
        @Assert(ins_1.size, 6)
    }

    @TestCase
    func testAttributes_put_ViaAttribute_02(): Unit {
        let ins_2: Attributes = Attributes()
        strRes = ins_2.put(attr5).toString()
        @Assert(strRes.trimAscii(), "data-key=\"data_data\"")
        @Assert(ins_2.dataSize, 1)
        var attr_1: Attribute = Attribute("data-key", "data-新值")
        strRes = ins_2.put(attr_1).toString() // 替换这条属性，其值为attribute的value
        @Assert(strRes.trimAscii(), "data-key=\"data-新值\"")
        @Assert(ins_2.dataSize, 1)
        attr_1.setValue("setValue: 新值_V1")
        strRes = attr_1.getValue()
        @Assert(strRes, "setValue: 新值_V1")
        strRes = ins_2.put(attr_1).toString()
        @Assert(strRes.trimAscii(), "data-key=\"setValue: 新值_V1\"")
        @Assert(returnFlag, 0)
    }
}
