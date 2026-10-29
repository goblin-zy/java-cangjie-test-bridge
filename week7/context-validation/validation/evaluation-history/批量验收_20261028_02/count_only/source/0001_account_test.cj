package context_workflow_case

import std.unittest.*
import std.unittest.testmacro.*

@Test
class AccountTest {
    private var account: Account = Account(0)

    private func createAccount(): Account {
        return Account(100)
    }

    @BeforeEach
    func setup(): Unit {
        account = createAccount()
    }

    @TestCase
    func normalWithdrawal(): Unit {
        account.withdraw(30)
        @Assert(account.getBalance() == 70i32)
    }

    @TestCase
    func insufficientFunds(): Unit {
        @AssertThrows[IllegalArgumentException](account.withdraw(150))
        @Assert(account.getBalance() == 100i32)
    }
}
