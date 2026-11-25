# Java测试骨架提取记录

解析器：JDK javac语法树，Java17；仅解析，未执行符号绑定或测试。

文件：8；成员：179。

|成员标识|角色|原始方法体|
|---|---|---|
|com/samskivert/mustache/MustacheTest.java::com.samskivert.mustache.MustacheTest#testFieldVariable()|test|已保存|
|com/samskivert/mustache/MustacheTest.java::com.samskivert.mustache.MustacheTest#testMethodVariable()|test|已保存|
|com/samskivert/mustache/MustacheTest.java::com.samskivert.mustache.MustacheTest#testPropertyVariable()|test|已保存|
|com/samskivert/mustache/MustacheTest.java::com.samskivert.mustache.MustacheTest#testCustomContext()|test|已保存|
|com/samskivert/mustache/MustacheTest.java::com.samskivert.mustache.MustacheTest#testCharSequenceVariable()|test|已保存|
|com/samskivert/mustache/MustacheTest.java::com.samskivert.mustache.MustacheTest$HasDefault#getFoo()|helper|已保存|
|com/samskivert/mustache/MustacheTest.java::com.samskivert.mustache.MustacheTest$Interloper#getFoo()|helper|已保存|
|com/samskivert/mustache/MustacheTest.java::com.samskivert.mustache.MustacheTest#testDefaultMethodVariable()|test|已保存|
|com/samskivert/mustache/MustacheTest.java::com.samskivert.mustache.MustacheTest#testBooleanPropertyVariable()|test|已保存|
|com/samskivert/mustache/MustacheTest.java::com.samskivert.mustache.MustacheTest#testPrimitiveBooleanPropertyVariable()|test|已保存|
|com/samskivert/mustache/MustacheTest.java::com.samskivert.mustache.MustacheTest#testSkipVoidReturn()|test|已保存|
|com/samskivert/mustache/MustacheTest.java::com.samskivert.mustache.MustacheTest#testCallSiteReuse()|test|已保存|
|com/samskivert/mustache/MustacheTest.java::com.samskivert.mustache.MustacheTest#testCallSiteChange()|test|已保存|
|com/samskivert/mustache/MustacheTest.java::com.samskivert.mustache.MustacheTest#testSectionWithNonFalseyZero()|test|已保存|
|com/samskivert/mustache/MustacheTest.java::com.samskivert.mustache.MustacheTest#testSectionWithFalseyZero()|test|已保存|
|com/samskivert/mustache/MustacheTest.java::com.samskivert.mustache.MustacheTest#testOptionalSupportingCollector()|test|已保存|
|com/samskivert/mustache/MustacheTest.java::com.samskivert.mustache.MustacheTest#testCompoundVariable()|test|已保存|
|com/samskivert/mustache/MustacheTest.java::com.samskivert.mustache.MustacheTest#testNullComponentInCompoundVariable()|test|已保存|
|com/samskivert/mustache/MustacheTest.java::com.samskivert.mustache.MustacheTest#testMissingComponentInCompoundVariable()|test|已保存|
|com/samskivert/mustache/MustacheTest.java::com.samskivert.mustache.MustacheTest#testNullComponentInCompoundVariableWithDefault()|test|已保存|
|com/samskivert/mustache/MustacheTest.java::com.samskivert.mustache.MustacheTest#testMissingComponentInCompoundVariableWithDefault()|test|已保存|
|com/samskivert/mustache/MustacheTest.java::com.samskivert.mustache.MustacheTest#testCompoundVariableAsPlain()|test|已保存|
|com/samskivert/mustache/MustacheTest.java::com.samskivert.mustache.MustacheTest#testShadowedContextWithNull()|test|已保存|
|com/samskivert/mustache/MustacheTest.java::com.samskivert.mustache.MustacheTest#testContextPokingLambda()|test|已保存|
|com/samskivert/mustache/MustacheTest.java::com.samskivert.mustache.MustacheTest#testCustomFormatter()|test|已保存|
|com/samskivert/mustache/MustacheTest.java::com.samskivert.mustache.MustacheTest#testMapEntriesPlusReflectSection()|test|已保存|
|com/samskivert/mustache/MustacheTest.java::com.samskivert.mustache.MustacheTest#testNoAccesCoercion()|test|已保存|
|com/samskivert/mustache/SharedTests.java::com.samskivert.mustache.SharedTests#testSimpleVariable()|test|已保存|
|com/samskivert/mustache/SharedTests.java::com.samskivert.mustache.SharedTests#testPrimitiveArrayVariable()|test|已保存|
|com/samskivert/mustache/SharedTests.java::com.samskivert.mustache.SharedTests#testPrimitiveArrayIndexVariable()|test|已保存|
|com/samskivert/mustache/SharedTests.java::com.samskivert.mustache.SharedTests#testPrimitiveArrayIndexOutOfBoundsVariable()|test|已保存|
|com/samskivert/mustache/SharedTests.java::com.samskivert.mustache.SharedTests#testOneShotSection()|test|已保存|
|com/samskivert/mustache/SharedTests.java::com.samskivert.mustache.SharedTests#testListSection()|test|已保存|
|com/samskivert/mustache/SharedTests.java::com.samskivert.mustache.SharedTests#testListIndexSection()|test|已保存|
|com/samskivert/mustache/SharedTests.java::com.samskivert.mustache.SharedTests#testListIndexOutOfBoundsSection()|test|已保存|
|com/samskivert/mustache/SharedTests.java::com.samskivert.mustache.SharedTests#testListItemSection()|test|已保存|
|com/samskivert/mustache/SharedTests.java::com.samskivert.mustache.SharedTests#testMapEntriesSection()|test|已保存|
|com/samskivert/mustache/SharedTests.java::com.samskivert.mustache.SharedTests#testArraySection()|test|已保存|
|com/samskivert/mustache/SharedTests.java::com.samskivert.mustache.SharedTests#testArrayIndexSection()|test|已保存|
|com/samskivert/mustache/SharedTests.java::com.samskivert.mustache.SharedTests#testArrayIndexOutOfBoundsSection()|test|已保存|
|com/samskivert/mustache/SharedTests.java::com.samskivert.mustache.SharedTests#testArrayItemSection()|test|已保存|
|com/samskivert/mustache/SharedTests.java::com.samskivert.mustache.SharedTests#testIteratorSection()|test|已保存|
|com/samskivert/mustache/SharedTests.java::com.samskivert.mustache.SharedTests#testIteratorIndexSection()|test|已保存|
|com/samskivert/mustache/SharedTests.java::com.samskivert.mustache.SharedTests#testIteratorIndexOutOfBoundsSection()|test|已保存|
|com/samskivert/mustache/SharedTests.java::com.samskivert.mustache.SharedTests#testIteratorItemSection()|test|已保存|
|com/samskivert/mustache/SharedTests.java::com.samskivert.mustache.SharedTests#testEmptyListSection()|test|已保存|
|com/samskivert/mustache/SharedTests.java::com.samskivert.mustache.SharedTests#testEmptyArraySection()|test|已保存|
|com/samskivert/mustache/SharedTests.java::com.samskivert.mustache.SharedTests#testEmptyIteratorSection()|test|已保存|
|com/samskivert/mustache/SharedTests.java::com.samskivert.mustache.SharedTests#testFalseSection()|test|已保存|
|com/samskivert/mustache/SharedTests.java::com.samskivert.mustache.SharedTests#testNestedListSection()|test|已保存|
|com/samskivert/mustache/SharedTests.java::com.samskivert.mustache.SharedTests#testNullSection()|test|已保存|
|com/samskivert/mustache/SharedTests.java::com.samskivert.mustache.SharedTests#testMissingNonStrictSection()|test|已保存|
|com/samskivert/mustache/SharedTests.java::com.samskivert.mustache.SharedTests#testMissingStrictSection()|test|已保存|
|com/samskivert/mustache/SharedTests.java::com.samskivert.mustache.SharedTests#testMissingStrictSectionNullValue()|test|已保存|
|com/samskivert/mustache/SharedTests.java::com.samskivert.mustache.SharedTests#testMissingStrictSectionDefaultValue()|test|已保存|
|com/samskivert/mustache/SharedTests.java::com.samskivert.mustache.SharedTests#testSectionWithNonFalseyEmptyString()|test|已保存|
|com/samskivert/mustache/SharedTests.java::com.samskivert.mustache.SharedTests#testSectionWithFalseyEmptyString()|test|已保存|
|com/samskivert/mustache/SharedTests.java::com.samskivert.mustache.SharedTests#testComment()|test|已保存|
|com/samskivert/mustache/SharedTests.java::com.samskivert.mustache.SharedTests#testCommentWithFunnyChars()|test|已保存|
|com/samskivert/mustache/SharedTests.java::com.samskivert.mustache.SharedTests#testPartialUseWhenUnconfigured()|test|已保存|
|com/samskivert/mustache/SharedTests.java::com.samskivert.mustache.SharedTests#field:partials|field|无方法体／非方法|
|com/samskivert/mustache/SharedTests.java::com.samskivert.mustache.SharedTests#partials(Map.Entry<String,String>[])|helper|已保存|
|com/samskivert/mustache/SharedTests.java::com.samskivert.mustache.SharedTests#testPartial()|test|已保存|
|com/samskivert/mustache/SharedTests.java::com.samskivert.mustache.SharedTests#testPartialIndent()|test|已保存|
|com/samskivert/mustache/SharedTests.java::com.samskivert.mustache.SharedTests#testPartialBlankLines()|test|已保存|
|com/samskivert/mustache/SharedTests.java::com.samskivert.mustache.SharedTests#testNestedPartialBlankLines()|test|已保存|
|com/samskivert/mustache/SharedTests.java::com.samskivert.mustache.SharedTests#testNestedPartialBlankLinesCRLF()|test|已保存|
|com/samskivert/mustache/SharedTests.java::com.samskivert.mustache.SharedTests#testNestedPartialIndent()|test|已保存|
|com/samskivert/mustache/SharedTests.java::com.samskivert.mustache.SharedTests#testPartialIndentWithVariableAtTheStart()|test|已保存|
|com/samskivert/mustache/SharedTests.java::com.samskivert.mustache.SharedTests#testPartialIndentWithBlock()|test|已保存|
|com/samskivert/mustache/SharedTests.java::com.samskivert.mustache.SharedTests#testPartialIndentInBlock()|test|已保存|
|com/samskivert/mustache/SharedTests.java::com.samskivert.mustache.SharedTests#testPartialIndentWithBlockAtStart()|test|已保存|
|com/samskivert/mustache/SharedTests.java::com.samskivert.mustache.SharedTests#testPartialIndentWithInlineBlock()|test|已保存|
|com/samskivert/mustache/SharedTests.java::com.samskivert.mustache.SharedTests#testPartialPlusNestedContext()|test|已保存|
|com/samskivert/mustache/SharedTests.java::com.samskivert.mustache.SharedTests#testRecursivePartial()|test|已保存|
|com/samskivert/mustache/SharedTests.java::com.samskivert.mustache.SharedTests#testDelimiterChange()|test|已保存|
|com/samskivert/mustache/SharedTests.java::com.samskivert.mustache.SharedTests#testUnescapeHTML()|test|已保存|
|com/samskivert/mustache/SharedTests.java::com.samskivert.mustache.SharedTests#testDanglingTag()|test|已保存|
|com/samskivert/mustache/SharedTests.java::com.samskivert.mustache.SharedTests#testStrayTagCharacters()|test|已保存|
|com/samskivert/mustache/SharedTests.java::com.samskivert.mustache.SharedTests#testInvalidUnescapeHTML()|test|已保存|
|com/samskivert/mustache/SharedTests.java::com.samskivert.mustache.SharedTests#testEscapeHTML()|test|已保存|
|com/samskivert/mustache/SharedTests.java::com.samskivert.mustache.SharedTests#testUserDefinedEscaping()|test|已保存|
|com/samskivert/mustache/SharedTests.java::com.samskivert.mustache.SharedTests#testPartialDelimiterMatch()|test|已保存|
|com/samskivert/mustache/SharedTests.java::com.samskivert.mustache.SharedTests#testTopLevelThis()|test|已保存|
|com/samskivert/mustache/SharedTests.java::com.samskivert.mustache.SharedTests#testNestedThis()|test|已保存|
|com/samskivert/mustache/SharedTests.java::com.samskivert.mustache.SharedTests#testNestedNullThis()|test|已保存|
|com/samskivert/mustache/SharedTests.java::com.samskivert.mustache.SharedTests#testNewlineSkipping()|test|已保存|
|com/samskivert/mustache/SharedTests.java::com.samskivert.mustache.SharedTests#testNewlineSkippingCRLF()|test|已保存|
|com/samskivert/mustache/SharedTests.java::com.samskivert.mustache.SharedTests#testNewlineSkippingDelimsTag()|test|已保存|
|com/samskivert/mustache/SharedTests.java::com.samskivert.mustache.SharedTests#testNoTrimNewlineFromNestedTagAt0()|test|已保存|
|com/samskivert/mustache/SharedTests.java::com.samskivert.mustache.SharedTests#testTrimBlank()|test|已保存|
|com/samskivert/mustache/SharedTests.java::com.samskivert.mustache.SharedTests$GetKeysVisitor#field:keys|field|无方法体／非方法|
|com/samskivert/mustache/SharedTests.java::com.samskivert.mustache.SharedTests$GetKeysVisitor#visitText(String)|helper|已保存|
|com/samskivert/mustache/SharedTests.java::com.samskivert.mustache.SharedTests$GetKeysVisitor#visitVariable(String)|helper|已保存|
|com/samskivert/mustache/SharedTests.java::com.samskivert.mustache.SharedTests$GetKeysVisitor#visitInclude(String)|helper|已保存|
|com/samskivert/mustache/SharedTests.java::com.samskivert.mustache.SharedTests$GetKeysVisitor#visitSection(String)|helper|已保存|
|com/samskivert/mustache/SharedTests.java::com.samskivert.mustache.SharedTests$GetKeysVisitor#visitInvertedSection(String)|helper|已保存|
|com/samskivert/mustache/SharedTests.java::com.samskivert.mustache.SharedTests#testVisit()|test|已保存|
|com/samskivert/mustache/SharedTests.java::com.samskivert.mustache.SharedTests#testVisitNested()|test|已保存|
|com/samskivert/mustache/SharedTests.java::com.samskivert.mustache.SharedTests#testNewlineSkipping(String)|helper|已保存|
|com/samskivert/mustache/SharedTests.java::com.samskivert.mustache.SharedTests#testNewlineNonSkipping()|test|已保存|
|com/samskivert/mustache/SharedTests.java::com.samskivert.mustache.SharedTests#testNestedContexts()|test|已保存|
|com/samskivert/mustache/SharedTests.java::com.samskivert.mustache.SharedTests#testShadowedContext()|test|已保存|
|com/samskivert/mustache/SharedTests.java::com.samskivert.mustache.SharedTests#testFirst()|test|已保存|
|com/samskivert/mustache/SharedTests.java::com.samskivert.mustache.SharedTests#testLast()|test|已保存|
|com/samskivert/mustache/SharedTests.java::com.samskivert.mustache.SharedTests#testFirstLast()|test|已保存|
|com/samskivert/mustache/SharedTests.java::com.samskivert.mustache.SharedTests#testFirstLastCombo()|test|已保存|
|com/samskivert/mustache/SharedTests.java::com.samskivert.mustache.SharedTests#testInverseFirstLastCombo()|test|已保存|
|com/samskivert/mustache/SharedTests.java::com.samskivert.mustache.SharedTests#testNotFirst()|test|已保存|
|com/samskivert/mustache/SharedTests.java::com.samskivert.mustache.SharedTests#testNotLast()|test|已保存|
|com/samskivert/mustache/SharedTests.java::com.samskivert.mustache.SharedTests#testIndex()|test|已保存|
|com/samskivert/mustache/SharedTests.java::com.samskivert.mustache.SharedTests#testNestedIndex()|test|已保存|
|com/samskivert/mustache/SharedTests.java::com.samskivert.mustache.SharedTests#testLineReporting()|test|已保存|
|com/samskivert/mustache/SharedTests.java::com.samskivert.mustache.SharedTests#testStandardsModeWithNullValuesInLoop()|test|已保存|
|com/samskivert/mustache/SharedTests.java::com.samskivert.mustache.SharedTests#testStandardsModeWithNullValuesInInverseLoop()|test|已保存|
|com/samskivert/mustache/SharedTests.java::com.samskivert.mustache.SharedTests#testStandardsModeWithDotValue()|test|已保存|
|com/samskivert/mustache/SharedTests.java::com.samskivert.mustache.SharedTests#testStandardsModeWithNoParentContextSearching()|test|已保存|
|com/samskivert/mustache/SharedTests.java::com.samskivert.mustache.SharedTests#testMissingValue()|test|已保存|
|com/samskivert/mustache/SharedTests.java::com.samskivert.mustache.SharedTests#testMissingValueWithDefault()|test|已保存|
|com/samskivert/mustache/SharedTests.java::com.samskivert.mustache.SharedTests#testMissingValueWithDefaultNonEmptyString()|test|已保存|
|com/samskivert/mustache/SharedTests.java::com.samskivert.mustache.SharedTests#testMissingValueWithDefaultSubstitution()|test|已保存|
|com/samskivert/mustache/SharedTests.java::com.samskivert.mustache.SharedTests#testMissingValueWithDefaultSubstitution2()|test|已保存|
|com/samskivert/mustache/SharedTests.java::com.samskivert.mustache.SharedTests#testMissingValueWithDefaultSubstitution3()|test|已保存|
|com/samskivert/mustache/SharedTests.java::com.samskivert.mustache.SharedTests#testNullValueGetsDefault()|test|已保存|
|com/samskivert/mustache/SharedTests.java::com.samskivert.mustache.SharedTests#testMissingValueWithNullDefault()|test|已保存|
|com/samskivert/mustache/SharedTests.java::com.samskivert.mustache.SharedTests#testInvalidTripleMustache()|test|已保存|
|com/samskivert/mustache/SharedTests.java::com.samskivert.mustache.SharedTests#testNullValueGetsNullDefault()|test|已保存|
|com/samskivert/mustache/SharedTests.java::com.samskivert.mustache.SharedTests#testCompilingDoesntChangeCompilersDelimiters()|test|已保存|
|com/samskivert/mustache/SharedTests.java::com.samskivert.mustache.SharedTests#testLambda1()|test|已保存|
|com/samskivert/mustache/SharedTests.java::com.samskivert.mustache.SharedTests#testLambda2()|test|已保存|
|com/samskivert/mustache/SharedTests.java::com.samskivert.mustache.SharedTests#testInvertibleLambda()|test|已保存|
|com/samskivert/mustache/SharedTests.java::com.samskivert.mustache.SharedTests#testLambdaWithContext()|test|已保存|
|com/samskivert/mustache/SharedTests.java::com.samskivert.mustache.SharedTests#testLambdaDecompile()|test|已保存|
|com/samskivert/mustache/SharedTests.java::com.samskivert.mustache.SharedTests#testLambdaFragExecTemplate()|test|已保存|
|com/samskivert/mustache/SharedTests.java::com.samskivert.mustache.SharedTests#testNonStandardDefaultDelims()|test|已保存|
|com/samskivert/mustache/SharedTests.java::com.samskivert.mustache.SharedTests#field:name|field|无方法体／非方法|
|com/samskivert/mustache/SharedTests.java::com.samskivert.mustache.SharedTests#field:watcher|field|无方法体／非方法|
|com/samskivert/mustache/SharedTests.java::com.samskivert.mustache.SharedTests#test(Mustache.Compiler,String,String,Object)|helper|已保存|
|com/samskivert/mustache/SharedTests.java::com.samskivert.mustache.SharedTests#check(String,String)|helper|已保存|
|com/samskivert/mustache/SharedTests.java::com.samskivert.mustache.SharedTests#test(String,String,Object)|helper|已保存|
|com/samskivert/mustache/SharedTests.java::com.samskivert.mustache.SharedTests#uncrlf(String)|helper|已保存|
|com/samskivert/mustache/SharedTests.java::com.samskivert.mustache.SharedTests#context(Object[])|helper|已保存|
|com/samskivert/mustache/SharedTests.java::com.samskivert.mustache.SharedTests#field:EMPTY|field|无方法体／非方法|
|com/samskivert/mustache/specs/CustomSpecTest.java::com.samskivert.mustache.specs.CustomSpecTest#<init>(Spec,String)|constructor|已保存|
|com/samskivert/mustache/specs/CustomSpecTest.java::com.samskivert.mustache.specs.CustomSpecTest#data()|helper|已保存|
|com/samskivert/mustache/specs/OfficialSpecTest.java::com.samskivert.mustache.specs.OfficialSpecTest#<init>(Spec,String)|constructor|已保存|
|com/samskivert/mustache/specs/OfficialSpecTest.java::com.samskivert.mustache.specs.OfficialSpecTest#data()|helper|已保存|
|com/samskivert/mustache/specs/Spec.java::com.samskivert.mustache.specs.Spec#field:map|field|无方法体／非方法|
|com/samskivert/mustache/specs/Spec.java::com.samskivert.mustache.specs.Spec#field:partials|field|无方法体／非方法|
|com/samskivert/mustache/specs/Spec.java::com.samskivert.mustache.specs.Spec#<init>(Map<String,Object>)|constructor|已保存|
|com/samskivert/mustache/specs/Spec.java::com.samskivert.mustache.specs.Spec#getName()|helper|已保存|
|com/samskivert/mustache/specs/Spec.java::com.samskivert.mustache.specs.Spec#getDescription()|helper|已保存|
|com/samskivert/mustache/specs/Spec.java::com.samskivert.mustache.specs.Spec#getTemplate()|helper|已保存|
|com/samskivert/mustache/specs/Spec.java::com.samskivert.mustache.specs.Spec#getExpectedOutput()|helper|已保存|
|com/samskivert/mustache/specs/Spec.java::com.samskivert.mustache.specs.Spec#getData()|helper|已保存|
|com/samskivert/mustache/specs/Spec.java::com.samskivert.mustache.specs.Spec#getPartial(String)|helper|已保存|
|com/samskivert/mustache/specs/Spec.java::com.samskivert.mustache.specs.Spec#toString()|helper|已保存|
|com/samskivert/mustache/specs/SpecAwareTemplateLoader.java::com.samskivert.mustache.specs.SpecAwareTemplateLoader#field:EMPTY_STRING|field|无方法体／非方法|
|com/samskivert/mustache/specs/SpecAwareTemplateLoader.java::com.samskivert.mustache.specs.SpecAwareTemplateLoader#field:spec|field|无方法体／非方法|
|com/samskivert/mustache/specs/SpecAwareTemplateLoader.java::com.samskivert.mustache.specs.SpecAwareTemplateLoader#<init>(Spec)|constructor|已保存|
|com/samskivert/mustache/specs/SpecAwareTemplateLoader.java::com.samskivert.mustache.specs.SpecAwareTemplateLoader#getTemplate(String)|helper|已保存|
|com/samskivert/mustache/specs/SpecTest.java::com.samskivert.mustache.specs.SpecTest#field:yaml|field|无方法体／非方法|
|com/samskivert/mustache/specs/SpecTest.java::com.samskivert.mustache.specs.SpecTest#field:spec|field|无方法体／非方法|
|com/samskivert/mustache/specs/SpecTest.java::com.samskivert.mustache.specs.SpecTest#field:name|field|无方法体／非方法|
|com/samskivert/mustache/specs/SpecTest.java::com.samskivert.mustache.specs.SpecTest#<init>(Spec,String)|constructor|已保存|
|com/samskivert/mustache/specs/SpecTest.java::com.samskivert.mustache.specs.SpecTest#test()|test|已保存|
|com/samskivert/mustache/specs/SpecTest.java::com.samskivert.mustache.specs.SpecTest#showWhitespace(String)|helper|已保存|
|com/samskivert/mustache/specs/SpecTest.java::com.samskivert.mustache.specs.SpecTest#uncrlf(String)|helper|已保存|
|com/samskivert/mustache/specs/SpecTest.java::com.samskivert.mustache.specs.SpecTest#data(String,String[])|helper|已保存|
|com/samskivert/mustache/specs/SpecTest.java::com.samskivert.mustache.specs.SpecTest#getTestsForGroup(String,String)|helper|已保存|
|com/samskivert/mustache/specs/SpecTest.java::com.samskivert.mustache.specs.SpecTest#getTestsFromYaml(String,String)|helper|已保存|
|com/samskivert/mustache/ThreadSafetyTest.java::com.samskivert.mustache.ThreadSafetyTest#field:templateA|field|无方法体／非方法|
|com/samskivert/mustache/ThreadSafetyTest.java::com.samskivert.mustache.ThreadSafetyTest#field:templateB|field|无方法体／非方法|
|com/samskivert/mustache/ThreadSafetyTest.java::com.samskivert.mustache.ThreadSafetyTest$CountingLoader#field:counter|field|无方法体／非方法|
|com/samskivert/mustache/ThreadSafetyTest.java::com.samskivert.mustache.ThreadSafetyTest$CountingLoader#getTemplate(String)|helper|已保存|
|com/samskivert/mustache/ThreadSafetyTest.java::com.samskivert.mustache.ThreadSafetyTest$CountingLoader#counter()|helper|已保存|
|com/samskivert/mustache/ThreadSafetyTest.java::com.samskivert.mustache.ThreadSafetyTest#testTemplateLoading()|test|已保存|
|com/samskivert/mustache/ThreadSafetyTest.java::com.samskivert.mustache.ThreadSafetyTest#templateLoadingIsThreadSafe(int)|helper|已保存|
|com/samskivert/mustache/ThreadSafetyTest.java::com.samskivert.mustache.ThreadSafetyTest#testPartialThreadSafe()|test|已保存|

