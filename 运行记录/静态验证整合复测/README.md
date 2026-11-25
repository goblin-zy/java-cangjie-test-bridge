# 上下文、week12 骨架与静态验证整合复测

本记录说明三部分如何交接，以及实际测试结论。日期：2026-11-25。基线为 df41dae，静态验证来源为 a787dc7，Java 骨架及检查器来源为 a546d3e。

## 实际结果

| 项目 | 本次结果 | 原始证据 |
| --- | --- | --- |
| 上下文程序回归 | 40/40 | 01-context-regression.stderr.log |
| 静态验证原有回归 | 14/14；原先缺失的三项已跑通 | 02-static-regression.stderr.log |
| week12 提取→上下文→骨架→填充 | 21 项通过 | base/integration_summary.json、base/checks.json |
| 新增静态验证流程检查 | 14 项通过 | checks.json |
| Interval 整类静态审阅 | 9/9 个单元完成，保留 12 条源断言 | interval-review/deliverables/report.md/json |
| 原 Java 与仓颉译文执行 | 各 9/9 | base/15、16-java 与 base/13、14-cj 日志 |
| 带验证注释的仓颉源码 | 编译成功、9/9 | 18/19 日志、annotated-cangjie.clean.log |

Java 为 JDK 17/JUnit 4.13.2；仓颉为本机 SDK 1.2.0，直接 cjc 测试。没有修改实际业务源码，也没有评测完整 cjpm 工程构建。

## 本次衔接修改

1. 补齐钱包测试所需的 Translation-all 输入，以仓库内相对配置替代作者本机目录；使用 week12 提取器补齐 Java 提取结果。原有 14 项测试现在可独立运行。
2. 新增 prepare_static_validation.py，接收整体任务、最终译文和上下文 suite。校验共享/逐条/完整上下文摘要与身份，使用冻结的 Java 业务源码，生成静态验证原生目录。
3. 静态验证支持配置指定 Java 成员表的位置，接收第二版上下文与本侧业务源码；保留执行类关联。跨文件继承测试列为受阻，避免被过滤掉或套用错误文件行号。
4. 保留静态验证现有的证据核验与报告逻辑，整体提示词新增最终译文生成后的使用入口。

## 边界检查

- 未提交结果时 audit 报告漏做；九条全部提交后完整清点。
- 将一份逐条上下文改动后，适配器因摘要不一致失败，验证器拒绝 FAILED 输入。
- 受控地把 test_size 的期望值从 3 改为 4：旧比较包被拒绝；本次 Agent 给出带真实新引文的差异提交，程序保留“发现差异”。这检查的是材料更新和差异提交路径，不是模型自动检出准确率。
- JUnit 3 的 ChildCase 两个执行入口均进入清单；基类 testFromBase 跨文件，明确 java=null 并注明定位受阻；本类 testOwn 保留有效位置。inherited-skeleton 仅为接口范围样例，含显式占位异常，没有作为可执行译文交付。
- 验证注释插入后，两侧源码均能还原原行；所有报告引文可回到带注释的交付源码，仓颉源码重新执行仍为九条通过。

## 如何阅读文件

先看 [静态报告](interval-review/deliverables/report.md)，再看结构化 report.json 的 source、interface、证据与接口前提。static-input 保存适配交付，interval-review/process 保存五步过程。mutant-review 保存受控差异的比较结果，inherited-review 保存继承测试受阻定位。

commands.json 和日志保留当时的绝对路径用于复查。换机器后由 Agent 按整体任务模板重新准备，不直接执行历史路径。完整索引不在此重复归档，实际副本的侧输入、上下文及版本记录已保留；需要新索引时运行工具重建。

## 本轮结论的范围

静态结论为“在所列前提和范围内一致”，接口约定状态是 assumed：本次 Agent 对照真实业务、原测试及固定译文整理了前提和比较理由。程序没有证明两种语言在任意输入上的等价。

本轮由当前 Agent 联合审阅并固定回放标注/结论，**没有重新运行两个相互隔离的盲审会话，也没有测量语义错误检出率**。因此本次证明的是三部分材料可以接通、流程约束有效，以及本例测试能够运行；正常独立审阅仍按静态验证总控提示词组织。

复跑入口为主体/集成适配/tests/run_static_integration.py，接收 --output 新目录。它实际运行回归、Java/CJ 测试并下载固定 Java 测试依赖；沿用 run_integration.py 的环境变量设置。没有模型 API 调用。除 Interval 和合成接口边界外，本轮未重跑上游全部项目。
