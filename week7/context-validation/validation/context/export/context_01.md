# study.translation.AccountTest#testWithdraw()

负责人：蒋逸舟。选择与使用方案由人工/智能体提供；人工审核状态：PENDING

依赖完整性尚未证明；未分析资源；不包含仓颉参考答案。

## 使用方案

从独立初始化开始，保留取款30与余额70的检查。

## 导入

```java
org.junit.jupiter.api.Test
org.junit.jupiter.api.BeforeEach
static org.junit.jupiter.api.Assertions.*
```

## 完整原测试

### study.translation.AccountTest#testWithdraw()

上游标识：`study/translation/AccountTest.java::study.translation.AccountTest#testWithdraw()`

来源：[inputs/week7/src/test/java/study/translation/AccountTest.java](inputs/week7/src/test/java/study/translation/AccountTest.java)，行24—26。

选择理由：本轮完整待译测试

```java
@Test void testWithdraw() {
        account.withdraw(30); assertEquals(70, account.getBalance());
    }
```

## 完整所在测试类

### study.translation.AccountTest

上游标识：`study/translation/AccountTest.java::study.translation.AccountTest`

来源：[inputs/week7/src/test/java/study/translation/AccountTest.java](inputs/week7/src/test/java/study/translation/AccountTest.java)，行6—56。

选择理由：保留完整所在测试类，供人工核对准备和辅助方法

```java
class AccountTest {
    private Account account;
    // 每个测试前创建独立账户，避免前一测试的余额影响下一测试。
    @BeforeEach void setUp() { account = new Account(100); }
    // A05的辅助准备：存50、取20，并分别检查中间状态。
    private void prepareSequence() {
        account.deposit(50); assertEquals(150, account.getBalance());
        account.withdraw(20); assertEquals(130, account.getBalance());
    }
    // A01：检查普通初始余额及合法上下限。（新编样例）
    @Test void testInitialBalance() {
        assertEquals(0, new Account(0).getBalance()); assertEquals(100, account.getBalance()); assertEquals(1_000_000, new Account(1_000_000).getBalance());
    }
    // A02：存入30后余额应从100增加至130。（新编样例）
    @Test void testDeposit() {
        account.deposit(30); assertEquals(130, account.getBalance());
    }
    // A03：取出30后余额应从100减少至70。（新编样例）
    @Test void testWithdraw() {
        account.withdraw(30); assertEquals(70, account.getBalance());
    }
    // A04：允许恰好取完余额并得到0。（新编样例）
    @Test void testWithdrawAll() {
        account.withdraw(100); assertEquals(0, account.getBalance());
    }
    // A05：借助辅助方法检查连续操作的顺序和每步余额。（新编样例）
    @Test void testSequence() {
        prepareSequence(); account.withdraw(10); assertEquals(120, account.getBalance());
    }
    // A06：余额不足应抛专门异常，保留余额且允许后续合法取款。（新编样例）
    @Test void testInsufficientFunds() {
        assertThrows(InsufficientFundsException.class, () -> account.withdraw(101));
        assertEquals(100, account.getBalance()); account.withdraw(40); assertEquals(60, account.getBalance());
    }
    // A07：金额为0或负数时存取款均失败，余额不变。（新编样例）
    @Test void testInvalidAmounts() {
        for (int amount : new int[]{0, -1}) {
        assertThrows(IllegalArgumentException.class, () -> account.deposit(amount)); assertEquals(100, account.getBalance());
        assertThrows(IllegalArgumentException.class, () -> account.withdraw(amount)); assertEquals(100, account.getBalance());
        }
    }
    // A08：检查恰好达到余额上限与再次存款失败后的状态。（新编样例）
    @Test void testBalanceLimit() {
        account = new Account(999_999); account.deposit(1); assertEquals(1_000_000, account.getBalance());
        assertThrows(IllegalArgumentException.class, () -> account.deposit(1)); assertEquals(1_000_000, account.getBalance());
    }
    // A09：检查非法初始余额不能创建账户。（新编样例）
    @Test void testInvalidInitialBalance() {
        assertThrows(IllegalArgumentException.class, () -> new Account(-1)); assertThrows(IllegalArgumentException.class, () -> new Account(1_000_001));
    }
}
```

