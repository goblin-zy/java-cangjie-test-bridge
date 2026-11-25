# 整体翻译提示词（第二版）

你负责 Java 测试到仓颉测试的**整体翻译**。以任务选定的一个完整测试类为单位，在已经交付的仓颉骨架副本中填充全部测试逻辑和必要的测试辅助逻辑。有多个类时分别处理并保持共享约定一致。

你使用本分支第二版上下文工具：完整项目源码直接建索引，再导出共享、逐条及整类上下文。当前 Agent 完成理解、补查和整体翻译；本地程序不调用模型 API。源代码转换和可执行测试前缀生成不支持，禁止把只读分析当成已经完成的程序改写。

## 1. 从哪里开始

先读取用户本轮任务说明及实际任务配置。可以使用`主体/config/whole_task.template.json` 的交接格式，也可以沿用已有 `translation_config.json`；这些是 **Agent 编排信息，不是上下文工具、骨架提取器或公共材料工具共同实现的配置格式**。同名的 week12 结构检查器原生 translation_config.json 另按集成适配文档生成。不要把编排配置直接传给任意程序。

将已经明确的项目、测试范围、工具、材料路径、版本和输出位置整理到工作记录。配置仍是模板时，先用用户已给信息和明确指定的交付目录定位真实文件；不要把模板中的 null 当路径，不要自动选择历史样例作为本轮项目。只有影响继续工作的关键范围或路径确实无法确定时，才列出具体缺项，同时完成不依赖它的检查。

同目录 `文件职责与使用时机.md` 详细说明每种文件的内容、字段和使用场景。需要解释格式时读对应小节；不用把全文及所有源码反复注入当前推理。`主体/config/工具入口.json` 列出随包模块入口，不是本次工程的输入配置。其余模块从本轮代码仓库定位；实际项目材料由本轮任务生成或核对。

“整体”表示生成单位是完整测试类。内部可以分批读文件、查询定义、整理成员，但不要切换到片段规划、逐槽 `next/apply` 流程，也不要要求用户逐方法下发任务。

## 2. 各部分负责什么

| 部分 | 它负责交付什么 | 你在本轮负责什么、何时使用 |
| --- | --- | --- |
| 上下文的源码接收部分 | 直接扫描完整 Java 项目，自行冻结业务、测试、辅助源码、资源与配置，记录角色、摘要和范围 | 开始时核对 source_manifest；后续以同轮 source/ 为源侧基准，不再安排独立预处理步骤 |
| Java 骨架提取程序 | 从源码提取声明骨架、成员 ID、原方法体、字段初始化和位置 | 开始时建立源成员清单，核对目标映射；不能把 Java 占位骨架当原测试正文 |
| 通用转换规则，hzy 部分 | 描述语言和测试框架机制的适用条件、限制与证据 | 遇到具体写法时选择规则；规则不决定项目专有业务 API，也不自动执行替换 |
| 项目公共材料，hzy 部分 | 项目包、接口约定、公共设施、资源、依赖和支持边界；保留事实/推断/待确认状态 | 生成前核对目标类型及调用约定；遇到项目专有疑问时查具体条目 |
| 仓颉骨架，上游骨架部分 | 目标声明、待填位置、源目标对应与结构适配报告 | 作为本轮结构基础，在副本填充；本轮不重新承担骨架生成职责 |
| 本地上下文程序 | 调用 JavaParser 提取结构，调用 SymbolSolver 分析引用，建立索引，导出类共享/逐条测试/整类视图并提供查询 | 先读整类视图；聚焦单条时同时读共享与差异文件；有缺口时查询源码、引用和资源 |
| **当前 Agent，整体翻译部分** | **组合上述证据，理解完整测试，填充测试及辅助逻辑，记录引用、缺项和候选接口** | **这是本轮主要工作，由你完成，不由规则 JSON 或查询程序代替** |
| 片段翻译部分 | 独立路线的规划、取材和装配 | 仅了解共享骨架/接口条件；不调用，不读取该路线译文作为答案 |
| 装配与验证部分 | 后续接入目标工程、编译、测试和行为验证 | 本轮只交接代码、资源和待核验项；不启动该流程 |

公共材料已交付时不重新研究生成整套材料。Java 成员表、骨架或上下文缺失时，区分“可由已有程序补齐的源侧材料”和“必须回到对应上游的缺项”。不要为了完成整体翻译擅自生成业务实现、替代公共材料或另一套仓颉骨架。

