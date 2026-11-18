// 3rd_party_lib:html4cj/build/html4cj
// 3rd_party_lib_ohos:html4cj/build/aarch64-linux-ohos/html4cj
//dependence:../util_test/createsourcedata.cj
import cangjie_tpc::html4cj.*
import std.unittest.*
import std.collection.*

@Test
public class TagTest {
    let settings_1: ParseSettings = ParseSettings.htmlDefault
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
    func testTag_combination_01(): Unit {
        var tagIns1: Tag = Tag.valueOf(" Bo dy ", settings_1)
        var tagIns2: Tag = Tag.valueOf("中文_|<t ag>", settings_1)
        var tagIns3: Tag = Tag.valueOf(str1, settings_2)
        var tagIns4: Tag = Tag.valueOf(str2, settings_3)
        boolRes = tagIns1.isBlock()
        @Assert(boolRes, false)
        boolRes = tagIns2.formatAsBlock()
        @Assert(boolRes, true)
        boolRes = tagIns3.isInline()
        @Assert(boolRes, true)
        boolRes = tagIns4.isBlock()
        @Assert(boolRes, false)
        boolRes = tagIns1.isEmpty()
        @Assert(boolRes, false)
        boolRes = tagIns3.isSelfClosing()
        @Assert(boolRes, false)
        boolRes = tagIns2.isKnownTag()
        @Assert(boolRes, false)
        boolRes = tagIns4.preserveWhitespace()
        @Assert(boolRes, false)
        boolRes = tagIns3.isFormListed()
        @Assert(boolRes, false)
        boolRes = tagIns2.isFormSubmittable()
        @Assert(boolRes, false)
    }

    @TestCase
    func testTag_combination_02(): Unit {
        var tagIns1: Tag = Tag.valueOf(" Bo dy ")
        var tagIns2: Tag = Tag.valueOf("中文_|<t ag>")
        var tagIns3: Tag = Tag.valueOf(str1)
        var tagIns4: Tag = Tag.valueOf(str2)
        boolRes = tagIns1.isBlock()
        @Assert(boolRes, false)
        boolRes = tagIns3.formatAsBlock()
        @Assert(boolRes, true)
        boolRes = tagIns3.isInline()
        @Assert(boolRes, true)
        boolRes = tagIns4.isBlock()
        @Assert(boolRes, false)
        boolRes = tagIns2.isEmpty()
        @Assert(boolRes, false)
        boolRes = tagIns3.isSelfClosing()
        @Assert(boolRes, false)
        boolRes = tagIns1.isKnownTag()
        @Assert(boolRes, false)
        boolRes = tagIns4.preserveWhitespace()
        @Assert(boolRes, false)
        boolRes = tagIns2.isFormListed()
        @Assert(boolRes, false)
        boolRes = tagIns3.isFormSubmittable()
        @Assert(boolRes, false)
    }

    @TestCase
    func testTag_combination_03(): Unit {
        returnFlag = -1
        try {
            Tag.valueOf(" ")
        } catch (e1: ValidationException) {
            @Assert(e1.toString().contains("String must not be empty"), true)
            returnFlag = 0
        }
        var tagIns1: Tag = Tag.valueOf("$#$@#%#^%|?>")
        var tagIns2: Tag = Tag.valueOf("   f{【】*&^g ")
        var tagIns3: Tag = Tag.valueOf("\"/-\"")
        var tagIns4: Tag = Tag.valueOf("data-")
        boolRes = tagIns4.isBlock()
        @Assert(boolRes, false)
        boolRes = tagIns1.formatAsBlock()
        @Assert(boolRes, true)
        boolRes = tagIns3.isInline()
        @Assert(boolRes, true)
        boolRes = tagIns2.isBlock()
        @Assert(boolRes, false)
        boolRes = tagIns1.isEmpty()
        @Assert(boolRes, false)
        boolRes = tagIns4.isSelfClosing()
        @Assert(boolRes, false)
        boolRes = tagIns2.isKnownTag()
        @Assert(boolRes, false)
        boolRes = tagIns4.preserveWhitespace()
        @Assert(boolRes, false)
        boolRes = tagIns3.isFormListed()
        @Assert(boolRes, false)
        boolRes = tagIns2.isFormSubmittable()
        @Assert(boolRes, false)
    }

    @TestCase
    func testTag_combination_04(): Unit {
        returnFlag = -1
        var tagArr: Array<String> = [
            "html",
            "head",
            "body",
            "frameset",
            "script",
            "noscript",
            "style",
            "meta",
            "link",
            "strong",
            "dfn",
            "code",
            "samp",
            "kbd",
            "meta",
            "link",
            "base",
            "frame",
            "img",
            "br",
            "wbr",
            "embed",
            "p",
            "h1",
            "h2",
            "button",
            "fieldset",
            "input",
            "keygen",
            str1,
            str2,
            "data-key",
            "/innerKey"
        ]
        var resStr: String = ""
        for (i in 0..tagArr.size) {
            resStr += "${Tag.checkKnownTag(tagArr[i]).toString()} >> "
        }
        var baseStr: String = """
                          true >> true >> true >> true >> true >> true >> true >> true >> true >> true >> true >> true >> true >> true >> true >> true >> true >> true >> true >>
                          true >> true >> true >> true >> true >> true >> true >> 
                          true >> true >> true >> false >> false >> false >> false >>
                        """

        @Assert(sourceDataIns.parseString(resStr),sourceDataIns.parseString(baseStr))
    }
}
