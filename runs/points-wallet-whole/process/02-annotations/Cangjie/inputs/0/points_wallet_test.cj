package wallet

import std.unittest.*
import std.unittest.testmacro.*

@Test
class PointsWalletTest {
    private var wallet: ?PointsWallet = None

    private func newWallet(): PointsWallet {
        return PointsWallet(100i32)
    }

    private func setup(): Unit {
        wallet = Some(newWallet())
    }

    @TestCase
    func spendsPointsInOrder(): Unit {
        setup()
        let active = wallet.getOrThrow()
        @Assert(true, active.spend(30i32))
        @Assert(70i32, active.balance())
        @Assert(true, active.spend(20i32))
        @Assert(50i32, active.balance())
    }

    @TestCase
    func rejectsOverspending(): Unit {
        setup()
        let active = wallet.getOrThrow()
        @Assert(false, active.spend(150i32))
        @Assert(100i32, active.balance())
    }
}
