# jsoup ↔ html4cj

HTML 解析与 CSS 选择器。实跑的 5 条对应测试覆盖标签、ID、类名及转义查询。初次验证可以选 `testByTag` 和 `testById`。

- [java/](java/交付说明.md) 存放 Java 原业务和测试。
- [cangjie/](cangjie/交付说明.md) 存放仓颉业务和参考测试。

## 已核对用例

| Java 测试 | 仓颉测试 | 共同预期 |
| --- | --- | --- |
| `testByTag` | `testByTag` | DIV 命中 3 个节点且 ID 为 1/2/3，span 命中 0 个 |
| `byEscapedTag` | `byEscapedTag` | 带转义的标签选择返回 One 和 Two |
| `testById` | `testById` | 重复 ID 选中 2 个节点，缺失 ID 选中 0 个 |
| `byEscapedId` | `byEscapedId` | 带转义的 ID 选择返回 One、Two、Three |
| `testByClass` | `testByClass` | 类名与大小写匹配，缺失类为空 |
