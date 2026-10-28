# Java测试骨架提取：使用说明与输出格式

## 输入与运行

输入单个UTF-8（无BOM）.java文件或目录。目录会递归处理所有.java文件，不根据文件名猜测测试类。输出目录必须是新目录或空目录，并在输入目录之外。建议全组固定输入根目录为src/test/java，以便成员标识一致。

```powershell
.\scripts\extract-java.ps1 -JavaHome 'E:\jdk17' -InputPath '.\examples\week6\java\src\test\java' -OutputDirectory '.\generated\run-001'
```

不使用PowerShell包装时：

```text
javac -encoding UTF-8 --add-modules jdk.compiler -d build/extractor src/main/java/JavaTestSkeletonExtractor.java
java "-Dfile.encoding=UTF-8" --add-modules jdk.compiler -cp build/extractor JavaTestSkeletonExtractor --input <文件或目录> --output <新输出目录>
```

完整JDK17+必须存在jdk.compiler；本工具按Java17语法处理。解析阶段不执行注解处理、不做类型归属分析，不需要先安装JUnit；原测试能否编译运行仍需单独确认。

## 输出文件

|文件|含义|
|---|---|
|original/相对路径.java|输入文件的原始字节副本，不修改输入|
|skeleton/相对路径.java|保留包、导入、类型声明、字段和初始化、方法头及注解；方法体改为明确占位|
|members.json|文件、类型和成员的机器可读记录；包含原始方法体及两侧源码位置|
|extraction-report.md|同一次输出的成员清单和限制／诊断摘要|

方法体统一用throw new UnsupportedOperationException("SKELETON_PLACEHOLDER")占位，避免空@Test方法被误认为测试成功。显式构造器this(...)或super(...)调用保留在第一条语句，随后是占位异常。无方法体的abstract、interface等声明不造出方法体。

## members.json主要结构

|字段|说明|
|---|---|
|schema_version/tool/java_language_level|格式、工具和语法级别|
|summary|文件、类型、成员、角色和语法错误计数|
|files|源文件／原副本／骨架路径、SHA-256、提取状态、包和导入|
|classes|类型名、包内限定名、kind、类型注解和两侧位置|
|members|字段、构造器、方法的明细|
|diagnostics|语法错误、注解无法确认、尚未独立支持的结构等|

成员主要字段：

- id：`相对文件::包.外部类$内部类#方法名(参数类型)`；构造器用`<init>`，字段用`#field:名称`。不绑定样例编号或业务类名。
- owner/name/parameter_types/return_type/throws/modifiers：身份与签名信息。参数类型是源码语法表示，不是类型解析后的全限定名。
- role：`test`、`lifecycle_BeforeEach`、`lifecycle_AfterEach`、`lifecycle_BeforeAll`、`lifecycle_AfterAll`、`helper`、`constructor`、`field`；扩展机制标为`test_ParameterizedTest`等。
- annotations：保留原注解和基于导入的候选绑定；不声称已完成符号解析。
- original_body：包含最外层花括号的原始方法体。无方法体时是null，而不是提取失败；字段没有该字段。
- signature_source：原始方法头，保留注解、泛型、参数和throws等表达。
- source_location/skeleton_location：原副本及骨架中整个成员的位置。
- body_source_location/skeleton_body_location：对应方法体位置；有方法体时存在。
- initializer：字段初始化的实际源码；没有初始化时是null。
- constructor_delegation：原构造器的显式this/super调用；没有时是null。

位置的start_offset_utf16与end_offset_utf16_exclusive使用Java字符串的UTF-16代码单元，结束偏移不包含该位置。行列从1开始；end_line/end_column表示最后一个包含字符。包含中文和表情时不能直接把这些偏移当UTF-8字节或Python字符下标。位置中的original/和skeleton/路径均相对members.json所在目录。

稳定性边界：同一输入根目录、文件相对路径和成员签名不变时id保持一致；更换输入根会改变文件前缀。下游也可用owner、name、parameter_types构建项目级符号键。缺失绑定和不支持结构在diagnostics或说明中体现，不给出虚假的已解析结论。

## 真实示例

generated/week6-tests/来自整个测试目录，共3文件、27成员。generated/single-account/来自单个AccountTest.java，共12成员。二者都保留AccountTest.account字段及初始化、setUp、prepareSequence和9个测试。
该文件的testWithdraw成员，role为test、参数为空、返回void；original_body保存取款30与余额70断言，骨架保留@Test和方法签名。整份真实JSON和.java已随包提供，而不是空模板。

## 支持范围与停止条件

- 主要支持普通具名类型及成员、JUnit Jupiter直接或星号导入、常规生命周期、重载、泛型、Lambda、嵌套具名类型和显式构造器委托。
- 字段及其初始化原样保留；不把字段初始化中的匿名类／Lambda拆成独立成员。类级初始化块原样保留并发出CLASS_INITIALIZER_RETAINED警告。
- 方法内局部类、匿名类只在original_body中完整保存，不再单独移除其方法体，避免重叠替换；发出LOCAL_OR_ANONYMOUS_CLASS_IN_METHOD警告。
- 参数化、重复、动态测试等可以识别注解角色，但未展开数据、发现测试实例或保证目标端对应机制。组合注解、继承生命周期、跨文件符号绑定及依赖闭包不在本模块支持范围内。
- 星号导入和注解遮蔽仅作语法级保守判断，角色不是JUnit运行器的权威发现结果。所有方法和注解仍导出，未知机制需人工核对。
- 语法错误文件标syntax_error，不生成成功骨架；目录中其他有效文件可继续输出，最终退出码非零。
- record等特殊结构会提示人工核查；不把第一版声明为所有Java语法及工程的完整分析器。

## 如何找回原方法体

原始副本可直接读取。也提供可选Python3.9+回填核对程序：

```text
python tools/restore_methods.py generated/week6-tests/members.json generated/restored-run-001
```

它按骨架中的方法体位置反向替换，并要求重建文件SHA-256与原始文件完全一致，失败则报错。它用于验证成员对应关系，不是仓颉逻辑填充器。

## 与TransRepo参考实现的关系

参考源码固定为microsoft/TransRepo提交a4825ba97cb2227773ec33c4c79a582d786ec639中的`transrepo/translators/java2csharp/skeleton/skeleton_extractor.py`。
该实现提供语法树定位方法／构造器、替换方法体、保留目录结构等可借鉴做法；还对静态初始化块保留部分赋值。本交付没有复制该Python提取器，而是独立使用JDK语法树实现，避免额外Tree-sitter二进制依赖。
本任务新增／明确了JUnit方法角色、原方法体保存、重载成员id、原副本与骨架位置、回填核对及不支持结构诊断。静态初始化策略选择原样保留并报告；占位选择抛异常，不沿用默认返回值。不是对论文实验效果的复现声明。
