# 积分钱包样例

[Java 样例项目](points-wallet/README.md)保留了业务类和 JUnit 5 测试。先读 [PointsWalletTest.java](points-wallet/src/test/java/wallet/PointsWalletTest.java)，再对照 [PointsWallet.java](points-wallet/src/main/java/wallet/PointsWallet.java)。连续消费用例检查扣减顺序和剩余积分，超额消费用例还检查失败后余额是否保持。样例来自本地 Translation-all 钱包项目。

## 对照本轮输入

本轮检查整体翻译路线。在[第一阶段目录](../runs/points-wallet-whole/process/01-alignment)并排打开 `PointsWalletTest.java` 和 `points_wallet_test.cj`，即可看到实际参与比较的两份原文。`source_scope.json` 列出选定的源测试，`alignment.json` 的 `units` 给出对应方法及行号，`versions` 保存输入文件的 SHA-256。历史记录中的绝对路径用于标识当时的取材位置。

## 重新运行

阅读已有报告只需本分支。发起新验证还需要 Translation-all 的翻译结果目录，包括翻译配置、Java 骨架成员表、仓颉成员映射及所选路线的最终译文。钱包的结果目录是 `output/points-wallet-coverage`，Java 项目位于 `01-projects/points-wallet`。本轮没有提供目标业务接口约定。准备好上述材料后，按[运行说明](../src/README.md)指定本机路径。
