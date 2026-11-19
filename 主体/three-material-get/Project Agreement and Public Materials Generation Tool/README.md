# 项目约定与公共材料生成工具

为 Java 测试翻译成仓颉测试提供项目级材料。提供仓颉业务时核查已有接口；只有 Java 工程时，根据测试所需的调用拟定目标接口约定。程序负责提取与校验，Codex 负责分析与拟定。

| 位置 | 内容 |
|---|---|
| [src/README.md](src/README.md) | 环境、配置、命令和输出说明。执行命令前进入 src |
| src/src/pmtool、src/adapters、src/scripts | Python 程序、语言解析助手及其构建脚本 |
| src/prompts、src/schemas | 分析指令和输入输出格式 |
| [版本更新记录](版本更新记录.md) | 格式和框架衔接变化 |
| [积分钱包输入](../../01-projects/points-wallet/README.md) | 框架共用的样例工程 |
| [源端试跑记录](../../output/points-wallet-interface-20261118/README.md) | 使用的范围、结果和未验证项 |

配置指定输入范围 → scan 固定快照并索引成员 → draft 输出事实和接口审查范围 → packet 提供证据 → Codex 逐接口整理 → merge、check、export 输出 project_materials.json 和同源 Markdown。

格式 2.0 保留九个类别。C03「目标接口约定」归集源目标对应、签名与业务行为；其他类别沿用原编号。无实现时每项拟议接口注明 Java 签名、目标调用、行为、选择依据、引用及 pending 状态。旧版 1.0 材料仍可检查和导出。
