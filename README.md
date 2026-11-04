# week8蔡俊杰

本周负责选取项目、提取 Java 测试骨架和翻译仓颉测试骨架。依据 [第八周任务文档](https://my.feishu.cn/file/XTDDbjVLyokybZxUSkRcVg0rn7c)，骨架翻译阶段交付模型提示词、仓颉骨架、源目标成员对应表和检查程序。

| 部分 | 输入 | 输出 |
| --- | --- | --- |
| 项目选取 | 候选仓库、业务易懂程度、测试可运行性、仓颉侧接口准备成本 | 两个固定版本的源码出处与下载入口、选取理由、首轮测试范围和 Java 基线记录 |
| Java 骨架提取 | 任一项目中纳入处理范围的 Java 源文件或目录，可包含测试、基类和辅助类 | Java 骨架、原源码副本、`members.json` 和提取报告 |
| 仓颉骨架翻译 | 提取目录中的 Java 骨架和 `members.json`，加上该项目的类型、名称和注解映射。模型阶段按需补充项目材料、上下文和原源码 | 仓颉 `.cj` 骨架、源目标成员对应、待填位置和诊断 |

提取器和规则版翻译器都可换项目使用。借阅资格和 BOM 是本批验收输入。本批 `check_skeleton.py` 按两份候选骨架核对产物并输出 `member_mapping.json`。可复用的规则版翻译器另外输出 `member-map.json` 和 `diagnostics.json`，支持的结构见生成记录。

Commons IO 的源码、测试与资源位于 [commons-io](01-projects/commons-io)。运行 `python prepare_inputs.py --jdk "JDK17 安装目录"` 可从固定提交获取 Smart Library，并准备检查程序所需的 Java 骨架与成员表。分支保存工具、仓颉骨架、成员对应表及实测日志。

- [项目选取和源码导航](01-projects/项目选取.md)
- [提取器源码和提取记录说明](02-java-skeleton/提取说明.md)
- [骨架翻译提示词](03-cangjie-skeleton/骨架翻译提示词.md) · [生成记录](03-cangjie-skeleton/生成记录.md) · [成员对应表](03-cangjie-skeleton/member_mapping.json) · [检查程序](03-cangjie-skeleton/check_skeleton.py)

首轮采用 Smart Library 的 5 项借阅资格测试和 Commons IO 的 9 项 BOM 测试。提取了 17 个源成员，包括 14 个测试方法和 3 个字段。两份仓颉骨架经 SDK 1.2.0 编译通过，并在本机实验性 localfix 运行库下分别发现 5 项和 9 项测试。此处的 dry-run 结果记录测试发现，方法体仍待填充。Commons IO 的目标业务类型暂用独立声明完成结构编译。

Java 基线中，Smart Library 的两组策略测试合计 14 项通过，其中罚款的 9 个参数化用例作为扩展材料保存。Commons IO 的所选测试类 9 项通过。验证日志在 validation/。
