# 规则映射说明：Java→仓颉测试程序翻译

版本 **0.2.0** · 整理日期 **2026-10-26** · **十二类目录、21 条当前规则、3 项后续候选**。

## 1. 目标与收录边界

这份规则库服务于 **Java 测试程序及其必要测试辅助代码的仓颉翻译**：保留准备条件、被测接口调用、调用顺序、断言、异常预期和清理行为。语言与生态层的知识仍可跨项目复用，但只围绕测试迁移需要收录，不追求覆盖所有 Java 程序。

规则正文：[translation_rules.json](<D:/program_study/sc/yrys/一人一事/Translate/Rule mapping/translation_rules.json>)。本说明在项目目录及 Obsidian 中各保存一份，本次内容相同；以后不自动同步。

默认版本为 **Java 17、JUnit Jupiter 5.13.4、仓颉及标准库 1.2.0**。规则供人工或模型参考，不是可执行转换器。

收录时先问：**去掉这条规则，会影响哪一部分测试或必要辅助代码的翻译？** 只有被测业务实现用到某机制，不足以成为收录理由。

| 材料或操作 | 本规则库如何处理 |
|---|---|
| 测试类、方法、字段、初始化与清理 | 属于翻译对象，保留结构与执行行为 |
| 创建被测对象、传参、调用方法、检查返回值 | 属于测试表达；目标类和签名由项目材料提供 |
| 测试辅助方法、数据构造器、自定义检查及其必要依赖 | 只迁移保留测试行为所必需且目标侧尚无可复用实现的部分 |
| 被测业务方法体、解析算法、业务计算 | 不加入当前翻译对象；实现片段可按需用来理解行为 |
| 已有业务类、业务异常和公共设施 | 引用项目提供的声明及对应关系，不为翻译测试重新生成 |

例如，测试调用 `parser.parse("+12")` 并检查结果，只需要表达输入、调用接口和断言；不需要把解析器内部的 `parseInt`、分词或列表累积算法一起翻译。

仍保持三层分工：规则库记录通用转换方案；项目材料记录符号、接口、异常类型及公共约定；当前测试提供具体输入、状态和预期值。不能为了套用规则而重算预期结果或修改被测接口。

## 2. 每条规则的测试翻译用途

十二类 `category` 回答“属于哪种机制”；新增 `translation_use` 回答“测试翻译为什么需要它”。两者各有用途。

| `translation_use.kind` | 当前数量 | 用途与选择条件 |
|---|---:|---|
| 测试框架迁移 | 5 | TEST-01/02、ASSERT-01～03；保留测试发现、生命周期和判定机制 |
| 测试代码基础表达 | 14 | 表达测试准备、对象与接口使用、条件及检查；按实际出现的机制选择 |
| 按需辅助表达 | 2 | EXCEPTION-01、LIB-01；仅在测试或必须迁移的辅助代码直接使用时选用 |

数量不代表应把整组规则交给模型。即使属于基础表达，也只选当前测试需要的条目。

```json
"translation_use": {
  "kind": "测试代码基础表达",
  "purpose": "创建被测对象或测试数据，并保留同一对象的引用共享。"
}
```

这是 OBJECT-02 的用途标识。`purpose` 解释保留规则的理由；`conditions` 继续说明技术前提，例如目标必须是已存在且构造签名已确认的 class。

## 3. 十二类目录与实际覆盖

| 分类 | 当前规则 | 收紧后的内容 |
|---|---|---|
| 基础语法与程序结构 | SYNTAX-01～03 | 测试变量、字面量、条件循环、包与导入；不再提供 switch→match |
| 类型系统与类型转换 | TYPE-01～03 | 测试数据和接口类型、数组及缺失值；不擅自修改目标签名 |
| 运算与求值语义 | OP-01～02 | 测试端有限整数计算、短路、实参顺序和求值次数 |
| 对象模型与状态语义 | OBJECT-01～03 | 测试字段、必要辅助类型、对象创建和已有成员访问 |
| 函数与可执行片段 | FUNC-01～02 | 测试辅助方法、接口调用和异常检查中的延迟操作 |
| 相等、身份与比较 | COMPARE-01 | 测试条件中的基础值和字符串内容比较 |
| 异常与资源管理 | EXCEPTION-01 | 按需迁移测试端已有的显式异常处理和 finally |
| 标准库与常见第三方库 | LIB-01 | 按需处理测试端空文本检查与简单文本拼接 |
| 测试结构与执行机制 | TEST-01～02 | 测试发现、逐测试准备、清理与隔离 |
| 断言与测试判定 | ASSERT-01～03 | 标量、数组和指定异常检查；保留快速失败 |
| 测试替代组件与交互验证 | 暂未覆盖 | Mock/Stub、调用次数和交互顺序 |
| 特殊运行机制 | 暂未覆盖 | 反射、并发、异步等 |

