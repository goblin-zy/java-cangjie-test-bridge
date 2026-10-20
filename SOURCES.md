# 来源、许可与样例边界

本包版本：1.2.0。初始整理日期：2026-10-19；更新日期：2026-10-20。代码与文档由 Codex 根据本次任务辅助整理，需由提交者阅读、复现并确认；不应写成独立人工编写或自动翻译实验成果。

## Rectangle：开源改编

- 来源仓库：https://github.com/microsoft/TransRepo
- 固定提交：a4825ba97cb2227773ec33c4c79a582d786ec639
- Java类：data/java_origin/double-dispatch/src/main/java/com/iluwatar/doubledispatch/Double-Dispatch/Rectangle.java
- 测试：data/java_origin/double-dispatch/src/test/java/com/iluwatar/doubledispatch/RectangleTest.java
- 原文件版权：Copyright © 2014-2022 Ilkka Seppälä；MIT。许可见 LICENSE-TransRepo.txt。
- 改编内容：改包名；展开 Lombok 构造方法和 getter；设为 final；相交判断直接读字段；增加坐标合法性检查；新增共享边、点矩形和非法坐标测试。
- R01—R03保留原测试主要输入和判断意图，但代码组织经过改编；R04—R06是新增测试。
- 因加入构造参数验证，本模块不是原项目的逐行为复刻。测试中的有效矩形仍沿用原相交规则。

## InstructionParser：新编教学样例

借鉴“文本指令转换成整数数组”这一通用题型，未直接复制 TransRepo 的 InstructionConverterUtil。
ZERO/INC/DEC 的映射和输入约定是本包自定；P01—P09全部为新编测试，不能标成 TransRepo 原始样例。

## Account：新编教学样例

为覆盖状态变化、初始化、辅助调用和失败后状态而设计；A01—A09全部为新编测试。
金额采用整数单位，余额上限1000000，不代表真实银行业务系统。

## 仓颉侧

三份仓颉业务实现和24个参考测试均为本次人工辅助迁移、整理的参考材料；不来自 TransRepo，也不是LLM翻译方法的评测输出。
仓颉SDK不随交付压缩包分发，运行需使用官方SDK。实际验证版本和结果见validation/运行记录.md。

新编部分可按MIT许可使用，Copyright (c) 2026 starter-dataset contributors；不覆盖第三方SDK与上游代码的独立许可。

## v1.1本地环境修复

仓颉SDK副本使用两处字节修正以绕过已定位的DLL链表头遍历错误。不是官方发布版或源码重建版本；原始、修复后哈希及复现脚本已披露。材料zip不包含SDK或修改后的运行库二进制。

## v1.2整理

重新按任务2、任务3补齐逐方法接口、具体断言、上下文、场景核对和三阶段真实记录；给13个业务及测试源码文件增加中文注释，检查有效代码词法序列未变。原有三个模块与24个测试方法保持不变。Maven制品版本1.0.0与材料版本1.2.0分别记录，使用源码哈希对应本次执行。
