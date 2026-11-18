package cangjie_tpc::html4cj

@Test
public class AttributeTest {
    @TestCase
    public func htmlTest(): Unit {
        // 1
        let attr: Attribute = Attribute("key", "value &")
        @Assert("key=\"value &amp;\"", attr.html())
        @Assert(attr.html(), attr.toString())

        println("Pass1")
    }

    @TestCase
    public func testWithSupplementaryCharacterInAttributeKeyAndValue(): Unit {
        // 2
        var s: String = String("${'\u{210C1}'}")
        var attr: Attribute = Attribute(s, "A" + s + "B")
        @Assert(s + "=\"A" + s + "B\"", attr.html())
        @Assert(attr.html(), attr.toString())

        println("Pass2")
    }

    @TestCase
    public func validatesKeysNotEmpty(): Unit {
        // 3
        var threw: Bool = false
        try {
            Attribute(" ", "Check")
        } catch (validationException: ValidationException) {
            threw = true
        }
        @Assert(threw, true)

        println("Pass3")
    }

    @TestCase
    public func validatesKeysNotEmptyViaSet(): Unit {
        // 4
        var threw: Bool = false
        try {
            var attr4: Attribute = Attribute("One", "Check")
            attr4.setKey(" ")
        } catch (validationException: ValidationException) {
            threw = true
        }
        @Assert(threw, true)

        println("Pass4")
    }

    @TestCase
    public func booleanAttributesAreEmptyStringValues(): Unit {
        // 5
        var doc: Document = Html4cj.parse("<div hidden>")
        var attributes: Attributes = doc.body().child(0).attributes()
        @Assert("", attributes.get("hidden"))
        var first: Attribute = attributes.iterator().next().getOrThrow()
        @Assert("hidden", first.getKey())
        @Assert("", first.getValue())
        @Assert(first.hasDeclaredValue(), false)
        @Assert(Attribute.isBooleanAttribute(first.getKey()), true)

        println("Pass5")
    }

    @TestCase
    public func settersOnOrphanAttribute(): Unit {
        // 6
        var attr: Attribute = Attribute("one", "two")
        attr.setKey("three")
        var oldVal: String = attr.setValue("four")
        @Assert("two", oldVal)
        @Assert("three", attr.getKey())
        @Assert("four", attr.getValue())
        @Assert(attr.parent, None)

        println("Pass6")
    }

    @TestCase
    public func hasValue(): Unit {
        // 7
        var a1: Attribute = Attribute("one", "")
        var a2: Attribute = Attribute("two", None)
        var a3: Attribute = Attribute("thr", "thr")
        @Assert(a1.hasDeclaredValue(), true)
        @Assert(a2.hasDeclaredValue(), false)
        @Assert(a3.hasDeclaredValue(), true)

        println("Pass7")
    }

    @TestCase
    public func canSetValueToNull(): Unit {
        // 8
        var attr: Attribute = Attribute("one", "val")
        var oldVal: String = attr.setValue(None)
        @Assert("one", attr.html())
        @Assert("val", oldVal)
        oldVal = attr.setValue("foo")

        // string, not null
        @Assert("", oldVal)

        println("Pass8")
    }

    @TestCase
    public func booleanAttributesAreNotCaseSensitive(): Unit {
        // 9
        // https://github.com/jhy/jsoup/issues/1656
        @Assert(Attribute.isBooleanAttribute("required"), true)
        @Assert(Attribute.isBooleanAttribute("REQUIRED"), true)
        @Assert(Attribute.isBooleanAttribute("rEQUIREd"), true)
        @Assert(Attribute.isBooleanAttribute("random string"), false)
        var html: String = "<a href=autofocus REQUIRED>One</a>"
        var doc: Document = Html4cj.parse(html)
        @Assert("<a href=\"autofocus\" required>One</a>", doc.selectFirst("a").getOrThrow().outerHtml())
        var doc2: Document = Html4cj.parse(html, Parser.htmlParser().settings(ParseSettings.preserveCase))
        @Assert("<a href=\"autofocus\" REQUIRED>One</a>", doc2.selectFirst("a").getOrThrow().outerHtml())

        println("Pass9")
    }

    @TestCase
    public func createFromEncodedTest(): Unit {
        // 10
        // var a2: Attribute = Attribute.createFromEncoded("one", "amp")
        // @Assert(a2.getKey(), "one")
        // @Assert(a2.getValue(), "amp")

        // println("Pass10")
    }

    @TestCase
    public func isDataAttributeTest(): Unit {
        // 11
        var a1: Attribute = Attribute("one", "")
        var boolValue: Bool = a1.isDataAttribute()
        @Assert(boolValue, false)

        println("Pass11")
    }

    @TestCase
    public func isDataAttributeValueTest(): Unit {
        // 12
        var a1: Attribute = Attribute("one", "")
        var boolValue: Bool = a1.isDataAttribute("one")
        @Assert(boolValue, false)

        println("Pass12")
    }

    @TestCase
    public func shouldCollapseAttributeTest(): Unit {
        // 13
        var a1: Attribute = Attribute("one", "")
        var boolValue: Bool = a1.shouldCollapseAttribute(DocumentOutputSettings())
        @Assert(boolValue, false)

        println("Pass13")
    }

    @TestCase
    public func hashCodeTest(): Unit {
        // 14
        var a1: Attribute = Attribute("one", "")
        var attribute: Attribute = Attribute("key", "value")
        var attribute2: Attribute = Attribute("key", None)
        @Assert(a1.hashCode(), a1.hashCode())
        @Assert(attribute.hashCode(), attribute.hashCode())
        @Assert(attribute2.hashCode(), attribute2.hashCode())

        println("Pass14")
    }

    @TestCase
    public func cloneTest(): Unit {
        // 15
        var a1: Attribute = Attribute("one", "")
        var a2: Attribute = a1.clone()
        @Assert(a2.getKey(), "one")

        println("Pass15")
    }

    @TestCase
    public func equationTest(): Unit {
        // 16
        var attribute: Attribute = Attribute("key", "value")
        var attribute2: Attribute = Attribute("key", "value")
        @Assert(attribute == attribute2, true)
        @Assert(attribute == Attribute("key", "value"), true)
        @Assert(attribute == Attribute("key1", "value"), false)
        @Assert(attribute == Attribute("key", "value1"), false)
        @Assert(attribute != attribute, false)

        println("Pass16")
    }
}
