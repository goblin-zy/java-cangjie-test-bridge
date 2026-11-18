// EXEC: cjc %import-path %L %l %f
// EXEC: ./main
import cangjie_tpc::html4cj.*
import std.collection.HashMap
import std.collection.ArrayList
import std.collection.HashMapIterator
import std.unittest.*
import std.unittest.testmacro.*

main(): Int64 {
    let attributesTest: AttributesTest = AttributesTest()

    attributesTest.htmlTest()
    attributesTest.testIteratorRemovable()
    attributesTest.testIteratorUpdateable()
    attributesTest.testIteratorHasNext()
    attributesTest.testIterator()

    attributesTest.testIteratorSkipsInternal()
    attributesTest.testListSkipsInternal()
    attributesTest.htmlSkipsInternals()
    attributesTest.testIteratorEmpty()
    attributesTest.removeCaseSensitive()

    attributesTest.testSetKeyConsistency()
    attributesTest.testBoolean()
    attributesTest.testSizeWhenHasInternal()
    attributesTest.testBooleans()
    attributesTest.booleanNullAttributesConsistent()

    attributesTest.booleanEmptyString()
    attributesTest.booleanCaseInsensitive()
    attributesTest.equalsIsOrderInsensitive()
    attributesTest.cloneAttributes()
    attributesTest.hashCodeTest()

    attributesTest.removeIgnoreCaseTest()
    attributesTest.isEmptyTest()
    attributesTest.putBoolTest()
    attributesTest.putAttributeTest()
    attributesTest.addAllTest()

    attributesTest.dataTest()
    attributesTest.datasetTest()

    return 0
}

@Test
public class AttributesTest {
    @TestCase
    public func htmlTest(): Unit {
        // 1
        var a: Attributes = Attributes()
        a.put("Tot", "a&p")
        a.put("Hello", "There")
        a.put("data-name", "Html4cj")
        @Assert(3, a.size)
        @Assert(a.hasKey("Tot"), true)
        @Assert(a.hasKey("Hello"), true)
        @Assert(a.hasKey("data-name"), true)
        @Assert(a.hasKey("tot"), false)
        @Assert(a.hasKeyIgnoreCase("tot"), true)
        @Assert("There", a.getIgnoreCase("hEllo"))
        @Assert(1, a.dataSize)
        @Assert("Html4cj", a.getData("name").getOrThrow())
        @Assert("", a.get("tot"))
        @Assert("a&p", a.get("Tot"))
        @Assert("a&p", a.getIgnoreCase("tot"))
        @Assert(" Tot=\"a&amp;p\" Hello=\"There\" data-name=\"Html4cj\"", a.html())
        @Assert(a.html(), a.toString())

        println("Pass1")
    }

    @TestCase
    public func testIteratorRemovable(): Unit {
        // 2
        var a: Attributes = Attributes()
        a.put("Tot", "a&p")
        a.put("Hello", "There")
        a.put("data-name", "Html4cj")
        @Assert(a.hasKey("Tot"), true)
        var iterator: Iterator<Attribute> = a.iterator()
        var attr: Attribute = iterator.next().getOrThrow()
        @Assert("Tot", attr.getKey())
        attr = iterator.next().getOrThrow()
        @Assert("Hello", attr.getKey())
        @Assert("There", attr.getValue())
        @Assert("There", a.get("Hello"))

        println("Pass2")
    }

    @TestCase
    public func testIteratorUpdateable(): Unit {
        // 3
        var a: Attributes = Attributes()
        a.put("Tot", "a&p")
        a.put("Hello", "There")
        @Assert(a.hasKey("Foo"), false)
        var iterator: Iterator<Attribute> = a.iterator()
        var attr: Attribute = iterator.next().getOrThrow()
        attr.setKey("Foo")
        attr = iterator.next().getOrThrow()
        attr.setKey("Bar")
        attr.setValue("Qux")
        @Assert("a&p", a.get("Foo"))
        @Assert("Qux", a.get("Bar"))
        @Assert(a.hasKey("Tot"), false)
        @Assert(a.hasKey("Hello"), false)

        println("Pass3")
    }

