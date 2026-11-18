# 骨架样例运行记录

输入对应[两份固定 Java 原测试](../../样例材料/骨架样例输入/README.md)。提取器沿用第七周提交 `6105b07` 中的实现。仓颉候选使用前一版提示词生成，既有测试发现记录的日期为 2026-11-04。本审阅版复核 Java 提取和两份已有仓颉骨架的声明对应。

| 样例 | Java 提取结果 | 仓颉骨架及既有测试发现 |
| --- | --- | --- |
| Smart Library | 5 个测试方法。[成员表](smart-library/members.json) · [提取报告](smart-library/extraction-report.md) | [仓颉骨架](model-output/DefaultBorrowPolicyUnitTest.cj) · [发现 5 项测试](测试发现/smart-library-cangjie-discovery.log) |
| Commons IO | 9 个测试方法和 3 个字段。[成员表](commons-io/members.json) · [提取报告](commons-io/extraction-report.md) | [仓颉骨架](model-output/ByteOrderMarkTest.cj) · [发现 9 项测试](测试发现/commons-io-cangjie-discovery.log) |

两组目录各自保存提取时生成的原文副本、Java 骨架、成员表和报告。仓颉结构检查结果见[17 条成员对应](member_mapping.json)。已有仓颉候选通过 SDK 1.2.0 的结构编译，测试发现日志中 `NORUN` 表示只发现了测试，方法体仍使用占位。Commons IO 的 [BOM 临时声明](compile-support/byte_order_mark_type.cj)用于编译检查，实际业务类型待绑定。提示词版本与待验证事项见[生成记录](生成记录.md)。

2026-11-18 审阅版复跑时，使用 OpenJDK 17.0.13 对两份输入重新提取。Smart Library 得到 5 个成员，Commons IO 得到 12 个成员，两组原文副本和 Java 骨架的文件哈希均与保存的结果相同。随后运行[结构检查脚本](../../主体/03-仓颉骨架翻译器/check_skeleton.py)，全部 17 条成员映射通过检查，源文件和目标文件路径均有效。
