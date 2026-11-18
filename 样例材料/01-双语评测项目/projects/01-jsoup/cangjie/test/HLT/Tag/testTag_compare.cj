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
    var str1: String = """
                      Cangjie\n 你好
                    """
    var str2: String = ##"
                      Cangjie\f 你好
                    "##
    var returnFlag: Int64 = -1

    @TestCase
    func testTag_compare_01(): Unit {
        var tagIns1: Tag = Tag.valueOf(" Bo dy ", settings_1)
        var tagIns2: Tag = Tag.valueOf("中文_|<t ag>", settings_2)
        var tagIns3: Tag = Tag.valueOf(" Body ", settings_1)
        var tagIns4: Tag = Tag.valueOf(str2, settings_3)
        var tagIns5: Tag = Tag.valueOf(str2, settings_3)
        intRes = tagIns1.hashCode()
        @PowerAssert(intRes!=0)
        boolRes = tagIns1 == tagIns2
        @Assert(boolRes, false)
        @Assert(tagIns4 == tagIns5, true)
        @Assert(tagIns2 != tagIns5, true)
        @Assert(tagIns4.hashCode() == tagIns5.hashCode(), true)
        @Assert(tagIns2.hashCode() == tagIns3.hashCode(), false)
        @Assert(tagIns2.toString(), "中文_|<t ag>")
        @Assert(tagIns4.toString() == tagIns5.toString(), true)
    }

    @TestCase
    func testTag_compare_02(): Unit {
        var tagIns1: Tag = Tag.valueOf(" Bo dy ")
        var tagIns2: Tag = Tag.valueOf("中文_|<t ag>")
        var tagIns3: Tag = Tag.valueOf(" Body ")
        var tagIns4: Tag = Tag.valueOf(str2)
        var tagIns5: Tag = Tag.valueOf(str2)
        intRes = tagIns1.hashCode()
        @PowerAssert(intRes!=0)
        boolRes = tagIns1 == tagIns2
        @Assert(boolRes, false)
        @Assert(tagIns4 == tagIns5, true)
        @Assert(tagIns2 != tagIns5, true)
        @Assert(tagIns4.hashCode() == tagIns5.hashCode(), true)
        @Assert(tagIns2.hashCode() == tagIns3.hashCode(), false)
        @Assert(tagIns2.toString(), "中文_|<t ag>")
        @Assert(tagIns4.toString() == tagIns5.toString(), true)
    }
}