    @TestCase
    public func testIteratorHasNext(): Unit {
        // 4
        var a: Attributes = Attributes()
        a.put("Tot", "1")
        a.put("Hello", "2")
        a.put("data-name", "3")
        var seen: Int64 = 0
        for (attribute in a) {
            seen++
            @Assert(seen.toString(), attribute.getValue())
        }
        @Assert(3, seen)

        println("Pass4")
    }

    @TestCase
    public func testIterator(): Unit {
        // 5
        var a: Attributes = Attributes()
        var datas: Array<Array<String>> = [["Tot", "raul"], ["Hello", "pismuth"], ["data-name", "Html4cj"]]
        for (atts in datas) {
            a.put(atts[0], atts[1])
        }
        a.iterator()
        var i: Int64 = 0
        for (attribute in a) {
            @Assert(datas[i][0], attribute.getKey())
            @Assert(datas[i][1], attribute.getValue())
            i++
        }
        @Assert(datas.size, i)

        println("Pass5")
    }

    @TestCase
    public func testIteratorSkipsInternal(): Unit {
        // 6
        var a: Attributes = Attributes()
        a.put("One", "One")
        a.put(Attributes.internalKey("baseUri"), "example.com")
        a.put("Two", "Two")
        a.put(Attributes.internalKey("another"), "example.com")
        var it: Iterator<Attribute> = a.iterator()
        @Assert("One", it.next().getOrThrow().getKey())
        @Assert("Two", it.next().getOrThrow().getKey())
        var seen: Int64 = 0
        for (attribute in a) {
            attribute
            seen++
        }
        @Assert(2, seen)

        println("Pass6")
    }

    @TestCase
    public func testListSkipsInternal(): Unit {
        // 7
        var a: Attributes = Attributes()
        a.put("One", "One")
        a.put(Attributes.internalKey("baseUri"), "example.com")
        a.put("Two", "Two")
        a.put(Attributes.internalKey("another"), "example.com")
        var attributes: ArrayList<Attribute> = a.asList()
        @Assert(2, attributes.size)
        @Assert("One", attributes[0].getKey())
        @Assert("Two", attributes[1]. getKey())

        println("Pass7")
    }

    @TestCase
    public func htmlSkipsInternals(): Unit {
        // 8
        var a: Attributes = Attributes()
        a.put("One", "One")
        a.put(Attributes.internalKey("baseUri"), "example.com")
        a.put("Two", "Two")
        a.put(Attributes.internalKey("another"), "example.com")
        @Assert(" One=\"One\" Two=\"Two\"", a.html())

        println("Pass8")
    }

    @TestCase
    public func testIteratorEmpty(): Unit {
        // 9
        var a: Attributes = Attributes()
        var iterator: Iterator<Attribute> = a.iterator()
        @Assert(iterator.next(),None)

        println("Pass9")
    }

    @TestCase
    public func removeCaseSensitive(): Unit {
        // 10        
        var a: Attributes = Attributes()
        a.put("Tot", "a&p")
        a.put("tot", "one")
        a.put("Hello", "There")
        a.put("hello", "There")
        a.put("data-name", "Html4cj")
        @Assert(5, a.size)
        a.remove("Tot")
        a.remove("Hello")
        @Assert(3, a.size)
        @Assert(a.hasKey("tot"), true)
        @Assert(a.hasKey("Tot"), false)

        println("Pass10")
    }

    @TestCase
    public func testSetKeyConsistency(): Unit {
        // 11
        var a: Attributes = Attributes()
        a.put("a", "a")
        for (at in a) {
            at.setKey("b")
        }
        @Assert(a.hasKey("a"), false)
        @Assert(a.hasKey("b"), true)

        println("Pass11")
    }

