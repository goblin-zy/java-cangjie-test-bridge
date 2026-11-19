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
let prepared = wallet.getOrThrow()
@Assert(true, prepared.spend(30i32))
@Assert(70i32, prepared.balance())
@Assert(true, prepared.spend(20i32))
@Assert(50i32, prepared.balance())
    }

    @TestCase
    func rejectsOverspending(): Unit {
        setup()
let prepared = wallet.getOrThrow()
@Assert(false, prepared.spend(150i32))
@Assert(100i32, prepared.balance())
    }
}
