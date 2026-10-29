# 第七周：上下文查找工具与可执行性评价

负责人：**蒋逸舟**。实现、整理与本地验证由Codex协助，最终人工审核待完成。

本周范围仅包括翻译方法的“上下文查找工具”和初步验证方法的“可执行性评价”（此前交流也称可行性评价）。ReCodeAgent移至[参考资料研读](../../references/reading/recodeagent/README.md)，不计入两项工具完成情况。

**开始使用：[逐步操作教程](docs/使用教程.md)。**

| 模块 | 实现与输入 | 实际输出与证据 | 当前边界 |
| --- | --- | --- | --- |
| 上下文查找 | [context_lookup.py](tools/context_lookup.py)，复用已有JavaTestSkeletonExtractor和members.json；[示例选择](examples/account/selection.json) | [成员索引](validation/context/index/index.md)、[三份上下文核对](validation/context/export/checks.json)、[普通取款上下文](validation/context/export/context_01.md) | 人工/智能体显式选择依赖；不声称自动依赖闭包 |
| 可执行性评价 | [cangjie_runner.py](tools/cangjie_runner.py)，通用单组/批量执行；[仓库账户入口](tools/evaluate_account.py) | [当前九条参考测试报告](validation/repository-account-preupload/execution/report.md)、[环境与运行库哈希](validation/repository-account-preupload/run_metadata.json) | 当前Windows直接cjc、单包、普通类测试；不判断语义等价 |

## 与现有仓库的关系

不替换week7已有Maven项目、src、reference、VSCode任务及manifest。上下文索引直接调用既有骨架提取器，保留其成员ID、角色、源码位置和原始方法体；不再复制另一套短ID索引工具。新接口与来源见[接口和格式](docs/接口与输出格式.md)。

当前示例仅使用仓库九条账户测试中的testWithdraw、testSequence、testInsufficientFunds生成上下文。执行评价则运行全部九条账户参考测试。原先五条/两条本地账户演示不作为当前上下文输入。

## 验证状态

- 索引当前仓库8个Java文件、64个成员，示例导出3份上下文、共32条源码证据核对。
- 7项源码/选择边界测试通过；[可迁移证据检查](validation/portable-checks.json)169/169通过。
- 上传前当前账户参考测试：预期9、发现9、执行9、通过9，0失败/错误/跳过。
- 运行库SHA256与仓库披露localfix一致，不能表述成原版SDK验证通过。
- 保留13组历史评价场景和环境失败、数量不符等证据；历史两条账户结果不计为当前九条或模型翻译成功率。

[统一验收与限制](docs/交付验收与限制.md) · [本周进度汇报](docs/本周进度汇报.md) · [仓库基线](REPOSITORY_BASELINE.json)

输出均选新目录。源码、选择和结果分别留档；runs/是个人新运行目录，不进入Git。历史绝对路径只是当次运行证据，新运行使用当前仓库相对路径。此交付未运行大模型翻译，也未把未完成的自动选择、资源或类型解析列为已完成。
