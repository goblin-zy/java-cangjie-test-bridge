package cjmustache.test

import cjmustache.*

import stdx.serialization.serialization.*
import stdx.encoding.json.*
import std.unittest.*
import stdx.encoding.json.ToJson
import std.unittest.testmacro.*
import std.io.*
import std.collection.*
import std.convert.*
import std.fs.*

@Test
public class SharedTest {
    protected var name: String = ""
    protected var partials = HashMap<String, String>()
    private let EMPTY = DataModel.fromJson(JsonValue.fromStr("{}"))

    @TestCase
    public func simpleVariableTest() {
        let json = 
        """
        { 
            "foo": "bar"
        }
        """
        @Expect(test("bar", "{{foo}}", 
            DataModel.fromJson(JsonValue.fromStr(json))))
    }

    @TestCase
    public func testPrimitiveArrayVariable () {  
        let json = 
        """
        {
            "foo": [1, 2, 3, 4]
        }
        """
        @Expect(test("1234", "{{#foo}}{{this}}{{/foo}}", 
            DataModel.fromJson(JsonValue.fromStr(json))))
    }

    @TestCase
    public func testPrimitiveArrayIndexVariable() {
        let json = 
        """
        {
            "foo": [1, 2, 3, 4]
        }
        """
        @Expect(test("1", "{{foo.0}}",
            DataModel.fromJson(JsonValue.fromStr(json))))
    }

    @TestCase
    public func testPrimitiveArrayIndexOutOfBoundsVariable() {
        let comp = Mustache.compiler().defaultValue("?");
        let json = 
        """
        {
            "foo": [1, 2, 3, 4]
        }
        """
        @Expect(test(comp, "?", "{{foo.4}}",
            DataModel.fromJson(JsonValue.fromStr(json))))
    }

    @TestCase 
    public func testOneShotSection() { 
        let json =
        """
        {
            "foo": { "bar": "baz" }
        }
        """
        @Expect(test("baz", "{{#foo}}{{bar}}{{/foo}}",
            DataModel.fromJson(JsonValue.fromStr(json))))
    }

    @TestCase 
    public func testListSection () {
        let json = 
        """
        {
            "foo": [
                {"bar": "baz"},
                {"bar": "bif"}
            ]
        }
        """
        @Expect(test("bazbif", "{{#foo}}{{bar}}{{/foo}}", 
            DataModel.fromJson(JsonValue.fromStr(json))))
    }

    @TestCase 
    public func testListIndexSection() { 
        let json = 
        """
        {
            "foo": [
                {"bar": "baz"},
                {"bar": "bif"}
            ]
        }
        """
        @Expect(test("baz", "{{#foo.0}}{{bar}}{{/foo.0}}",
            DataModel.fromJson(JsonValue.fromStr(json))))
    }

    @TestCase 
    public func testListIndexOutOfBoundsSection (){
        let json = 
        """
        {
            "foo": [
                {"bar": "baz"},
                {"bar": "bif"}
            ]
        }
        """
        @Expect(test("", "{{#foo.2}}{{bar}}{{/foo.2}}",
            DataModel.fromJson(JsonValue.fromStr(json))))
    }

    @TestCase 
    public func testListItemSection () {
        let json = 
        """
        {
            "foo": [
                {"bar": "baz"},
                {"bar": "bif"}
            ]
        }
        """
        @Expect(test("baz", "{{foo.0.bar}}", 
            DataModel.fromJson(JsonValue.fromStr(json))))
    }

    @TestCase 
    public func testArraySection() {
        let json = 
        """
        {
            "foo": [
                {"bar": "baz"},
                {"bar": "bif"}
            ]
        }
        """
        @Expect(test("bazbif", "{{#foo}}{{bar}}{{/foo}}",
                DataModel.fromJson(JsonValue.fromStr(json))))
    }

    @TestCase 
    public func testArrayIndexSection() {
        let json = 
        """
        {
            "foo": [
                {"bar": "baz"},
                {"bar": "bif"}
            ]
        }
        """
        @Expect(test("baz", "{{#foo.0}}{{bar}}{{/foo.0}}",
                DataModel.fromJson(JsonValue.fromStr(json))))
    }

    @TestCase
    public func testArrayIndexOutOfBoundsSection() {
        let json = 
        """
        {
            "foo": [
                {"bar": "baz"},
                {"bar": "bif"}
            ]
        }
        """
        @Expect(test("", "{{#foo.2}}{{bar}}{{/foo.2}}",
                DataModel.fromJson(JsonValue.fromStr(json))))
    }
    
    @TestCase 
    public func testEmptyListSection() {
        let json = 
        """
        {
            "foo": []
        }
        """
        @Expect(test("", "{{#foo}}{{bar}}{{/foo}}", 
            DataModel.fromJson(JsonValue.fromStr(json))))
    }

