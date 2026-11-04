# 蒋逸舟 · 第七周工作材料

负责人：蒋逸舟（mercury-carl）。本分支包含上下文查找工具、可行性验证方法执行及ReCodeAgent论文研读。

|用途|入口|说明|
|---|---|---|
|查找当前测试的具体上下文|[上下文查找工具](week7/context-lookup/README.md)|输入项目路径、测试文件或方法标识，输出实际代码、资源、来源和未解析项|
|查看工具使用方式与接口|[使用说明](week7/context-lookup/docs/使用说明.md)|不需要selection.json，可由程序或Agent直接调用|
|阅读实际输出|[样例输出](week7/context-lookup/actual/README.md)|原仓库账户测试及多模块依赖、资源、歧义场景|
|核对查找范围及停止条件|[查找策略](week7/context-lookup/docs/查找范围与策略.md)|初始化、清理、辅助断言、相关代码、资源和限制|
|查看可行性评价方法与记录|[可执行性评价](week7/context-validation/README.md)|评价工具与既有运行记录保留原内容|
|阅读ReCodeAgent论文|[论文研读](references/reading/recodeagent/README.md)|保留原有研读正文与来源核对材料|

上下文查找使用自带的 `JavaFacts.java`。需要生成 Java 骨架或 `members.json` 时，可使用[蔡俊杰第七周分支的提取器](https://github.com/goblin-zy/java-cangjie-test-bridge/tree/蔡俊杰week7)。

## 目录结构

```text
week7/context-lookup/       当前上下文查找工具、说明、测试与实际输出
week7/context-validation/   原评价工具和历史上下文/评价证据
week7/src/、reference/      固定版本Java与仓颉参考材料
references/reading/recodeagent/  论文研读
docs/                      任务及来源导航
```

上下文工具只负责方法／样例层材料，不筛选跨语言规则或组织完整模型输入。保留完整测试类，并标记实际展开成员；查找范围和未解析项明确记录。大型项目性能及完整动态依赖仍需后续验证。