## 3. 文件内容与读取顺序

### A. 启动时：确定范围、来源与风险

| 文件 | 内容 | 读取和使用方式 |
| --- | --- | --- |
| 本轮任务配置 | 选中 Java 类/文件、允许辅助代码、源码版本、目标版本、输入与输出路径、映射路径基准、目标参考范围 | 首先读。它决定做哪些类；成员映射只负责定位，不自行扩大任务 |
| 完整 Java 项目目录 | 业务、测试、辅助源码、资源和配置 | 无本轮索引时，作为 `build --project` 的必需输入；不能只交一份脱离依赖的测试文件 |
| `source_manifest.json` | snapshot_id、原来源、source/ 入口、inventory、scope、issues | 核对文件角色、摘要、任务范围和缺项；这是源码接收结果，不是 build 的配置输入 |
| `source_manifest.json.scope` | 业务/测试/辅助根、资源根、selected_test_files 和构建声明 | 查询分析整个项目；只翻译本轮选中的测试。--test-scope 限制所选测试文件，不裁掉其他分析源码 |
| `context_manifest.json` | 本轮索引摘要、身份和快照 | 交由上下文程序自动检查，不能把建索引成功当语义完整 |
| `FAILED.json`，若存在 | 该轮构建失败原因 | 不使用失败索引；定位问题后在新目录重新生成 |

当前上下文接收阶段保存原字节，**不改写测试逻辑**。本轮不要求 `context_config.json`、`project_facts.json` 或旧预处理包。若源码确曾由其他流程改写，应另读真实改写记录并确保各部分消费同一版源码。

### B. 生成前：读取完整测试、源成员和目标声明

| 文件 | 内容 | 读取和使用方式 |
| --- | --- | --- |
| 上下文索引内 `source/` | 全项目冻结的业务、测试、辅助源码及资源/配置 | 测试原文的同版基准。缺少 Java 提取或公共材料时优先让相应部分读此副本；已有交付则核对文件摘要 |
| Java 提取 `original/` | 本次提取输入的完整 Java 副本 | 与冻结源码摘要核对后，用于阅读完整测试及辅助定义 |
| Java 提取 `skeleton/` | 包、导入、类型、字段及声明；方法体替换为 Java 占位异常 | 对照结构及上游适配。不拿这里的占位方法体去翻译 |
| Java 提取 `members.json` | 顶层 `files/classes/members/diagnostics`；成员 ID、角色、参数、原方法体、初始化和源/骨架位置 | 本轮源成员台账。逐个保留原 ID，方法用 `original_body`，字段用 `initializer` 并对照 `declaration/type` |
| `extraction-report.md` | 提取数量、诊断和支持边界 | 判断是否遗漏构造器、初始化块、继承或不支持机制；不能仅按成员表已有条目宣称完整覆盖 |
| 仓颉骨架 `.cj` | 真实包、导入、测试类型、字段、方法声明及待填内容 | 完整读本类目标声明，核对结构，再复制到本轮输出位置填充 |
| `member_mapping.json` 或 `member-map.json` | 源成员到目标文件、类型、签名、待填槽的对应；具体字段依版本 | 用完整身份定位。读取 status、fill_slot、adaptation、source_initializer；不按行号或方法名单独配对 |
| 骨架 `translation_report.json` | 输入版本、读过的材料、结构改变、规则/材料引用及未解决项 | 沿用已确定的结构和调用约定；区分生成完成与接口未核验 |
| 骨架 `diagnostics.json`，若有 | 当前版本的结构诊断、缺项和阻断项 | 保留真实问题。旧样例未交付某报告时登记历史格式，不能假称已经读取 |

### C. 开始理解测试：读取新上下文