    @TestCase
    public func testFalseSection() {
        let json = 
        """
        {
            "foo": false
        }
        """
        @Expect(test("", "{{#foo}}{{bar}}{{/foo}}", 
            DataModel.fromJson(JsonValue.fromStr(json))))
    }

    @TestCase 
    public func testNestedListSection() {
        let json = 
        """
        {
            "a": {
                "b": [ { "c": "1" }, { "c": "2" } ],
                "d": [ { "e": "3" }, { "e": "4" } ]
            }
        }
        """
        @Expect(test("1234", "{{#a}}{{#b}}{{c}}{{/b}}{{#d}}{{e}}{{/d}}{{/a}}",
            DataModel.fromJson(JsonValue.fromStr(json))))
    }

    @TestCase 
    public func testNullSection() {
        @Expect(test("", "{{#foo}}{{bar}}{{/foo}}", EMPTY))
        @Expect(test(Mustache.compiler().defaultValue(""), 
                        "", "{{#foo}}{{bar}}{{/foo}}", EMPTY))
        @Expect(test(Mustache.compiler().nullValue(""), 
                        "", "{{#foo}}{{bar}}{{/foo}}", EMPTY))
    }

    @TestCase
    public func testMissingNonStrictSection() {
        @Expect(test("", "{{#foo}}{{bar}}{{/foo}}", EMPTY))

        @Expect(test(Mustache.compiler().nullValue(""), 
                        "", "{{#foo}}{{bar}}{{/foo}}", EMPTY))

        @Expect(test(Mustache.compiler().defaultValue(""),
                        "", "{{#foo}}{{bar}}{{/foo}}", EMPTY))
    }

    @TestCase 
    public func testMissingStrictSection() { 
        try {
            @Expect(test(Mustache.compiler().strictSections(true), 
                        "", "{{#foo}}{{bar}}{{/foo}}", EMPTY))
            @Assert(false)
        } catch (me: Exception) {}
    }

    @TestCase 
    public func testMissingStrictSectionDefaultValue() {
        try {
            @Expect(test(Mustache.compiler().strictSections(true).defaultValue(""), "",
                "{{#foo}}{{bar}}{{/foo}}", EMPTY))
            @Assert(false)
        } catch (me: Exception) {}
    }

    @TestCase
    public func testSectionWithFalseyEmptyString() {
        let json = 
        """
        {
            "foo": "",
            "bar": "nonempty"
        }
        """
        let dataModel = DataModel.fromJson(JsonValue.fromStr(json))
        
        var compiler = Mustache.compiler().emptyStringIsFalse(true)
        @Expect(test(compiler, "",     "{{#foo}}test{{/foo}}", dataModel))
        @Expect(test(compiler, "test", "{{#bar}}test{{/bar}}", dataModel))

        @Expect(test(compiler, "test", "{{^foo}}test{{/foo}}", dataModel))
        @Expect(test(compiler, "",     "{{^bar}}test{{/bar}}", dataModel))
    }

    @TestCase
    public func testComment() {
        @Expect(test("foobar", "foo{{! nothing to see here}}bar", EMPTY))
    }

    @TestCase 
    public func testCommentWithFunnyChars(){
        @Expect(test("foobar", "foo{{! {baz\n }}bar", EMPTY))
    }

    @TestCase
    public func testPartialUseWhenUnconfigured() { 
        try {
            test(None, "{{>foo}}", DataModelNull())
            @Assert(false)
        } catch (me: Exception) {} 
    }

    @TestCase 
    public func testPartial() {
        let json = 
        """
        { "bar": "foo" }
        """
        @Expect(test(Mustache.compiler().withLoader(
                fpartials(("foo", "inside:{{bar}}"), ("baz", "nonfoo")))
                    , "foo inside:foo nonfoo foo", "{{bar}} {{>foo}} {{>baz}} {{bar}}", 
                        DataModel.fromJson(JsonValue.fromStr(json))))
    }

    @TestCase
    public func testPartialIndent() {
        let json = 
        """
        { "content": "<\n->" }
        """
        @Expect(test(Mustache.compiler().withLoader(
            StringTemplateLoader("|\n{{{content}}}\n|\n"))
                , "\\\n |\n <\n->\n |\n/\n", "\\\n {{>partial}}\n/\n",
                    DataModel.fromJson(JsonValue.fromStr(json))))
    }

    @TestCase
    public func testPartialBlankLines() {
        @Expect(test(Mustache.compiler().withLoader(
            StringTemplateLoader("|\na\n\nb\n|\n"))
                , "\\\n\t|\n\ta\n\t\n\tb\n\t|\n/\n", 
                    "\\\n\t{{>partial}}\n/\n", EMPTY))
    }

