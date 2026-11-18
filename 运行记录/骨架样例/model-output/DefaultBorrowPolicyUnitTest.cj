package week8_library

import std.unittest.*
import std.unittest.testmacro.*

@Test
class DefaultBorrowPolicyUnitTest {
    @TestCase
    func canBorrow_returnsFalse_whenMemberIsNull(): Unit {
        throw Exception("SKELETON_PLACEHOLDER: canBorrow_returnsFalse_whenMemberIsNull")
    }

    @TestCase
    func canBorrow_returnsFalse_whenMemberInactive(): Unit {
        throw Exception("SKELETON_PLACEHOLDER: canBorrow_returnsFalse_whenMemberInactive")
    }

    @TestCase
    func canBorrow_returnsFalse_whenActiveBorrowsEqualsMax(): Unit {
        throw Exception("SKELETON_PLACEHOLDER: canBorrow_returnsFalse_whenActiveBorrowsEqualsMax")
    }

    @TestCase
    func canBorrow_returnsTrue_whenActiveBorrowsLessThanMax_andNoOverdue_andMemberActive(): Unit {
        throw Exception("SKELETON_PLACEHOLDER: canBorrow_returnsTrue_whenActiveBorrowsLessThanMax_andNoOverdue_andMemberActive")
    }

    @TestCase
    func canBorrow_returnsFalse_whenHasOverdueTrue(): Unit {
        throw Exception("SKELETON_PLACEHOLDER: canBorrow_returnsFalse_whenHasOverdueTrue")
    }
}
