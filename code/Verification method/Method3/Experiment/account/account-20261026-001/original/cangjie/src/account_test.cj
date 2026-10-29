package starter
import std.unittest.*
import std.unittest.testmacro.*

@Test
class AccountTest {
    // A05的辅助准备：保留与Java侧相同的操作顺序和中间断言。
    private func prepareSequence(account: Account): Unit {
        account.deposit(50)
        @Expect(account.getBalance(), 150)
        account.withdraw(20)
        @Expect(account.getBalance(), 130)
    }
    // A01：检查普通初始余额及合法上下限。（新编样例）
    @TestCase
    func testInitialBalance(): Unit {
        var account = Account(100)
        @Expect(Account(0).getBalance(), 0)
        @Expect(account.getBalance(), 100)
        @Expect(Account(1000000).getBalance(), 1000000)
    }
    // A02：存入30后余额应从100增加至130。（新编样例）
    @TestCase
    func testDeposit(): Unit {
        var account = Account(100)
        account.deposit(30)
        @Expect(account.getBalance(), 130)
    }
    // A03：取出30后余额应从100减少至70。（新编样例）
    @TestCase
    func testWithdraw(): Unit {
        var account = Account(100)
        account.withdraw(30)
        @Expect(account.getBalance(), 70)
    }
    // A04：允许恰好取完余额并得到0。（新编样例）
    @TestCase
    func testWithdrawAll(): Unit {
        var account = Account(100)
        account.withdraw(100)
        @Expect(account.getBalance(), 0)
    }
    // A05：借助辅助方法检查连续操作的顺序和每步余额。（新编样例）
    @TestCase
    func testSequence(): Unit {
        var account = Account(100)
        prepareSequence(account)
        account.withdraw(10)
        @Expect(account.getBalance(), 120)
    }
    // A06：余额不足应抛专门异常，保留余额且允许后续合法取款。（新编样例）
    @TestCase
    func testInsufficientFunds(): Unit {
        var account = Account(100)
        var caught = false
        try { account.withdraw(101) } catch (_: InsufficientFundsException) { caught = true }
        @Expect(caught, true)
        @Expect(account.getBalance(), 100)
        account.withdraw(40)
        @Expect(account.getBalance(), 60)
    }
    // A07：金额为0或负数时存取款均失败，余额不变。（新编样例）
    @TestCase
    func testInvalidAmounts(): Unit {
        var account = Account(100)
        for (amount in [0, -1]) {
        var depositCaught = false
        try { account.deposit(amount) } catch (_: IllegalArgumentException) { depositCaught = true }
        @Expect(depositCaught, true)
        @Expect(account.getBalance(), 100)
        var withdrawCaught = false
        try { account.withdraw(amount) } catch (_: IllegalArgumentException) { withdrawCaught = true }
        @Expect(withdrawCaught, true)
        @Expect(account.getBalance(), 100)
        }
    }
    // A08：检查恰好达到余额上限与再次存款失败后的状态。（新编样例）
    @TestCase
    func testBalanceLimit(): Unit {
        var account = Account(100)
        account = Account(999999)
        account.deposit(1)
        @Expect(account.getBalance(), 1000000)
        var caught = false
        try { account.deposit(1) } catch (_: IllegalArgumentException) { caught = true }
        @Expect(caught, true)
        @Expect(account.getBalance(), 1000000)
    }
    // A09：检查非法初始余额不能创建账户。（新编样例）
    @TestCase
    func testInvalidInitialBalance(): Unit {
        for (initial in [-1, 1000001]) {
        var caught = false
        try { Account(initial) } catch (_: IllegalArgumentException) { caught = true }
        @Expect(caught, true)
        }
    }
}
