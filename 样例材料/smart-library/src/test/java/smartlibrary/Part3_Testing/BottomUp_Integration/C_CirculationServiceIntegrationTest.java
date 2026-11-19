package smartlibrary.Part3_Testing.BottomUp_Integration;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import smartlibrary.model.*;
import smartlibrary.notification.impl.StubAlertService;
import smartlibrary.policy.impl.DefaultBorrowPolicy;
import smartlibrary.policy.impl.DefaultPenaltyPolicy;
import smartlibrary.service.impl.DefaultCirculationService;
import smartlibrary.storage.memory.MemoryBorrowStorage;
import smartlibrary.storage.memory.MemoryItemStorage;
import smartlibrary.storage.memory.MemoryMemberStorage;

import java.time.LocalDate;

import static org.junit.jupiter.api.Assertions.*;

/// VIOLA ZENELI (first half)
/// SIDRIT RRUSTEMI (second half)

// CirculationService integration (real storages + policies + stub alert)

// Integration level C:
// - Memory storages are already tested (level A)
// - Policies are already tested (level B)
// - Here we test how CirculationService integrates ALL of them together

class C_CirculationServiceIntegrationTest {

    private MemoryItemStorage itemStorage;
    private MemoryMemberStorage memberStorage;
    private MemoryBorrowStorage borrowStorage;
    private StubAlertService alertService;

    private DefaultCirculationService circulationService;

    @BeforeEach
    void setup() {
        // Real storages (already validated in level A)
        itemStorage = new MemoryItemStorage();
        memberStorage = new MemoryMemberStorage();
        borrowStorage = new MemoryBorrowStorage();

        // Stub alert service to observe side effects
        alertService = new StubAlertService();

        // Real policies (already validated in level B)
        circulationService = new DefaultCirculationService(
                itemStorage,
                memberStorage,
                borrowStorage,
                new DefaultBorrowPolicy(),
                new DefaultPenaltyPolicy(),
                alertService
        );
    }


    /// VIOLA ZENELI (16 tests)

    // requestBorrow()

    @Test
    void requestBorrow_happyPath_savesRecord_andMarksItemUnavailable() {
        memberStorage.save(new Member(1, true, MembershipType.STUDENT));
        itemStorage.save(new LibraryItem("BOOK1", true));

        circulationService.requestBorrow(1, "BOOK1");

        assertFalse(itemStorage.find("BOOK1").isAvailable());
        assertNotNull(borrowStorage.findActiveBorrow("BOOK1"));
    }

    @Test
    void requestBorrow_whenMemberNotFound_throwsIllegalStateException() {
        itemStorage.save(new LibraryItem("BOOK1", true));

        assertThrows(IllegalStateException.class, () -> circulationService.requestBorrow(1, "BOOK1"));
    }

    @Test
    void requestBorrow_whenItemNotFound_throwsIllegalStateException() {
        memberStorage.save(new Member(1, true, MembershipType.STUDENT));

        assertThrows(IllegalStateException.class, () -> circulationService.requestBorrow(1, "BOOK1"));
    }

    @Test
    void requestBorrow_whenItemNotAvailable_throwsIllegalStateException() {
        memberStorage.save(new Member(1, true, MembershipType.STUDENT));
        itemStorage.save(new LibraryItem("BOOK1", false));

        assertThrows(IllegalStateException.class, () -> circulationService.requestBorrow(1, "BOOK1"));
    }

    @Test
    void requestBorrow_whenBorrowPolicyRejects_dueToInactiveMember_throwsIllegalStateException() {
        memberStorage.save(new Member(1, false, MembershipType.STUDENT));
        itemStorage.save(new LibraryItem("BOOK1", true));

        assertThrows(IllegalStateException.class, () -> circulationService.requestBorrow(1, "BOOK1"));
    }

    @Test
    void requestBorrow_whenBorrowPolicyRejects_dueToLimitReached_throwsIllegalStateException() {
        memberStorage.save(new Member(1, true, MembershipType.GUEST));
        itemStorage.save(new LibraryItem("BOOK1", true));
        itemStorage.save(new LibraryItem("BOOK2", true));

        circulationService.requestBorrow(1, "BOOK1");

        assertThrows(IllegalStateException.class, () -> circulationService.requestBorrow(1, "BOOK2"));
    }

