# Java测试骨架提取记录

解析器：JDK javac语法树，Java17；仅解析，未执行符号绑定或测试。

文件：4；成员：19。

|成员标识|角色|原始方法体|
|---|---|---|
|ParameterCases.java::fixtures.ParameterCases#start()|lifecycle_BeforeAll|已保存|
|ParameterCases.java::fixtures.ParameterCases#stop()|lifecycle_AfterAll|已保存|
|ParameterCases.java::fixtures.ParameterCases#input(int)|test_ParameterizedTest|已保存|
|ParameterCases.java::fixtures.Contract#fetch()|helper|无方法体／非方法|
|ParameterCases.java::fixtures.Contract#defaultValue()|helper|已保存|
|ShadowedTest.java::fixtures.ShadowedTest#customAnnotation()|helper|已保存|
|StructureCases.java::fixtures.StructureCases#field:text|field|无方法体／非方法|
|StructureCases.java::fixtures.StructureCases#field:value|field|无方法体／非方法|
|StructureCases.java::fixtures.StructureCases#<init>()|constructor|已保存|
|StructureCases.java::fixtures.StructureCases#<init>(int)|constructor|已保存|
|StructureCases.java::fixtures.StructureCases#setup()|lifecycle_BeforeEach|已保存|
|StructureCases.java::fixtures.StructureCases#cleanup()|lifecycle_AfterEach|已保存|
|StructureCases.java::fixtures.StructureCases#lambdaWithBraces()|test|已保存|
|StructureCases.java::fixtures.StructureCases#overloaded(int)|helper|已保存|
|StructureCases.java::fixtures.StructureCases#overloaded(T)|helper|已保存|
|StructureCases.java::fixtures.StructureCases#localClassAndAnonymous()|helper|已保存|
|StructureCases.java::fixtures.StructureCases$NestedCase#nestedTest()|test|已保存|
|SuperCases.java::fixtures.ParentWithArgument#<init>(int)|constructor|已保存|
|SuperCases.java::fixtures.ChildWithArgument#<init>(int)|constructor|已保存|

## 支持边界

方法内局部类和匿名类只保存在完整原方法体中；字段初始化保持原样；类级初始化块原样保留并报告。参数类型按源码记录，未做完整类型解析。扩展JUnit机制只识别角色，不保证其可迁移性。骨架抛出占位异常，不可当成已恢复行为的测试。

- ParameterCases.java：EXTENDED_TEST_MECHANISM — Identified ParameterizedTest; data/dynamic execution needs downstream support
- ShadowedTest.java：UNRESOLVED_TEST_ANNOTATION — No confirmed JUnit binding for Test; no test role assumed
- StructureCases.java：LOCAL_OR_ANONYMOUS_CLASS_IN_METHOD — Class inside removed body remains in original_body only
- StructureCases.java：LOCAL_OR_ANONYMOUS_CLASS_IN_METHOD — Class inside removed body remains in original_body only
- StructureCases.java：CLASS_INITIALIZER_RETAINED — Class/static initializer retained unchanged, not treated as method
