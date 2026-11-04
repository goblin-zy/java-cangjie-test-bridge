package smartlibrary.Part3_Testing.System;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import smartlibrary.api.LibraryFacade;
import smartlibrary.api.impl.DefaultLibraryFacade;
import smartlibrary.model.BorrowRecord;
import smartlibrary.model.LibraryItem;
import smartlibrary.model.Member;
import smartlibrary.model.MembershipType;
import smartlibrary.notification.impl.StubAlertService;
import smartlibrary.policy.impl.DefaultBorrowPolicy;
import smartlibrary.policy.impl.DefaultPenaltyPolicy;
import smartlibrary.service.impl.DefaultCirculationService;
import smartlibrary.storage.memory.MemoryBorrowStorage;
import smartlibrary.storage.memory.MemoryItemStorage;
import smartlibrary.storage.memory.MemoryMemberStorage;

import java.time.LocalDate;

import static org.junit.jupiter.api.Assertions.*;

/**
 * SYSTEM TESTING:
 * - Tests the entire system end-to-end through the LibraryFacade
 * - Uses ONLY the public API (LibraryFacade) for operations
 * - All components are real implementations (no mocks)
 * - Worked by All Group
 *
 * NOTE: Due to facade methods returning void, we verify system state
 * by checking storage layers directly. In a production system, the
 * facade would provide query methods to avoid this.
 */
public class LibrarySystemTest {

    private MemoryItemStorage itemStorage;
    private MemoryMemberStorage memberStorage;
    private MemoryBorrowStorage borrowStorage;
    private StubAlertService alertService;

    private LibraryFacade facade;

    @BeforeEach
    void setup() {
        // Real infrastructure
        itemStorage = new MemoryItemStorage();
        memberStorage = new MemoryMemberStorage();
        borrowStorage = new MemoryBorrowStorage();
        alertService = new StubAlertService();

        // Real service layer
        DefaultCirculationService circulationService =
                new DefaultCirculationService(
                        itemStorage,
                        memberStorage,
                        borrowStorage,
                        new DefaultBorrowPolicy(),
                        new DefaultPenaltyPolicy(),
                        alertService
                );

        // Facade (system entry point)
        facade = new DefaultLibraryFacade(circulationService);
    }

    // =========================================================
    // ARSILDO VELIU (4 tests)
    // =========================================================

    @Test
    void borrowFlow_success_marksItemUnavailable_andCreatesActiveBorrowRecord() {
        memberStorage.save(new Member(1, true, MembershipType.STUDENT));
        itemStorage.save(new LibraryItem("BOOK1", true));

        facade.borrowFlow(1, "BOOK1");

        assertFalse(itemStorage.find("BOOK1").isAvailable());
        assertNotNull(borrowStorage.findActiveBorrow("BOOK1"));
    }

    @Test
    void returnFlow_success_marksRecordReturned_andMarksItemAvailable() {
        memberStorage.save(new Member(1, true, MembershipType.STUDENT));
        itemStorage.save(new LibraryItem("BOOK1", true));

        facade.borrowFlow(1, "BOOK1");
        facade.returnFlow("BOOK1");

        assertTrue(itemStorage.find("BOOK1").isAvailable());
        assertTrue(borrowStorage.findAll().get(0).isReturned());
    }

    @Test
    void borrowFlow_nonexistentMember_throwsRuntimeExceptionWithMessage() {
        itemStorage.save(new LibraryItem("BOOK1", true));

        RuntimeException ex = assertThrows(RuntimeException.class,
                () -> facade.borrowFlow(999, "BOOK1"));

        assertTrue(ex.getMessage().contains("Member not found"),
                "Should explain member doesn't exist");
    }

    @Test
    void borrowFlow_nonexistentItem_throwsRuntimeExceptionWithMessage() {
        memberStorage.save(new Member(1, true, MembershipType.STUDENT));

        RuntimeException ex = assertThrows(RuntimeException.class,
                () -> facade.borrowFlow(1, "NONEXISTENT"));

        assertTrue(ex.getMessage().contains("Item not found"),
                "Should explain item doesn't exist");
    }

    // =========================================================
    // MEGI ALMADHI (4 tests)
    // =========================================================

    @Test
    void completeUserJourney_borrowMultipleItems_returnSome_borrowMore() {
        memberStorage.save(new Member(1, true, MembershipType.STUDENT));

        itemStorage.save(new LibraryItem("BOOK1", true));
        itemStorage.save(new LibraryItem("BOOK2", true));
        itemStorage.save(new LibraryItem("BOOK3", true));

        facade.borrowFlow(1, "BOOK1");
        facade.borrowFlow(1, "BOOK2");

        assertEquals(2, borrowStorage.countActiveBorrows(1));

        facade.returnFlow("BOOK1");

        assertEquals(1, borrowStorage.countActiveBorrows(1));

        facade.borrowFlow(1, "BOOK3");

        assertEquals(2, borrowStorage.countActiveBorrows(1));
        assertNotNull(borrowStorage.findActiveBorrow("BOOK2"));
        assertNotNull(borrowStorage.findActiveBorrow("BOOK3"));
    }

