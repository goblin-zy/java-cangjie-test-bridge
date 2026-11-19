# 片段翻译工具

使用 Python 3.10+ 标准库。总流程 Agent 调用本工具；每次翻译完整成员的方法体或字段初始表达式。业务接口和业务原文用于参考。程序负责规划、取材、校验、装配，模型负责识别相关材料、翻译和意图核对。

## 输入

`--run` 指向本轮输出根。需要 `translation_config.json`、`02-java-skeleton/` 的成员表、`05-cangjie-skeleton/` 下的仓颉骨架及成员映射。配置中的 `test_files` 和可选的 `test_support_files` 均采用项目相对路径；只接受这些文件里的成员。映射中的 `source_members_file` 相对本轮输出根，`target_file` 相对仓颉骨架目录。待填映射必须含唯一 `slot_id`，两端用骨架提示词规定的标记。

## Agent 调用顺序

下表的命令都接在 `python <工具目录>/fragment_tool.py --run <本轮输出根>` 后。按顺序串行调用片段工具，整体翻译可以独立执行。所有命令的成功结果均为 JSON。

| 命令 | 用法 |
|---|---|
| `plan` | 根据成员表和映射建立 `07-fragment-translation/fragment_plan.json`。同一轮重跑会沿用已有清单。 |
| `review <review.json>` | 录入 Agent 核对后的取材条目和前置任务。只录入已检查的任务，可分批提交。 |
| `next` | 返回 `ready` 和材料包路径、摘要，或返回 `complete`、`blocked`。若受阻，读取 `waiting` 和 `blocked_mappings` 查原因。 |
| `apply <result.json>` | 核对任务编号与材料包摘要，保存译文并登记为已提交。骨架副本由最后一步统一装配。重复提交同一结果可以重试。 |
| `block <任务编号> <原因>` | 记录任务的具体缺项，然后继续取下一项。 |
| `finalize` | 核对骨架版本，回填已提交结果并合并导入。完整文件输出到 `test/`，留有待填项的文件登记在 `assembly_report.json`。 |

在片段输出目录保存 `review.json`，以任务编号为键。样例中的路径和指针应换成当轮实际位置。

```json
{
  "T03": {
    "depends_on": ["T01"],
    "refs": [
      {
        "root": "run",
        "file": "04-test-context/AccountTest/context_AccountTest.json",
        "pointer": "/records/0",
        "purpose": "确认每次测试前怎样准备账户"
      }
    ],
    "unresolved": []
  }
}
```

`root` 可为 `run`、`project`、`rules`，默认 `run`。`file` 相对于相应根。`pointer` 用于选取 JSON 条目，例如 `/records/0` 是第一条记录。文本可用 `"lines": [10, 15]` 取第 10 至第 15 行。两者都省略时读取全文。优先引用具体记录或行段。按「样例上下文 → 原项目补查 → 项目约定与规则」找依据。业务方法、资源和规则写入 `refs`；只有需要读取已完成译文的任务才写入 `depends_on`。互相调用的辅助方法可以通过共享声明约定翻译，避免把它们互设为必须先完成的任务。

输入发生变化时，从新的本轮输出目录重新生成清单。装配报告只证明工具实际完成的文件检查。Agent 还需按总流程保存意图核对、资源装配和实际运行证据。
在审查测试任务时，必须直接查阅本轮 `java-coverage/java_coverage.json`。将对应测试条目加入现有 `refs`（`root: "run"`、`file: "java-coverage/java_coverage.json"`、`pointer: "/tests/<索引>"`），同时引用相关样例上下文。共享辅助和生命周期任务只取相关测试条目。无法引用时通过 `unresolved` 保留原因。