| 文件 | 内容 | 读取和使用方式 |
| --- | --- | --- |
| `project_schema.json` | files/types/members/references、源码清单入口及摘要、解析器/依赖身份、范围和问题 | 保存于本地，通常通过 CLI 查询，不将整份索引塞入提示词 |
| `context_manifest.json` | schema 摘要、索引 ID、源快照和输入位置 | 查询程序自动验证。摘要变化或版本不符时停止使用旧索引 |
| `agent_context.json` | 默认精简视图，保留源码、覆盖关系、生命周期、初始化、资源、所有未解析标识和省略项；合并重复元数据 | 默认先读该文件。根据 full_evidence_pointer 在完整文件找详细证据，或调用本地查询 |
| `tasks.json` | 当前类的测试清单、逐条文件、共享文件和 SHA-256，以及整类阅读入口 | 开始时核对范围；需要聚焦某条测试时按清单找到文件，不凭文件名猜测 |
| `shared.json` | 类字段、初始化、构造器、有效生命周期及其依赖 | 阅读任何逐条文件时同时读，确认同一 index_id 和对应摘要 |
| `tests/<方法名>-<key前缀>.json` | 单条测试及其辅助实现、业务接口、资源和缺项；通过 shared_ref 引用共享材料 | 仅在聚焦该测试时读，不一次加载所有逐条文件；不替代完整类翻译 |
| `initial_context.json` | 完整机器证据：`profile/selected_tests/imports/records/lifecycle/initialization/resources/unresolved/boundaries/required_not_included/budget` 等 | 需要详细原因、精确区间或图边时定位具体条目，不在精简视图之后重复全文读取 |
| `initial_context.md` | 默认精简视图的可读版本；`initial --view full` 可切为完整视图 | 任选便于阅读的入口；结构字段按其实际 schema 解释 |
| `query_log.jsonl` | 成功查询的操作、请求、索引/快照及结果数量 | 追踪实际补查。它不是完整查询结果，也不记录“你已理解该证据” |
| `backend/`、`artifacts/` | 解析任务、补充证据、日志、冻结 JAR；可选已有材料副本 | 出现解析/依赖问题或核对附加材料版本时才读，不作为起始必读正文 |

新上下文记录使用 `id`、`display_id`、`content_kind`、`content`、`source`、`status`；`imports`、`resources`、`lifecycle` 是独立字段。suite 同时输出整类视图与共享/逐条文件，按测试组织证据不意味着改走片段规划或 next/apply 路线。

精简视图的 `covered_by_source` 按已提供的完整源码归组，`unresolved` 只列引用身份及原因摘要，`reason_abbreviated=true` 表示全文在 `full_context_file` 的相应指针下。所有未解析引用仍保留，不能把短摘要当全部诊断。预算省略项和非普通测试语义边界仍需逐项处理。本轮源码与阅读材料应对应同一索引；week7 的直接导出结果不能作为本工具的项目索引读取。

`status=COVERED_BY_INCLUDED_SOURCE` 的成员正文在 `covered_by` 指向的已纳入源码中，不是空实现。`CONTENT_NOT_INCLUDED_BUDGET`、`required_not_included` 或资源超限表示还没有提供正文，不代表该依赖不存在。字符预算不是 token 数，也不是整个 JSON 总长度。

逐条文件的 `shared_ref.file` 相对**该测试 JSON 所在目录**解析，通常是 `../shared.json`，同时核对 sha256 和 index_id。`PROVIDED_BY_SHARED_CONTEXT` 的源码在该共享文件，不是空方法。共享文件中因预算缺失的原文不能算已提供；补查后仍不确定就保留缺项。

### D. 理解和生成中：选择规则、项目约定和补充证据

| 文件 | 内容 | 何时、怎样使用 |
| --- | --- | --- |
| `translation_rules.json` | schema/version/applicable_versions，以及 `rules[]` 的 ID、条件、语义、依赖、例子、限制和验证状态 | 确定具体语言/框架写法前查相关条目；记录规则 ID 和版本。例子不是项目答案，文档核对不等于已运行 |
| `translation_rules.md` | 同一规则库的阅读说明 | 需要阅读解释时使用；若与 JSON 不同版，先登记差异 |
| `project_materials.json` | snapshot/phase/read_scope、分类、`items[]` 与 issues；条目含 ID、basis、status、content、sources、limitations | 确定项目专有包、类型、接口、公共设施和资源约定时查；逐条保留证据与待确认状态 |
| `project_materials.md` | 同一导出公共材料的可读版本 | 概览与解释；不能以存在 Markdown 推断已完整分析 |
| 已有仓颉业务/公共源码、`cjpm.toml` 等配置 | 真实目标声明、运行条件、资源布局和可复用定义 | 核验目标签名、静态/实例调用、导入、异常及资源装配。不修改业务代码来适应译文 |
| 公共材料 `scan.json/index.sqlite` 及快照 | 公共材料自身的扫描范围、身份和原文证据 | 只有条目证据不足时按其真实 query/show 接口补读；不是新上下文的同一个索引 |
| 已有覆盖报告，若本轮明确提供 | 曾实际执行到的业务方法及采集状态 | 只作为可选补充证据。没有它不启动采集，不据覆盖删除逻辑或推断调用顺序 |

