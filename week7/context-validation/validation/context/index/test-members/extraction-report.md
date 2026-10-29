# Java测试骨架提取记录

解析器：JDK javac语法树，Java17；仅解析，未执行符号绑定或测试。

文件：4；成员：43。

|成员标识|角色|原始方法体|
|---|---|---|
|JavaTestSkeletonExtractorTest.java::JavaTestSkeletonExtractorTest#field:ROOT|field|无方法体／非方法|
|JavaTestSkeletonExtractorTest.java::JavaTestSkeletonExtractorTest#field:BUSINESS_TESTS|field|无方法体／非方法|
|JavaTestSkeletonExtractorTest.java::JavaTestSkeletonExtractorTest#extractsBusinessTestDirectory()|test|已保存|
|JavaTestSkeletonExtractorTest.java::JavaTestSkeletonExtractorTest#extractsSingleTestFile()|test|已保存|
|JavaTestSkeletonExtractorTest.java::JavaTestSkeletonExtractorTest#preservesOverloadsAndConstructorDelegation()|test|已保存|
|JavaTestSkeletonExtractorTest.java::JavaTestSkeletonExtractorTest#restoresOriginalSourceExactly()|test|已保存|
|JavaTestSkeletonExtractorTest.java::JavaTestSkeletonExtractorTest#reportsBrokenJavaSyntax()|test|已保存|
|JavaTestSkeletonExtractorTest.java::JavaTestSkeletonExtractorTest#protectsExistingOutput()|test|已保存|
|JavaTestSkeletonExtractorTest.java::JavaTestSkeletonExtractorTest#freshOutput(String)|helper|已保存|
|JavaTestSkeletonExtractorTest.java::JavaTestSkeletonExtractorTest#extract(Path,Path)|helper|已保存|
|JavaTestSkeletonExtractorTest.java::JavaTestSkeletonExtractorTest#findMember(JsonObject,String)|helper|已保存|
|JavaTestSkeletonExtractorTest.java::JavaTestSkeletonExtractorTest#findProjectRoot()|helper|已保存|
|JavaTestSkeletonExtractorTest.java::JavaTestSkeletonExtractorTest$RunResult#field:exitCode|field|无方法体／非方法|
|JavaTestSkeletonExtractorTest.java::JavaTestSkeletonExtractorTest$RunResult#field:log|field|无方法体／非方法|
|JavaTestSkeletonExtractorTest.java::JavaTestSkeletonExtractorTest$RunResult#field:output|field|无方法体／非方法|
|JavaTestSkeletonExtractorTest.java::JavaTestSkeletonExtractorTest$RunResult#field:metadata|field|无方法体／非方法|
|study/translation/AccountTest.java::study.translation.AccountTest#field:account|field|无方法体／非方法|
|study/translation/AccountTest.java::study.translation.AccountTest#setUp()|lifecycle_BeforeEach|已保存|
|study/translation/AccountTest.java::study.translation.AccountTest#prepareSequence()|helper|已保存|
|study/translation/AccountTest.java::study.translation.AccountTest#testInitialBalance()|test|已保存|
|study/translation/AccountTest.java::study.translation.AccountTest#testDeposit()|test|已保存|
|study/translation/AccountTest.java::study.translation.AccountTest#testWithdraw()|test|已保存|
|study/translation/AccountTest.java::study.translation.AccountTest#testWithdrawAll()|test|已保存|
|study/translation/AccountTest.java::study.translation.AccountTest#testSequence()|test|已保存|
|study/translation/AccountTest.java::study.translation.AccountTest#testInsufficientFunds()|test|已保存|
|study/translation/AccountTest.java::study.translation.AccountTest#testInvalidAmounts()|test|已保存|
|study/translation/AccountTest.java::study.translation.AccountTest#testBalanceLimit()|test|已保存|
|study/translation/AccountTest.java::study.translation.AccountTest#testInvalidInitialBalance()|test|已保存|
|study/translation/InstructionParserTest.java::study.translation.InstructionParserTest#testEmpty()|test|已保存|
|study/translation/InstructionParserTest.java::study.translation.InstructionParserTest#testSpaces()|test|已保存|
|study/translation/InstructionParserTest.java::study.translation.InstructionParserTest#testNamedInstructions()|test|已保存|
|study/translation/InstructionParserTest.java::study.translation.InstructionParserTest#testSignedNumbers()|test|已保存|
|study/translation/InstructionParserTest.java::study.translation.InstructionParserTest#testRepeatedSpaces()|test|已保存|
|study/translation/InstructionParserTest.java::study.translation.InstructionParserTest#testInt32Boundaries()|test|已保存|
|study/translation/InstructionParserTest.java::study.translation.InstructionParserTest#testInvalidTokens()|test|已保存|
|study/translation/InstructionParserTest.java::study.translation.InstructionParserTest#testOutOfRange()|test|已保存|
|study/translation/InstructionParserTest.java::study.translation.InstructionParserTest#testNullInput()|test|已保存|
|study/translation/RectangleTest.java::study.translation.RectangleTest#testConstructor()|test|已保存|
|study/translation/RectangleTest.java::study.translation.RectangleTest#testToString()|test|已保存|
|study/translation/RectangleTest.java::study.translation.RectangleTest#testIntersection()|test|已保存|
|study/translation/RectangleTest.java::study.translation.RectangleTest#testTouchingEdge()|test|已保存|
|study/translation/RectangleTest.java::study.translation.RectangleTest#testPointRectangle()|test|已保存|
|study/translation/RectangleTest.java::study.translation.RectangleTest#testInvalidCoordinates()|test|已保存|

## 支持边界

方法内局部类和匿名类只保存在完整原方法体中；字段初始化保持原样；类级初始化块原样保留并报告。参数类型按源码记录，未做完整类型解析。扩展JUnit机制只识别角色，不保证其可迁移性。骨架抛出占位异常，不可当成已恢复行为的测试。

- JavaTestSkeletonExtractorTest.java：RECORD_LIMITATION — Confirm compiler-shaped record member source positions manually
