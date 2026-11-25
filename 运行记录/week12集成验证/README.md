# week12 合并影响与实际复测

本记录说明蔡俊杰 week12 对我们的上下文和整体翻译调用的影响，并保存合并后的实际结果。运行日期：2026-11-25。

## 结论与影响

能够合并，但需要补齐三个接口。核心整体翻译路线不变，Java 提取顺序与骨架检查时机需要调整。

| week12 交付 | 对我们原流程的影响 | 本分支处理 |
| --- | --- | --- |
| Java 提取器新增 JUnit 3/4 与 test_invocations | 不能只按注解或声明类判断测试；子类执行可能读取基类方法体 | 同版成员表可交给 build，按摘要/声明/原文关联；suite 同时保留声明和执行身份 |
| 骨架提示词原读 week7 records.category | 直接交第二版 agent_context 会读错字段或遗漏共享材料 | 提示词增加第二版整类、shared/tests、按需查询入口；旧字段只兼容旧材料 |
| 通用 check_skeleton.py | 固定读取原生配置、02-java-skeleton 和 05-cangjie-skeleton；不能直接接整体任务模板 | 新适配器复制交付并转换路径，先检查骨架，再整体填充副本 |

Java 提取与上下文仍各自读取源码。需要继承入口时先取得成员表，再建索引，避免“先完成上下文才可提取，又等提取结果补上下文”的循环。公共材料和仓颉骨架仍不是索引前置条件。没有新增独立预处理。

原 week12 提交只保留精简工具和报告；其历史样例删减不应覆盖我们的源码、上下文和整体提示词。此次在独立集成分支合并，保留 week11 产物，工具按主体分类保存。原提示词另存用于对照，上游报告的八组结论与本次复测分开。

## 实际结果

| 检查 | 结果 | 证据 |
| --- | --- | --- |
| 上下文已有回归 | 40 项通过 | context-regression.log/json |
| 新集成边界及运行检查 | 21 项通过 | checks.json、commands.json |
| 新提取与上下文 suite | 9 个 JUnit 4 测试及 9 个执行关联 | java-extraction/、context-suite/ |
| 填充前骨架检查 | passed，9 个必要成员、9 个有效槽位 | structure-check.json、checker-run/ |
| Java 原测试 | JDK 17、JUnit 4.13.2，9/9 | 15/16-java 日志 |
| 仓颉译文 | Cangjie 1.2.0，9/9 | 13/14-cj 日志、cangjie-tests.clean.log |

合成用例另检查了 JUnit 3 子类执行/基类声明、继承 setUp、static testXxx 与 fake.Test 不误识别、expected/timeout 保留、旧摘要拒绝，以及缺失映射、重复槽位、blocked/partial、命名空间和截短泛型签名。21 项中包含真实运行检查，不表示新增 21 条业务用例。

## 文件组织

| 目录或文件 | 内容 |
| --- | --- |
| java-extraction/ | 本次程序生成的原文副本、Java 骨架、成员表和提取报告 |
| context-index/、context-suite/ | 同轮索引/冻结源码、整类及逐条初始材料 |
| fixture-project/、fixture-extraction/、fixture-index/、fixture-suite/、four-view/ | 接口边界的合成源码、提取和上下文 |
| skeleton/ | 本次新整理的待填骨架与原映射 |
| checker-run/ | 适配后的副本、原生配置及来源清单 |
| translation/ | 新译文、成员对应、按需查询证据及交接记录 |
| integration_summary.json、checks.json、commands.json、*.log | 原始结果和实际命令；保留当时路径作为记录 |

复跑使用主体/集成适配/tests/run_integration.py，在新目录重新生成入口。普通查询可使用归档索引；归档的执行配置和命令含原机绝对路径，不能当跨机器配置直接执行。索引按原程序结果复制，未改写路径和摘要。

## 范围与剩余问题

本轮是工具衔接和 Interval 完整类的固定翻译回放：本次 Agent 对照 Java 原文和真实目标整理骨架/译文，回归脚本将其固定以便复现。没有重新运行规则生成、项目公共材料生成或片段路线，也没有重跑上游八组项目。不能据此声称任意项目的整体翻译已经通过。

本轮未修改 32 个仓颉业务文件，直接用本机安装的 SDK 1.2.0 编译测试；没有验证原 cjpm.toml 所声明平台/参数的完整工程构建，也没有复用上游报告中的实验性 localfix。Java/CJ 测试通过不是普遍等价证明。

expected/timeout、复杂 runner、参数化/动态执行等仍需 Agent 和对应模块落实。源程序转换、可执行测试前缀仍未实现。源侧继承元数据也不能代替 JUnit 实际发现；基类缺失时应补输入，而不是猜测。
