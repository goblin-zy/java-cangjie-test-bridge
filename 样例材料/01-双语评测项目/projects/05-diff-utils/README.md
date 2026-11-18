# java-diff-utils ↔ diffutils4cj

计算文本行差异。3 组对应输入验证插入、删除和替换。仓颉三份上游测试程序以返回码 0 表示通过。

- [java/](java/交付说明.md) 存放 Java 原业务和测试。
- [cangjie/](cangjie/交付说明.md) 存放仓颉业务和参考测试。

## 已核对用例

| Java 测试 | 仓颉测试 | 共同预期 |
| --- | --- | --- |
| `testDiff_Insert` | `testdiff01.cj` | 单个插入差异，插入 jjj、kkk |
| `testDiff_Delete` | `testdiff02.cj` | 单个删除差异，删除 ddd、fff |
| `testDiff_Change` | `testdiff03.cj` | 单个替换差异，bbb 变为 zzz |
