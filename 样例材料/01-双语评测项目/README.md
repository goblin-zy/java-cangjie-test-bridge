# Java 与仓颉双语言项目

交付包含 8 组现成的 Java 与仓颉业务源码和原测试，用于评测 Java→仓颉测试翻译。项目目录内的 Markdown 记录源码来源、测试入口和已核对的对应场景。[打开项目导览](projects/README.md) · [查看已运行结果](../../运行记录/双语项目基线/README.md)

| 文件夹 | Java → 仓颉 | 已验证的对应场景 | Java 测试框架 |
| --- | --- | --- | --- |
| `01-jsoup` | jsoup 1.15.4 → html4cj | 5 项。标签、ID、类名、带转义字符的选择器 | JUnit 5 |
| `02-aho-corasick` | Aho-Corasick 0.6.3 → ahocorasick4cj | 4 项。首个匹配的关键词与起止位置 | JUnit 4 |
| `03-jmustache` | JMustache → cjmustache | 6 项。模板变量、数组、下标越界默认值和嵌套段落 | JUnit 4 |
| `04-chardet` | Juniversalchardet 2.4.0 → chardet4cj | 4 项。两侧用相同文件字节识别 UTF-8（带 BOM、无 BOM、含 emoji）和 UTF-16LE | JUnit 4 |
| `05-diff-utils` | java-diff-utils 1.3.0 → diffutils4cj | 3 项。行列表的插入、删除和替换差异 | JUnit 3，使用 Vintage 引擎运行 |
| `06-caverphone` | Commons Codec 1.17.1 → caverphone4cj | 两侧原测试有 248 条输入与预期输出对应记录，全部通过 | JUnit 5 |
| `07-levenshtein` | Commons Text 1.12.0 → leven4cj | 两侧原测试通过，另核对 Java 原测试的 10 组输入在仓颉业务上结果一致 | JUnit 5 + AssertJ |
| `08-base32` | Commons Codec 1.17.1 → hibase32-cj | 两侧原测试通过，另核对 Java 原测试的 7 组标准 Base32 编码向量 | JUnit 5 |

使用时，先选定 Java 原测试及其所需辅助源码，再用对应的仓颉业务运行生成的测试。已有仓颉参考测试可用于验收。只支持 JUnit 5 时，可以先选 jsoup 的 `testByTag` 和 `testById`，再尝试 Caverphone 和 Base32。

此前选定用例已在 Windows x64、OpenJDK 17.0.13 和仓颉 SDK 1.2.0 环境运行，仓颉侧配合实验性 `localfix` 运行库。结果用于确定可以配对的业务场景。
