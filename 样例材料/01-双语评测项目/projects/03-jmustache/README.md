# JMustache ↔ cjmustache

Mustache 模板渲染。实跑的 6 条对应测试包括变量、数组、段落及索引越界默认值。

- [java/](java/交付说明.md) 存放 Java 原业务和测试。
- [cangjie/](cangjie/交付说明.md) 存放仓颉业务和参考测试。

## 已核对用例

| Java 测试 | 仓颉测试 | 共同预期 |
| --- | --- | --- |
| `testSimpleVariable` | `simpleVariableTest` | 变量渲染为 bar |
| `testPrimitiveArrayVariable` | `testPrimitiveArrayVariable` | 数组段落渲染为 1234 |
| `testPrimitiveArrayIndexVariable` | `testPrimitiveArrayIndexVariable` | 下标 0 渲染为 1 |
| `testPrimitiveArrayIndexOutOfBoundsVariable` | `testPrimitiveArrayIndexOutOfBoundsVariable` | 越界渲染为配置的 ? |
| `testOneShotSection` | `testOneShotSection` | 单对象段落渲染为 baz |
| `testListSection` | `testListSection` | 列表段落渲染为 bazbif |
