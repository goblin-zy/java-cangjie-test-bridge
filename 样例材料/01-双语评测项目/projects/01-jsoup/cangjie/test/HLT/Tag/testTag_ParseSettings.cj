// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
//dependence:../util_test/createsourcedata.cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

@Test
public class TagTest {
    let settings_1: ParseSettings = ParseSettings.htmlDefault // ParseSettings(false, false)
    let sourceDataIns: SourceData = SourceData()
    var intRes: Int64 = -1
    var boolRes: Bool = false
    var strRes: String = ""
    var str1: String = """
                      Cangjie\n 你好
                    """
    var str2: String = ##"
                      Cangjie\f 你好
                    "##
    var returnFlag: Int64 = -1

    @TestCase
    func testTag_ParseSettings_01(): Unit {
        boolRes = settings_1.preserveTagCase()
        @Assert(boolRes, false)
        boolRes = settings_1.preserveAttributeCase()
        @Assert(boolRes, false)
        strRes = settings_1.normalizeTag(" Body ")
        @Assert(strRes, "body")
        strRes = settings_1.normalizeTag(" B od y ") // 标签规范化: 去首尾空白, 大小写转换
        @Assert(strRes, "b od y")
        strRes = settings_1.normalizeTag(str1)
        @Assert(sourceDataIns.parseString(strRes),"cangjie你好")
        strRes = settings_1.normalizeTag(str2)
        @Assert(sourceDataIns.parseString(strRes),"cangjie\\f你好")
        strRes = settings_1.normalizeTag("")
        @Assert(strRes,"")
        strRes = settings_1.normalizeTag("      中文_|<T ag>")
        @Assert(strRes,"中文_|<t ag>")
        strRes = settings_1.normalizeAttribute(" claSs   ")
        @Assert(strRes, "class")
        strRes = settings_1.normalizeAttribute(str2)
        println("strRes_22: ${strRes}")
        @Assert(sourceDataIns.parseString(strRes),"cangjie\\f你好")
        strRes = settings_1.normalizeAttribute("")
        @Assert(strRes,"")
        strRes = settings_1.normalizeAttribute(" $#%^&中文属性 呀 ")
        @Assert(strRes,"$#%^&中文属性 呀")
    }

    @TestCase
    func testTag_ParseSettings_02(): Unit {
        let settings_2: ParseSettings = ParseSettings(true, false)
        let settings_3: ParseSettings = ParseSettings(true, true)
        @Assert(settings_2.preserveTagCase(), true)
        @Assert(settings_2.preserveAttributeCase(), false)
        @Assert(settings_3.preserveTagCase(), true)
        @Assert(settings_3.preserveAttributeCase(), true)
        @Assert(settings_2.normalizeTag(" B od y   "), "B od y")
        @Assert(settings_3.normalizeTag("    B OD Y "), "B OD Y")
        @Assert(settings_2.normalizeAttribute(" B od y   "), "b od y")
        @Assert(settings_3.normalizeAttribute("    B OD Y "), "B OD Y")
    }
}
