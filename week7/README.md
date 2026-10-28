# week7：统一Java项目与参考仓颉测试

版本1.1.0 · 2026-10-27。Java骨架提取器、原有业务类和全部Java测试已放在同一个标准Maven项目中，支持VS Code测试面板及Run Test按钮，无需手工输入PowerShell命令。

**从这里开始：[VS Code运行说明](docs/VSCode运行说明.md)。**

仓颉全部、单项、按类运行及“搜不到任务”的处理，见[仓颉测试VS Code复现步骤](docs/仓颉测试-VSCode复现步骤.md)。

## 在VS Code中运行

1. “文件→打开文件夹”，选择本README所在的week7-skeleton-reference目录。
2. 等待Java/Maven导入完成。
3. 打开src/test/java/JavaTestSkeletonExtractorTest.java，点击类名上方Run Test运行提取器6项测试。
4. 打开src/test/java/study/translation中的三个测试类，点击同样按钮运行业务测试。
5. 或在左侧烧杯“测试”面板运行根项目全部测试，合计30项（提取器6＋业务24）。

普通业务类与提取器在src/main/java；测试在src/test/java。main的F5运行配置也已提供，详见运行说明。

## 材料与实现

- [骨架提取使用说明与格式](docs/骨架提取-使用说明与输出格式.md)
- [骨架提取实际核对记录](docs/骨架提取-实际核对记录.md)
- [参考仓颉测试逐项核对](docs/参考仓颉测试-说明与逐项核对.md)
- [参考测试运行及错误检测](docs/参考测试-运行与检查能力.md)
- [交付核对与已知限制](docs/交付核对与已知限制.md)
- 核心提取器：src/main/java/JavaTestSkeletonExtractor.java（JDK语法树，运行无需额外库）。
- 提取器JUnit测试：src/test/java/JavaTestSkeletonExtractorTest.java。
- 实际骨架和成员表：generated/week6-tests/；点击测试产生的临时结果：generated/vscode-tests/。
- 参考仓颉业务与测试：reference/cangjie/；24个场景：reference/cases.json。

当前工具、JUnit和编译插件配置均在根pom.xml；请在本机安装并配置JDK17。仓颉SDK路径需修改.vscode/settings.json中的CangjieSdkPath.CJNativeBackend。examples/week6/java为原基线存档，不作为第二个VS Code项目导入；tests/invalid是故意非法的解析负例，不会加入正常Java构建。

参考仓颉24项及四个有针对性错误实现的结果保留在validation中；仓颉使用已披露的1.2.0本地修复运行库localfix，不能写成原版SDK通过。范围、来源与许可见SOURCES.md和相关说明。

本目录为蔡俊杰第七周交付，飞书汇报材料见 docs/飞书汇报材料/。


仓颉参考测试入口：VS Code菜单“终端→运行任务→运行仓颉参考测试（24项）”。任务已配置，采用相同进程入口实测24项通过，详见VSCode运行说明。