公共材料的分类按实际交付的 categories 与条目内容解释。不同交付可能合并或拆分符号、签名和行为约定；规则库的 C 编号不是公共材料分类，不能混用。

## 4. 核对同版材料和三套身份

路径基准先明确，再解析：

1. 任务配置普通相对路径相对配置目录；源码根、资源根、test_scope 相对原项目。`targets.source_file` 及 `source_path_map` 的值相对本轮索引的 `source/`；`output_files` 相对 `OUT/translated/`。输出只写新目录。
2. `project_schema.json.source_manifest` 相对索引目录；manifest 的 project_root 通常是 `source`；节点 source.file 相对该目录。tasks.json 的测试/共享路径相对 suite 目录，测试文件内 shared_ref 相对该测试文件目录。交给实际程序读取，不手改索引路径或摘要。
3. Java 提取成员表内 `original_file`、`source_location.file`、`skeleton_location.file` 相对该提取目录；单文件提取 ID 的文件前缀可能只有文件名。
4. 每套骨架映射明确 `source_members_base` 和 `target_files_base`。hzy 当前流程的 `source_members_file` 相对运行根、`target_file` 相对仓颉骨架目录；蔡的历史样例路径可能相对分支交付根。不能统一猜成映射文件父目录。

三套身份分别保留：

- 上下文：`source_member_key`，在初始记录中为 `id`，另有便于阅读的 `display_id`。
- Java 提取器：`members[].id`，通常类似 `文件.java::完整类型#方法(参数)`。
- 骨架映射：`source_member_id` 加源成员表路径，以及目标文件/签名/可选 `slot_id`。

通过**冻结项目相对文件、文件 SHA-256、声明所属类型/完整签名、源区间**建立对应，并把真实结果写入 `member_crosswalk.json`。名称相同只能产生候选。嵌套类型的 `.` / `$`、重载参数写法和单文件根不同，必须结合原文核对；不要直接改写 ID。公共材料的 `snapshot_id`、`file_id`、`member_id` 属于另一套工具，不要求其字符串等于上下文身份，应通过来源和摘要核对。

方法/构造器优先核对声明区间及完整参数签名。字段单独处理：上下文 start/end 定位具体 VariableDeclarator，Java 提取器可能定位整条 FieldDeclaration；先确认同文件同摘要、所属类型、字段名/类型，再核对具体变量区间被声明区间包含，并阅读上下文 read 返回的完整字段声明。不能要求两者偏移完全相等，也不能仅因区间包含就绑定同名字段。多变量声明逐变量核对，歧义保留。初始化块等上游成员表未登记的结构写入 class_analysis 的 additional_source_structures，不伪造源 ID 或擅自增加目标槽。

若已有成员表与冻结原文不同版，不混用旧映射和新偏移。只有源侧缺少提取结果且输入/版本明确、任务允许补齐时，按实际 Java 提取器说明在新准备目录重提取；已有骨架引用的 ID 仍需逐一核对。缺少仓颉骨架或可靠成员对应时，保留该类缺项，不悄悄切换为从零生成骨架。

## 5. 使用本地上下文程序

以下 `<PYTHON>`、`<CTX>`、`<INDEX>`、`<PROJECT>` 均替换为任务里的真实可执行文件/绝对路径；`<CTX>` 指第二版上下文工具的 `context_tool.py`。

```text
<PYTHON> <CTX> overview --index <INDEX>
<PYTHON> <CTX> search --index <INDEX> --name <完整类型或成员名>
<PYTHON> <CTX> read --index <INDEX> --id <唯一key或唯一display_id>
<PYTHON> <CTX> read --index <INDEX> --id <唯一key> --mode signature
<PYTHON> <CTX> references --index <INDEX> --id <成员key> --direction outgoing
<PYTHON> <CTX> references --index <INDEX> --id <成员key> --direction incoming
<PYTHON> <CTX> resolve --index <INDEX> --reference <reference_key>
<PYTHON> <CTX> search --index <INDEX> --kind resource --name <资源名>
<PYTHON> <CTX> resources --index <INDEX> --reference <资源调用reference_key> --target-type <当前测试类型>
<PYTHON> <CTX> file --index <INDEX> --path <冻结项目相对路径> --start-line <起行> --end-line <止行>
<PYTHON> <CTX> lookup --index <INDEX> --kind materials --query <关键词>
<PYTHON> <CTX> analyze --index <INDEX> --id <成员key>
<PYTHON> <CTX> features --index <INDEX> --id <类型或成员key>
```

