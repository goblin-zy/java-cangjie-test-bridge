// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

@Test
public class AttributeTest {
    let ins_1: Attribute = Attribute("Attribute_K1", "中文值【哈喽！】", Attributes())
    var strRes: String = ""
    var returnFlag: Int64 = -1

    @TestCase
    func testAttribute_toString_01(): Unit {
        strRes = ins_1.getValue()
        @Assert(strRes, "中文值【哈喽！】")
        strRes = ins_1.toString()
        @Assert(strRes, "Attribute_K1=\"中文值【哈喽！】\"")
    }

    @TestCase
    func testAttribute_toString_02(): Unit {
        let ins_2: Attribute = Attribute("Attribute_K1", None, Attributes())
        var resBool: Bool = ins_2.hasDeclaredValue()
        @Assert(resBool, false)
        ins_2.setValue(Option<String>.Some("Attribute_V1"))
        resBool = ins_2.hasDeclaredValue()
        @Assert(resBool, true)
        strRes = ins_2.toString()
        @Assert(strRes, "Attribute_K1=\"Attribute_V1\"")
    }

    @TestCase
    func testAttribute_toString_03(): Unit {
        var attrs: Attributes = Attributes().put("Attributes_中文键", "hello C昂捷")
        let ins_3: Attribute = Attribute("Attribute_K1", Option<String>.Some("Attribute_V1"), attrs)
        var resBool: Bool = ins_3.hasDeclaredValue()
        @Assert(resBool, true)
        strRes = ins_3.toString()
        ins_3.setValue(Option<String>.Some("Word !"))
        strRes = ins_3.toString()
        @Assert(strRes, "Attribute_K1=\"Word !\"")
    }

    @TestCase
    func testAttribute_toString_04(): Unit {
        let ins_3: Attribute = Attribute("Attribute_K1", Option<String>.Some("Attribute_V1"))
        var resBool: Bool = ins_3.hasDeclaredValue()
        @Assert(resBool, true)
        strRes = ins_3.toString()
        @Assert(strRes, "Attribute_K1=\"Attribute_V1\"")
        ins_3.setValue(Option<String>.Some("Word !"))
        strRes = ins_3.toString()
        @Assert(strRes, "Attribute_K1=\"Word !\"")
        ins_3.setKey("setKey: key_new1")
        strRes = ins_3.toString()
        @Assert(strRes, "setKey: key_new1=\"Word !\"")
    }
}