目录完整不表示每类都已完成。OBJECT-01 的构造写法只用于必要测试辅助类型；被测类的构造接口只引用项目约定。TEST-01 仍要求普通目标测试类可无参构造。

### 移出当前规则列表的内容

| 原编号 | 当前处理 | 再次收录的条件 |
|---|---|---|
| EXCEPTION-02 自定义异常定义 | 仅登记候选；测试引用业务异常由项目层提供 | 测试确实自行定义专用异常且没有目标声明可复用 |
| LIB-02 动态列表及导出数组 | 仅登记候选；检查返回数组不要求迁移业务列表实现 | 测试或必要数据构造器实际使用动态列表 |
| LIB-03 整数解析 | 仅登记候选；数字文本和边界测试不等于测试调用 parseInt | 测试或必要辅助代码直接执行整数解析 |

这三项在 JSON 的 `deferred_candidates` 中只保留原因和重新纳入条件，不保留完整转换正文，不计入 `rules` 或分类的 `rule_ids`；旧编号不重新分配。原版已保存在项目临时目录的 `before-0.2.0` 备份中。

另外，SYNTAX-02 删除由业务分支引出的 switch 方案；LIB-01 删除分词、ASCII 字节处理和通用格式化的范围。未来遇到真实测试需求时再核对、补充。

## 4. JSON 字段与证据含义

顶层保存适用版本、收录边界、用途选择政策、十二类目录、`rules`、`deferred_candidates` 及固定源码版本。结构版本为 **1.1**，规则库版本为 **0.2.0**。

| 字段 | 含义 |
|---|---|
| `id`、`category`、`name` | 稳定编号、机制分类、规则名称 |
| `translation_use.kind`、`purpose` | 测试翻译用途类别，以及这条规则解决的具体需求 |
| `source`、`target` | 源机制及目标方案；不是可执行匹配表达式 |
| `conditions` | 允许采用方案的技术前提，与用途说明配合使用 |
| `dependencies` | 必要导入、类型或其他材料；无则为空数组 |
| `semantics` | 必须保留的值、顺序、状态或判定行为 |
| `example.java`、`example.cangjie`、`example.context` | 对应片段及上下文；不能视为已独立编译的程序 |
| `verification.documentation` | 既有文档核对状态，仅覆盖受限方案 |
| `verification.source_comparison` | 固定提交下的写法或差异；业务源码对照不证明测试端有需求 |
| `verification.execution`、`notes` | 本次运行状态及证据范围、差异和缺口 |
| `sources` | 实际查阅的版本化文档或标准库源码入口及章节/成员 |
| `limitations` | 不适用范围、未支持机制及剩余限制 |

本版 21 条当前规则沿用已有文档“已核对”记录，**所有示例均为“本次未运行”**。0.2.0 是范围与用途调整，没有新增编译、测试或等价性实验。字段、编号、目录及副本一致性检查不能替代运行验证。

