// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

@Test
public class AttributeTest {
    let ins_1: Attribute = Attribute("Attribute_K1", "中文值【哈喽！】")
    var boolRes: Bool = false
    var returnFlag: Int64 = -1

    @TestCase
    func testAttribute_isBooleanAttribute_01(): Unit {
        boolRes = Attribute.isBooleanAttribute("isBooleanAttribute_false")
        @Assert(boolRes, false)
        boolRes = Attribute.isBooleanAttribute("allowfullscreen") // 此属性名称在HTML5中定义为布尔属性
        @Assert(boolRes, true)
    }

    @TestCase
    func testAttribute_html_02(): Unit {
        var strArr: Array<String> = 
            [
                "allowfullscreen",
                "async",
                "autofocus",
                "checked",
                "compact",
                "declare",
                "default",
                "defer",
                "disabled",
                "formnovalidate",
                "hidden",
                "inert",
                "ismap",
                "itemscope",
                "multiple",
                "muted",
                "nohref",
                "noresize",
                "noshade",
                "novalidate",
                "nowrap",
                "open",
                "readonly",
                "required",
                "reversed",
                "seamless",
                "selected",
                "sortable",
                "truespeed",
                "typemustmatch"
            ]
        
        var count: Int64 = 0
        var intArr: Array<Int64> = Array<Int64>(strArr.size, repeat: -1)
        for (i in 0..strArr.size) {
            boolRes = Attribute.isBooleanAttribute(strArr[i])
            if (!boolRes) {
                intArr[i] = i
                continue
            }
            count += intArr[i]
        }
        @Assert(count, -30)
        var count2: Int64 = 0
        for (j in 0..strArr.size) {
            if (j % 2 == 0) {
                strArr[j] = "Attribute_${j}"
            }
            boolRes = Attribute.isBooleanAttribute(strArr[j])
            if (!boolRes) {
                intArr[j] = j
                count2 += intArr[j]
                continue
            }
        }
        @Assert(count2, 210)
    }
}
