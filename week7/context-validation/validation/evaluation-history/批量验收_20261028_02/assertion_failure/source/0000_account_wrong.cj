package context_workflow_case

// Handwritten execution fixture for the supplied example, not model output.
class Account {
    private var balance: Int32

    public init(balance: Int32) {
        this.balance = balance
    }

    public func withdraw(amount: Int32): Unit {
        if (amount > balance) {
            throw IllegalArgumentException("Insufficient funds")
        }
        balance += amount
    }

    public func getBalance(): Int32 {
        return balance
    }
}
