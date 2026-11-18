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
    var res: Int64 = -1

    @TestCase
    func testAttribute_combination_01(): Unit {
        strRes = ins_1.toString()
        @Assert(strRes, "Attribute_K1=\"中文值【哈喽！】\"")
        var hashCode_1 = ins_1.hashCode()
        var attr_1 = ins_1.clone()
        var hashCode_2 = attr_1.hashCode()
        @Assert(hashCode_1 ,hashCode_2) // 
        strRes = attr_1.toString()
        @Assert(strRes, "Attribute_K1=\"中文值【哈喽！】\"")
        @Assert(ins_1 == attr_1 ,true )
        attr_1.setValue(Option<String>.Some("Word !")) //修改属性值后再次判等
        var hashCode_3 = attr_1.hashCode()
        @Assert(hashCode_3 != hashCode_2,true )
        @Assert(ins_1 != attr_1,true )
        @Assert(hashCode_1 ,ins_1.hashCode())
    }

    @TestCase
    func testAttribute_combination_02(): Unit {
        let ins_2: Attribute = Attribute("Attribute_K1", "hello C昂捷", Attributes())
        strRes = ins_2.toString() 
        @Assert(strRes, "Attribute_K1=\"hello C昂捷\"")
        var hashCode_1 = ins_2.hashCode()
        var attr_1 = ins_2.clone()
        var hashCode_2 = attr_1.hashCode()
        @Assert(hashCode_1 ,hashCode_2) // 
        strRes = attr_1.toString()
        @Assert(strRes, "Attribute_K1=\"hello C昂捷\"")
        attr_1.setValue(Option<String>.None) //修改属性值后再次判等
        var hashCode_3 = attr_1.hashCode()
        @Assert(hashCode_3 != hashCode_2,true )
        @Assert(ins_1 != attr_1,true )
        strRes = attr_1.toString()
        @Assert(strRes, "Attribute_K1")
    }
}
