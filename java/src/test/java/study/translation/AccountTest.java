package study.translation;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.BeforeEach;
import static org.junit.jupiter.api.Assertions.*;

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
