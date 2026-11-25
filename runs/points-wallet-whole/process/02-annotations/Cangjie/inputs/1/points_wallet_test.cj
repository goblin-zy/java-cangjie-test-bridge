package wallet

import std.unittest.*
import std.unittest.testmacro.*

@Test
class PointsWalletTest {
    private var wallet: ?PointsWallet = None

    private func newWallet(): PointsWallet {
        /* FRAGMENT_BEGIN:T01 */
        throw Exception("SKELETON_PLACEHOLDER")
        /* FRAGMENT_END:T01 */
    }

    private func setup(): Unit {
        /* FRAGMENT_BEGIN:T02 */
        throw Exception("SKELETON_PLACEHOLDER")
        /* FRAGMENT_END:T02 */
    }

    @TestCase
    func spendsPointsInOrder(): Unit {
        /* FRAGMENT_BEGIN:T03 */
        throw Exception("SKELETON_PLACEHOLDER")
        /* FRAGMENT_END:T03 */
    }

    @TestCase
    func rejectsOverspending(): Unit {
        /* FRAGMENT_BEGIN:T04 */
        throw Exception("SKELETON_PLACEHOLDER")
        /* FRAGMENT_END:T04 */
    }
}
