package cangjie_tpc::html4cj

@Test
public class ParserSettingsTest {
    @TestCase
    public func caseSupport(): Unit {
        // 1
        let bothOn: ParseSettings = ParseSettings(true, true)
        let bothOff: ParseSettings = ParseSettings(false, false)
        let tagOn: ParseSettings = ParseSettings(true, false)
        let attrOn: ParseSettings = ParseSettings(false, true)
        @Assert("IMG", bothOn.normalizeTag("IMG"))
        @Assert("ID", bothOn.normalizeAttribute("ID"))
        @Assert("img", bothOff.normalizeTag("IMG"))
        @Assert("id", bothOff.normalizeAttribute("ID"))
        @Assert("IMG", tagOn.normalizeTag("IMG"))
        @Assert("id", tagOn.normalizeAttribute("ID"))
        @Assert("img", attrOn.normalizeTag("IMG"))
        @Assert("ID", attrOn.normalizeAttribute("ID"))

        println("Pass1")
    }

    @TestCase
    public func attributeCaseNormalization(): Unit {
        // 2
        let parseSettings: ParseSettings = ParseSettings(false, false)
        let normalizedAttribute: String = parseSettings.normalizeAttribute("HIDDEN")
        @Assert("hidden", normalizedAttribute)

        println("Pass2")
    }

    @TestCase
    public func attributesCaseNormalization(): Unit {
        // 3
        let parseSettings: ParseSettings = ParseSettings(false, false)
        let attributes: Attributes = Attributes()
        attributes.put("ITEM", "1")
        let normalizedAttributes: Attributes = parseSettings.normalizeAttributes(attributes).getOrThrow()
        @Assert("item", normalizedAttributes.asList().get(0).getOrThrow().getKey())

        println("Pass3")
    }

    @TestCase
    public func settingCheck(): Unit {
        // 4
        @Assert(false, ParseSettings.htmlDefault.preserveTagCase())
        @Assert(false, ParseSettings.htmlDefault.preserveAttributeCase())
        @Assert(true, ParseSettings.preserveCase.preserveTagCase())
        @Assert(true, ParseSettings.preserveCase.preserveAttributeCase())

        println("Pass4")
    }

    @TestCase
    public func initTest(): Unit {
        // 5
        let parseSettings: ParseSettings = ParseSettings(false, false)
        let parseSettings1: ParseSettings = ParseSettings(parseSettings)
        let normalizedAttribute: String = parseSettings1.normalizeAttribute("HIDDEN")
        @Assert("hidden", normalizedAttribute)
        @Assert("abcdef", ParseSettings.normalName("ABCdef"))

        println("Pass5")
    }
}