    @Test
    void studentMember_canBorrow3Items_cannotExceed() {
        memberStorage.save(new Member(1, true, MembershipType.STUDENT));

        itemStorage.save(new LibraryItem("B1", true));
        itemStorage.save(new LibraryItem("B2", true));
        itemStorage.save(new LibraryItem("B3", true));
        itemStorage.save(new LibraryItem("B4", true));

        facade.borrowFlow(1, "B1");
        facade.borrowFlow(1, "B2");
        facade.borrowFlow(1, "B3");

        assertEquals(3, borrowStorage.countActiveBorrows(1));

        RuntimeException ex = assertThrows(RuntimeException.class,
                () -> facade.borrowFlow(1, "B4"));

        assertTrue(ex.getMessage().contains("policy violation"),
                "Should explain capacity limit reached");
    }

    @Test
    void borrowUpToLimit_returnOne_borrowAnother_respectsCapacity() {
        memberStorage.save(new Member(1, true, MembershipType.GUEST)); // limit: 1

        itemStorage.save(new LibraryItem("BOOK1", true));
        itemStorage.save(new LibraryItem("BOOK2", true));

        facade.borrowFlow(1, "BOOK1");

        // At limit, cannot borrow another
        assertThrows(RuntimeException.class,
                () -> facade.borrowFlow(1, "BOOK2"));

        // Return first item
        facade.returnFlow("BOOK1");

        // Now can borrow the second item
        facade.borrowFlow(1, "BOOK2");

        assertTrue(itemStorage.find("BOOK1").isAvailable());
        assertFalse(itemStorage.find("BOOK2").isAvailable());
        assertEquals(1, borrowStorage.countActiveBorrows(1));
    }

    @Test
    void borrowReturn_sameItem_multipleTimes() {
        memberStorage.save(new Member(1, true, MembershipType.STUDENT));
        itemStorage.save(new LibraryItem("BOOK1", true));

        // Borrow-return cycle 1
        facade.borrowFlow(1, "BOOK1");
        facade.returnFlow("BOOK1");

        // Borrow-return cycle 2
        facade.borrowFlow(1, "BOOK1");
        facade.returnFlow("BOOK1");

        // Borrow-return cycle 3
        facade.borrowFlow(1, "BOOK1");
        facade.returnFlow("BOOK1");

        // Should have 3 records total, all returned
        long count = borrowStorage.findAll().stream()
                .filter(r -> r.getItemCode().equals("BOOK1"))
                .count();
        assertEquals(3, count);

        boolean allReturned = borrowStorage.findAll().stream()
                .filter(r -> r.getItemCode().equals("BOOK1"))
                .allMatch(BorrowRecord::isReturned);
        assertTrue(allReturned);
    }

    // =========================================================
    // SIDRIT RRUSTEMI (4 tests)
    // =========================================================

    @Test
    void staffMember_canBorrow5Items_cannotExceed() {
        memberStorage.save(new Member(1, true, MembershipType.STAFF));

        // Borrow up to limit (5)
        for (int i = 1; i <= 5; i++) {
            itemStorage.save(new LibraryItem("BOOK" + i, true));
            facade.borrowFlow(1, "BOOK" + i);
        }

        assertEquals(5, borrowStorage.countActiveBorrows(1));

        // Try to exceed limit (6th item)
        itemStorage.save(new LibraryItem("BOOK6", true));

        RuntimeException ex = assertThrows(RuntimeException.class,
                () -> facade.borrowFlow(1, "BOOK6"));

        assertTrue(ex.getMessage().contains("policy violation"),
                "Should explain capacity limit reached");
    }

    @Test
    void guestMember_limitedTo1Item() {
        memberStorage.save(new Member(1, true, MembershipType.GUEST));

        itemStorage.save(new LibraryItem("BOOK1", true));
        itemStorage.save(new LibraryItem("BOOK2", true));

        facade.borrowFlow(1, "BOOK1");

        assertEquals(1, borrowStorage.countActiveBorrows(1));

        RuntimeException ex = assertThrows(RuntimeException.class,
                () -> facade.borrowFlow(1, "BOOK2"));

        assertTrue(ex.getMessage().contains("policy violation"));
    }

