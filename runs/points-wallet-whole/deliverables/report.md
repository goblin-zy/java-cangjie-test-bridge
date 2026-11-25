# 测试翻译静态验证报告

本轮采用 points-wallet 的整体译文。选定的两个 Java 测试都在仓颉最终源码中找到了对应方法，六条断言均已对照到具体调用。源码可见的准备、调用顺序、对象和判断条件相符；两个单元的综合结论均为**信息不足**，原因是目标业务接口仍属暂定。

### spendsPointsInOrder · 连续消费

每条测试从构造参数 100 开始。Java 通过 `@BeforeEach` 初始化钱包；仓颉在方法开头调用 `setup()`，随即从刚赋值的字段取出钱包。两侧都对这个钱包执行同一序列：消费 30 并要求返回真，查余额并要求等于 70，再消费 20 并要求返回真，最后查余额并要求等于 50。四条断言逐项对应 J06–J09 和 C10–C13。

### rejectsOverspending · 超额消费

在各自新建的钱包上消费 150，两侧都先要求返回假，再要求原钱包的余额仍等于 100。后一条断言保留了这个场景的重要条件：即使调用报告失败，状态被错误改变也应触发检查。两条断言对应 J11–J12 和 C17–C18。

### 依据与未知项

Java 的 `PointsWallet.java` 给出了扣减与返回值的实现；仓颉译文只给出了调用及期望。骨架交接 `handoff.md` 也将目标业务接口记为暂定。名称和数字对应，仍无法独立确认构造参数、消费单位、真假返回值和余额查询在目标业务中的约定。两个单元都保留这一项未知，当前没有发现能由两侧源码直接确认的翻译差异。

清点以 Java 源清单为准，两条都已比较。两条仓颉测试均在首次读取钱包前完成准备，已有证据足以解释初始化，无需另开类级回查。本轮只进行了静态验证，编译、测试执行以及错误检出能力均未验证。

## 范围与结果索引

路线 `whole`，选定 2 项，完成比较 2 项。
目标接口约定状态 `missing`。版本指纹见 [结构化报告](report.json) 的 versions。

- U01 · spendsPointsInOrder · 信息不足
- U02 · rejectsOverspending · 信息不足

## 原文证据

行号指向交付包中带注释的源码。

- java/J05 · [PointsWalletTest.java 第 56–57 行](PointsWalletTest.java#L56)
- cangjie/C02 · [points_wallet_test.cj 第 17–18 行](points_wallet_test.cj#L17)
- cangjie/C03 · [points_wallet_test.cj 第 27–28 行](points_wallet_test.cj#L27)
- cangjie/C07 · [points_wallet_test.cj 第 67–68 行](points_wallet_test.cj#L67)
- java/J01 · [PointsWalletTest.java 第 17–17 行](PointsWalletTest.java#L17)
- java/J02 · [PointsWalletTest.java 第 26–28 行](PointsWalletTest.java#L26)
- java/J03 · [PointsWalletTest.java 第 37–38 行](PointsWalletTest.java#L37)
- java/J04 · [PointsWalletTest.java 第 46–46 行](PointsWalletTest.java#L46)
- cangjie/C04 · [points_wallet_test.cj 第 36–36 行](points_wallet_test.cj#L36)
- cangjie/C05 · [points_wallet_test.cj 第 45–47 行](points_wallet_test.cj#L45)
- cangjie/C06 · [points_wallet_test.cj 第 56–58 行](points_wallet_test.cj#L56)
- cangjie/C08 · [points_wallet_test.cj 第 76–76 行](points_wallet_test.cj#L76)
- cangjie/C09 · [points_wallet_test.cj 第 84–84 行](points_wallet_test.cj#L84)
- java/J06 · [PointsWalletTest.java 第 65–65 行](PointsWalletTest.java#L65)
- cangjie/C10 · [points_wallet_test.cj 第 92–92 行](points_wallet_test.cj#L92)
- java/J07 · [PointsWalletTest.java 第 73–73 行](PointsWalletTest.java#L73)
- cangjie/C11 · [points_wallet_test.cj 第 100–100 行](points_wallet_test.cj#L100)
- java/J08 · [PointsWalletTest.java 第 81–81 行](PointsWalletTest.java#L81)
- cangjie/C12 · [points_wallet_test.cj 第 108–108 行](points_wallet_test.cj#L108)
- java/J09 · [PointsWalletTest.java 第 89–89 行](PointsWalletTest.java#L89)
- cangjie/C13 · [points_wallet_test.cj 第 116–116 行](points_wallet_test.cj#L116)
- java/J10 · [PointsWalletTest.java 第 99–100 行](PointsWalletTest.java#L99)
- cangjie/C14 · [points_wallet_test.cj 第 126–127 行](points_wallet_test.cj#L126)
- cangjie/C15 · [points_wallet_test.cj 第 135–135 行](points_wallet_test.cj#L135)
- cangjie/C16 · [points_wallet_test.cj 第 143–143 行](points_wallet_test.cj#L143)
- java/J11 · [PointsWalletTest.java 第 108–108 行](PointsWalletTest.java#L108)
- cangjie/C17 · [points_wallet_test.cj 第 151–151 行](points_wallet_test.cj#L151)
- java/J12 · [PointsWalletTest.java 第 116–116 行](PointsWalletTest.java#L116)
- cangjie/C18 · [points_wallet_test.cj 第 159–159 行](points_wallet_test.cj#L159)