    @TestCase
    public func testNestedPartialBlankLines() {
        @Expect(test(Mustache.compiler().withLoader(
            DualStrPartialTemplateLoader("1\n\t{{>nest}}\n1\n", "2\na\n\nb\n2\n" ))
                , "\\\n\t1\n\t\t2\n\t\ta\n\t\t\n\t\tb\n\t\t2\n\t1\n/\n",
                    "\\\n\t{{>partial}}\n/\n", EMPTY))
    }

    @TestCase 
    public func testNestedPartialBlankLinesCRLF() {
        @Expect(test(Mustache.compiler().withLoader(
            DualStrPartialTemplateLoader("1\r\n\t{{>nest}}\r\n1\r\n", "2\r\na\r\n\r\nb\r\n2\r\n"))
                , "\\\r\n\t1\r\n\t\t2\r\n\t\ta\r\n\t\t\r\n\t\tb\r\n\t\t2\r\n\t1\r\n/\r\n",
                    "\\\r\n\t{{>partial}}\r\n/\r\n", EMPTY))
    }

    @TestCase
    public func testNestedPartialIndent() {
        let json = 
        """
        { "content": "<\n->" }
        """
        let loader = fpartials(("partial", "1\n {{>nest}}\n1\n"), ("nest", "2\n{{{content}}}\n2\n"))
        @Expect(test(Mustache.compiler().withLoader(loader), "|\n 1\n  2\n  <\n->\n  2\n 1\n|\n",
            "|\n {{>partial}}\n|\n", DataModel.fromJson(JsonValue.fromStr(json))))
    }

    @TestCase
    public func testPartialIndentWithVariableAtTheStart() {
        let json = 
        """
        { "content": "<\n->" }
        """
        @Expect(test(Mustache.compiler().withLoader(
                StringTemplateLoader("{{{content}}}\n|\n"))
                , "\\\n <\n->\n |\n/\n", "\\\n {{>partial}}\n/\n", 
                    DataModel.fromJson(JsonValue.fromStr(json))))
    }

    @TestCase
    public func testPartialIndentWithBlock() {
        let json = 
        """
        { 
            "show": true,
            "content": "<\n->"
        }
        """
        @Expect(test(Mustache.compiler().withLoader(
            StringTemplateLoader("|\n{{#show}}\n{{{content}}}{{/show}}\n|\n"))
                , "\\\n |\n <\n->\n |\n/\n", "\\\n {{>partial}}\n/\n", 
                    DataModel.fromJson(JsonValue.fromStr(json))))
    }

    @TestCase public func testPartialIndentInBlock() {
        let json = 
        """
        { "show": true }
        """
        @Expect(test(Mustache.compiler().withLoader(StringTemplateLoader("content"))
            , " content", "{{#show}}\n {{>partial}}\n{{/show}}\n", 
                DataModel.fromJson(JsonValue.fromStr(json))))
    }

    @TestCase
    public func testPartialIndentWithBlockAtStart() {
        let json = 
        """
        { 
            "show": true,
            "content": "<\n->" 
        }
        """
        @Expect(test(Mustache.compiler().withLoader(
            StringTemplateLoader("{{#show}}\n{{{content}}}{{/show}}\n|\n"))
                , "\\\n <\n->\n |\n/\n", "\\\n {{>partial}}\n/\n", 
                    DataModel.fromJson(JsonValue.fromStr(json))))
    }

    @TestCase 
    public func testPartialIndentWithInlineBlock() {
        let json = 
        """
        { "show": true }
        """
        @Expect(test(Mustache.compiler().withLoader(
            StringTemplateLoader("line {{#show}}content{{/show}}\n"))
                , "\\\n line content\n/\n", "\\\n {{>partial}}\n/\n",
                    DataModel.fromJson(JsonValue.fromStr(json))))
    }

    @TestCase 
    public func testPartialPlusNestedContext() {
        let json = 
        """
        {
            "name": "foo",
            "things": [
                { "thing_name": "bar" },
                { "thing_name": "baz" }
            ]
        }
        """
        @Expect(test(Mustache.compiler().withLoader(
            DualStrNestedTemplateLoader("{{name}}{{thing_name}}", "nonfoo"))
                , "foo((foobar)(foobaz))", "{{name}}({{#things}}({{>nested}}){{/things}})",
                    DataModel.fromJson(JsonValue.fromStr(json))))
    }

    @TestCase 
    public func testDelimiterChange() {
        let json = 
        """
        { "one": "foo", "two": "bar", "three": "baz" }
        """
        let dataModel = DataModel.fromJson(JsonValue.fromStr(json))
        @Expect(test("foo bar baz", "{{one}} {{=<% %>=}}<%two%><%={{ }}=%> {{three}}",
            dataModel))
        @Expect(test("baz bar foo", "{{three}} {{=% %=}}%two%%={{ }}=% {{one}}",
            dataModel))
    }