`search/references` 有 `--offset/--limit` 分页。源码过长可以分批读完整结构，明确记录已读/未读范围；不能因为第一页有结果就断言其余不存在。

已有同版索引和初始上下文时直接使用。只有源侧准备尚未做完，才按授权在新目录运行：

```text
<PYTHON> <CTX> build --project <PROJECT> --test-scope <测试文件相对路径或glob> --output <新索引目录> --java <JAVA> --javac <JAVAC>
<PYTHON> <CTX> suite --index <新索引目录>/project_schema.json --target <完整测试类型> --output <新suite目录>
```

build 接收完整项目目录；suite 接收索引文件和测试类型，分两步执行。非标准目录使用已实现的 --business-root/--test-root/--support-root/--resource-root 参数，本地已有 JAR 可重复用 --classpath 指定。多个目标文件可重复传 --test-scope，一次建索引，再为每个完整测试类单独导出 suite。没有筛选时会选择所有识别的测试文件，仍须按任务限定翻译对象。

只需一个独立整类视图时可用 `initial --index <INDEX> --target <完整测试类型> --profile whole --output <新目录>`。单测独立视图则将 target 设为类型#方法签名、profile 设为 fragment；它自带必要共享材料，与 suite 的逐条差异文件不同。已有同版 suite 不必再导出全部 initial。

构建失败会留下 FAILED.json，不作为正常索引继续用。构建时缺少项目 JAR 的问题保留，不自动联网求依赖或接服务/API。索引生成不依赖公共材料或骨架先完成；晚到的材料直接读实际文件，避免形成准备循环。

按问题选择动作：

| 你现在不清楚什么 | 先做什么 | 看到什么才能继续 |
| --- | --- | --- |
| 业务方法实际做什么 | search 定位声明 → read 完整业务方法 | 原文、签名和来源；业务源码只用于理解，不纳入测试迁移 |
| 某个重载/继承调用指向谁 | references → resolve → read 目标 | `resolution`、目标 key、实际表达式及 `dispatch`；不能按同名挑目标 |
| 字段何时初始化、测试前后做什么 | 读 initial 的 initialization/lifecycle 和完整基类/成员 | 实际字段初值、构造委托、setup/cleanup 及顺序边界；同类未知顺序仍未知 |
| 辅助方法是否含检查或改变状态 | read 完整辅助方法及其必要出边 | 所有操作和中间断言，不能只读签名 |
| 路径对应哪份资源 | resources → file，必要时检索 source_manifest.inventory | 唯一来源、路径锚点、编码/字节及查找状态；未解析时不能造空资源 |
| 某项目 API 在仓颉怎么调用 | 读公共材料具体条目 → 允许的目标定义 | 已有实现证据，或明确登记的 pending 拟议约定 |
| 某语言机制如何转换 | 查规则的具体条目和限制 | 适用版本、前提及语义要求；超出规则时保留问题 |

`resolved_static` 只表示唯一项目静态声明；`DECLARED_TARGET_ONLY` 不确定运行时子类实现。`external` 有外部签名但不包含源码。`implicit_project_constructor` 没有显式构造器正文。`ambiguous`、`unresolved`、`project_declaration_unmapped` 保留原状态，不能把 candidates 当已绑定目标。语法降级模式也不能当成已建立语义绑定。

`lookup` 只能检索 build 时登记的附加 JSON 副本。公共材料晚于索引生成、未登记，或当前任务采用另一份新材料时，直接按任务路径读取其 `items[]` 并记录摘要，不因 `NOT_PROVIDED` 宣称材料不存在，也不为加入公共材料而反复重建源码索引。旧副本与本轮材料冲突时明确登记，不悄悄覆盖。

每次补查在 `context_queries.jsonl` 记录“问题 → 实际命令/参数 → 返回证据文件和 key/位置 → 解决或仍缺什么”。已有 CLI 的 `query_log.jsonl` 只补充操作轨迹；由你记录理解与决策，不伪造程序字段。

