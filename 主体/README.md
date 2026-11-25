# 输入输出与使用流程（第二版）

本部分有两项成果：上下文工具优化、整体翻译更改。工具调用和材料整理由当前 Agent 完成。

## 一、上下文工具

### 输入文件

| 输入 | 内容 | 样例位置 |
| --- | --- | --- |
| 完整 Java 项目目录 | 业务、测试、辅助代码、资源和项目配置 | 样例材料/Interval双语项目/java/ |
| 测试范围 | 本次选中的测试文件或类 | src/test/java/org/ahocorasick/interval/IntervalTest.java |
| 任务配置 | 项目、测试范围、材料入口和结果目录 | [Interval任务示例.json](config/Interval任务示例.json) |
| 可选补充材料 | 已有本地依赖 JAR、规则、公共材料或成员映射 | 按本轮实际文件提供 |

任务配置供 Agent 整理入口；上下文程序直接接收项目目录和测试范围。

### 输出文件

| 文件 | 内容 | 用途 |
| --- | --- | --- |
| source/ | 保留相对目录的原始项目副本 | 读取同版源码和资源 |
| source_manifest.json | 文件角色、摘要、源码根、范围和缺项 | 核对来源及分析范围 |
| project_schema.json | 类型、成员、静态引用和内部结构索引 | 支持后续查询 |
| context_manifest.json | 索引身份和文件摘要 | 校验索引 |
| tasks.json | 所选测试、共享入口、逐条文件及摘要 | 确定材料范围 |
| agent_context.json | 整类初始阅读材料 | 整体翻译先读此文件 |
| shared.json | 字段、初始化和生命周期等共享材料 | 与逐条测试文件一起读 |
| tests/*.json | 单条测试及必要依赖、资源和问题 | 聚焦某个测试时读 |
| initial_context.json/.md | 完整证据及可读展示 | 补查诊断、位置和图关系 |
| query_log.jsonl | 实际查询操作记录 | 回看取材过程 |

成员内部分析随索引保存；初始材料中的 test_structure 提供步骤入口，详细语句、检查及控制区域按需查询。

## 二、整体翻译

### 输入文件

| 文件或目录 | 提供的内容 |
| --- | --- |
| 完整 Java 测试与 members.json | 测试原文、成员 ID、方法体、字段和位置 |
| translation_rules.json/.md | 转换规则及适用条件 |
| project_materials.json/.md | 项目接口、公共设施和资源约定 |
| 仓颉骨架 .cj 与成员映射 | 目标声明、待填内容和源目标对应 |
| 仓颉业务源码及工程配置 | 实际目标包、接口和行为 |
| 上下文工具输出 | 当前测试的共享/逐条/整类材料与查询入口 |

规则、公共材料、骨架和映射从对应模块取得。已有产物按来源与摘要核对；缺项由 Agent 根据该模块说明补齐。

### 输出文件

| 文件或目录 | 内容 |
| --- | --- |
| translated/*.cj | 完整候选仓颉测试类及必要辅助代码 |
| resources/ | 测试需要携带的资源 |
| member_crosswalk.json | 上下文、Java 成员与目标映射的对应 |
| class_analysis.json | 完整测试类的行为与成员去向 |
| translation_result.json | 类、成员、证据及未解决项 |
| checks.json | 实际检查结果及未执行项 |
| translation_handoff.md | 结果入口、资源、接口约定和后续事项 |

其余取材记录和字段要求见 [文件职责指南](整体翻译/文件职责与使用时机.md)。

## 使用流程

1. 提供项目目录、测试范围、仓颉业务源码及其他模块的交付入口。
2. Agent 建立项目索引并生成初始上下文，确认同版材料。
3. 准备成员表、规则、公共材料、仓颉骨架和映射。
4. Agent 阅读测试，按问题补查并翻译完整类。
5. 保存候选译文、资源和交接文件。

组织完整任务使用 [整体流程调用提示词](整体翻译/整体流程调用提示词.md)；进入翻译阶段使用 [整体翻译提示词](整体翻译/translate_whole.md)。通用任务模板在 [config](config/whole_task.template.json)。

源码实现见 [源码指南](源码阅读指南.md)，职责及待实现项见 [流程说明](职责分工与流程.md)，实际结果见 [运行记录](../运行记录/README.md)。

## 三、week12 工具入口

| 文件 | 负责的工作 |
| --- | --- |
| Java骨架提取器/JavaTestSkeletonExtractor.java | Java 源码变为声明骨架、原逻辑成员表及源侧执行类关联 |
| 上下文工具/java_members.py | 校验并接收成员表，关联上下文 key、继承执行类和注解参数 |
| 仓颉骨架翻译器/骨架翻译提示词.md | Agent 根据材料生成目标骨架及成员映射，已适配第二版上下文 |
| 仓颉骨架翻译器/check_skeleton.py | 在整体填充前检查声明、映射、槽位和包命名空间 |
| 集成适配/prepare_skeleton_check.py | 把整体任务复制为检查器要求的目录与配置 |

成员表是上下文的可选输入；要使用 week12 继承入口，应在建索引前提供。同版表冻结到 `artifacts/java-members/`；`project_schema.json.java_members` 和初始上下文中的 `test_invocations` 保存源 ID 与执行入口。完整文件含义及调用时机见 [week12 对接](集成适配/README.md)。

## 四、最终译文的静态验证

输入为整体任务、最终译文、成员映射及同版上下文/业务。prepare_static_validation.py 生成静态验证可读取的目录；Agent 按总控提示词提交标注与比较，输出两份带注释源码和 report.json/md。文件职责见 [静态验证](静态验证/README.md)。它安排在整体填充之后，与填充前骨架结构检查分别使用。

整体任务的 targets[].selected_test_methods 可填写完整执行选择器，明确本轮子集；骨架与静态检查沿用相同范围。实际样例见 [四项目阶段测试](../运行记录/四项目阶段复测/README.md)。