    @TestCase
    public func testUnescapeHTML() {
        let json = 
        """
        { "a": "<b>" }
        """
        let dataModel = DataModel.fromJson(JsonValue.fromStr(json))
        @Expect(check("<b>", Mustache.compiler().escapeHTML(true).compile("{{&a}}").
            execute(dataModel)))
        @Expect(check("<b>", Mustache.compiler().escapeHTML(true).compile("{{{a}}}").
            execute(dataModel)))
        @Expect(check("<b>", Mustache.compiler().escapeHTML(false).compile("{{&a}}").
            execute(dataModel)))
        @Expect(check("<b>", Mustache.compiler().escapeHTML(false).compile("{{{a}}}").
            execute(dataModel)))
    }

    @TestCase 
    public func testStrayTagCharacters() {
        let json1 = 
        """
        { "a": "[b]" }
        """
        let dataModedl = DataModel.fromJson(JsonValue.fromStr(json1))
        let json2 = 
        """
        { "a": "<b>" }
        """
        let dataModel2 = DataModel.fromJson(JsonValue.fromStr(json2))
        @Expect(test("funny [b] business {{", "funny {{a}} business {{", dataModedl))
        @Expect(test("funny <b> business {{", "funny {{{a}}} business {{", dataModel2))
        @Expect(test("{{ funny [b] business", "{{ funny {{a}} business", dataModedl))
        @Expect(test("{{ funny <b> business", "{{ funny {{{a}}} business", dataModel2))
        @Expect(test("funny [b] business }}", "funny {{a}} business }}", dataModedl))
        @Expect(test("funny <b> business }}", "funny {{{a}}} business }}", dataModel2))
        @Expect(test("}} funny [b] business", "}} funny {{a}} business", dataModedl))
        @Expect(test("}} funny <b> business", "}} funny {{{a}}} business", dataModel2))
    }

    @TestCase 
    public func testInvalidUnescapeHTML() {
        let json = 
        """
        { "a": "<b>" }
        """
        try {
            Mustache.compiler().escapeHTML(true).compile("{{{a}}").execute(
                DataModel.fromJson(JsonValue.fromStr(json)))
            @Assert(false)
        } catch (me: Exception) {} 
    }

    @TestCase 
    public func testEscapeHTML () {
        let json1 = 
        """
        { "a": "<b>" }
        """
        let dataModel1 = DataModel.fromJson(JsonValue.fromStr(json1))
        let json2 = 
        """
        { "a": "`=" }
        """
        let dataModel2 = DataModel.fromJson(JsonValue.fromStr(json2))
        @Expect(check("&lt;b&gt;", Mustache.compiler().compile("{{a}}").execute(
            dataModel1)))
        @Expect(check("<b>", Mustache.compiler().escapeHTML(false).compile("{{a}}").
            execute(dataModel1)))
        @Expect(check("&#x60;&#x3D;", Mustache.compiler().compile("{{a}}").execute(
            dataModel2)))
    }

    @TestCase 
    public func testUserDefinedEscaping(){
        let json = 
        """
        { "a": "[b]" }
        """
        let escaper = Escapers.simple([
            [ "[", ":BEGIN:" ],
            [ "]", ":END:" ]
        ])
        @Expect(check(":BEGIN:b:END:", Mustache.compiler().withEscaper(escaper).
            compile("{{a}}").execute(DataModel.fromJson(JsonValue.fromStr(json)))))
    }

    @TestCase 
    public func testPartialDelimiterMatch() {
        let json = 
        """
        { "bob}bob": "bar" }
        """
        @Expect(check("{bob}", Mustache.compiler().compile("{bob}").execute(EMPTY)))
        @Expect(check("bar", Mustache.compiler().compile("{{bob}bob}}").execute(
            DataModel.fromJson(JsonValue.fromStr(json)))))
    }

    @TestCase
    public func testDanglingTag() {
        let json = 
        """
        { "a": "<b>" }
        """
        let dataModel = DataModel.fromJson(JsonValue.fromStr(json))
        @Expect(test("foo{", "foo{", dataModel))
        @Expect(test("foo{{", "foo{{", dataModel))
        @Expect(test("foo{{a", "foo{{a", dataModel))
        @Expect(test("foo{{a}", "foo{{a}", dataModel))
    }

    @TestCase 
    public func testTopLevelThis() {
        @Expect(check("bar", Mustache.compiler().compile("{{this}}").execute("bar".serialize())))
        @Expect(check("bar", Mustache.compiler().compile("{{.}}").execute("bar".serialize())))
    }