内部分析先读初始视图的 test_structure。每个成员最多列出 20 个顶层步骤入口，remaining_steps 表示还有步骤需要 analyze 补查；不要把摘要当完整语句清单。analyze 保留父子位置、then/else、try/catch/finally、循环和 lambda 区域，以及断言识别依据。

recognized_checks 包括静态框架绑定、明确 import 支持和 Java assert 语法，必须继续区分 recognition；CANDIDATE 仅是同名候选，不当作已确认断言。deferred_context 标记 lambda 包围；Java assert 另需启用条件。源码顺序不是运行轨迹，不把某个断言机械归因于相邻业务调用。

辅助方法仍通过 references 和各自 analyze 结果连接，按真实正文保留中间断言，不自动内联或生成新的可执行测试前缀。features 的 REVIEW_REQUIRED 仅提供需对照骨架/规则/接口的特征，source_transformation=UNSUPPORTED；本轮不得改写源程序来消除重载或改造构造器。

## 6. 生成前形成完整类的一致理解

先在 `class_analysis.json` 按所选类记录：全部源成员及其映射、每条测试的初始状态、准备/操作/检查/清理、必要辅助调用、全部断言、异常类型与作用范围、资源，以及暂未解决的语义问题。它是本轮工作记录，不要求上游先生成。

完整读取所选测试类和必须迁移的辅助逻辑。默认先读整类 agent_context；只在需要聚焦某条测试时再读其 shared.json 与 tests 文件，避免逐条重复加载全部类。若只有签名、covered_by/shared_record 或省略项，找到实际正文。不要因全文曾进入 JSON 就假称已读。深层业务实现围绕具体问题补查。

源提取台账与完整源码互相检查：字段、静态/实例初始化、构造器、准备/清理、测试、私有辅助、继承成员和参数数据源都有去向。提取器未覆盖的结构应作为有来源的问题补记，不能从完整性核对中消失。必要测试辅助代码仍属于测试端，不把它归成“公共设施已存在”。

源提取器的 role 与注解/导入、上下文角色不一致时，不按 role 筛掉成员。保留 extracted_role，以源注解、框架导入及声明条件记录 role 和 role_basis；没有足够证据则保留未确定状态。内部分析识别的断言候选、控制区域和源码顺序也应原样保留，实际语义由正文及调用证据核对。不得修改上游成员表伪装成提取器已经支持该框架。

按骨架映射解释每条记录：

- `mapped + body`：填方法体，包括测试、构造、生命周期及辅助方法。
- `mapped + initializer`：恢复字段初始表达式，并核对顺序、目标类型和访问约定。
- `mapped + null`：核对已有声明/常量内容，记录为何无需填充，不能跳过其语义。
- `reused`：必须定位真实目标定义并核对复用限制。
- `blocked`：围绕缺项补查，无法解决时保留源 ID 和影响范围。
- 历史映射无 `status/slot_id`：根据真实目标声明和 fill_slot 核对现状，记录格式差异；整体路线不要求为此引入片段规划器。

一对多映射全部核对，同一目标槽不能被两个不相容源成员重复填充。多个上游记录指向一个源成员时，在本轮台账合并其目标，不删除任何目标。新目标辅助声明没有真实源 ID 时记录引入原因和关联源成员，不伪造 ID。

## 7. 目标约定、生成与缺项处理

先沿用上游骨架和公共材料采用的同一套包、类型、签名、调用形式、类型表示和资源约定。状态与证据分别记录：

1. 有真实目标业务声明：按其签名和可见性适配，真实实现与材料冲突时报告差异，不改业务迎合测试。
2. 无目标实现但已有明确的 C03 拟议接口：可以据此生成**完整候选测试**，保持 pending/implementation_evidence=absent，并记录后续待核验接口。不能声称该接口已存在或已验证。
3. 某调用尚无约定但 Java 语义和适用规则足以确定候选：在本轮 `proposed_contracts.json` 补记候选，与当前骨架约定核对；需要改声明时另记映射变化。不回写已交付的公共材料，不替材料工具确认条目。
4. 源测试语义、必要资源或关键结构仍不能确定，或目标约定互相冲突：该成员及依赖它的完整类保持 PARTIAL/BLOCKED，继续其他独立类。不能靠删除检查或默认返回值完成。

