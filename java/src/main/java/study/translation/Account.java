package study.translation;
/** Integer currency units; balance is limited to 1,000,000. No floating point arithmetic. */
public final class Account {
    public static final int MAX_BALANCE = 1_000_000;
    private int balance;
    // 创建账户，初始余额必须在[0,1000000]内；金额使用整数单位，不进行浮点计算。
    public Account(int initialBalance) {
        if (initialBalance < 0 || initialBalance > MAX_BALANCE)
            throw new IllegalArgumentException("invalid balance");
        balance = initialBalance;
    }
    // 查询当前余额，不改变账户状态。
    public int getBalance() { return balance; }
    // 存入正整数金额且不能超过余额上限；先检查再更新，失败时余额保持不变。
    public void deposit(int amount) {
        // 先做减法形式的上限比较，避免先相加造成整数溢出。
        if (amount <= 0 || amount > MAX_BALANCE - balance)
            throw new IllegalArgumentException("invalid deposit");
        balance += amount;
    }
    // 取出正整数金额；余额不足时抛出专门异常，检查通过后才扣款。
    public void withdraw(int amount) {
        if (amount <= 0) throw new IllegalArgumentException("invalid withdrawal");
        if (amount > balance) throw new InsufficientFundsException("insufficient funds");
        balance -= amount;
    }
}
