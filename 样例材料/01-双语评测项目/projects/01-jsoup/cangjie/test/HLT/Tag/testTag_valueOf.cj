// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
//dependence:../util_test/createsourcedata.cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

@Test
public class TagTest {
    let settings_1: ParseSettings = ParseSettings.htmlDefault // ParseSettings(false, false)
    let settings_2: ParseSettings = ParseSettings(true, false)
    let settings_3: ParseSettings = ParseSettings(true, true)
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
    func testTag_valueOf_01(): Unit {
        var tagIns1: Tag = Tag.valueOf(" Bo dy ", settings_1)
        var tagIns2: Tag = Tag.valueOf("中文_|<t ag>", settings_1)
        var tagIns3: Tag = Tag.valueOf(str1, settings_2)
        var tagIns4: Tag = Tag.valueOf(str2, settings_3)
        strRes = tagIns1.toString()
        @Assert(strRes, "bo dy")
        strRes = tagIns2.toString()
        @Assert(strRes, "中文_|<t ag>")
        strRes = tagIns3.toString()
        @Assert(sourceDataIns.parseString(strRes),"Cangjie你好")
        strRes = tagIns4.toString()
        @Assert(sourceDataIns.parseString(strRes),"Cangjie\\f你好")
        strRes = tagIns1.getName()
        @Assert(strRes, "bo dy")
        strRes = tagIns2.getName()
        @Assert(strRes, "中文_|<t ag>")
        strRes = tagIns3.normalName()
        @Assert(sourceDataIns.parseString(strRes),"cangjie你好")
        strRes = tagIns4.normalName()
        @Assert(sourceDataIns.parseString(strRes),"cangjie\\f你好")
    }

    @TestCase
    func testTag_valueOf_02(): Unit {
        var tagIns1: Tag = Tag.valueOf(" Bo dy ")
        var tagIns2: Tag = Tag.valueOf("中文_|<t ag>")
        var tagIns3: Tag = Tag.valueOf(str1)
        var tagIns4: Tag = Tag.valueOf(str2)
        @Assert(tagIns1.getName(), "Bo dy")
        @Assert(tagIns1.normalName(), "bo dy")
        @Assert(tagIns2.toString(), "中文_|<t ag>")
        @Assert(tagIns2.getName(), "中文_|<t ag>")
        @Assert(tagIns2.getName(), "中文_|<t ag>")
        @Assert(sourceDataIns.parseString(tagIns4.getName()), "Cangjie\\f你好")
        @Assert(sourceDataIns.parseString(tagIns3.toString()), "Cangjie你好")
    }

    @TestCase
    func testTag_valueOf_03(): Unit {
        try {
            Tag.valueOf(" ")
        } catch (e1: ValidationException) {
            @Assert(e1.toString().contains("String must not be empty"), true)
            returnFlag = 0
        }
    }
}
