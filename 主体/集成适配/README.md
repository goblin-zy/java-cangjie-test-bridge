# week12 对接

本文说明蔡俊杰 week12 工具与第二版上下文、整体翻译之间的输入输出，供 Agent 编排任务时读取。两个上游程序保留原实现；上下文接收与检查目录适配在本分支实现。

## 输入输出

| 环节 | 输入 | 输出及作用 |
| --- | --- | --- |
| Java 骨架提取 | 所选 Java 文件或包含测试、基类及辅助代码的目录 | `original/`、`skeleton/`、`members.json`、`extraction-report.md`；保存原逻辑及声明身份 |
| 上下文建索引 | 完整 Java 项目、测试范围，可选同版 `members.json` | 原字节快照、`project_schema.json`；新表复制到 `artifacts/java-members/` 并校验摘要、声明区间和方法体 |
| 上下文导出 | 索引及所选执行测试类 | `agent_context.json`、`tasks.json`、`shared.json`、`tests/*.json`；提供初始取材和补查入口 |
| 骨架生成 | Java 骨架/成员表、规则、公共材料、第二版上下文及实际仓颉业务 | Agent 按骨架提示词生成 `.cj`、`member_mapping.json` 和报告 |
| 检查目录适配 | 填好真实路径的整体任务配置、原 Java 提取及仓颉骨架 | 新检查目录中的 `translation_config.json`、`02-java-skeleton/`、`05-cangjie-skeleton/`、`adapter_manifest.json` |
| 填充前结构检查 | 上述目录及实际目标业务源码 | JSON 检查报告；`passed`、`partial` 或 `failed`，分别退出 0、2、1 |
| 整体填充 | 原骨架与映射、结构检查结果、完整测试及全部翻译依据 | 新候选测试、成员对应和交接记录；按整体提示词交付 |

```mermaid
flowchart TD
  A[完整 Java 项目] --> B[Java 提取：声明及原逻辑]
  A --> C[上下文 build：冻结及静态索引]
  B -. 同版 members.json 可选输入 .-> C
  C --> D[suite：整类、共享、逐条上下文]
  B --> E[Agent 生成仓颉骨架和映射]
  D --> E
  R[规则、公共材料、真实仓颉业务] --> E
  E --> F[prepare_skeleton_check：复制并适配目录]
  B --> F
  F --> G[check_skeleton：填充前结构检查]
  G --> H[Agent 整体填充骨架副本]
  D --> H
  R --> H
  H -. 有当前任务授权时 .-> I[编译及执行对应测试]
```

## 三个接口的处理

**成员表先于需要它的索引。** Java 提取与上下文都可直接接收源码。需要 week12 的继承执行入口时，先提取，再把成员表作为 `build --java-members` 的可重复参数提供。已建好的旧索引不会自动吸收晚到的新表，需要在新目录重建。没有成员表仍可按原方式分析普通项目，不依赖公共材料或仓颉骨架先完成。

`members[].test_framework` 标记源框架；`test_invocations[]` 区分 `declaring_class`、`execution_class`、`source_member_id` 和 `selector`。例如 `p.ChildCase#testFromBase()` 的正文位于 `p.BaseCase`，两者不能合成一个身份。上下文的 `java_members.member_links` 提供原 ID 到 context key 的关联，suite 的 `test_invocations` 将关联交给 Agent。源码继承证据单独保存，不改写 SymbolSolver 的静态绑定，也不等同于 JUnit 的真实发现名单。多个执行类可能复用同一声明，成员数量不能直接当成执行次数。

**两种配置有不同用途。** `whole_task.template.json` 供 Agent 组织入口；检查器的 `translation_config.json` 供程序读取。`prepare_skeleton_check.py` 的 `--task/--output/--bundle` 明确选择整体任务、新目录和骨架组。配置普通路径相对任务文件；映射中的源表和目标文件分别相对 `source_members_base`、`target_files_base`。适配器只修改副本入口，保留源 ID、原文和状态。检查器的 `--run` 指向新目录，`--target-source` 传实际允许使用的业务文件或目录，`--report` 保存结果。不可把整体任务文件直接当作检查器配置。

**结构检查安排在填充前。** 槽位需要唯一 `slot_id`、成对 `FRAGMENT_BEGIN/END` 和完整占位内容。检查源成员覆盖、目标声明/签名、槽位及真实包名。它不能证明测试行为正确。填充后相应标记已经移除，应做最终声明/占位/编译与执行检查，不再以原占位规则检查完整译文。`partial` 必须保留 blocked 原因，不能按通过处理。

## 注解和范围

`@Test(expected=..., timeout=...)` 的参数以原表达式保存，上下文提示语义复核。Agent 必须保留预期异常包围范围和超时要求；当前工具不会自动生成对应仓颉执行机制。JUnit 3 的基类要一起交给提取器；只有叶子文件而没有基类时，不能声称继承测试完整。参数化、动态、嵌套、自定义 runner 等继续按实际能力和材料记录缺项。

## 复跑入口

`tests/run_integration.py` 接收 `--output` 新目录。依赖 JDK 17、Python 和可用的仓颉 SDK；Java 入口可用 `PP_TEST_JAVA/PP_TEST_JAVAC`，编译器可用 `CJ_TEST_CJC` 指定，运行库由当前 SDK 环境提供。脚本会下载固定 JUnit/Hamcrest 依赖并实际执行 Java 和仓颉测试，普通静态翻译任务不需要运行它。

此脚本回放本次 Agent 根据原测试整理的固定 Interval 骨架和译文，验证提取→上下文→检查→填充及执行接口，不是通用自动翻译程序，也没有重新调用规则和公共材料生成器。合成边界用例检查继承、注解、摘要与错误映射；当前实际结果见 [集成验证](../../运行记录/week12集成验证/README.md)。

## 最终译文接入静态验证

prepare_static_validation.py 接收 --task（完整整体任务）、--translated（实际最终 .cj 目录）、--output（新准备目录）和可选 --bundle。它复用来源/映射路径校验，新增最终译文和第二版上下文副本；校验 suite 文件摘要与索引身份，Java 业务从冻结快照读取。

输出的 translation_config.json 增加 java_members_file、execution_classes、context_files、context_identity 和 side_sources。静态验证程序接收该目录即可，不要求把整体任务配置直接传给它。每轮一个执行类/一对测试文件；跨文件继承成员进入范围但标为受阻。

正常静态审阅的输入输出见 [静态验证说明](../静态验证/README.md)。三部分复跑入口 tests/run_static_integration.py 保存固定 Interval 审阅和受控错误的流程回归，不是自动模型审阅器。实际结果见 [整合复测](../../运行记录/静态验证整合复测/README.md)。
