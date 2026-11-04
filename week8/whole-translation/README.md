# 第八周：整体翻译提示词

本交付对应《第八周.md》的整体翻译路线：在已有仓颉骨架中，按完整测试类填充Java测试逻辑。只提供可直接交给Agent执行的任务与输入输出约定，不提前承担骨架翻译或片段路线。

## 使用

1. 在 GitHub 工作区根目录执行 `python week8/whole-translation/fetch_inputs.py`。脚本按 [固定提交清单](github_inputs.json) 将依赖下载到 `.deps/`，并核对所需文件。
2. 示例配置中的骨架、源码、映射、规则及工具均可按工作区相对路径找到。项目材料及真实目标业务由本轮任务提供，缺项会阻断翻译。
3. 填写或沿用本次translation_config.json。示例仅供格式参考，不能直接作为真实配置运行；已有路径无需重复填写。
4. 将以下任务交给Agent：

> 请阅读本目录translate_whole.md，使用“实际translation_config.json路径”执行整体测试翻译。直接读取材料并保存产物；输入不足时按规定报告受阻项，不自行生成业务替代实现。

Agent负责读取、上下文补查、整体填充及结果保存。无需另接模型API，也不要求使用者手动维护成员片段选择清单。

## 文件

- [translate_whole.md](translate_whole.md)：可独立使用的完整提示词，包含输入、已有工具接口、翻译约束、固定输出与完成判定。
- [translation_config.example.json](translation_config.example.json)：路径与范围模板，是本任务约定，不声称现有程序已实现解析器。
- [接口核对与现有样例说明](接口核对与现有样例说明.md)：已核对的代码库版本、字段差异及阻断风险。

任务文档中建议的文件名沿用其含义；translation_result.json、input_manifest.json和checks.json是由本次Agent任务生成的结果记录，不要求先制作。

本交付未实际生成仓颉译文或执行翻译效果评测。需要真实目标接口、规则和项目材料后才能开展一次完整执行。
