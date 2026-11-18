# Juniversalchardet ↔ chardet4cj

通过文件字节识别字符编码。两侧的 4 个对应场景覆盖带 BOM 的 UTF-8、无 BOM 的 UTF-8、含 emoji 的 UTF-8 及 UTF-16LE。仓颉由两份上游测试程序执行，返回码均为 0。

- [java/](java/交付说明.md) 存放 Java 原业务和测试。
- [cangjie/](cangjie/交付说明.md) 存放仓颉业务和参考测试。

## 已核对用例

| Java 测试 | 仓颉测试 | 共同预期 |
| --- | --- | --- |
| `testUTF8` | `test_chartdet_utf8_01.cj / utf8.txt` | 同一文件字节，识别为 UTF-8 |
| `testUTF8N` | `test_chartdet_utf8_01.cj / utf8n.txt` | 同一文件字节，识别为 UTF-8 |
| `testUTF8Emoji` | `test_chartdet_utf8.cj / utf8n-emoji.txt` | 同一文件字节，含 emoji，识别为 UTF-8 |
| `testUTF16LE` | `test_chartdet_utf8.cj / utf16le.txt` | 同一文件字节，识别为 UTF-16LE |
