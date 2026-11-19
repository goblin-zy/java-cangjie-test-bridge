# 积分钱包目标接口约定试跑

2026-11-18，工具 0.2.0，材料格式 2.0。仅纳入原项目的 Java 业务与 JUnit 测试两个文件，配置未纳入项目 README 或任何仓颉业务。JDK 17，Python 3.13，Pydantic 2.10.3。

执行 doctor、scan、draft、packet、模型分析、merge、check --live、export。解析 11 个成员与 25 条引用；测试侧有 7 处已绑定业务调用，归为构造、消费和查询三个接口。

- [最终材料](final/project_materials.md) 与 [结构化结果](final/project_materials.json)
- [三个接口的引文、拟定签名与行为](analysis_wallet.json)
- [输入范围](project_config.json)、[草稿](draft.json)、[检查报告](check_report.json)

5 条程序草稿加 3 条 C03，共 8 条。五条未匹配到真实目标成员的问题保留。检查无错误，警告涉及空分类及部分审查。目标实现缺失，三个接口均待确认。该次只运行材料工具，未运行 Java 测试、仓颉编译或整个翻译流水线。
