# 蒋逸舟 · Week 7：Java 测试到仓颉测试的上下文与验证

负责人：蒋逸舟（GitHub：mercury-carl）。本周有三项任务：**上下文查找工具、可行性验证方法执行、ReCodeAgent 论文阅读**。

## 1. 本周做什么，交付了什么

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

## 3. 目录结构

```text
README.md                         本周三项任务的统一入口
docs/                             实现路线、用例讲解、文件索引与迁移记录
week7/context-validation/tools/   上下文工具与仓颉执行评价脚本
week7/context-validation/tests/   工具边界测试（不是九条账户业务测试）
week7/context-validation/examples/ 显式选择成员的输入示例
week7/context-validation/validation/ 已保存的上下文、日志和历史评价证据
week7/src/                        固定版本 Java 提取器及业务/测试输入
week7/reference/                  固定版本仓颉业务与参考测试，仅供验证
references/reading/recodeagent/   第三项任务：论文正文与版本核对材料
```

保留原工具路径及相对引用。`week7/src` 和 `week7/reference` 是复用蔡俊杰固定版本的依赖，不计为蒋逸舟新实现。文档按模块职责、输入、操作、输出与适用范围组织。

## 4. 最小复核

在本分支仓库根目录，用 Python 3.9+ 执行（索引另需 JDK 17+，仓颉运行另需 SDK）：

```powershell
python -m unittest discover -s week7/context-validation/tests -v
python week7/context-validation/tools/check_delivery.py
```

前者检查7种源码/选择边界；后者交叉核对已保存证据，不会重新运行仓颉。复核结果见 [验证记录](docs/06-整理验证记录.md)。历史运行记录保留原时间与环境，与本次执行结果分别记录。
