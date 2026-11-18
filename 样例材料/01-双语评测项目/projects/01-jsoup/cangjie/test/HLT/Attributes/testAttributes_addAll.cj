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
    func testAttributes_addAll_01(): Unit {
        let attrs_1: Attributes = Attributes()
        ins_1.put(attr1)
        attrs_1.addAll(ins_1)
        @Assert(attrs_1.size, 1)
        @Assert(attrs_1.dataSize, 0)
        ins_1.put(attr5)
        attrs_1.addAll(ins_1)
        @Assert(attrs_1.dataSize, 1)
        @Assert(attrs_1.size, 2)
        strRes = attrs_1.toString()
        @Assert(strRes.trimAscii(), "Attribute_K1=\"Attribute_V1\" data-key=\"data_data\"")
        attrs_1.addAll(Attributes())
        @Assert(attrs_1.size, 2)
        ins_1.put(attr2)
        ins_1.put(attr3)
        ins_1.put(attr4)
        ins_1.put(attr6)
        attrs_1.addAll(ins_1)
        @Assert(attrs_1.size, 5)
        @Assert(attrs_1.dataSize, 1)
    }

    @TestCase
    func testAttributes_addAll_02(): Unit {
        returnFlag = -1
        let ins_2: Attributes = Attributes()
        let attrs_2: Attributes = Attributes()
        let it_1 = attrs_2.iterator()
        try {
            it_1.next().getOrThrow()
        } catch (e1: NoneValueException) {
            @Assert(e1.toString().contains("NoneValueException"), true)
            returnFlag = 0
        }
        for (i in 0..200) {
            ins_2.put(Attribute("Key_${i}", "value_${i}"))
        }
        @Assert(ins_2.size, 200)
        attrs_2.addAll(ins_2)
        @Assert(attrs_2.size, 200)
        strRes = attrs_2.get("Key_198")
        @Assert(strRes, "value_198")
        let it_2 = attrs_2.iterator()
        var strR1 = ""
        for (i in 0..attrs_2.size) {
            try {
                strR1 += it_2.next().getOrThrow().toString()
            } catch (e1: NoneValueException) {
                returnFlag = i
                continue
            }
        }
        @Assert(strR1.toRuneArray().size, 3580)
        strRes = attrs_2.get("Key_98")
        @Assert(strRes, "value_98")
        @Assert(returnFlag, 0)
    }
}
