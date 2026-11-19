# 积分钱包翻译框架试跑

从原始 Java 项目重新生成。Java 17、JUnit Console 1.13.4、JaCoCo 0.8.13。本轮未进行预处理。

- [Java 覆盖](java-coverage/java_coverage.json) 实际运行 2 条测试，均通过并获得覆盖。两条测试均运行钱包构造器、spend 和 balance。相同的方法覆盖对应不同的消费场景，具体行为仍由原测试断言判断。
- [整体译文](06-whole-translation/test/wallet/points_wallet_test.cj) 包含 2 条测试、6 条断言。覆盖使用见 [交接记录](06-whole-translation/translation_handoff.md)。
- [片段译文](07-fragment-translation/test/wallet/points_wallet_test.cj) 装配 4 个方法体，包含相同的测试范围。覆盖与静态材料的条目见 [取材记录](07-fragment-translation/review.json)。
- 两路已进行源码逐项核对。仓颉编译、运行及目标接口核验为 NOT_RUN，缺少目标业务实现和 SDK。项目公共材料为部分审查状态，暂定接口待确认。