    @Test
    void requestBorrow_whenBorrowPolicyRejects_dueToOverdue_throwsIllegalStateException() {
        memberStorage.save(new Member(1, true, MembershipType.STUDENT));
        itemStorage.save(new LibraryItem("BOOK1", true));
        itemStorage.save(new LibraryItem("BOOK2", true));

        // Create overdue borrow manually
        borrowStorage.save(new BorrowRecord(1, "BOOK1", LocalDate.now().minusDays(5)));

        assertThrows(IllegalStateException.class, () -> circulationService.requestBorrow(1, "BOOK2"));
    }


    // returnItem()

    @Test
    void returnItem_happyPath_marksReturned_andMarksItemAvailable() {
        memberStorage.save(new Member(1, true, MembershipType.STUDENT));
        itemStorage.save(new LibraryItem("BOOK1", true));

        circulationService.requestBorrow(1, "BOOK1");
        circulationService.returnItem("BOOK1");

        assertTrue(itemStorage.find("BOOK1").isAvailable());
        assertTrue(borrowStorage.findAll().get(0).isReturned());
    }

    @Test
    void returnItem_whenOverdue_sendsAlert() {
        memberStorage.save(new Member(1, true, MembershipType.STUDENT));
        itemStorage.save(new LibraryItem("BOOK1", true));

        borrowStorage.save(new BorrowRecord(1, "BOOK1", LocalDate.now().minusDays(3)));

        circulationService.returnItem("BOOK1");

        assertEquals(1, alertService.getLastMemberId());
        assertNotNull(alertService.getLastMessage());
    }

    @Test
    void returnItem_whenNotOverdue_doesNotSendAlert() {
        memberStorage.save(new Member(1, true, MembershipType.STUDENT));
        itemStorage.save(new LibraryItem("BOOK1", true));

        circulationService.requestBorrow(1, "BOOK1");
        circulationService.returnItem("BOOK1");

        assertNull(alertService.getLastMessage());
    }


    // canBorrowMore()

    @Test
    void canBorrowMore_whenUnderLimit_returnsTrue() {
        memberStorage.save(new Member(1, true, MembershipType.STUDENT));

        assertTrue(circulationService.canBorrowMore(1));
    }

    @Test
    void canBorrowMore_whenAtLimit_returnsFalse() {
        memberStorage.save(new Member(1, true, MembershipType.GUEST));
        itemStorage.save(new LibraryItem("BOOK1", true));

        circulationService.requestBorrow(1, "BOOK1");

        assertFalse(circulationService.canBorrowMore(1));
    }


    // Multi-member scenarios

    @Test
    void multipleMembersCanBorrowDifferentItems_simultaneously() {
        memberStorage.save(new Member(1, true, MembershipType.STUDENT));
        memberStorage.save(new Member(2, true, MembershipType.STUDENT));

        itemStorage.save(new LibraryItem("BOOK1", true));
        itemStorage.save(new LibraryItem("BOOK2", true));

        circulationService.requestBorrow(1, "BOOK1");
        circulationService.requestBorrow(2, "BOOK2");

        assertNotNull(borrowStorage.findActiveBorrow("BOOK1"));
        assertNotNull(borrowStorage.findActiveBorrow("BOOK2"));
    }

    @Test
    void sameMember_cannotBorrowSameItemTwice() {
        memberStorage.save(new Member(1, true, MembershipType.STUDENT));
        itemStorage.save(new LibraryItem("BOOK1", true));

        circulationService.requestBorrow(1, "BOOK1");

        assertThrows(IllegalStateException.class, () -> circulationService.requestBorrow(1, "BOOK1"));
    }


    // Borrowing lifecycle

