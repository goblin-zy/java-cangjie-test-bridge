# 蔡俊杰week7：Java测试骨架提取与已有仓颉测试

本分支根目录即完整第七周项目。第六周历史材料见[蔡俊杰week6分支](https://github.com/goblin-zy/java-cangjie-test-bridge/tree/%E8%94%A1%E4%BF%8A%E6%9D%B0week6)。

本周主要完成两部分：**提取Java测试的结构骨架**，以及**整理、运行并检查已有仓颉参考测试**。前者为后续按成员翻译提供材料，后者为后续评价生成测试提供参考。

## 一、Java测试骨架提取

### 骨架是什么，有什么作用

Java测试骨架保留包、导入、类声明、字段及初始化、方法签名和注解，将方法体替换为明确的占位异常。原方法体单独保存，便于后续找到每个成员、组织翻译上下文并回填结果。

例如，原测试中的取款操作和断言：

```java
@Test void testWithdraw() {
    account.withdraw(30);
    assertEquals(70, account.getBalance());
}
```

提取后保留测试声明，用占位替换方法体：

```java
@Test void testWithdraw() {
    throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
}
```

上例账户由原测试的@BeforeEach方法初始化为余额100；初始化方法本身也会被识别、保存原方法体并生成占位。取款操作和断言保存在members.json的original_body中，不会因生成骨架而丢失。

### 本周实现与验证

- 使用JDK的javac语法树接口解析Java17源码，支持单文件和目录输入，不依赖固定业务类名。
- 输出原始源码副本、Java骨架、members.json和提取报告；记录成员ID、角色、签名及源码／骨架位置。
- 现有三个业务测试类共提取27个成员：24个测试方法、1个@BeforeEach初始化方法、1个辅助方法和1个字段。
- 检查重载、嵌套类、构造器委托、语法错误和输出保护；验收样例的方法体回填后与原文件逐字节一致。

骨架用于结构交接，其中的方法会抛占位异常，不能拿它代替完整测试运行。当前尚未实现完整跨文件符号绑定、继承生命周期和组合注解语义分析。

详细说明：[提取器使用方法与输出格式](docs/骨架提取-使用说明与输出格式.md) · [实际核对记录](docs/骨架提取-实际核对记录.md)。

## 二、已有仓颉参考测试

### 测试内容与用途

本目录整理了三个模块的仓颉业务实现及参考测试，并对照Java测试的输入、操作、预期结果和异常行为。它们是已有参考材料，后续可用于比较模型生成测试的行为和错误检测能力。

|模块|测试数量|主要检查内容|
|---|---:|---|
|账户Account|9|初始余额、存取款、连续操作、余额不足及非法金额|
|矩形Rectangle|6|坐标保存、字符串表示、相交、共享边和非法坐标|
|指令解析InstructionParser|9|空输入、空格、命名指令、整数与范围、非法输入|
|合计|24|逐项场景见reference/cases.json|

### 已有验证结果

1. 参考业务实现与24项仓颉测试已编译运行，24项全部通过。
2. 在独立业务副本中分别注入取款加钱、共享边判断错误、INC映射错误、取款失败后扣费四种错误，参考测试均发现了相应错误。
3. 保存编译和运行日志、逐项结果、源码哈希与错误补丁；错误注入实验不修改正式实现和测试。
4. 支持全部、单个方法和按测试类运行；单项示例为AccountTest.testWithdraw，按类示例为RectangleTest.*。

仓颉结果来自SDK1.2.0配合非官方实验性localfix运行库，不能视为原版SDK验证通过。当前24项场景与四种错误提供有限验证证据，尚未完成大模型测试翻译效果评估。

详细说明：[逐项测试核对](docs/参考仓颉测试-说明与逐项核对.md) · [错误检测验证](docs/参考测试-运行与检查能力.md) · [VS Code复现步骤](docs/仓颉测试-VSCode复现步骤.md)。

## 三、目录与文件内容

以下路径均相对于本README所在目录。GitHub中请切换到“蔡俊杰week7”分支；克隆后直接在VS Code中打开仓库根目录。

|目录／文件|内容|
|---|---|
|src/main/java/JavaTestSkeletonExtractor.java|Java骨架提取器实现|
|src/main/java/study/translation/|账户、矩形、指令解析等Java业务实现|
|src/test/java/JavaTestSkeletonExtractorTest.java|提取器的6项JUnit自测|
|src/test/java/study/translation/|三个业务测试类，共24项JUnit测试|
|generated/business-tests/|三类测试的实际提取结果：original/、skeleton/、members.json、提取报告|
|generated/single-account/|单文件提取示例|
|reference/cangjie/implementation/|已有仓颉业务实现|
|reference/cangjie/tests/|24项参考仓颉测试源码|
|reference/cases.json|测试编号、输入、操作、预期及两侧源码对应|
|tests/|提取器结构样例、非法输入及验收脚本|
|tools/|原方法体回填等辅助工具|
|scripts/|提取、Java基线与仓颉测试运行脚本|
|validation/|验证汇总、编译运行记录、错误注入结果及补丁|
|docs/|使用说明、实际核对、限制、进度汇报与飞书汇报材料|
|.mvn/jvm.config|统一Maven JVM为UTF-8，避免中文目录下增量编译缓存编码不一致|
|.vscode/|Java测试、提取器启动及仓颉测试任务配置|
|pom.xml|统一Java项目配置，使用Java17和JUnit Jupiter 5.13.4|
|SOURCES.md、LICENSE-third-party.txt|材料来源、改动与许可说明|
|manifest.sha256|发布文件的SHA256清单|

## 四、运行入口

1. **Java测试：** 配置JDK17，等待Maven导入；在测试类点击Run Test，或在测试面板运行全部30项测试（业务24项＋提取器6项）。
2. **骨架提取：** 在“运行和调试”中选择“提取业务测试骨架”，启动后输入新的输出目录。
3. **仓颉测试：** 在.vscode/settings.json设置实际SDK目录；选择“终端→运行任务→运行仓颉参考测试（24项）”或“运行单个仓颉测试”。本目录是Maven项目，根目录没有cjpm.toml。

完整步骤见[VS Code运行说明](docs/VSCode运行说明.md)。环境前提与发布副本调整见[发布与复现说明](docs/发布与复现说明.md)，交付范围见[已知限制](docs/交付核对与已知限制.md)。

目录迁移与历史记录边界见[分支目录整理说明](docs/分支目录整理说明.md)；根目录结构复测结果见[验证汇总](validation/layout-20261029/results.json)。
