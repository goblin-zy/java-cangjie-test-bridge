# 积分钱包

一个用于验证 Java 测试翻译流程的独立小项目。钱包从给定余额开始，消费时扣除积分，积分不足时返回 false 并保持余额。

Java 源码在 `src/main/java`，JUnit 5 测试在 `src/test/java`。目标测试沿用包名 `wallet`，暂定业务接口为 `PointsWallet(Int32)`、`spend(Int32): Bool` 和 `balance(): Int32`。目标业务实现由接收方提供。