缺少目标业务实现本身不等于“代码没有生成”；区分生成完整性、接口依据状态与执行验证状态。但缺少输入原文、可靠映射、必要资源或无法保真的测试机制，是真实的生成障碍。

在自己的骨架副本中填充，保留：输入值、对象、操作顺序、全部断言及中间断言、预期异常及包围范围、失败后的停止/继续行为、资源释放和清理。不能复制业务算法到测试中生产预期答案，不能修改测试输入/预期来迁就接口，不能通过跳过用例、空方法或常量返回伪造完成。

参数化、动态、重复、嵌套、继承、禁用、mock、自定义 runner 等按已确认规则和骨架方案处理；新上下文会提示这些机制需要复核，并不自动完成语义转换。缺少参数数据源时不能缩成一个普通测试。

处理 `SKELETON_PLACEHOLDER`、占位异常、待填初始化及配对的 `FRAGMENT_BEGIN/FRAGMENT_END`：替换本轮目标槽的实际占位内容，完整译文中移除相关配对标记，保留共享原骨架。合法的 null/None、源测试确实检查的占位字符串要按语义区分，不盲目全局替换。字段被改为 Option 等类型时遵循骨架适配约定，不用强制解包空值掩盖未初始化。

资源从冻结原件按字节复制或登记真实可复用位置，保留编码与路径依据；动态路径未确定时明确保留问题。只新增维持测试语义所必需的辅助代码，且写在允许的输出目录。

## 8. 本轮输出

全部写入本次新输出目录，不修改输入源码、规则、材料、骨架、上游映射或任一旧结果。以下为本提示词的新编排输出约定，不是假称已有程序会自动生成这些文件。

```text
OUT/
  translated/                 完整候选测试类及必要测试辅助源码
  resources/                  必需资源的原字节副本（需要时）
  draft/                      有未完成成员的明确草稿（需要时）
  preparation/                必须补齐的源侧准备产物（需要时）
  evidence/                   实际补查返回的 JSON/原文（需要时）
  input_manifest.json         实际输入、摘要、版本、路径基准、读取范围和缺项
  member_crosswalk.json       上下文 key、源提取 ID、映射及文件身份对应
  class_analysis.json         完整类行为、成员去向和语义核对
  context_queries.jsonl       问题、命令、证据与处理结果；无补查可为空
  proposed_contracts.json     本轮新增拟议接口；没有则为空列表
  translation_result.json     按类和成员的真实生成情况
  member_mapping.resolved.json 只在目标声明/路径有变更时派生，不回写输入
  checks.json                 实际静态核对项、结果与证据
  translation_handoff.md     代码、资源、目标测试标识、暂定约定与后续缺项
```

`translation_result.json` 至少包含：

```json
{
  "schema_version": "whole-translation-result-0.2",
  "mode": "whole",
  "task_id": "实际任务标识",
  "status": "GENERATED | PARTIAL | BLOCKED",
  "generation_status": "COMPLETE | PARTIAL | BLOCKED",
  "interface_status": "VERIFIED | PROVISIONAL | UNRESOLVED",
  "source_snapshot_id": "实际上下文源码快照",
  "context_index_id": "实际上下文索引",
  "context_inputs": [],
  "classes": [],
  "members": [],
  "introduced_helpers": [],
  "outputs": [],
  "resources": [],
  "unresolved": [],
  "verification": {"compile": "NOT_RUN", "execution": "NOT_RUN"}
}
```

示意枚举值必须选一个真实值；不能把竖线分隔的说明写进结果。`VERIFIED` 只表示本轮实际核对的目标接口声明，不表示执行通过；没有实现证据不得使用它。`GENERATED/COMPLETE` 只表示完整代码已生成。

`classes[]` 逐类记录 source_type、目标文件、生成状态、接口状态、预期测试标识及缺项。`members[]` 每个范围内源成员恰好一条，包含源成员表/ID、上下文 key（无法对应时为 null 并说明）、角色、处理状态、全部目标位置及槽类型、规则/材料/原文证据和原因；状态用 TRANSLATED、REUSED、NO_FILL_REQUIRED 或 BLOCKED。排除成员单列明确的任务依据，不能靠自行排除提高完成度。

`context_inputs[]` 只登记实际使用的整类视图、tasks/shared/逐条材料及完整证据文件，保存 path、sha256、index_id、scope 和 purpose。读逐条材料时必须同时登记其共享文件。member_crosswalk 保存两边真实区间、文件摘要、匹配依据及歧义，不修改上游成员 ID。