    @TestCase 
    public func testNestedThis() {
        let json = 
        """
        { "things": ["bar", "baz", "bif"] }
        """
        let dataModel = DataModel.fromJson(JsonValue.fromStr(json))
        @Expect(check("barbazbif", Mustache.compiler().compile("{{#things}}{{this}}{{/things}}").
            execute(dataModel)))
        @Expect(check("barbazbif", Mustache.compiler().compile("{{#things}}{{.}}{{/things}}").
            execute(dataModel)))
    }

    @TestCase 
    public func testNewlineSkipping() {
        testNewlineSkipping("\n")
    }

    @TestCase 
    public func testNewlineSkippingCRLF() {
        testNewlineSkipping("\r\n")
    }

    @TestCase 
    public func testNewlineSkippingDelimsTag() {
        @Expect(test("Begin.\nEnd.\n", "Begin.\n{{=@ @=}}\nEnd.\n", EMPTY))
    }

    @TestCase 
    public func testNoTrimNewlineFromNestedTagAt0() {
        let json = 
        """
        { "boolean": false }
        """
        @Expect(test(" | \n  | \n", " | {{^boolean}}{{! comment }}\n {{/boolean}} | \n",
            DataModel.fromJson(JsonValue.fromStr(json))))
    }

    @TestCase
    public func testTrimBlank() {
        let str = StringSegment("  \r\n  ", false)
        @Expect(check("Text(  )-1/0", str.trimLeadBlank().toString()))
        @Expect(check("Text(  \\r\\n)3/-1", str.trimTrailBlank().toString()))
    }

    @TestCase 
    public func testVisit(){
        let template = "{{#one}}1{{/one}} {{^two}}2{{three}}{{/two}}{{four}}"
        let viz = GetKeysVisitor()
        Mustache.compiler().compile(template).visit(viz)
        @Expect(viz.keys.size, 4)
        @Expect(viz.keys.contains("one"))
        @Expect(viz.keys.contains("two"))
        @Expect(viz.keys.contains("three"))
        @Expect(viz.keys.contains("four"))
    }

    @TestCase 
    public func testVisitNested() {
        let template = "{{#one}}1{{/one}} {{^two}}" +
            "2{{two_and_half}}{{#five}}{{three}}{{/five}}" +
            "{{/two}} {{#one}}{{three}}{{/one}} {{four}}{{! ignore me }}"
        let viz = GetKeysVisitor()
        Mustache.compiler().compile(template).visit(viz)
        @Expect(viz.keys.size, 6)
        @Expect(viz.keys.contains("one"))
        @Expect(viz.keys.contains("two"))
        @Expect(viz.keys.contains("three"))
        @Expect(viz.keys.contains("four"))
        @Expect(viz.keys.contains("two_and_half"))
        @Expect(viz.keys.contains("five"))
    }

    protected func testNewlineSkipping(sep: String) {
        let json1 = 
        """
        { "items": ["one", "two", "three"] }
        """
        let dataModel1 = DataModel.fromJson(JsonValue.fromStr(json1))
        let json2 = 
        """
        { "items": [] }
        """
        let dataModel2 = DataModel.fromJson(JsonValue.fromStr(json2))
        let tmpl = "list:" + sep +
            "{{#items}}" + sep +
            "{{this}}" + sep +
            "{{/items}}" + sep +
            "{{^items}}" + sep +
            "no items" + sep +
            "{{/items}}" + sep +
            "endlist"
        @Expect(test("list:" + sep +
            "one" + sep +
            "two" + sep +
            "three" + sep +
            "endlist", tmpl, dataModel1))
        @Expect(test("list:" + sep +
            "no items" + sep +
            "endlist", tmpl, dataModel2))

        let htmlTmpl =
            "<ul>" + sep +
            "  {{#items}}  " + sep +
            "  <li>{{this}}</li>" + sep +
            "  {{/items}}  " + sep +
            "  {{^items}}" + sep +
            "  <li>no items</li>" + sep +
            "  {{/items}}" + sep +
            "</ul>"
        @Expect(test("<ul>" + sep +
            "  <li>one</li>" + sep +
            "  <li>two</li>" + sep +
            "  <li>three</li>" + sep +
            "</ul>", htmlTmpl, dataModel1))
        @Expect(test("<ul>" + sep +
            "  <li>no items</li>" + sep +
            "</ul>", htmlTmpl, dataModel2))
    }

    @TestCase
    public func testNewlineNonSkipping () {
        let json1 = 
        """
        { "thing": true }
        """
        let json2 = 
        """
        { "thing": false }
        """
        let tmpl = "thing?: {{#thing}}yes{{/thing}}{{^thing}}no{{/thing}}\n" +
            "that's nice";
        @Expect(test("thing?: yes\n" +
            "that's nice", tmpl, DataModel.fromJson(JsonValue.fromStr(json1))))
        @Expect(test("thing?: no\n" +
            "that's nice", tmpl, DataModel.fromJson(JsonValue.fromStr(json2))))
    }

