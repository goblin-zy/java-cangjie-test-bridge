# 技术依据与版本

这些是实现依据，不是本工具的运行或测试证明。

- JavaParser/SymbolSolver固定3.26.3；Java依赖以Maven Central的javaparser-parent 3.26.3 POM为依据，Javassist 3.30.2-GA、Guava 33.3.1-jre；Gson 2.11.0用于助手协议。下载文件及SHA-256保存在.build/java/artifacts.json。
  - https://github.com/javaparser/javaparser
  - https://repo.maven.apache.org/maven2/com/github/javaparser/javaparser-parent/3.26.3/javaparser-parent-3.26.3.pom
- 仓颉std.ast 1.2.0：parseProgram(cangjieLex(code))、dump及示例字段。本版dump协议有版本边界；不是完整类型/符号分析器。
  - https://cj-docs.gitcode.com/zh/1.2.0/libs/std/ast/ast_samples/parse.html
  - https://cj-docs.gitcode.com/zh/1.2.0/libs/std/ast/ast_package_overview.html
- Pydantic 2.10.3：约束字段、模型及JSON Schema；不证明业务语义。
  - https://docs.pydantic.dev/latest/
- Python SQLite：本地索引，不需要数据库服务器。
  - https://docs.python.org/3.11/library/sqlite3.html
- Account输入例子仅用于说明路径和材料类型，固定提交9b5b13e1dd02a026650f46185ab6a3ee093268d8；本阶段没有获取并运行样例。
  - https://github.com/goblin-zy/java-cangjie-test-bridge/tree/9b5b13e1dd02a026650f46185ab6a3ee093268d8

输入仓库、已有目标参考测试、原工具第三方依赖和本工具实现的角色分别记录。本文不授权发布第三方源码或二进制；分发时按各自许可证处理。