## 已选择上下文

### study.translation.AccountTest#field:account

上游标识：`study/translation/AccountTest.java::study.translation.AccountTest#field:account`

来源：[inputs/week7/src/test/java/study/translation/AccountTest.java](inputs/week7/src/test/java/study/translation/AccountTest.java)，行7—7。

选择理由：确认测试对象字段及其类型

```java
private Account account;
```

### study.translation.AccountTest#setUp()

上游标识：`study/translation/AccountTest.java::study.translation.AccountTest#setUp()`

来源：[inputs/week7/src/test/java/study/translation/AccountTest.java](inputs/week7/src/test/java/study/translation/AccountTest.java)，行9—9。

选择理由：确认@BeforeEach在每条测试前创建独立余额100的账户

```java
@BeforeEach void setUp() { account = new Account(100); }
```

### study.translation.Account#<init>(int)

上游标识：`Account.java::study.translation.Account#<init>(int)`

来源：[inputs/week7/src/main/java/study/translation/Account.java](inputs/week7/src/main/java/study/translation/Account.java)，行7—11。

选择理由：确认构造与初始余额约束

```java
public Account(int initialBalance) {
        if (initialBalance < 0 || initialBalance > MAX_BALANCE)
            throw new IllegalArgumentException("invalid balance");
        balance = initialBalance;
    }
```

### study.translation.Account#field:balance

上游标识：`Account.java::study.translation.Account#field:balance`

来源：[inputs/week7/src/main/java/study/translation/Account.java](inputs/week7/src/main/java/study/translation/Account.java)，行5—5。

选择理由：定位取款影响的状态字段

```java
private int balance;
```

### study.translation.Account#field:MAX_BALANCE

上游标识：`Account.java::study.translation.Account#field:MAX_BALANCE`

来源：[inputs/week7/src/main/java/study/translation/Account.java](inputs/week7/src/main/java/study/translation/Account.java)，行4—4。

选择理由：构造和存款条件使用余额上限常量

```java
public static final int MAX_BALANCE = 1_000_000;
```

### study.translation.Account#withdraw(int)

上游标识：`Account.java::study.translation.Account#withdraw(int)`

来源：[inputs/week7/src/main/java/study/translation/Account.java](inputs/week7/src/main/java/study/translation/Account.java)，行22—26。

选择理由：保留非法金额、余额不足和扣款顺序

```java
public void withdraw(int amount) {
        if (amount <= 0) throw new IllegalArgumentException("invalid withdrawal");
        if (amount > balance) throw new InsufficientFundsException("insufficient funds");
        balance -= amount;
    }
```

### study.translation.Account#getBalance()

上游标识：`Account.java::study.translation.Account#getBalance()`

来源：[inputs/week7/src/main/java/study/translation/Account.java](inputs/week7/src/main/java/study/translation/Account.java)，行13—13。

选择理由：确定断言实际观察的是余额查询结果

```java
public int getBalance() { return balance; }
```

### study.translation.InsufficientFundsException#<init>(String)

上游标识：`InsufficientFundsException.java::study.translation.InsufficientFundsException#<init>(String)`

来源：[inputs/week7/src/main/java/study/translation/InsufficientFundsException.java](inputs/week7/src/main/java/study/translation/InsufficientFundsException.java)，行4—4。

选择理由：确认专门余额不足异常与非法金额异常不同

```java
public InsufficientFundsException(String message) { super(message); }
```

## 未解决项

- JUnit注解和断言仅保留导入与调用，未展开框架实现。
- java.lang.IllegalArgumentException与RuntimeException等JDK定义未展开。
- 资源、继承生命周期、动态分派和外部依赖未做完整查找。

## 限制

- JDK parse only; no symbol attribution
- Dependencies must be selected by a human or agent
- Inherited lifecycle, resources and dynamic dispatch are not resolved
