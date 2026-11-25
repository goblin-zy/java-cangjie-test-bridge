# Interval 双语样例

| 输入文件或目录 | 内容 |
| --- | --- |
| Interval双语项目/java/ | 完整 Java 工程，共 40 个 Java 文件及原始配置、许可 |
| java/src/test/java/org/ahocorasick/interval/IntervalTest.java | 所选测试类，含 9 个 JUnit 测试方法 |
| java/src/main/java/org/ahocorasick/interval/Interval.java | Java 区间业务实现 |
| Interval双语项目/cangjie/src/ | 对应仓颉业务实现，共 32 个文件，包名 ahoCorasick4cj |
| cangjie/src/interval.cj | 仓颉 Interval 的构造、取值、重叠与比较接口 |
| cangjie/cjpm.toml | 原目标工程配置 |

上下文工具以完整 Java 工程为输入，选择 IntervalTest 组织材料。Agent 可通过 test_construct 的构造、取值和两个检查理解流程，再对照仓颉业务声明。重载 overlapsWith(int) 与 overlapsWith(Interval) 按完整签名区分。

| 结果入口 | 内容 |
| --- | --- |
| [第二版上下文检查](../运行记录/第二版上下文检查/检查结果.json) | 当前工具生成的索引、测试材料及查询结果 |
| [已有整体翻译样例](../运行记录/已有整体翻译样例/README.md) | 之前生成的仓颉测试及真实编译、运行记录 |

已知差异：Java 与仓颉构造器对反向区间的处理不同，所选 9 个用例未覆盖该输入。

Java 源码来自原材料登记的 robert-bor/aho-corasick 固定提交 e68720d0afd51093fbba1232edf154ad71a62ac3。原 README、许可、仓颉 LICENSE、README.OpenSource 和版权注释随工程保留。

[静态验证钱包](静态验证钱包/README.md) 补齐原有验证回归的输入；本次三部分整合继续使用 Interval 双语项目。