    @Test
    void borrowReturnBorrowAgain_sameItem_worksCorrectly() {
        memberStorage.save(new Member(1, true, MembershipType.STUDENT));
        itemStorage.save(new LibraryItem("BOOK1", true));

        circulationService.requestBorrow(1, "BOOK1");
        circulationService.returnItem("BOOK1");
        circulationService.requestBorrow(1, "BOOK1");

        assertFalse(itemStorage.find("BOOK1").isAvailable());
    }

    @Test
    void borrowMultipleItems_respectsCapacity() {
        memberStorage.save(new Member(1, true, MembershipType.GUEST));
        itemStorage.save(new LibraryItem("BOOK1", true));
        itemStorage.save(new LibraryItem("BOOK2", true));

        circulationService.requestBorrow(1, "BOOK1");

        assertThrows(IllegalStateException.class, () -> circulationService.requestBorrow(1, "BOOK2"));
    }


    //===========================================================================================


    /// SIDRIT RRUSTEMI (16 tests)

    // Fine calculation integration
    @Test
    void calculateFine_usesRealPenaltyPolicy_withOverdueRecord() {
        memberStorage.save(new Member(1, true, MembershipType.STUDENT));
        itemStorage.save(new LibraryItem("BOOK1", true));

        // Create overdue borrow (3 days overdue)
        borrowStorage.save(new BorrowRecord(1, "BOOK1", LocalDate.now().minusDays(3)));

        double fine = circulationService.calculateFine("BOOK1");

        // DefaultPenaltyPolicy: 3 days * $1.0 = $3.0 (within grace period)
        assertEquals(3.0, fine, 0.01);
    }

    @Test
    void calculateFine_returns0_whenNotOverdue() {
        memberStorage.save(new Member(1, true, MembershipType.STUDENT));
        itemStorage.save(new LibraryItem("BOOK1", true));

        // Create borrow due tomorrow
        borrowStorage.save(new BorrowRecord(1, "BOOK1", LocalDate.now().plusDays(1)));

        double fine = circulationService.calculateFine("BOOK1");

        assertEquals(0.0, fine, 0.01);
    }

    // New methods integration
    @Test
    void getRemainingBorrowCapacity_decreasesAfterBorrow_increasesAfterReturn() {
        memberStorage.save(new Member(1, true, MembershipType.STUDENT));
        itemStorage.save(new LibraryItem("BOOK1", true));

        // STUDENT has max 3 loans
        assertEquals(3, circulationService.getRemainingBorrowCapacity(1));

        circulationService.requestBorrow(1, "BOOK1");
        assertEquals(2, circulationService.getRemainingBorrowCapacity(1));

        circulationService.returnItem("BOOK1");
        assertEquals(3, circulationService.getRemainingBorrowCapacity(1));
    }

    @Test
    void validateMemberStatus_reflectsRealStorageState() {
        memberStorage.save(new Member(1, true, MembershipType.STUDENT));

        assertEquals("ACTIVE_GOOD_STANDING", circulationService.validateMemberStatus(1));

        itemStorage.save(new LibraryItem("BOOK1", true));
        circulationService.requestBorrow(1, "BOOK1");

        // Still active, no overdue
        assertEquals("ACTIVE_GOOD_STANDING", circulationService.validateMemberStatus(1));

        // Create overdue borrow
        borrowStorage.save(new BorrowRecord(1, "BOOK2", LocalDate.now().minusDays(5)));

        assertEquals("OVERDUE_ITEMS", circulationService.validateMemberStatus(1));
    }

    @Test
    void canRenewBorrow_checksRealOverdueStatus() {
        memberStorage.save(new Member(1, true, MembershipType.STUDENT));
        itemStorage.save(new LibraryItem("BOOK1", true));

        circulationService.requestBorrow(1, "BOOK1");

        // Not overdue, can renew
        assertTrue(circulationService.canRenewBorrow(1, "BOOK1"));

        // Make it overdue by creating overdue record
        borrowStorage.save(new BorrowRecord(1, "BOOK2", LocalDate.now().minusDays(3)));

        // Now has overdue items, cannot renew
        assertFalse(circulationService.canRenewBorrow(1, "BOOK1"));
    }

