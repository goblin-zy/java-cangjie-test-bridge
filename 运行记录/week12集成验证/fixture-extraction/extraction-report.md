# Java测试骨架提取记录

解析器：JDK javac语法树，Java17；仅解析，未执行符号绑定或测试。

文件：5；成员：7。

|成员标识|角色|原始方法体|
|---|---|---|
|p/BaseCase.java::p.BaseCase#field:value|field|无方法体／非方法|
|p/BaseCase.java::p.BaseCase#setUp()|lifecycle_BeforeEach|已保存|
|p/BaseCase.java::p.BaseCase#testFromBase()|test|已保存|
|p/BaseCase.java::p.BaseCase#testStatic()|helper|已保存|
|p/ChildCase.java::p.ChildCase#testOwn()|test|已保存|
|p/FakeCase.java::p.FakeCase#pretend()|helper|已保存|
|p/FourCase.java::p.FourCase#check()|test|已保存|

## 支持边界

方法内局部类和匿名类只保存在完整原方法体中；字段初始化保持原样；类级初始化块原样保留并报告。参数类型按源码记录，未做完整类型解析。扩展JUnit机制只识别角色，不保证其可迁移性。骨架抛出占位异常，不可当成已恢复行为的测试。

- p/FakeCase.java：UNRESOLVED_TEST_ANNOTATION — No confirmed JUnit binding for Test; no test role assumed
