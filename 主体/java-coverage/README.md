# Java 测试逐方法覆盖采集

Agent 准备配置并执行 `python coverage_tool.py --config <配置绝对路径>`。Python 使用标准库，测试由 JUnit Console 执行，JaCoCo 0.8.13 采集并生成报告。两份 JaCoCo JAR 位于项目共享环境 `environment-config/tools/jacoco/`。

## 输入

配置 JSON 中所有路径使用绝对路径。

| 字段 | 内容 |
|---|---|
| project_root | 原 Java 工程目录，作为运行工作目录。 |
| output_dir | 工程外的新结果目录，建议本轮 OUT/java-coverage。 |
| java、junit_jar、agent_jar、cli_jar | Java、JUnit 与两个 JaCoCo 文件的实际位置。 |
| business_classes | 本次业务 class 目录列表，排除测试类。 |
| classpath | 运行测试所需业务、测试 class、依赖和资源路径列表。 |
| tests | JUnit 方法选择器列表，例如 wallet.PointsWalletTest#rejectsOverspending。 |
| build_commands | 可选的编译命令列表，每条命令为字符串参数数组，脚本依次执行。 |
| timeout_seconds | 单个命令超时，默认 120 秒。 |

Agent 从 Java 成员表获取普通 JUnit 测试，结合实际导入与构建配置核对。按项目本身方式准备编译产物和运行依赖，解析助手的 class 不能当成业务 class。缺少环境或编译失败时记录原因。第一版只接受每次选择实际执行一个用例的测试，参数化、多次重复或零用例结果保存为未采集，Agent 按报告说明处理。

## 输出与含义

`java_coverage.json` 是下游直接读取的汇总。tests 数组每项含完整选择器、JUnit 结果、实际执行用例数、采集状态和业务方法列表。方法用类名、方法名和 JVM descriptor 区分重载，line 是报告给出的源行。evidence 指向该条测试的子目录，内含 test.log、JUnit XML、coverage.exec、coverage.xml、report.log。class_hashes 固定所用字节码版本。

覆盖包含本次测试运行中的类初始化、准备、测试体和清理。方法列表没有调用次序或调用边信息。通过测试与采集成功分别记录。断言失败且进程正常结束时仍可得到失败前的覆盖。超时、异常退出、空测试、类文件不匹配等状态须核对原因。脚本退出成功只表示完成采集尝试，下游继续读取汇总中的 status。

## 在翻译中使用

两路 Agent 都按完整测试标识阅读原样例上下文和覆盖记录。已有定义直接引用，新增方法回原项目核对相关性，原文中尚未执行的逻辑仍按源测试保留。覆盖记录不能确定某个调用表达式究竟绑定到哪个运行方法。片段取材可直接通过 review.json 引用汇总的 /tests/序号，业务定义仍是参考。
