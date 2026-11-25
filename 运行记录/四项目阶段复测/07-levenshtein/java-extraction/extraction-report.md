# Java测试骨架提取记录

解析器：JDK javac语法树，Java17；仅解析，未执行符号绑定或测试。

文件：1；成员：10。

|成员标识|角色|原始方法体|
|---|---|---|
|LevenshteinDistanceTest.java::org.apache.commons.text.similarity.LevenshteinDistanceTest#field:UNLIMITED_DISTANCE|field|无方法体／非方法|
|LevenshteinDistanceTest.java::org.apache.commons.text.similarity.LevenshteinDistanceTest#testApplyThrowsIllegalArgumentExceptionAndCreatesLevenshteinDistanceTakingInteger()|test|已保存|
|LevenshteinDistanceTest.java::org.apache.commons.text.similarity.LevenshteinDistanceTest#testConstructorWithNegativeThreshold()|test|已保存|
|LevenshteinDistanceTest.java::org.apache.commons.text.similarity.LevenshteinDistanceTest#testGetLevenshteinDistance_NullString()|test|已保存|
|LevenshteinDistanceTest.java::org.apache.commons.text.similarity.LevenshteinDistanceTest#testGetLevenshteinDistance_NullStringInt()|test|已保存|
|LevenshteinDistanceTest.java::org.apache.commons.text.similarity.LevenshteinDistanceTest#testGetLevenshteinDistance_StringNull()|test|已保存|
|LevenshteinDistanceTest.java::org.apache.commons.text.similarity.LevenshteinDistanceTest#testGetLevenshteinDistance_StringNullInt()|test|已保存|
|LevenshteinDistanceTest.java::org.apache.commons.text.similarity.LevenshteinDistanceTest#testGetLevenshteinDistance_StringString()|test|已保存|
|LevenshteinDistanceTest.java::org.apache.commons.text.similarity.LevenshteinDistanceTest#testGetLevenshteinDistance_StringStringInt()|test|已保存|
|LevenshteinDistanceTest.java::org.apache.commons.text.similarity.LevenshteinDistanceTest#testGetThresholdDirectlyAfterObjectInstantiation()|test|已保存|

## 支持边界

方法内局部类和匿名类只保存在完整原方法体中；字段初始化保持原样；类级初始化块原样保留并报告。参数类型按源码记录，未做完整类型解析。扩展JUnit机制只识别角色，不保证其可迁移性。骨架抛出占位异常，不可当成已恢复行为的测试。