    @TestCase
    public func testBoolean(): Unit {
        // 12
        var ats: Attributes = Attributes()
        ats.put("a", "a")
        ats.put("B", "b")
        ats.put("c", None)
        @Assert(ats.hasDeclaredValueForKey("a"), true)
        @Assert(ats.hasDeclaredValueForKey("A"), false)
        @Assert(ats.hasDeclaredValueForKeyIgnoreCase("A"), true)
        @Assert(ats.hasDeclaredValueForKey("c"), false)
        @Assert(ats.hasDeclaredValueForKey("C"), false)
        @Assert(ats.hasDeclaredValueForKeyIgnoreCase("C"), false)

        println("Pass12")
    }

    @TestCase
    public func testSizeWhenHasInternal(): Unit {
        // 13
        var a: Attributes = Attributes()
        a.put("One", "One")
        a.put("Two", "Two")
        @Assert(2, a.size)
        a.put(Attributes.internalKey("baseUri"), "example.com")
        a.put(Attributes.internalKey("another"), "example.com")
        a.put(Attributes.internalKey("last"), "example.com")
        a.remove(Attributes.internalKey("last"))
        @Assert(4, a.size)

        // excluded from lists
        @Assert(2, a.asList().size)

        println("Pass13")
    }

    @TestCase
    public func testBooleans(): Unit {
        // 14        
        // want unknown=null, and known like async=null, async="", and async=async to collapse
        var html: String = "<a foo bar=\"\" async=async qux=qux defer=deferring ismap inert=\"\">"
        var el: Element = Html4cj.parse(html).selectFirst("a").getOrThrow()
        @Assert(" foo bar=\"\" async qux=\"qux\" defer=\"deferring\" ismap inert", el.attributes().html())

        println("Pass14")
    }

    @TestCase
    public func booleanNullAttributesConsistent(): Unit {
        // 15
        var attributes: Attributes = Attributes()
        attributes.put("key", None)
        var attribute: Attribute = attributes.iterator().next().getOrThrow()
        @Assert("key", attribute.html())
        @Assert(" key", attributes.html())

        println("Pass15")
    }

    @TestCase
    public func booleanEmptyString(): Unit {
        // 16
        var attributes: Attributes = Attributes()
        attributes.put("checked", "")
        var attribute: Attribute = attributes.iterator().next().getOrThrow()
        @Assert("checked", attribute.html())
        @Assert(" checked", attributes.html())

        println("Pass16")
    }

    @TestCase
    public func booleanCaseInsensitive(): Unit {
        // 17
        var attributes: Attributes = Attributes()
        attributes.put("checked", "CHECKED")
        var attribute: Attribute = attributes.iterator().next().getOrThrow()
        @Assert("checked", attribute.html())
        @Assert(" checked", attributes.html())

        println("Pass17")
    }

    @TestCase
    public func equalsIsOrderInsensitive(): Unit {
        // 18
        var one: Attributes = Attributes().add("Key1", "Val1").add("Key2", "Val2").add("Key3", None)
        var two: Attributes = Attributes().add("Key1", "Val1").add("Key2", "Val2").add("Key3", None)
        var three: Attributes = Attributes().add("Key2", "Val2").add("Key3", None).add("Key1", "Val1")
        var four: Attributes = Attributes().add("Key1", "Val1").add("Key2", "Val2").add("Key3", None).add("Key4", "Val4"
        )
        @Assert(one, one.clone())
        @Assert(one, two)
        @Assert(two, two)
        @Assert(one, three)
        @Assert(two, three)
        @Assert(three, three)
        @Assert(three, three.clone())
        @Assert(four, four)
        @Assert(four, four.clone())
        @Assert(one != four, true)

        println("Pass18")
    }

    @TestCase
    public func cloneAttributes(): Unit {
        // 19
        var one: Attributes = Attributes().add("Key1", "Val1").add("Key2", "Val2").add("Key3", None)
        var two: Attributes = one.clone()
        @Assert(3, two.size)
        @Assert("Val2", two.get("Key2"))
        @Assert(one, two)
        two.add("Key4", "Val4")
        @Assert(4, two.size)
        @Assert(3, one.size)
        @Assert(one != two, true)

        println("Pass19")
    }

