# 上下文工具（第二版）

输入完整 Java 项目和测试范围，输出同版源码、项目索引、初始上下文及查询结果。入口为 context_tool.py，Agent 在本机调用。

| 材料 | 位置 |
| --- | --- |
| 程序源码 | 本目录的 Python 文件与 tools/SymbolFacts.java |
| 解析依赖 | vendor/ |
| 回归测试和微型夹具 | tests/ |
| 输入输出说明 | [主体 README](../README.md) |
| 函数及实现逻辑 | [源码阅读指南](../源码阅读指南.md) |
| 职责和待实现项 | [流程说明](../职责分工与流程.md) |
| 依赖和许可 | [来源说明](依赖与来源.md) |

## week12 可选成员表

`build --java-members <members.json>` 可重复提供同版 Java 提取结果。程序校验来源路径、SHA-256、所属声明区间和原方法体，将表复制进索引目录。旧表与当前源码不同版会失败；不提供该参数时按原方式分析。

新索引的 `java_members.member_links` 关联原成员 ID 与上下文 key，`test_invocations` 保留执行子类与声明基类；suite 的整类、逐条及任务文件同步保留该身份。JUnit 4 注解的 expected/timeout 仅作为语义复核信息。具体职责和新旧配置的区别见 [week12 对接](../集成适配/README.md)。