    @Test
    void getFineCategory_correctForDifferentOverdueLevels() {
        memberStorage.save(new Member(1, true, MembershipType.STUDENT));
        itemStorage.save(new LibraryItem("BOOK1", true));
        itemStorage.save(new LibraryItem("BOOK2", true));
        itemStorage.save(new LibraryItem("BOOK3", true));

        // Not overdue
        borrowStorage.save(new BorrowRecord(1, "BOOK1", LocalDate.now().plusDays(2)));
        assertEquals("NO_FINE_ON_TIME", circulationService.getFineCategory("BOOK1"));

        // 3 days overdue (LOW)
        borrowStorage.save(new BorrowRecord(1, "BOOK2", LocalDate.now().minusDays(3)));
        assertEquals("LOW_FINE", circulationService.getFineCategory("BOOK2"));

        // 10 days overdue (MEDIUM)
        borrowStorage.save(new BorrowRecord(1, "BOOK3", LocalDate.now().minusDays(10)));
        assertEquals("MEDIUM_FINE", circulationService.getFineCategory("BOOK3"));
    }

    @Test
    void getDaysUntilDue_countdownToZero_thenNegative() {
        memberStorage.save(new Member(1, true, MembershipType.STUDENT));
        itemStorage.save(new LibraryItem("BOOK1", true));

        // Due in 3 days
        borrowStorage.save(new BorrowRecord(1, "BOOK1", LocalDate.now().plusDays(3)));
        assertEquals(3, circulationService.getDaysUntilDue("BOOK1"));

        // Overdue by 2 days
        itemStorage.save(new LibraryItem("BOOK2", true));
        borrowStorage.save(new BorrowRecord(1, "BOOK2", LocalDate.now().minusDays(2)));
        assertEquals(-2, circulationService.getDaysUntilDue("BOOK2"));
    }

    @Test
    void calculateLateFeeWithDiscount_appliesCorrectly() {
        memberStorage.save(new Member(1, true, MembershipType.STUDENT));
        itemStorage.save(new LibraryItem("BOOK1", true));

        // 10 days overdue: 10 * $2.0 = $20.0 (past grace period)
        borrowStorage.save(new BorrowRecord(1, "BOOK1", LocalDate.now().minusDays(10)));

        double fullFine = circulationService.calculateFine("BOOK1");
        assertEquals(20.0, fullFine, 0.01);

        // 50% discount
        double discountedFine = circulationService.calculateLateFeeWithDiscount("BOOK1", 50);
        assertEquals(10.0, discountedFine, 0.01);
    }

    @Test
    void getMembershipEligibility_basedOnBorrowHistory() {
        // No borrows, active
        String eligibility1 = circulationService.getMembershipEligibility(0, false, true);
        assertEquals("EXCELLENT_STANDING", eligibility1);

        // 2 borrows, no overdue, active
        String eligibility2 = circulationService.getMembershipEligibility(2, false, true);
        assertEquals("GOOD_STANDING", eligibility2);

        // 4 borrows, no overdue, active
        String eligibility3 = circulationService.getMembershipEligibility(4, false, true);
        assertEquals("MODERATE_USAGE", eligibility3);

        // Has overdue
        String eligibility4 = circulationService.getMembershipEligibility(2, true, true);
        assertEquals("HAS_OVERDUE_ITEMS", eligibility4);
    }

    @Test
    void assessItemReturnStatus_progressesThroughCategories() {
        memberStorage.save(new Member(1, true, MembershipType.STUDENT));
        itemStorage.save(new LibraryItem("BOOK1", true));
        borrowStorage.save(new BorrowRecord(1, "BOOK1", LocalDate.now()));

        assertEquals("ON_TIME", circulationService.assessItemReturnStatus("BOOK1", 0));
        assertEquals("SLIGHTLY_LATE", circulationService.assessItemReturnStatus("BOOK1", 2));
        assertEquals("MODERATELY_LATE", circulationService.assessItemReturnStatus("BOOK1", 5));
        assertEquals("VERY_LATE", circulationService.assessItemReturnStatus("BOOK1", 10));
        assertEquals("SEVERELY_OVERDUE", circulationService.assessItemReturnStatus("BOOK1", 20));
    }

