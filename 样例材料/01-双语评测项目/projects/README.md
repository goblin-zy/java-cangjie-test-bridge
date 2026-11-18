# 双语言评测项目

每组的 `java/` 存放业务源码、原测试和相关资源，`cangjie/` 存放该组的目标业务及参考测试。部分项目额外提供 `validation/`，用 Java 原测试的输入校验仓颉实现。

| 项目目录 | 评测范围 | Java 测试框架 |
| --- | --- | --- |
| [01-jsoup](01-jsoup/README.md) | HTML 解析及 CSS 选择器 | JUnit 5 |
| [02-aho-corasick](02-aho-corasick/README.md) | 多关键词首次命中及位置 | JUnit 4 |
| [03-jmustache](03-jmustache/README.md) | 模板、变量、数组及段落 | JUnit 4 |
| [04-chardet](04-chardet/README.md) | 从文件字节识别字符编码 | JUnit 4 |
| [05-diff-utils](05-diff-utils/README.md) | 文本行插入、删除和替换 | JUnit 3 |
| [06-caverphone](06-caverphone/README.md) | Caverphone 2.0 语音编码 | JUnit 5 |
| [07-levenshtein](07-levenshtein/README.md) | 无阈值的编辑距离 | JUnit 5 + AssertJ |
| [08-base32](08-base32/README.md) | 标准 Base32 编码与填充 | JUnit 5 |

从单组说明拿到 Java 测试、测试辅助代码和仓颉业务入口。翻译器生成测试后，再对照已有仓颉参考测试和运行记录。测试入口和来源见各组说明，已执行范围见[双语项目基线](../../../运行记录/双语项目基线/README.md)。
