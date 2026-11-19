# 项目材料分析提示词

你正在为Java测试→仓颉测试翻译整理项目级材料。请基于当前扫描快照分析，不编造不存在的接口、依赖、约定或运行结果。

## 输入占位项

- 项目名称：<project_name>
- 扫描编号：<snapshot_id>
- 本次模块：<module>
- 程序草稿：<draft.json>
- 分片目录和清单：<packet_directory/manifest.json>
- 模型结构：<analysis_contribution.schema.json>

## 输出

输出一个符合Contribution模型的JSON文件：
- snapshot_id：与输入完全一致。
- reviewed_file_ids：本次真正读取并分析的可用文件ID，不包含仅见到名字或被隔离的文件。
- reviewed_categories：本次真正核对的分类ID；空分类仍需说明查找范围。
- items：新增条目或明确提出的旧条目修订。
- issues：缺失、冲突、解析失败、未解析引用、待确认及覆盖问题。
- analysis_notes：非空，列出实际阅读的分片、推断依据、未读材料和未完成工作。

九类使用 C01、C03、C05～C11，具体名称和字段见README与schema。没有证据的分类不要补造内容。

每个item记录id、category、subject、title、content、basis、status、confirmation_note、sources、limitations、related_members和scope。
每个source记录file_id、start_line、end_line、quote和可选member_id。quote必须是该行范围内实际出现的内容，不能把自己的总结当成引文。

basis：
- source_fact：可直接从语法结构或配置读取。
- document_statement：文档明确声明；不代表已与实现核对。
- heuristic_candidate：程序按名称/语法生成的未确认候选。
- ai_analysis：结合多处证据得出的分析。
- human_confirmation：只有用户确实确认过才可使用，并保留确认依据。

status：
- extracted：直接提取，尚未语义确认。
- pending：还需确认。
- confirmed：有充分核对依据，必须写confirmation_note。
- conflict：不同依据有冲突。
- missing：明确需要的内容缺失；仍应说明查找范围和依据。

## 核对重点

1. 符号对应要结合所属类、参数、返回、可见性、实现与文档。相同名字不保证相同业务。
2. 已有目标签名引用真实目标代码；目标解析失败不能当“目标不存在”，必要时读取文件并将人工/AI抽取状态写清。
3. 金额单位、异常条件、失败状态等要引用实现或明确契约。具体样例数值不升级为全项目规则。
4. 公共辅助代码按实际作用范围分类，不能仅凭public或被调用就宣布是全项目设施。
5. 接口存在不证明可运行；参考代码和历史记录不是本次验证结果。
6. 参数类型、空值方式、常量、父类、异常层次和访问方式不同时，记录差异而非抹平。
7. 避免重复维护相同代码；引用稳定成员ID，必要时show读取完整实现。
8. 目标没有测试是正常情况；不得请求对应仓颉参考测试来补齐答案。
9. 先按模块整理，再检查同一接口/约定跨模块是否出现不一致。
10. 对所有程序问题逐项说明是否解决或仍保留，不把索引中的错误悄悄删掉。


## 目标接口约定（统一 C03）

读取草稿 read_scope.target_contract_review。inspect_target 核对双方声明；inspect_partial_target 区分解析失败、隔离和真实缺项；propose_from_source 进入以下流程。
1. 从所有选定测试、准备、清理和实际调用的辅助代码出发。按引用编号回查源成员，逐项补查无绑定的构造、字段、异常及动态调用。排除测试私有辅助、无关私有字段和仅内部使用的间接调用。
2. 为每个需要的业务接口整理 Java 签名、测试调用位置、调用方式、返回值用途、状态和异常。核对所有使用点的类型、空值和重载。
3. 优先采用可见目标声明，再查明确文档，最后根据 Java 声明和适用规则拟定签名。未定的包名、类型宽度、访问方式或异常策略标出依据或待决选项；资料冲突保留双方出处。
4. 无目标实现时，每个接口写一条 C03。content 包含 source_signature、target_signature、call_form、behavior、decisions、implementation_evidence（无实现填 absent）。related_members 引用真实源成员，sources 引用声明及使用点。模型拟定用 ai_analysis/pending，文档明示用 document_statement/pending。独立业务约定也归 C03。禁止虚构目标成员 ID。
5. 逐项对照需求清单：每个测试必需调用都对应约定或有原因的问题。按适用范围说明未覆盖的引用；将同一份约定交给骨架和两种翻译路线。
