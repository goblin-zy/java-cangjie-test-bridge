package cjmustache
import std.unittest.*
import std.unittest.testmacro.*
import stdx.serialization.serialization.*
import std.collection.*

private func makeModel(fields: Array<Field>): DataModelStruct {
    return DataModelStruct(ArrayList<Field>(fields))
}

@Test
class MustacheTranslationTest {

    @TestCase
    func testSimpleVariable(): Unit {
        let context = makeModel([Field("foo", "bar".serialize())])
        let result = Mustache.compiler().compile("{{foo}}").execute(context)
        @Assert("bar", result)
    }
    @TestCase
    func testPrimitiveArrayVariable(): Unit {
        let items: Array<DataModel> = [Int64(1).serialize(), Int64(2).serialize(), Int64(3).serialize(), Int64(4).serialize()]
        let context = makeModel([Field("foo", DataModelSeq(ArrayList<DataModel>(items)))])
        let result = Mustache.compiler().compile("{{#foo}}{{this}}{{/foo}}").execute(context)
        @Assert("1234", result)
    }
    @TestCase
    func testPrimitiveArrayIndexVariable(): Unit {
        let items: Array<DataModel> = [Int64(1).serialize(), Int64(2).serialize(), Int64(3).serialize(), Int64(4).serialize()]
        let context = makeModel([Field("foo", DataModelSeq(ArrayList<DataModel>(items)))])
        let result = Mustache.compiler().compile("{{foo.0}}").execute(context)
        @Assert("1", result)
    }
    @TestCase
    func testPrimitiveArrayIndexOutOfBoundsVariable(): Unit {
        let items: Array<DataModel> = [Int64(1).serialize(), Int64(2).serialize(), Int64(3).serialize(), Int64(4).serialize()]
        let context = makeModel([Field("foo", DataModelSeq(ArrayList<DataModel>(items)))])
        let compiler = Mustache.compiler().defaultValue("?")
        let result = compiler.compile("{{foo.4}}").execute(context)
        @Assert("?", result)
    }
    @TestCase
    func testOneShotSection(): Unit {
        let inner = makeModel([Field("bar", "baz".serialize())])
        let context = makeModel([Field("foo", inner)])
        let result = Mustache.compiler().compile("{{#foo}}{{bar}}{{/foo}}").execute(context)
        @Assert("baz", result)
    }
    @TestCase
    func testListSection(): Unit {
        let first = makeModel([Field("bar", "baz".serialize())])
        let second = makeModel([Field("bar", "bif".serialize())])
        let items: Array<DataModel> = [first, second]
        let context = makeModel([Field("foo", DataModelSeq(ArrayList<DataModel>(items)))])
        let result = Mustache.compiler().compile("{{#foo}}{{bar}}{{/foo}}").execute(context)
        @Assert("bazbif", result)
    }
}
