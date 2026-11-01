# 蒋逸舟 · Week 7：Java 测试到仓颉测试的上下文与验证

负责人：蒋逸舟（GitHub：mercury-carl）。本周有三项任务：**上下文查找工具、可行性验证方法执行、ReCodeAgent 论文阅读**。

## 用途导航

|用途|入口|内容|
|---|---|---|
|了解本周任务与实现关系|[实现路线](docs/01-实现路线.md)|三项任务的输入、处理流程、输出及适用范围|
|查找测试翻译所需上下文|[上下文查找工具](week7/context-validation/README.md)|成员索引、依赖选择、源码定位与上下文导出|
|复现上下文构建与测试评价|[操作教程](week7/context-validation/docs/使用教程.md)|环境要求、操作命令、输出位置及检查方法|
|理解可行性验证方法及测试用例|[验证方法与用例](docs/02-验证方法与测试用例.md)|7项工具测试、9条账户参考测试与历史故障场景|
|查看已有实验结果|[验证材料](week7/context-validation/validation/README.md)|上下文核对、账户测试结果、故障场景与执行日志|
|阅读ReCodeAgent论文及源码分析|[论文研读](references/reading/recodeagent/README.md)|方法流程、关键模块、断言检查及项目适配|
|定位代码、配置和说明文件|[文件职责清单](docs/04-文件职责清单.md)|逐文件用途与路径|
|核对材料来源与版本|[来源记录](docs/05-来源与分支迁移.md)|原分支迁移、固定版本依赖及执行来源|
|生成与审查上下文选择方案|[选择提示词](week7/context-validation/prompts/生成selection.md) · [人工复验规范](week7/context-validation/docs/selection人工复验规范.md)|智能体任务、R1—R8审查标准与复验记录|
|理解工具设计与逻辑衔接|[工具设计](week7/context-validation/docs/工具设计与输入输出.md) · [流程串联](week7/context-validation/docs/流程逻辑与材料衔接.md)|各脚本输入输出、职责边界与完整交接流程|

## 1. 本周任务

|任务|要解决的问题|实现与交付|结论边界|
|---|---|---|---|
|上下文查找工具|确定测试翻译所需的初始化、辅助方法、业务接口及异常定义|[工具与教程](week7/context-validation/README.md)、显式选择配置、三份带源码出处的上下文|程序查找并核对已选择的成员；依赖选择由人/智能体提供，尚无自动依赖闭包|
|可行性验证方法执行|检查仓颉测试的编译、发现与执行情况|[验证方法与用例](docs/02-验证方法与测试用例.md)、执行器、九条账户参考测试及历史故障场景|已有日志为预期9、发现9、执行9、通过9；使用披露的 localfix 运行库；不是模型翻译成功率|
|ReCodeAgent 论文阅读|分析仓库级翻译的分析、规划、翻译与验证流程|[阅读路线](docs/03-ReCodeAgent阅读路线.md)、论文研读正文及固定源码版本记录|论文与关键源码静态分析；未运行作者完整系统|

## 2. 阅读顺序

1. 阅读[实现路线与术语](docs/01-实现路线.md)，理解三项任务怎样连接。
2. 按[逐步教程](week7/context-validation/docs/使用教程.md)查看三份上下文，再尝试重新建立索引、选择成员并导出。
3. 阅读[测试用例说明](docs/02-验证方法与测试用例.md)，逐项比较输入、预期、实际证据。
4. 按[论文阅读路线](docs/03-ReCodeAgent阅读路线.md)阅读正文，区分论文做法与本项目实际实现。
5. 需要定位某个文件时查[逐文件职责清单](docs/04-文件职责清单.md)，需要复现时查[来源与分支迁移记录](docs/05-来源与分支迁移.md)。

## 3. 分支与目录结构

### 仓库分支

|分支|用途|
|---|---|
|[main](https://github.com/goblin-zy/java-cangjie-test-bridge/tree/main)|团队公共导航，个人周报和实现材料分别保存在个人分支|
|[蒋逸舟week7](https://github.com/goblin-zy/java-cangjie-test-bridge/tree/蒋逸舟week7)|本分支：上下文查找工具、可行性验证方法执行及ReCodeAgent论文研读|
|[hzy-week7](https://github.com/goblin-zy/java-cangjie-test-bridge/tree/hzy-week7)|项目约定与公共材料生成工具；保留的其他成员旧材料属于分支历史快照|
|[蔡俊杰week7](https://github.com/goblin-zy/java-cangjie-test-bridge/tree/蔡俊杰week7)|第七周Java测试骨架提取、业务样例及仓颉参考测试|
|[蔡俊杰week6](https://github.com/goblin-zy/java-cangjie-test-bridge/tree/蔡俊杰week6)|第六周实验材料、用例说明与运行记录|
|[week6](https://github.com/goblin-zy/java-cangjie-test-bridge/tree/week6)|第六周材料的原分支，与“蔡俊杰week6”指向同一版本|

原 `codex/week7-jiangyizhou-context-validation` 分支已删除，其材料已纳入 `蒋逸舟week7`。各分支独立保存文件版本；当前分支的修改不会自动同步至其他分支。

### 本分支目录

```text
蒋逸舟week7（分支）
├─ README.md                         本周任务与用途导航
├─ docs/                             实现路线、测试说明、文件职责及版本记录
├─ week7/
│  ├─ context-validation/            上下文查找与可执行性评价
│  │  ├─ tools/                      成员索引、上下文导出及测试评价脚本
│  │  ├─ tests/                      工具边界测试
│  │  ├─ examples/                   显式选择成员的输入示例
│  │  ├─ docs/                       操作教程、接口与输出格式
│  │  └─ validation/                 上下文、运行报告及历史故障场景
│  ├─ src/                           固定版本Java提取器、业务实现及原始测试
│  └─ reference/                     固定版本仓颉业务及参考测试
└─ references/reading/recodeagent/    论文研读与源码版本核对材料
```

`week7/src` 和 `week7/reference` 复用蔡俊杰固定版本的材料，作为本分支工具的输入与验证依赖；来源见[版本记录](docs/05-来源与分支迁移.md)。

## 4. 最小复核

在本分支仓库根目录，用 Python 3.9+ 执行（索引另需 JDK 17+，仓颉运行另需 SDK）：

```powershell
python -m unittest discover -s week7/context-validation/tests -v
python week7/context-validation/tools/check_delivery.py
```

前者检查7种源码/选择边界；后者交叉核对已保存证据，不会重新运行仓颉。复核结果见 [验证记录](docs/06-整理验证记录.md)。历史运行记录保留原时间与环境，与本次执行结果分别记录。