    @Test
    void twoMembers_cannotBorrowSameItem_secondMemberBlocked() {
        memberStorage.save(new Member(1, true, MembershipType.STUDENT));
        memberStorage.save(new Member(2, true, MembershipType.STAFF));
        itemStorage.save(new LibraryItem("BOOK1", true));

        // Member 1 borrows successfully
        facade.borrowFlow(1, "BOOK1");

        // Member 2 (even with higher privileges) cannot borrow same item
        RuntimeException ex = assertThrows(RuntimeException.class,
                () -> facade.borrowFlow(2, "BOOK1"));

        assertTrue(ex.getMessage().contains("not available"),
                "Should explain item is already borrowed");

        // After return, member 2 can borrow
        facade.returnFlow("BOOK1");
        facade.borrowFlow(2, "BOOK1");

        assertEquals(0, borrowStorage.countActiveBorrows(1));
        assertEquals(1, borrowStorage.countActiveBorrows(2));
    }

    @Test
    void borrowFlow_inactiveMember_throwsRuntimeException() {
        memberStorage.save(new Member(1, false, MembershipType.STUDENT)); // inactive
        itemStorage.save(new LibraryItem("BOOK1", true));

        RuntimeException ex = assertThrows(RuntimeException.class,
                () -> facade.borrowFlow(1, "BOOK1"));

        assertTrue(ex.getMessage().contains("policy violation"),
                "Should explain member cannot borrow");
    }

    // =========================================================
    // VIOLA ZENELI (4 tests)
    // =========================================================

    @Test
    void twoMembers_borrowAndReturn_differentItems_noInterference() {
        memberStorage.save(new Member(1, true, MembershipType.STUDENT));
        memberStorage.save(new Member(2, true, MembershipType.STUDENT));

        itemStorage.save(new LibraryItem("BOOK1", true));
        itemStorage.save(new LibraryItem("BOOK2", true));

        facade.borrowFlow(1, "BOOK1");
        facade.borrowFlow(2, "BOOK2");

        facade.returnFlow("BOOK1");

        assertTrue(itemStorage.find("BOOK1").isAvailable());
        assertFalse(itemStorage.find("BOOK2").isAvailable());
        assertEquals(0, borrowStorage.countActiveBorrows(1));
        assertEquals(1, borrowStorage.countActiveBorrows(2));
    }

    @Test
    void memberWithOverdueItem_cannotBorrowAnother() {
        // NOTE: This test bypasses the facade to create an overdue state
        // that cannot be created through the public API due to time dependency
        memberStorage.save(new Member(1, true, MembershipType.STUDENT));
        itemStorage.save(new LibraryItem("BOOK1", true));
        itemStorage.save(new LibraryItem("BOOK2", true));

        // Manually create overdue borrow (limitation of system design)
        borrowStorage.save(new BorrowRecord(1, "BOOK1",
                LocalDate.now().minusDays(5)));
        itemStorage.updateAvailability("BOOK1", false);

        RuntimeException ex = assertThrows(RuntimeException.class,
                () -> facade.borrowFlow(1, "BOOK2"));

        assertTrue(ex.getMessage().contains("policy violation"),
                "Should explain member has overdue items");
    }

    @Test
    void returnOverdueItem_sendsAlert() {
        // NOTE: This test creates an overdue state manually
        memberStorage.save(new Member(1, true, MembershipType.STUDENT));
        itemStorage.save(new LibraryItem("BOOK1", true));

        borrowStorage.save(new BorrowRecord(1, "BOOK1",
                LocalDate.now().minusDays(3)));
        itemStorage.updateAvailability("BOOK1", false);

        facade.returnFlow("BOOK1");

        assertEquals(1, alertService.getLastMemberId());
        assertNotNull(alertService.getLastMessage());
        assertTrue(alertService.getLastMessage().contains("overdue"));
    }

    @Test
    void systemMaintainsConsistency_itemAvailabilityMatchesBorrowRecords() {
        memberStorage.save(new Member(1, true, MembershipType.STUDENT));

        itemStorage.save(new LibraryItem("BOOK1", true));
        itemStorage.save(new LibraryItem("BOOK2", true));
        itemStorage.save(new LibraryItem("BOOK3", true));

        facade.borrowFlow(1, "BOOK1");
        facade.borrowFlow(1, "BOOK2");

        // Check consistency between item availability and borrow records
        assertFalse(itemStorage.find("BOOK1").isAvailable());
        assertFalse(itemStorage.find("BOOK2").isAvailable());
        assertTrue(itemStorage.find("BOOK3").isAvailable());

        assertEquals(2, borrowStorage.countActiveBorrows(1));
        assertNotNull(borrowStorage.findActiveBorrow("BOOK1"));
        assertNotNull(borrowStorage.findActiveBorrow("BOOK2"));
        assertNull(borrowStorage.findActiveBorrow("BOOK3"));
    }
}