# Aho-Corasick ↔ ahocorasick4cj

多关键词搜索。实跑的 4 条对应测试核对首个命中的关键词、起点和终点。

- [java/](java/交付说明.md) 存放 Java 原业务和测试。
- [cangjie/](cangjie/交付说明.md) 存放仓颉业务和参考测试。

## 已核对用例

| Java 测试 | 仓颉测试 | 共同预期 |
| --- | --- | --- |
| `test_KeywordAndTextAreTheSameFirstMatch` | `testFirstMatch_00` | abc 命中 abc，区间 [0,2] |
| `test_TextIsLongerThanKeywordFirstMatch` | `testFirstMatch_01` | 前置空格后命中 abc，区间 [1,3] |
| `test_VariousKeywordsFirstMatch` | `testFirstMatch_02` | 多个关键词中命中 bcd，区间 [0,2] |
| `test_UshersTestFirstMatch` | `testFirstMatch_03` | ushers 中首个匹配 he，区间 [2,3] |
