# Java测试骨架提取器：最小运行包

来源：goblin-zy/java-cangjie-test-bridge，蔡俊杰week7，固定提交 6105b07bf4f48f183bae437e1c6dd6b5393985cd。

本包只提取Java骨架，不进行仓颉翻译。Java实现保持上游原文；运行脚本已合并为一个入口，自动使用共享环境中的JDK。

## 文件

- src/JavaTestSkeletonExtractor.java：完整提取器。
- 提取骨架.ps1：唯一运行入口，负责编译和执行。
- docs/骨架提取-使用说明与输出格式.md：上游格式说明；其中目录与命令属于原分支布局，本地运行以本README为准。
- LICENSE-third-party.txt：上游许可说明。

## 使用

在本文件所在目录打开PowerShell：

```powershell
.\提取骨架.ps1 -InputPath 'D:\你的项目\测试源码' -OutputDirectory 'D:\你的输出\第一次'
```

输入可以是单个.java文件或源码目录；输出须是输入目录以外的新目录或空目录。此命令由使用者自行执行，本次整理未运行提取。

执行时才会生成build（工具编译文件）以及指定输出中的original、skeleton、members.json、extraction-report.md。本包没有预建这些目录。

默认使用 ../../environment-config/tools/jdk-17；也可通过 -JavaHome 指定自己的JDK目录。不要求将输入源码放在固定目录。

## 范围

为保持运行包简洁，不包含上游业务样例、测试源码、验收输入或历史实验结果。原有6项自测依赖这些样例，不能只放入一个测试文件便声称可独立运行。若后续需要自测，应独立补充完整自测包。

骨架提取只依赖完整JDK17，不依赖JUnit、Maven或Gson；这些环境留在environment-config供后续框架使用。