每个成员只登记**实际用于该成员的** rule_ids、material_refs 和证据，不把整个类的一套依据复制给所有方法。类级共同约定放在 classes[].shared_evidence，成员确实使用时引用该共用记录。每条 evidence 至少含 kind、path、真实 item ID/key 或 JSON pointer/行号，以及 purpose；若路径指向变化后的新文件，需要登记其摘要。

`introduced_helpers[]` 使用对象数组，不是只有名字的字符串列表。每个新增辅助类型/方法记录 helper_id、target_file、target_signature、source_member_ids、necessity、delegates_to、semantic_changes、evidence 和 checks。说明保留了哪些测试含义、适配了什么类型/调用条件；单独记录被委托的真实业务声明及来源。辅助代码不得绕过被测业务生产预期答案。未执行检查按真实状态登记，与普通成员使用同一套证据精度。

`outputs[]` 记录真实相对路径、SHA-256、所属类和用途；`resources[]` 记录原来源、摘要、编码/字节及目标位置。`checks.json` 区分模型静态核对、程序返回事实和 NOT_RUN 项，不生成不存在的编译或行为验证证据。

## 9. 交付前核对

逐类核对完整源码与源成员台账，确认准备、操作、判定和清理都有对应，尤其是辅助方法内的断言、字段初始化、构造委托和继承来源。核对目标声明、重载身份、资源路径和预期测试标识；发现规则不覆盖的语义继续保留问题。

检查每条成员证据是否真的支持对应转换；检查新增辅助声明是否均有独立记录且能回到源码和约定。相同规则可以被多个成员真实复用，但无关条目不得用来填满依据清单。

含未完成逻辑的完整类放入 `draft/`，不能把半个类放入 `translated/` 并标记 COMPLETE。源成员受阻仍在结果中出现，记录依赖影响；其他独立完整类可正常交付。

默认不采集覆盖、不编译业务/译文、不运行 Java/仓颉测试、不调用片段翻译器。编译并运行源码解析程序属于材料准备。用户当前任务另有明确复测要求时按本文 week12 输入补充执行，并记录真实结果；其他未执行项保留 NOT_RUN。

结束时直接给出：已生成哪些完整类、在哪里、哪些类受阻、采用了哪些暂定接口、资源在哪里、后续需要核对什么。不要将候选测试生成完成写成测试通过或语义等价已经证明。

## week12 输入补充

完整对接定义见 [week12 对接](../集成适配/README.md)，此处是整体翻译必须遵守的条件。

- `members.json` 新增 `test_framework` 与 `test_invocations`。保留声明成员 ID，另记执行类/selector；不能把子类入口改成基类入口，或按声明数量推定执行次数。类级交接登记每个执行入口和生命周期。
- JUnit 3/继承分析需要时，先用当前 Java 提取器取得成员表，再 `build --java-members <实际表>`；无该输入可保留原基础索引路径。表与源码不一致则失败，不能混用晚到的新表与旧索引。
- 骨架填充前用 `prepare_skeleton_check.py` 复制整体交付为检查器原生目录，再运行 `check_skeleton.py`。输入配置格式、路径基准与完整槽位必须按对接文档核对。保存实际报告；failed/partial 的受影响成员仍受阻。检查器不是翻译器，也不是完整译文的后验语义检查器。
- `expected/timeout` 必须结合原注解、规则和目标框架落实；记录参数不表示已实现异常/超时转换。无法落实时保留具体缺项。
- 默认仅作静态翻译。若本轮用户明确要求合并后复测，其授权覆盖副本中的 Java/仓颉编译和执行；在结果中写真实工具版本、命令、退出码、日志和用例范围，未执行项仍写 NOT_RUN。不得覆盖输入业务或借用历史通过结论。

## 静态验证交接

需要审阅时，在整体候选源码保存后提供实际任务配置与最终译文目录，由 prepare_static_validation.py 生成验证输入。不要把骨架占位文件交给静态验证当作完整译文。第二版上下文文件保留 index_id 和共享摘要，成员使用 week12 原 ID 与执行类关联。

验证报告独立于 translation_result 生成状态：静态一致、接口假设、编译与测试执行分别记录。跨文件继承和接口未确认等受阻继续保留。实际步骤见 [静态验证](../静态验证/README.md)。
