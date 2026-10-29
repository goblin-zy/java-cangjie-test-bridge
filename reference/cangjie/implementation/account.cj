package starter
public class InsufficientFundsException <: Exception {
    // 创建余额不足异常并将说明交给父类保存。
    public init(message: String) { super(message) }
}
public class Account {
    private var balance: Int64
    // 创建账户；初始余额限定在[0,1000000]，与Java侧约定一致。
    public init(initialBalance: Int64) {
        if (initialBalance < 0 || initialBalance > 1000000) {
            throw IllegalArgumentException("invalid balance")
        }
        balance = initialBalance
    }
    // 返回当前余额，不改变状态。
    public func getBalance(): Int64 { return balance }
    // 先检查金额为正且存入后不超上限，再增加余额；失败不修改余额。
    public func deposit(amount: Int64): Unit {
        if (amount <= 0 || amount > 1000000 - balance) {
            throw IllegalArgumentException("invalid deposit")
        }
        balance += amount
    }
    // 先检查金额和余额，再扣款；余额不足与非法金额使用不同异常。
    public func withdraw(amount: Int64): Unit {
        if (amount <= 0) { throw IllegalArgumentException("invalid withdrawal") }
        if (amount > balance) { throw InsufficientFundsException("insufficient funds") }
        balance -= amount
    }
}
