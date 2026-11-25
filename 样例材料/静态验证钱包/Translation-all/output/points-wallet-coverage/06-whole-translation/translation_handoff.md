# 整体翻译交接

输入为同轮 Java 原文、仓颉骨架、公共材料、通用规则和 `04-test-context/PointsWalletTest/context_wallet.PointsWalletTest_53e40b49.json`。
逐测试查阅 `java-coverage/java_coverage.json` 的 `/tests/0` 和 `/tests/1`。两条均通过，均命中构造器、spend 和 balance。结合源码确认构造发生在共享准备阶段。消费顺序和预期余额从测试原文获取。
生成 `test/wallet/points_wallet_test.cj`，覆盖 2 条测试和共享辅助、准备方法。目标接口采用骨架中的暂定签名。目标接口核验、编译和运行均为 NOT_RUN。