对照仓库固定为 [java-cangjie-test-bridge，9b5b13e](https://github.com/goblin-zy/java-cangjie-test-bridge/tree/9b5b13e1dd02a026650f46185ab6a3ee093268d8)。标准库源码沿用 [v1.2.0，52f9e08](https://github.com/cangjielanguage/cangjie_runtime/tree/52f9e08f985ba42e23581e725e1b11f956f941d6)。部分仓颉文档此前通过检索返回的正文核对，不声称已逐页离线阅读全文。

## 5. 使用顺序

1. 确认翻译单元是测试类/方法，补齐它需要的初始化、辅助方法及项目接口对应。
2. 对遇到的机制查看 `translation_use.purpose`，确认它解决当前测试的哪一部分需求，再检查 `conditions`。
3. 只选相关规则；被测方法的实现依赖不自动加入规则选择或翻译范围。
4. 保留原输入、预期值、调用次序、辅助断言及异常后检查；不得靠删检查或改接口消除困难。
5. 碰到候选或未支持机制，先判断是否真正属于测试端；需要迁移时再补充规则、记录待确认点。

例如，`assertArrayEquals(makeExpected(), callTarget())` 需要 ASSERT-02；有副作用时结合 OP-02 保留两侧顺序和执行次数，数组声明结合 TYPE-02。目标 `callTarget` 的签名由项目材料提供，它内部是否使用解析器或列表不会自动触发 LIB-02/03。

## 6. 当前材料的测试端覆盖核对

以下沿用 0.1.1 已阅读固定源码的 24 个测试方法清单，按测试端职责重新归类；这次没有重新运行实验，也不再将业务内部机制算成测试规则覆盖。

| 原测试方法 | 主要规则与测试端重点 |
|---|---|
| Rectangle：testConstructor | OBJECT-02/03、ASSERT-01；创建并读取状态，不翻译构造器内部实现 |
| Rectangle：testToString | COMPARE-01、ASSERT-01；保留预期字符串及调用，不翻译业务格式化 |
| Rectangle：testIntersection、testTouchingEdge、testPointRectangle | OBJECT-02、FUNC-01、ASSERT-01；创建对象、调用并检查布尔结果 |
| Rectangle：testInvalidCoordinates | OBJECT-02、ASSERT-03；两个独立构造异常检查 |
| InstructionParser：testEmpty、testSpaces | SYNTAX-01、TYPE-02、ASSERT-02；保留文本输入和空数组预期 |
| InstructionParser：testNamedInstructions、testSignedNumbers、testRepeatedSpaces | TYPE-02、ASSERT-02；保留输入文本、数组值和顺序，不迁移分词或数字解析 |
| InstructionParser：testInt32Boundaries | TYPE-01/02、ASSERT-02；保留边界输入与预期值，不要求 LIB-03 |
| InstructionParser：testInvalidTokens、testOutOfRange | SYNTAX-02、FUNC-02、ASSERT-03；逐项异常检查，不复制非法输入判断算法 |
| InstructionParser：testNullInput | TYPE-03、ASSERT-03；沿用项目可空适配入口 |
| Account：testInitialBalance、testDeposit、testWithdraw、testWithdrawAll | TEST-02、OBJECT-02、FUNC-01、ASSERT-01；准备、调用与状态检查 |
| Account：testSequence | TEST-02、FUNC-01、ASSERT-01；保留辅助方法中的断言及后续检查 |
| Account：testInsufficientFunds | ASSERT-03、ASSERT-01；引用已有异常类型，保留异常后状态和后续调用，不要求 EXCEPTION-02 |
| Account：testInvalidAmounts | SYNTAX-02、ASSERT-03、ASSERT-01；各次异常及状态检查 |
| Account：testBalanceLimit | TYPE-01、ASSERT-03、ASSERT-01；保留边界检查，不实现业务上限算法 |
| Account：testInvalidInitialBalance | OBJECT-02、ASSERT-03；保留构造失败检查 |

清单仍为 **6＋9＋9＝24 个测试方法**；不是“21 条规则覆盖全部测试特性”的证明。所有类还需 TEST-01、SYNTAX-03 等基础规则；按需规则不必在每个样例中使用。

既有差异继续保留：整数宽度和 getter→目标成员对应由项目提供；仓库的 `@Expect` 不作为快速失败依据，本库采用 `@Assert(expected, actual)`；异常检查优先采用受限的 `@AssertThrows`，手写 catch 的失败报告可能不同。仓库 localfix 历史通过记录不计为本规则库实测。

## 7. 待扩展边界

暂未完整支持对象身份/一般 equals、浮点容差、复杂泛型与继承、参数化/动态/禁用测试、自动资源关闭、Mock、反射、并发和异步。遇到这些情况应记录，不静默省略。

新增条目先说明测试用途，再核对源含义、目标方案、条件、依赖及语义；需要项目专有类型或业务约定时放在项目材料中。候选重新启用不沿用“已出现过就已验证”的结论。

设计依据为 [《大概流程.md》](D:/OBsidian_cangku/大三上/一人一事/翻译方法设计/大概流程.md) 的十二类及三层边界；每条规则的具体语言规范和框架文档入口保留在 JSON 中。
