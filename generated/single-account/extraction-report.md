# Java测试骨架提取记录

解析器：JDK javac语法树，Java17；仅解析，未执行符号绑定或测试。

文件：1；成员：12。

|成员标识|角色|原始方法体|
|---|---|---|
|AccountTest.java::study.translation.AccountTest#field:account|field|无方法体／非方法|
|AccountTest.java::study.translation.AccountTest#setUp()|lifecycle_BeforeEach|已保存|
|AccountTest.java::study.translation.AccountTest#prepareSequence()|helper|已保存|
|AccountTest.java::study.translation.AccountTest#testInitialBalance()|test|已保存|
|AccountTest.java::study.translation.AccountTest#testDeposit()|test|已保存|
|AccountTest.java::study.translation.AccountTest#testWithdraw()|test|已保存|
|AccountTest.java::study.translation.AccountTest#testWithdrawAll()|test|已保存|
|AccountTest.java::study.translation.AccountTest#testSequence()|test|已保存|
|AccountTest.java::study.translation.AccountTest#testInsufficientFunds()|test|已保存|
|AccountTest.java::study.translation.AccountTest#testInvalidAmounts()|test|已保存|
|AccountTest.java::study.translation.AccountTest#testBalanceLimit()|test|已保存|
|AccountTest.java::study.translation.AccountTest#testInvalidInitialBalance()|test|已保存|

## 支持边界

方法内局部类和匿名类只保存在完整原方法体中；字段初始化保持原样；类级初始化块原样保留并报告。参数类型按源码记录，未做完整类型解析。扩展JUnit机制只识别角色，不保证其可迁移性。骨架抛出占位异常，不可当成已恢复行为的测试。