    @TestCase
    public func testNestedContexts() {
        let json = 
        """
        {
            "name": "foo",
            "things": [
                { "thing_name": "bar" },
                { "thing_name": "baz" }
            ]
        }
        """
        @Expect(test("foo((foobar)(foobaz))", "{{name}}({{#things}}({{name}}{{thing_name}}){{/things}})",
            DataModel.fromJson(JsonValue.fromStr(json))))
    }

    @TestCase 
    public func testShadowedContext() {
        let json = 
        """
        {
            "name": "foo",
            "things": [
                { "name": "bar" },
                { "name": "baz" }
            ]
        }
        """
        @Expect(test("foo((bar)(baz))", "{{name}}({{#things}}({{name}}){{/things}})",
            DataModel.fromJson(JsonValue.fromStr(json))))
    }

    @TestCase 
    public func testFirst() {
        let json = 
        """
        { "things": ["foo", "bar", "baz"] }
        """
        @Expect(test("foo|bar|baz", "{{#things}}{{^-first}}|{{/-first}}{{this}}{{/things}}",
            DataModel.fromJson(JsonValue.fromStr(json))))
    }

    @TestCase 
    public func testLast() {
        let json = 
        """
        { "things": ["foo", "bar", "baz"] }
        """
        @Expect(test("foo|bar|baz", "{{#things}}{{this}}{{^-last}}|{{/-last}}{{/things}}",
            DataModel.fromJson(JsonValue.fromStr(json))))
    }

    @TestCase 
    public func testFirstLast() { 
        let json = 
        """
        { "things": ["foo"] }
        """
        let dataModel = DataModel.fromJson(JsonValue.fromStr(json))
        @Expect(test("[foo]", "{{#things}}{{#-first}}[{{/-first}}{{this}}{{#-last}}]{{/-last}}{{/things}}",
            dataModel))
        @Expect(test("foo", "{{#things}}{{this}}{{^-last}}|{{/-last}}{{/things}}",
            dataModel))
    }

    @TestCase 
    public func testFirstLastCombo() {
        let json = 
        """
        { "things": ["_and_"] }
        """
        @Expect(test("FIRST_and_LAST", "{{#things}}{{#-first}}FIRST{{/-first}}{{this}}{{#-last}}LAST{{/-last}}{{/things}}",
            DataModel.fromJson(JsonValue.fromStr(json))))
    }

    @TestCase 
    public func testInverseFirstLastCombo() {  
        let json = 
        """
        { "things": ["_and_"] }
        """
        @Expect(test("_and_", "{{#things}}{{^-first}}NOT-FIRST{{/-first}}{{this}}{{^-last}}NOT-LAST{{/-last}}{{/things}}",
            DataModel.fromJson(JsonValue.fromStr(json))))
    }

    @TestCase 
    public func testNotFirst() { 
        let json = 
        """
        { "things": ["1", "2", "3"] }
        """
        @Expect(test("1,2,3", "{{#things}}{{^-first}},{{/-first}}{{this}}{{/things}}",
            DataModel.fromJson(JsonValue.fromStr(json))))
    }

    @TestCase 
    public func testNotLast() {
        let json = 
        """
        { "things": ["1", "2", "3"] }
        """
        @Expect(test("1,2,3", "{{#things}}{{this}}{{^-last}},{{/-last}}{{/things}}",
            DataModel.fromJson(JsonValue.fromStr(json))))
    }

    @TestCase 
    public func testIndex() {
        let json = 
        """
        { "things": ["foo", "bar", "baz"] }
        """
        @Expect(test("123", "{{#things}}{{-index}}{{/things}}",
            DataModel.fromJson(JsonValue.fromStr(json))))
    }

    @TestCase 
    public func testNestedIndex() {
        let json = 
        """
        { "fooList": [ { "name": "a", "quantity": "1" }, { "name": "b" } ] }
        """
        let tmpl =
            "{{#fooList}}\n" +
            "{{#quantity}}|q{{-index}}={{quantity}}{{/quantity}}|{{name}}\n" +
            "{{/fooList}}"
        @Expect(test("|q1=1|a\n|b\n", tmpl,
            DataModel.fromJson(JsonValue.fromStr(json))))
    }

    @TestCase 
    public func testLineReporting() {  
        let tmpl = "first line\n{{nonexistent}}\nsecond line"
        try {
            Mustache.compiler().compile(tmpl).execute(EMPTY)
            fail("Referencing a nonexistent variable should throw MustacheException")
        } catch (me: MustacheException) {
            @Expect(me.message.contains("line 2"))
        }
    }

