# Java → 仓颉测试骨架翻译

本目录已同步蔡俊杰week8最新提交 dd2dd206ca66bc807d90ebbbfcd28dfb21b14cac（2026-11-04）。正式流程改为由模型依据提示词翻译，旧规则转换器及其PowerShell入口已移除。

## 内容

- prompts/骨架翻译提示词.md：以上述分支版本为基础，规定输入、材料选择、处理与输出；2026-11-05 本地修订了上下文字段说明，使其与当前 context-lookup 的 records 和 completeness 等实际输出一致。
- docs/上游生成与修订记录.md：从最新分支复制，说明旧样例与新版提示词的验证边界。
- source-version.json：本次同步版本、范围、备份位置和文件变化。

同级01-projects保存两个项目；Java骨架提取继续使用同级java-skeleton-extractor。按此前约定，本目录不保存validation、固定样例骨架、固定样例成员表、专用检查器及空业务类型声明。

## 怎样使用

先使用Java提取器得到skeleton/、members.json、extraction-report.md及原文副本。再准备任务范围、输出目录、包名、版本与修改约束，以及相关通用规则、项目公共材料和样例上下文。

向Agent说明：

> 请阅读本目录prompts/骨架翻译提示词.md，依据我提供的任务配置、Java提取结果和三类材料生成仓颉骨架。将产物保存到本次指定的新输出目录，缺失接口或转换依据时明确报告，不自行补造。

提供每份实际输入的路径；输出目录由本次任务明确指定，不默认写在工具目录内。正式输出包括.cj骨架、member_mapping.json、translation_report.json、实际执行的检查记录和交接说明。具体字段以新版提示词为准。

## 环境和验证状态

模型翻译入口不需要旧Python转换环境或第三方Python依赖。Java提取复用environment-config/tools/jdk-17；仓颉编译验证需要实际SDK、业务类型及依赖齐备，当前未为本模块安装SDK。

此次更新核对了项目及提示词与源码归档的字节一致性，未执行模型骨架翻译、仓颉编译或测试。上游既有候选由旧提示词生成，不能作为新版提示词已验收的证据。
