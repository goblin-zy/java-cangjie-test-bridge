# 来源与实现说明

## Java骨架提取工具

本次独立使用JDK javac Tree API编写，不是复制TransRepo提取器。参考实现阅读位置：
https://github.com/microsoft/TransRepo/blob/a4825ba97cb2227773ec33c4c79a582d786ec639/transrepo/translators/java2csharp/skeleton/skeleton_extractor.py

任务要求中的方法角色、原方法体、成员标识及双侧位置由本次实现补充。工具只提取Java骨架，不声称完成Java→仓颉结构或逻辑翻译。

## 现有实验材料

复制自第六周本地材料v1.2，保留具体来源与改编事实：
- Rectangle及R01—R03：改编自microsoft/TransRepo固定提交a4825ba97cb2227773ec33c4c79a582d786ec639；原路径为data/java_origin/double-dispatch/src/main/java/com/iluwatar/doubledispatch/Double-Dispatch/Rectangle.java及对应RectangleTest.java。版权Copyright © 2014-2022 Ilkka Seppälä，MIT许可随LICENSE-third-party.txt保留。
- R04—R06为新增边界和非法参数测试。
- InstructionParser/P01—P09、Account/A01—A09为本项目新编教学样例，不能标为TransRepo原始数据。
- 仓颉业务及参考测试为已有人工辅助迁移、整理材料；本次重新核对和运行，不是自动模型翻译成果。

结构测试fixtures为本次新编的解析验收输入，与24个业务测试分开统计；invalid/Broken.java是故意不合法的负例，不应加入正常Java业务构建。

本交付使用辅助工具完成实现与验收，不冒充组员手工逐项执行。结果保留实际命令、日志和环境。SDK不分发，原版SDK与Windows系统文件没有在本任务中修改。


## v1.1统一Java项目

原业务实现和24个JUnit测试按原字节复制到标准src/main/java与src/test/java；提取器移至src/main/java。新增JavaTestSkeletonExtractorTest的6项JUnit检查，根pom.xml统一依赖与测试入口，.vscode配置提供测试面板和main运行。合计30项通过，报告在validation/vscode-java-002/。参考仓颉场景仍为24个，不把6个Java工具自测计入翻译数据集。


界面警告清理：移除JavaTestSkeletonExtractorTest中未使用的JsonArray导入，以及RectangleTest、InstructionParserTest中未使用的BeforeEach导入；测试输入、调用和断言未改变。