    @TestCase 
    public func testStandardsModeWithDotValue() {
        let json = 
        """
        { "foo": "bar" }
        """
        let tmpl = "{{#foo}}:{{.}}:{{/foo}}"
        let result = Mustache.compiler().standardsMode(true).compile(tmpl).
            execute(DataModel.fromJson(JsonValue.fromStr(json)))
        @Expect(check(":bar:", result))
    }

    @TestCase 
    public func testStandardsModeWithNoParentContextSearching() {
        let json =
        """
        { "parent": {}, "parentProperty": "bar" }
        """
        try {
            let tmpl = "{{#parent}}foo{{parentProperty}}bar{{/parent}}"
            let result = Mustache.compiler().standardsMode(true).compile(tmpl).
                execute(DataModel.fromJson(JsonValue.fromStr(json)))
            @Expect(false)
        } catch (me: Exception) {} 
    }

    @TestCase 
    public func testMissingValue() {
        let json = 
        """
        { "notmissing": "bar" }
        """
        try {
            test("n/a", "{{missing}} {{notmissing}}", 
                DataModel.fromJson(JsonValue.fromStr(json)))
            @Expect(false)
        } catch (me: Exception) {} 
    }

    @TestCase 
    public func testMissingValueWithDefault() {
        let json = 
        """
        { "notmissing": "bar" }
        """
        @Expect(test(Mustache.compiler().defaultValue(""),
            "bar", "{{missing}}{{notmissing}}", 
                DataModel.fromJson(JsonValue.fromStr(json))))
    }

    @TestCase 
    public func testMissingValueWithDefaultNonEmptyString() {
        let json = 
        """
        { "notmissing": "bar" }
        """
        @Expect(test(Mustache.compiler().defaultValue("foo"),
            "foobar", "{{missing}}{{notmissing}}", 
                DataModel.fromJson(JsonValue.fromStr(json))))
    }

    @TestCase 
    public func testMissingValueWithDefaultSubstitution() {
        let json = 
        """
        { "notmissing": "bar" }
        """
        @Expect(test(Mustache.compiler().defaultValue("?{{name}}?"),
            "?missing?bar", "{{missing}}{{notmissing}}",
                DataModel.fromJson(JsonValue.fromStr(json))))
    }

    @TestCase
    public func testMissingValueWithDefaultSubstitution2() {
        let json = 
        """
        { "notmissing": "bar" }
        """
        @Expect(test(Mustache.compiler().defaultValue("{{{{name}}}}"),
            "{{missing}}bar", "{{missing}}{{notmissing}}",
                DataModel.fromJson(JsonValue.fromStr(json))))
    }

    @TestCase
    public func testMissingValueWithDefaultSubstitution3() {
        let json = 
        """
        { "notmissing": "bar" }
        """
        @Expect(test(Mustache.compiler().defaultValue("{{?{{name}}?}}"),
            "{{?missing?}}bar", "{{missing}}{{notmissing}}", 
                DataModel.fromJson(JsonValue.fromStr(json))))
    }

    @TestCase
    public func testMissingValueWithNullDefault () {
        let json = 
        """
        { "notmissing": "bar" }
        """
        try {
            test(Mustache.compiler().nullValue(""), 
                "bar", "{{missing}}{{notmissing}}", 
                    DataModel.fromJson(JsonValue.fromStr(json)))
            @Expect(false)
        } catch (me: Exception) {} 
    }

    @TestCase 
    public func testInvalidTripleMustache() {
        try {
            Mustache.compiler().compile("{{{foo}}")
            fail("Expected MustacheParseException")
        } catch (me: MustacheException) {
            @Expect(check(
                "Invalid triple-mustache tag: {{{foo}} @ line 1", me.message))
        }
        try {
            Mustache.compiler().compile("{{{foo}}]")
            fail("Expected MustacheParseException")
        } catch (me: MustacheException) {
            @Expect(check(
                "Invalid triple-mustache tag: {{{foo}}] @ line 1", me.message))
        }
    }

    @TestCase 
    public func testNonStandardDefaultDelims() {
        let json = 
        """
        { "foo": "bar" }
        """
        @Expect(test(Mustache.compiler().withDelims("<% %>"), "bar", "<%foo%>", 
            DataModel.fromJson(JsonValue.fromStr(json))))
    }

    @TestCase 
    public func testCompilingDoesntChangeCompilersDelimiters() {
        let json = 
        """
        { "variable": "value" }
        """
        let dataModel = DataModel.fromJson(JsonValue.fromStr(json))
        let compiler = Mustache.compiler()
        @Expect(test(compiler, "value", "{{=<% %>=}}<% variable %>", dataModel))
        @Expect(test(compiler, "value", "{{=<% %>=}}<% variable %>", dataModel))
    }

