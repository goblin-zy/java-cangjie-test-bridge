# 任务3：Java真实运行记录

材料版本1.2.0，核对日期2026-10-20，时区Asia/Shanghai。记录由Codex本地工具实际执行并从JUnit XML生成，不冒充组员人工执行。Java Maven制品版本仍为1.0.0；材料版本与每阶段源码哈希共同标识本次代码。

环境：Windows11 25H2（26200.9711）x64；Microsoft OpenJDK17.0.13；Maven3.9.4；JUnit Jupiter5.13.4；Compiler3.11.0；Surefire3.5.3。每阶段environment.txt保留Maven/JDK原始输出，依赖固定配置在java/pom.xml。

## 三阶段汇总

|阶段|执行|通过|失败|错误|跳过|是否符合预期|
|---|---:|---:|---:|---:|---:|---|
|正常|24|24|0|0|0|是，BUILD SUCCESS|
|故意改错|24|20|4|0|0|是，4项业务断言失败，不是编译或环境错误|
|恢复|24|24|0|0|0|是，BUILD SUCCESS|

## V12-java-normal：正常运行

```text
Time: 2026-10-20T15:20:26.1526232+08:00
Runner: Codex local tools (AI-assisted execution)
Material version: 1.2.0
Command: mvn -B -ntp clean test
Working directory: C:\Users\14728\Documents\Codex\2026-10-19\xia\outputs\java-cangjie-starter/java
```

- 执行数／失败数／错误数／跳过数：24／0／0／0。
- 完整控制台输出：`validation/v1.2/java-normal/console.log`。
- JUnit XML和文本报告：`validation/v1.2/java-normal/reports/`。
- 环境信息：`validation/v1.2/java-normal/environment.txt`。
- 本阶段源文件SHA-256：`validation/v1.2/java-normal/source-sha256.json`。
- 各样例结果见下面逐项表及`validation/v1.2/results.json`。

## V12-java-mutant：故意改错运行

```text
Time: 2026-10-20T15:20:32.8226214+08:00
Runner: Codex local tools (AI-assisted execution)
Material version: 1.2.0
Command: mvn -B -ntp clean test
Working directory: C:\Users\14728\Documents\Codex\2026-10-19\xia\outputs\java-cangjie-starter/java
```

- 执行数／失败数／错误数／跳过数：24／4／0／0。
- 完整控制台输出：`validation/v1.2/java-mutant/console.log`。
- JUnit XML和文本报告：`validation/v1.2/java-mutant/reports/`。
- 环境信息：`validation/v1.2/java-mutant/environment.txt`。
- 本阶段源文件SHA-256：`validation/v1.2/java-mutant/source-sha256.json`。
- 各样例结果见下面逐项表及`validation/v1.2/results.json`。

## V12-java-restored：恢复后运行

```text
Time: 2026-10-20T15:20:40.0028528+08:00
Runner: Codex local tools (AI-assisted execution)
Material version: 1.2.0
Command: mvn -B -ntp clean test
Working directory: C:\Users\14728\Documents\Codex\2026-10-19\xia\outputs\java-cangjie-starter/java
```

- 执行数／失败数／错误数／跳过数：24／0／0／0。
- 完整控制台输出：`validation/v1.2/java-restored/console.log`。
- JUnit XML和文本报告：`validation/v1.2/java-restored/reports/`。
- 环境信息：`validation/v1.2/java-restored/environment.txt`。
- 本阶段源文件SHA-256：`validation/v1.2/java-restored/source-sha256.json`。
- 各样例结果见下面逐项表及`validation/v1.2/results.json`。

## 改错内容、失败断言与恢复

只将Account.withdraw中的`balance -= amount;`临时改成`balance += amount;`，模拟取款错误地增加余额。JUnit测试保持不变。错误版本以`validation/v1.2/mutation.patch`保留，不混入正常源码。

```diff
--- a/java/src/main/java/study/translation/Account.java
+++ b/java/src/main/java/study/translation/Account.java
@@ -22,6 +22,6 @@
     public void withdraw(int amount) {
         if (amount <= 0) throw new IllegalArgumentException("invalid withdrawal");
         if (amount > balance) throw new InsufficientFundsException("insufficient funds");
-        balance -= amount;
+        balance += amount;
     }
 }
```

|样例|实际失败信息|
|---|---|
|A03|expected: <70> but was: <130>|
|A04|expected: <0> but was: <200>|
|A05|expected: <130> but was: <170>|
|A06|expected: <60> but was: <140>|

A05的失败发生在辅助prepareSequence内第二次余额检查，说明辅助调用链中的断言也能发现错误。恢复操作在finally中执行；恢复后源码与正常阶段哈希一致，并且24项再次通过。其他20项未因这次特定改错失败，不代表测试无效。本周仅做一次明确改错，不开展完整变异测试研究。

## 24个样例逐项运行结果

|编号|测试方法|正常|故意改错|恢复|
|---|---|---|---|---|
|R01|testConstructor|通过|通过|通过|
|R02|testToString|通过|通过|通过|
|R03|testIntersection|通过|通过|通过|
|R04|testTouchingEdge|通过|通过|通过|
|R05|testPointRectangle|通过|通过|通过|
|R06|testInvalidCoordinates|通过|通过|通过|
|P01|testEmpty|通过|通过|通过|
|P02|testSpaces|通过|通过|通过|
|P03|testNamedInstructions|通过|通过|通过|
|P04|testSignedNumbers|通过|通过|通过|
|P05|testRepeatedSpaces|通过|通过|通过|
|P06|testInt32Boundaries|通过|通过|通过|
|P07|testInvalidTokens|通过|通过|通过|
|P08|testOutOfRange|通过|通过|通过|
|P09|testNullInput|通过|通过|通过|
|A01|testInitialBalance|通过|通过|通过|
|A02|testDeposit|通过|通过|通过|
|A03|testWithdraw|通过|断言失败|通过|
|A04|testWithdrawAll|通过|断言失败|通过|
|A05|testSequence|通过|断言失败|通过|
|A06|testInsufficientFunds|通过|断言失败|通过|
|A07|testInvalidAmounts|通过|通过|通过|
|A08|testBalanceLimit|通过|通过|通过|
|A09|testInvalidInitialBalance|通过|通过|通过|

## 其他问题与当前状态

本次Java三阶段没有编译错误、执行错误或跳过。历史仓颉启动问题见环境与本地修复说明；它不是Java改错检查的失败证据。仓颉本次localfix24项通过的日志单独保存于validation/v1.2/cangjie-localfix/。

## 复现

在材料包根目录PowerShell运行以下命令（会临时改错并恢复源码；OutputRoot应使用新的记录目录，以免覆盖旧证据）：

```powershell
.\scripts\verify-java.ps1 -JavaHome 'E:\jdk17' -OutputRoot 'validation/reproduce-001' -Runner '填写实际执行人' -MaterialVersion '1.2.0'
```