    @Test
    void canBorrowItemType_respectsValueLimits() {
        memberStorage.save(new Member(1, true, MembershipType.STUDENT));
        memberStorage.save(new Member(2, true, MembershipType.GUEST));

        // STUDENT limit: $100
        assertTrue(circulationService.canBorrowItemType(1, "BOOK", 100));
        assertFalse(circulationService.canBorrowItemType(1, "BOOK", 101));

        // GUEST limit: $50
        assertTrue(circulationService.canBorrowItemType(2, "BOOK", 50));
        assertFalse(circulationService.canBorrowItemType(2, "BOOK", 51));
    }

    @Test
    void shouldSendReminder_triggersAtRightTime() {
        memberStorage.save(new Member(1, true, MembershipType.STUDENT));
        itemStorage.save(new LibraryItem("BOOK1", true));

        // Due in 3 days
        borrowStorage.save(new BorrowRecord(1, "BOOK1", LocalDate.now().plusDays(3)));

        assertTrue(circulationService.shouldSendReminder("BOOK1", 3));
        assertFalse(circulationService.shouldSendReminder("BOOK1", 5));

        // Overdue items should trigger reminders
        itemStorage.save(new LibraryItem("BOOK2", true));
        borrowStorage.save(new BorrowRecord(1, "BOOK2", LocalDate.now().minusDays(2)));
        assertTrue(circulationService.shouldSendReminder("BOOK2", 1));
    }

    // Edge cases
    @Test
    void memberBecomesInactive_cannotBorrowMore() {
        memberStorage.save(new Member(1, true, MembershipType.STUDENT));
        itemStorage.save(new LibraryItem("BOOK1", true));
        itemStorage.save(new LibraryItem("BOOK2", true));

        circulationService.requestBorrow(1, "BOOK1");
        assertTrue(circulationService.canBorrowMore(1));

        // Replace with inactive member
        memberStorage.save(new Member(1, false, MembershipType.STUDENT));

        assertThrows(IllegalStateException.class,
                () -> circulationService.requestBorrow(1, "BOOK2"));
    }

    @Test
    void itemBecomesUnavailable_afterFirstBorrow() {
        memberStorage.save(new Member(1, true, MembershipType.STUDENT));
        memberStorage.save(new Member(2, true, MembershipType.STUDENT));
        itemStorage.save(new LibraryItem("BOOK1", true));

        circulationService.requestBorrow(1, "BOOK1");

        // Item is now unavailable, member 2 cannot borrow it
        assertThrows(IllegalStateException.class,
                () -> circulationService.requestBorrow(2, "BOOK1"));
    }

    @Test
    void isEligibleToBorrow_checksAllConditions_withRealData() {
        memberStorage.save(new Member(1, true, MembershipType.GUEST));
        itemStorage.save(new LibraryItem("BOOK1", true));
        itemStorage.save(new LibraryItem("BOOK2", true));

        assertTrue(circulationService.isEligibleToBorrow(1, "BOOK1"));

        // Borrow up to limit (GUEST = 1)
        circulationService.requestBorrow(1, "BOOK1");

        // At capacity, not eligible
        assertFalse(circulationService.isEligibleToBorrow(1, "BOOK2"));
    }

    @Test
    void getTotalOverdueDays_sumsAcrossMultipleBorrows() {
        memberStorage.save(new Member(1, true, MembershipType.STUDENT));
        itemStorage.save(new LibraryItem("BOOK1", true));
        itemStorage.save(new LibraryItem("BOOK2", true));
        itemStorage.save(new LibraryItem("BOOK3", true));

        // 3 days overdue
        borrowStorage.save(new BorrowRecord(1, "BOOK1", LocalDate.now().minusDays(3)));

        // 5 days overdue
        borrowStorage.save(new BorrowRecord(1, "BOOK2", LocalDate.now().minusDays(5)));

        // Not overdue
        borrowStorage.save(new BorrowRecord(1, "BOOK3", LocalDate.now().plusDays(2)));

        // Total: 3 + 5 = 8
        assertEquals(8, circulationService.getTotalOverdueDays(1));
    }
}
