# Java测试骨架提取记录

解析器：JDK javac语法树，Java17；仅解析，未执行符号绑定或测试。

文件：4；成员：21。

|成员标识|角色|原始方法体|
|---|---|---|
|Account.java::study.translation.Account#field:MAX_BALANCE|field|无方法体／非方法|
|Account.java::study.translation.Account#field:balance|field|无方法体／非方法|
|Account.java::study.translation.Account#<init>(int)|constructor|已保存|
|Account.java::study.translation.Account#getBalance()|helper|已保存|
|Account.java::study.translation.Account#deposit(int)|helper|已保存|
|Account.java::study.translation.Account#withdraw(int)|helper|已保存|
|InstructionParser.java::study.translation.InstructionParser#<init>()|constructor|已保存|
|InstructionParser.java::study.translation.InstructionParser#parse(String)|helper|已保存|
|InstructionParser.java::study.translation.InstructionParser#parseNumber(String)|helper|已保存|
|InsufficientFundsException.java::study.translation.InsufficientFundsException#<init>(String)|constructor|已保存|
|Rectangle.java::study.translation.Rectangle#field:left|field|无方法体／非方法|
|Rectangle.java::study.translation.Rectangle#field:top|field|无方法体／非方法|
|Rectangle.java::study.translation.Rectangle#field:right|field|无方法体／非方法|
|Rectangle.java::study.translation.Rectangle#field:bottom|field|无方法体／非方法|
|Rectangle.java::study.translation.Rectangle#<init>(int,int,int,int)|constructor|已保存|
|Rectangle.java::study.translation.Rectangle#getLeft()|helper|已保存|
|Rectangle.java::study.translation.Rectangle#getTop()|helper|已保存|
|Rectangle.java::study.translation.Rectangle#getRight()|helper|已保存|
|Rectangle.java::study.translation.Rectangle#getBottom()|helper|已保存|
|Rectangle.java::study.translation.Rectangle#intersectsWith(Rectangle)|helper|已保存|
|Rectangle.java::study.translation.Rectangle#toString()|helper|已保存|

## 支持边界

方法内局部类和匿名类只保存在完整原方法体中；字段初始化保持原样；类级初始化块原样保留并报告。参数类型按源码记录，未做完整类型解析。扩展JUnit机制只识别角色，不保证其可迁移性。骨架抛出占位异常，不可当成已恢复行为的测试。