    @TestCase
    public func hashCodeTest(): Unit {
        // 20
        var attributes: Attributes = Attributes()
        attributes.put("key1", "value1")
        attributes.put("key2", "value2")
        attributes.put("key3", "value3")
        var attributes2: Attributes = Attributes()
        attributes2.put("key1", "value1")
        attributes2.put("key2", "value2")
        attributes2.put("key3", "value3")
        @Assert(attributes.hashCode(), attributes.hashCode())
        @Assert(attributes2.hashCode(), attributes2.hashCode())

        println("Pass20")
    }

    @TestCase
    public func removeIgnoreCaseTest(): Unit {
        // 21
        var attributes: Attributes = Attributes()
        attributes.put("key1", "value1")
        attributes.put("key2", "value2")
        attributes.put("key3", "value3")
        attributes.removeIgnoreCase("KEY1")
        @Assert(attributes.size, 2)
        attributes.removeIgnoreCase("KEY1")
        @Assert(attributes.size, 2)
        attributes.removeIgnoreCase("KEY2")
        @Assert(attributes.size, 1)

        println("Pass21")
    }

    @TestCase
    public func isEmptyTest(): Unit {
        // 22
        var attributes: Attributes = Attributes()
        attributes.put("key1", "value1")
        attributes.put("key2", "value2")
        attributes.put("key3", "value3")
        attributes.removeIgnoreCase("KEY1")
        @Assert(attributes.isEmpty(), false)
        var attributes1: Attributes = Attributes()
        @Assert(attributes1.isEmpty(), true)

        println("Pass22")
    }

    @TestCase
    public func putBoolTest(): Unit {
        // 23
        var attributes: Attributes = Attributes()
        attributes.put("key1", true)
        attributes.put("key2", true)
        attributes.put("key3", true)
        attributes.put("key1", false)
        @Assert(attributes.size, 2)

        println("Pass23")
    }

    @TestCase
    public func putAttributeTest(): Unit {
        // 24
        var attributes: Attributes = Attributes()
        var attribute: Attribute = Attribute("key", "value")
        var attribute2: Attribute = Attribute("key", "value")
        var attribute3: Attribute = Attribute("key1", "value1")
        var attribute4: Attribute = Attribute("key2", "value2")
        attributes.put(attribute)
        attributes.put(attribute2)
        attributes.put(attribute3)
        attributes.put(attribute4)
        @Assert(attributes.size, 3)

        println("Pass24")
    }

    @TestCase
    public func addAllTest(): Unit {
        // 25
        var attributes: Attributes = Attributes()
        attributes.put("key1", "value1")
        attributes.put("key2", "value2")
        attributes.put("key3", "value3")
        @Assert(attributes.size, 3)
        var attributes1: Attributes = Attributes()
        attributes1.put("key3", "value3")
        attributes1.put("key4", "value4")
        attributes1.put("key5", "value5")
        attributes.addAll(attributes1)
        @Assert(attributes.size, 5)

        println("Pass25")
    }

    @TestCase
    public func dataTest(): Unit {
        // 26
        var attributes: Attributes = Attributes()
        attributes.putData("key1", "value1")
        attributes.putData("key2", "value2")
        attributes.putData("key3", "value3")
        @Assert(attributes.size, 3)
        attributes.removeData("key3")
        @Assert(attributes.size, 2)

        println("Pass26")
    }

    @TestCase
    public func datasetTest(): Unit {
        // 27
        var attributes: Attributes = Attributes()
        attributes.putData("key1", "value1")
        attributes.putData("key2", "value2")
        attributes.putData("key3", "value3")
        var dataset: Iterator<(String, ?String)> = attributes.dataset()
        dataset.iterator()
        @Assert(dataset.next().getOrThrow()[0], "data-key1")

        println("Pass27")
    }
}
