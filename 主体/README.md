# 使用说明

完整流程由 Agent 按[翻译流程](翻译流程.md)分步执行。程序、提示词、规则和配置示例按所属模块存放。准备 Python 3、完整 JDK 17 和原项目构建环境。逐测试覆盖还需 JUnit Console、JaCoCo agent 与 CLI。具体参数见 [Java 覆盖说明](java-coverage/README.md)。本机工具路径按实际安装位置填写。

**完整使用示例**　从分支根目录启动可访问本地文件的 Agent，给它以下指令：

> 依次执行 主体/翻译流程.md。以 主体 为 ROOT，样例材料/points-wallet 为 PROJECT，运行记录/wallet-new 为 OUT，先解析为本机绝对路径。执行整体和片段两路翻译，记录各阶段的实际执行状态。

每轮使用新的 OUT。第一步生成配置，后续工具读取其中的 test_files（Java 测试清单）等字段。查看 OUT/translation_summary.md 定位两路译文。历史配置中的绝对路径仅对应原机器。

**单独试用骨架提取**　在 Windows PowerShell 中从分支根目录运行，JAVA_HOME 指向完整 JDK：

```powershell
& './主体/java-skeleton-extractor/提取骨架.ps1' -JavaHome $env:JAVA_HOME -InputPath './样例材料/points-wallet/src/test/java/wallet/PointsWalletTest.java' -OutputDirectory './运行记录/wallet-skeleton-new'
```

输出中的 original 和 skeleton 分别存原文和骨架，members.json 用成员标识关联原方法体，extraction-report.md 记录诊断。