## 支持边界

方法内局部类和匿名类只保存在完整原方法体中；字段初始化保持原样；类级初始化块原样保留并报告。参数类型按源码记录，未做完整类型解析。扩展JUnit机制只识别角色，不保证其可迁移性。骨架抛出占位异常，不可当成已恢复行为的测试。

- com/samskivert/mustache/MustacheTest.java：LOCAL_OR_ANONYMOUS_CLASS_IN_METHOD — Class inside removed body remains in original_body only
- com/samskivert/mustache/MustacheTest.java：LOCAL_OR_ANONYMOUS_CLASS_IN_METHOD — Class inside removed body remains in original_body only
- com/samskivert/mustache/MustacheTest.java：LOCAL_OR_ANONYMOUS_CLASS_IN_METHOD — Class inside removed body remains in original_body only
- com/samskivert/mustache/MustacheTest.java：LOCAL_OR_ANONYMOUS_CLASS_IN_METHOD — Class inside removed body remains in original_body only
- com/samskivert/mustache/MustacheTest.java：LOCAL_OR_ANONYMOUS_CLASS_IN_METHOD — Class inside removed body remains in original_body only
- com/samskivert/mustache/MustacheTest.java：LOCAL_OR_ANONYMOUS_CLASS_IN_METHOD — Class inside removed body remains in original_body only
- com/samskivert/mustache/MustacheTest.java：LOCAL_OR_ANONYMOUS_CLASS_IN_METHOD — Class inside removed body remains in original_body only
- com/samskivert/mustache/MustacheTest.java：LOCAL_OR_ANONYMOUS_CLASS_IN_METHOD — Class inside removed body remains in original_body only
- com/samskivert/mustache/MustacheTest.java：LOCAL_OR_ANONYMOUS_CLASS_IN_METHOD — Class inside removed body remains in original_body only
- com/samskivert/mustache/MustacheTest.java：LOCAL_OR_ANONYMOUS_CLASS_IN_METHOD — Class inside removed body remains in original_body only
- com/samskivert/mustache/MustacheTest.java：LOCAL_OR_ANONYMOUS_CLASS_IN_METHOD — Class inside removed body remains in original_body only
- com/samskivert/mustache/MustacheTest.java：LOCAL_OR_ANONYMOUS_CLASS_IN_METHOD — Class inside removed body remains in original_body only
- com/samskivert/mustache/MustacheTest.java：LOCAL_OR_ANONYMOUS_CLASS_IN_METHOD — Class inside removed body remains in original_body only
- com/samskivert/mustache/MustacheTest.java：LOCAL_OR_ANONYMOUS_CLASS_IN_METHOD — Class inside removed body remains in original_body only
- com/samskivert/mustache/MustacheTest.java：LOCAL_OR_ANONYMOUS_CLASS_IN_METHOD — Class inside removed body remains in original_body only
- com/samskivert/mustache/MustacheTest.java：LOCAL_OR_ANONYMOUS_CLASS_IN_METHOD — Class inside removed body remains in original_body only
- com/samskivert/mustache/MustacheTest.java：LOCAL_OR_ANONYMOUS_CLASS_IN_METHOD — Class inside removed body remains in original_body only
- com/samskivert/mustache/MustacheTest.java：LOCAL_OR_ANONYMOUS_CLASS_IN_METHOD — Class inside removed body remains in original_body only
- com/samskivert/mustache/MustacheTest.java：LOCAL_OR_ANONYMOUS_CLASS_IN_METHOD — Class inside removed body remains in original_body only
- com/samskivert/mustache/MustacheTest.java：LOCAL_OR_ANONYMOUS_CLASS_IN_METHOD — Class inside removed body remains in original_body only
- com/samskivert/mustache/MustacheTest.java：LOCAL_OR_ANONYMOUS_CLASS_IN_METHOD — Class inside removed body remains in original_body only
- com/samskivert/mustache/MustacheTest.java：LOCAL_OR_ANONYMOUS_CLASS_IN_METHOD — Class inside removed body remains in original_body only
- com/samskivert/mustache/MustacheTest.java：LOCAL_OR_ANONYMOUS_CLASS_IN_METHOD — Class inside removed body remains in original_body only
- com/samskivert/mustache/MustacheTest.java：LOCAL_OR_ANONYMOUS_CLASS_IN_METHOD — Class inside removed body remains in original_body only
- com/samskivert/mustache/MustacheTest.java：LOCAL_OR_ANONYMOUS_CLASS_IN_METHOD — Class inside removed body remains in original_body only
- com/samskivert/mustache/MustacheTest.java：LOCAL_OR_ANONYMOUS_CLASS_IN_METHOD — Class inside removed body remains in original_body only
- com/samskivert/mustache/MustacheTest.java：LOCAL_OR_ANONYMOUS_CLASS_IN_METHOD — Class inside removed body remains in original_body only
- com/samskivert/mustache/MustacheTest.java：LOCAL_OR_ANONYMOUS_CLASS_IN_METHOD — Class inside removed body remains in original_body only
- com/samskivert/mustache/MustacheTest.java：LOCAL_OR_ANONYMOUS_CLASS_IN_METHOD — Class inside removed body remains in original_body only
- com/samskivert/mustache/MustacheTest.java：LOCAL_OR_ANONYMOUS_CLASS_IN_METHOD — Class inside removed body remains in original_body only
- com/samskivert/mustache/MustacheTest.java：LOCAL_OR_ANONYMOUS_CLASS_IN_METHOD — Class inside removed body remains in original_body only
- com/samskivert/mustache/SharedTests.java：LOCAL_OR_ANONYMOUS_CLASS_IN_METHOD — Class inside removed body remains in original_body only
- com/samskivert/mustache/SharedTests.java：LOCAL_OR_ANONYMOUS_CLASS_IN_METHOD — Class inside removed body remains in original_body only
- com/samskivert/mustache/SharedTests.java：LOCAL_OR_ANONYMOUS_CLASS_IN_METHOD — Class inside removed body remains in original_body only
- com/samskivert/mustache/SharedTests.java：LOCAL_OR_ANONYMOUS_CLASS_IN_METHOD — Class inside removed body remains in original_body only
- com/samskivert/mustache/SharedTests.java：LOCAL_OR_ANONYMOUS_CLASS_IN_METHOD — Class inside removed body remains in original_body only
- com/samskivert/mustache/SharedTests.java：LOCAL_OR_ANONYMOUS_CLASS_IN_METHOD — Class inside removed body remains in original_body only
- com/samskivert/mustache/SharedTests.java：LOCAL_OR_ANONYMOUS_CLASS_IN_METHOD — Class inside removed body remains in original_body only
- com/samskivert/mustache/SharedTests.java：LOCAL_OR_ANONYMOUS_CLASS_IN_METHOD — Class inside removed body remains in original_body only
- com/samskivert/mustache/SharedTests.java：LOCAL_OR_ANONYMOUS_CLASS_IN_METHOD — Class inside removed body remains in original_body only
- com/samskivert/mustache/SharedTests.java：LOCAL_OR_ANONYMOUS_CLASS_IN_METHOD — Class inside removed body remains in original_body only
- com/samskivert/mustache/SharedTests.java：LOCAL_OR_ANONYMOUS_CLASS_IN_METHOD — Class inside removed body remains in original_body only
- com/samskivert/mustache/SharedTests.java：LOCAL_OR_ANONYMOUS_CLASS_IN_METHOD — Class inside removed body remains in original_body only
- com/samskivert/mustache/SharedTests.java：LOCAL_OR_ANONYMOUS_CLASS_IN_METHOD — Class inside removed body remains in original_body only
- com/samskivert/mustache/SharedTests.java：LOCAL_OR_ANONYMOUS_CLASS_IN_METHOD — Class inside removed body remains in original_body only
- com/samskivert/mustache/SharedTests.java：LOCAL_OR_ANONYMOUS_CLASS_IN_METHOD — Class inside removed body remains in original_body only
- com/samskivert/mustache/SharedTests.java：LOCAL_OR_ANONYMOUS_CLASS_IN_METHOD — Class inside removed body remains in original_body only
- com/samskivert/mustache/SharedTests.java：LOCAL_OR_ANONYMOUS_CLASS_IN_METHOD — Class inside removed body remains in original_body only
- com/samskivert/mustache/SharedTests.java：LOCAL_OR_ANONYMOUS_CLASS_IN_METHOD — Class inside removed body remains in original_body only
- com/samskivert/mustache/SharedTests.java：LOCAL_OR_ANONYMOUS_CLASS_IN_METHOD — Class inside removed body remains in original_body only
- com/samskivert/mustache/SharedTests.java：LOCAL_OR_ANONYMOUS_CLASS_IN_METHOD — Class inside removed body remains in original_body only
- com/samskivert/mustache/SharedTests.java：LOCAL_OR_ANONYMOUS_CLASS_IN_METHOD — Class inside removed body remains in original_body only
- com/samskivert/mustache/SharedTests.java：LOCAL_OR_ANONYMOUS_CLASS_IN_METHOD — Class inside removed body remains in original_body only
- com/samskivert/mustache/ThreadSafetyTest.java：LOCAL_OR_ANONYMOUS_CLASS_IN_METHOD — Class inside removed body remains in original_body only
