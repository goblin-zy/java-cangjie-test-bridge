# 在VS Code中运行统一Java项目

仓颉任务的完整点选流程、单个测试、预期输出及常见报错，参见[仓颉测试VS Code复现步骤](仓颉测试-VSCode复现步骤.md)。重点是先进入“任务：运行任务”，再在第二个选择框选择仓颉任务。

## 打开项目

选择“文件→打开文件夹”，打开本README所在的项目根目录，不要只打开单个.java。

安装Java扩展包（包括Java语言支持、Debugger for Java、Test Runner for Java和Maven for Java），并配置本机完整JDK17。发布配置使用VS Code识别的JDK，不绑定个人安装目录。

等待Java/Maven导入完成。若VS Code显示工作区信任提示，由使用者自行决定是否信任并启用项目；受限模式可能不提供测试按钮。

## 项目布局

```text
项目根目录/
  pom.xml
  .vscode/                    VS Code运行与测试配置
  src/main/java/
    JavaTestSkeletonExtractor.java
    study/translation/        Account、Rectangle、InstructionParser及异常类
  src/test/java/
    JavaTestSkeletonExtractorTest.java   6个提取器测试
    study/translation/                  24个业务测试
  generated/vscode-tests/     点击测试后自动产生的骨架和日志
```

第六周完整存档位于“蔡俊杰week6”分支；tests/fixtures和tests/invalid是提取器读取的测试数据，不作为项目源代码编译。故意非法的Broken.java不会影响正常构建。

## 点击运行JUnit测试

1. 打开src/test/java/JavaTestSkeletonExtractorTest.java。
2. 点击类名上方“Run Test／运行测试”运行6项，或点击某个方法旁绿色三角只运行这一项。
3. 也可以点击左侧烧杯图标“测试”，找到该测试类，运行类内全部测试。
4. 在测试结果面板查看通过／失败和断言信息。提取器测试输出的实际目录会写入测试输出，位于generated/vscode-tests/；每次使用独立目录，不覆盖之前结果。

6个提取器测试分别检查：目录提取27成员、单文件及初始化辅助方法、重载与构造委托等结构、中文与表情的逐字节回填、非法语法诊断、已有输出目录保护。

要运行业务测试，打开src/test/java/study/translation中的AccountTest、RectangleTest或InstructionParserTest，点击同样的Run Test。选择根项目运行全部测试时，预期合计30项：提取器6项＋业务24项。单项测试运行数量应为1，而不是30。

## 直接运行提取器main

左侧“运行和调试”中选择“提取业务测试骨架”，点击绿色运行按钮或按F5。弹窗中输入新的输出目录，如generated/vscode-run-001。程序从src/test/java/study/translation读取3个业务测试类，输出3个文件、27个成员；结果显示在调试控制台，无需终端输入命令。

若目录已存在且非空，请换成vscode-run-002。这是输出保护，不是提取失败。可编辑launch.json中的--input来处理其他Java文件／目录。

不要用“Run Code”通用插件代替Java的Run Test；测试入口由JUnit管理。骨架中的SKELETON_PLACEHOLDER仍只表示占位，不能当成业务测试通过。

## 找不到测试按钮时

- 确认打开了含根pom.xml的整个项目目录，并等Java导入完成。
- 确认Java扩展启用，项目运行JDK是完整JDK17。
- 命令面板可执行“Java: Import Java Projects in Workspace”重新导入，再刷新测试面板。
- 依赖首次导入需要网络。本项目JUnit固定5.13.4，Gson2.9.1仅用于提取器测试读取JSON，不是提取器运行依赖。

## 本次验收

同一套JUnit测试已通过Maven实际执行：30项通过，失败、错误、跳过均为0。GUI按钮点击验收尚未完成：当时VS Code窗口最小化，控制接口未能恢复。配置和测试代码已完成，使用者打开新项目并完成Java导入后即可从测试面板运行。原始报告见validation/vscode-java-002/。


## 仓颉语言服务器ENOENT

请将工作区设置CangjieSdkPath.CJNativeBackend改为本机实际SDK路径，确认其包含tools/bin/LSPServer.exe，并选择CJNative。VS Code命令面板执行Cangjie: reLaunch LSPServer使配置生效；Java JUnit测试与此语言服务相互独立。旧插件缺少内置LSP时会回退失败，配置有效SDK可避免使用这个缺失路径。


## 在VS Code点选运行仓颉参考测试

菜单“终端→运行任务”，选择“运行仓颉参考测试（24项）”。任务读取工作区的CangjieSdkPath.CJNativeBackend，自动加载SDK、编译和执行，无需手输命令。运行结果在下方任务终端；日志保存在新建的validation/reference-时间目录。正常结果TOTAL24、PASSED24、FAILED0、ERROR0、SKIPPED0。

本机以任务配置相同的Windows PowerShell进程入口实测24项通过，证据在validation/vscode-cangjie-task-001/。使用已披露的localfix运行库。任务直接调用cjc，不依赖LSP语言服务器是否成功启动。


## 只运行一个仓颉测试函数

Ctrl+Shift+P选择“任务:运行任务”，再选“运行单个仓颉测试”。弹窗填写测试类.方法，例如AccountTest.testWithdraw。输入RectangleTest.*可运行矩形类全部6项。区分大小写；名字错误会在编译前被拒绝。

取款单测已实测只执行1项：原生报告TOTAL24、PASSED1、SKIPPED23表示工程定义24项、其余23项被筛选掉，不代表全部执行。单项记录在validation/cangjie-filter-single-001/，类过滤在cangjie-filter-class-001/，全部回归在cangjie-filter-all-001/。JSON的filter_excluded记录筛选掉的项，skipped只统计被选中却跳过的项。

筛选控制执行哪些测试，编译阶段仍会编译这些测试所在的工程源码。普通业务函数需由对应测试函数调用；例如测试withdraw时选择AccountTest.testWithdraw。