    @TestCase
    public func testChinese() {
        let json1 = 
        """
        { "foo": "世界" }
        """
        @Expect(test("你好, 世界!", "你好, {{foo}}!", 
            DataModel.fromJson(JsonValue.fromStr(json1))))

        let json2 =
        """
        { "中": "世界" }
        """
        @Expect(test("你好, 世界!", "你好, {{中}}!", 
            DataModel.fromJson(JsonValue.fromStr(json2))))
        
        let json3 =
        """
        { "中foo中": "世界" }
        """
        @Expect(test("你好, 世界!", "你好, {{中foo中}}!", 
            DataModel.fromJson(JsonValue.fromStr(json3))))

        let json4 = 
        """
        { "中中foo……下%#上中": "世界" }
        """
        @Expect(test("你好, 世界!", "你好, {{中中foo……下%#上中}}!", 
            DataModel.fromJson(JsonValue.fromStr(json4))))
    }

    protected func test(compiler: Compiler, expected: ?String, template: String, ctx: DataModel): Bool {
        let actual: String = compiler.compile(template).execute(ctx)
        if (!expected.getOrThrow().equalsIgnoreAsciiCase(actual)) {
            println("")
            println("----------------------------------------")
            println("")
            println("Failed: ${name}")
            println("Tempalte : \"${showWhitespace(template)}\"")
            if (!partials.isEmpty()) {
                println("Partials : ")
                for ((k, v) in partials) {
                    println("\t${k}: \"${showWhitespace(v)}\"")
                }
            }
            println("Expected : \"${showWhitespace(expected.getOrThrow())}\"")
            println("Result   : \"${showWhitespace(actual)}\"")
            println("----------------------------------------")
            println("")
        }

        return check(expected, actual)
    }

    protected func check(expected: ?String, output: String): Bool {
        return showWhitespace(expected.getOrThrow()).equalsIgnoreAsciiCase(showWhitespace(output))
    }

    protected func test(expected: ?String, template: String, ctx: DataModel): Bool {
        return test(Mustache.compiler(), expected, template, ctx)
    }

    protected func showWhitespace(s: String): String {
        s.replace("\r\n", (r"\u{240D}").toString())
        s.replace('\t', (r"\u{21E5}").toString())
        s.replace("\n", "\u{21B5}\n")
        s.replace("\u{240D}", "\u{240D}\n")
        return s
    }

    protected func fpartials(entries: Array<(String, String)>): TemplateLoader {
        let templates = HashMap<String, String>()
        for (e in entries) {
            templates.add(e[0], e[1])
        }
        partials = templates
        return MapTemplateLoader(templates)
    }
} 


public class MapTemplateLoader <: TemplateLoader {
    public MapTemplateLoader(let mp: HashMap<String, String>) {}

    public func getTemplate(name: String): InputStream {
        if (let Some(value) <- mp.get(name)) {
            return BufferedInputStream(ByteBuffer(value.toArray()))
        }
        return BufferedInputStream(ByteBuffer())
    }
}

public class StringTemplateLoader <: TemplateLoader {
    public StringTemplateLoader(let str: String) {}

    public func getTemplate(_: String): InputStream {
        return BufferedInputStream(ByteBuffer(str.toArray()))
    }
} 

public class DualStrPartialTemplateLoader <: TemplateLoader {
    public DualStrPartialTemplateLoader(let str1: String, let str2: String) {}

    public func getTemplate(name: String): InputStream {
        if (name.equalsIgnoreAsciiCase("partial")) {
            return BufferedInputStream(ByteBuffer(str1.toArray()))
        }
        return BufferedInputStream(ByteBuffer(str2.toArray()))
    }
} 


public class DualStrNestedTemplateLoader <: TemplateLoader {
    public DualStrNestedTemplateLoader(let str1: String, let str2: String) {}

    public func getTemplate(name: String): InputStream {
        if (name.equalsIgnoreAsciiCase("nested")) {
            return BufferedInputStream(ByteBuffer(str1.toArray()))
        }
        return BufferedInputStream(ByteBuffer(str2.toArray()))
    }
}

public abstract class AbsDiffTypeRenderClass <: Serializable<AbsDiffTypeRenderClass> {
    public func serialize(): DataModel 
    public static func deserialize(_: DataModel): AbsDiffTypeRenderClass {
        throw UnInplementException()
    }
}

public class GetKeysVisitor <: Visitor {
    public let keys = HashSet<String>()
    public func visitText (_: String): Unit {}
    public func visitVariable (name: String): Unit { keys.add(name) }
    public func visitInclude (name: String): Bool { 
        keys.add(name)
        return true
    }
    public func visitSection (name: String): Bool {
        keys.add(name)
        return true
    }
    public func visitInvertedSection (name: String): Bool { 
        keys.add(name) 
        return true 
    }
}
