# 预处理共用交接约束

以本文件目录为结果根。先检查FAILED.json，再读handoff.json、capabilities.json、issues.json和下游模块使用说明.md。按downstream_handoff.json选择被指派模块及专属prompt。prompt只提供操作约束，不会自动调用工具或模型。

input为选定原文字节副本，source_mapping为恒等对应，不包含业务实现或目标骨架。members提供源成员标识、原文和UTF-16区间；source_member_key只在同一源快照内使用。旧工具标识须显式对照，不得假定通用兼容。

translation_features只包含其coverage声明的语法特性与注解名称提示；不是已确认的JUnit角色、依赖图、初始化顺序或改写建议。external_references未绑定，不能将所有调用都标为业务接口。

不得删减断言、外部调用、初始化或资源来绕过缺项。整体翻译读取完整类型和辅助；片段规划另行完成，不将成员索引或累计状态解释为独立测试。

输出到独立目录，记录源snapshot_id、所用成员及补充输入。字节保持不证明译文语义或检错能力；未执行的检查和未完成的功能必须单列。
