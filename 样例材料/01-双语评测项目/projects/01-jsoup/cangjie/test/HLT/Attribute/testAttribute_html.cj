// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

@Test
public class AttributeTest {
    let ins_1: Attribute = Attribute("Attribute_K1", "中文值【哈喽！】")
    var strRes: String = ""

    @TestCase
    func testAttribute_html_01(): Unit {
        strRes = ins_1.getValue()
        @Assert(strRes, "中文值【哈喽！】")
        strRes = ins_1.html()
        @Assert(strRes, "Attribute_K1=\"中文值【哈喽！】\"")
    }

    @TestCase
    func testAttribute_html_02(): Unit {
        var resBool: Bool = ins_1.hasDeclaredValue()
        @Assert(resBool, true)
        ins_1.setValue(Option<String>.None)
        resBool = ins_1.hasDeclaredValue()
        @Assert(resBool, false)
        strRes = ins_1.html() // Attribute_K1
        @Assert(strRes, "Attribute_K1")
    }
}
