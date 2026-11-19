package smartlibrary.Part3_Testing.Unit.service;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.CsvSource;

import smartlibrary.model.*;
import smartlibrary.notification.AlertService;
import smartlibrary.policy.BorrowPolicy;
import smartlibrary.policy.PenaltyPolicy;
import smartlibrary.service.impl.DefaultCirculationService;
import smartlibrary.storage.BorrowStorage;
import smartlibrary.storage.ItemStorage;
import smartlibrary.storage.MemberStorage;

import java.time.LocalDate;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

/// VIOLA ZENELI (first half)
/// SIDRIT RRUSTEMI (second half)

public class DefaultCirculationServiceUnitTest {

    private ItemStorage itemStorage;
    private MemberStorage memberStorage;
    private BorrowStorage borrowStorage;
    private BorrowPolicy borrowPolicy;
    private PenaltyPolicy penaltyPolicy;
    private AlertService alertService;

    private DefaultCirculationService service;

    @BeforeEach
    void setup() {
        itemStorage = mock(ItemStorage.class);
        memberStorage = mock(MemberStorage.class);
        borrowStorage = mock(BorrowStorage.class);
        borrowPolicy = mock(BorrowPolicy.class);
        penaltyPolicy = mock(PenaltyPolicy.class);
        alertService = mock(AlertService.class);

        service = new DefaultCirculationService(
                itemStorage,
                memberStorage,
                borrowStorage,
                borrowPolicy,
                penaltyPolicy,
                alertService
        );
    }

    /// VIOLA ZENELI (36 tests)

    // =========================================================
    // requestBorrow()
    // =========================================================

    // validateMemberId()
    @Test
    void requestBorrow_throws_whenMemberIdInvalid() {
        assertThrows(IllegalArgumentException.class,
                () -> service.requestBorrow(0, "BOOK1"));
    }

    // validateItemCode()
    @Test
    void requestBorrow_throws_whenItemCodeInvalid() {
        assertThrows(IllegalArgumentException.class,
                () -> service.requestBorrow(1, ""));
    }

    // getMemberOrThrow()
    @Test
    void requestBorrow_throws_whenMemberNotFound() {
        when(memberStorage.find(1)).thenReturn(null);
        when(itemStorage.find("BOOK1")).thenReturn(new LibraryItem("BOOK1", true));

        assertThrows(IllegalStateException.class, () -> service.requestBorrow(1, "BOOK1"));
    }

    // getItemOrThrow()
    @Test
    void requestBorrow_throws_whenItemNotFound() {
        when(memberStorage.find(1)).thenReturn(new Member(1, true, MembershipType.STUDENT));
        when(itemStorage.find("BOOK1")).thenReturn(null);

        assertThrows(IllegalStateException.class, () -> service.requestBorrow(1, "BOOK1"));
    }

    // item.isAvailable()
    @Test
    void requestBorrow_throws_whenItemNotAvailable() {
        when(memberStorage.find(1)).thenReturn(new Member(1, true, MembershipType.STUDENT));
        when(itemStorage.find("BOOK1")).thenReturn(new LibraryItem("BOOK1", false));

        assertThrows(IllegalStateException.class, () -> service.requestBorrow(1, "BOOK1"));
    }

    // borrowPolicy.canBorrow()
    @Test
    void requestBorrow_throws_whenBorrowPolicyRejects() {
        Member member = new Member(1, true, MembershipType.STUDENT);

        when(memberStorage.find(1)).thenReturn(member);
        when(itemStorage.find("BOOK1")).thenReturn(new LibraryItem("BOOK1", true));
        when(borrowStorage.countActiveBorrows(1)).thenReturn(3);
        when(borrowStorage.hasOverdueBorrows(eq(1), any())).thenReturn(false);
        when(borrowPolicy.canBorrow(eq(member), anyInt(), anyBoolean())).thenReturn(false);

        assertThrows(IllegalStateException.class, () -> service.requestBorrow(1, "BOOK1"));
    }

    // updateAvailability() + save()
    @Test
    void requestBorrow_updatesAvailabilityToFalse_andSavesBorrowRecord_whenValid() {
        Member member = new Member(1, true, MembershipType.STUDENT);

        when(memberStorage.find(1)).thenReturn(member);
        when(itemStorage.find("BOOK1")).thenReturn(new LibraryItem("BOOK1", true));
        when(borrowStorage.countActiveBorrows(1)).thenReturn(0);
        when(borrowStorage.hasOverdueBorrows(eq(1), any())).thenReturn(false);
        when(borrowPolicy.canBorrow(eq(member), anyInt(), anyBoolean())).thenReturn(true);

        service.requestBorrow(1, "BOOK1");

        verify(itemStorage).updateAvailability("BOOK1", false);
        verify(borrowStorage).save(any(BorrowRecord.class));
    }

    // calculateDueDate()
    @Test
    void requestBorrow_savesBorrowRecordWithDueDate_todayPlusMaxLoanDays() {
        Member member = new Member(1, true, MembershipType.STUDENT);

        when(memberStorage.find(1)).thenReturn(member);
        when(itemStorage.find("BOOK1")).thenReturn(new LibraryItem("BOOK1", true));
        when(borrowPolicy.canBorrow(any(), anyInt(), anyBoolean())).thenReturn(true);

        service.requestBorrow(1, "BOOK1");

        verify(borrowStorage).save(argThat(r -> r.getDueDate().equals(LocalDate.now().plusDays(14))));
    }

    // =========================================================
    // returnItem()
    // =========================================================

    // validateItemCode()
    @Test
    void returnItem_throws_whenItemCodeNull() {
        assertThrows(IllegalArgumentException.class, () -> service.returnItem(null));
    }

    // findActiveBorrow()
    @Test
    void returnItem_throws_whenNoActiveBorrow() {
        when(borrowStorage.findActiveBorrow("BOOK1")).thenReturn(null);

        assertThrows(IllegalStateException.class, () -> service.returnItem("BOOK1"));
    }

    // markReturned() + updateAvailability()
    @Test
    void returnItem_marksRecordReturned_andUpdatesAvailabilityTrue() {
        BorrowRecord record = new BorrowRecord(1, "BOOK1", LocalDate.now().plusDays(2));

        when(borrowStorage.findActiveBorrow("BOOK1")).thenReturn(record);

        service.returnItem("BOOK1");

        assertTrue(record.isReturned());
        verify(itemStorage).updateAvailability("BOOK1", true);
    }

    // penaltyPolicy.calculatePenalty() + alertService.sendAlert()
    @Test
    void returnItem_sendsAlert_whenRecordIsOverdue() {
        BorrowRecord record = new BorrowRecord(1, "BOOK1", LocalDate.now().minusDays(3));

        when(borrowStorage.findActiveBorrow("BOOK1")).thenReturn(record);
        when(penaltyPolicy.calculatePenalty(anyInt())).thenReturn(6.0);

        service.returnItem("BOOK1");

        verify(alertService).sendAlert(eq(1), contains("overdue"));
    }

    // no alert path
    @Test
    void returnItem_doesNotSendAlert_whenRecordNotOverdue() {
        BorrowRecord record = new BorrowRecord(1, "BOOK1", LocalDate.now().plusDays(3));

        when(borrowStorage.findActiveBorrow("BOOK1")).thenReturn(record);

        service.returnItem("BOOK1");

        verify(alertService, never()).sendAlert(anyInt(), anyString());
    }

    // =========================================================
    // canBorrowMore()
    // =========================================================

    // validateMemberId()
    @Test
    void canBorrowMore_throws_whenMemberNotFound() {
        when(memberStorage.find(1)).thenReturn(null);

        assertThrows(IllegalStateException.class, () -> service.canBorrowMore(1));
    }

    // countActiveBorrows() < max
    @Test
    void canBorrowMore_returnsTrue_whenActiveBorrowsLessThanMax() {
        Member member = new Member(1, true, MembershipType.STUDENT);

        when(memberStorage.find(1)).thenReturn(member);
        when(borrowStorage.countActiveBorrows(1)).thenReturn(1);

        assertTrue(service.canBorrowMore(1));
    }

    // countActiveBorrows() == max
    @Test
    void canBorrowMore_returnsFalse_whenActiveBorrowsEqualsMax() {
        Member member = new Member(1, true, MembershipType.STUDENT);

        when(memberStorage.find(1)).thenReturn(member);
        when(borrowStorage.countActiveBorrows(1)).thenReturn(3);

        assertFalse(service.canBorrowMore(1));
    }

    // countActiveBorrows() > max
    @Test
    void canBorrowMore_returnsFalse_whenActiveBorrowsGreaterThanMax() {
        Member member = new Member(1, true, MembershipType.STUDENT);

        when(memberStorage.find(1)).thenReturn(member);
        when(borrowStorage.countActiveBorrows(1)).thenReturn(5);

        assertFalse(service.canBorrowMore(1));
    }

    // =========================================================
    // calculateFine()
    // =========================================================

    // not overdue
    @Test
    void calculateFine_returns0_whenNotOverdue() {
        BorrowRecord record = new BorrowRecord(1, "BOOK1", LocalDate.now().plusDays(2));

        when(borrowStorage.findActiveBorrow("BOOK1")).thenReturn(record);

        assertEquals(0, service.calculateFine("BOOK1"));
    }

    // overdue path
    @Test
    void calculateFine_returnsCorrectAmount_whenOverdue() {
        BorrowRecord record = new BorrowRecord(1, "BOOK1", LocalDate.now().minusDays(4));

        when(borrowStorage.findActiveBorrow("BOOK1")).thenReturn(record);
        when(penaltyPolicy.calculatePenalty(4)).thenReturn(8.0);

        assertEquals(8.0, service.calculateFine("BOOK1"));
    }

    // already returned
    @Test
    void calculateFine_returns0_whenItemReturned() {
        BorrowRecord record = new BorrowRecord(1, "BOOK1", LocalDate.now().minusDays(4));
        record.markReturned();

        when(borrowStorage.findActiveBorrow("BOOK1")).thenReturn(record);

        assertEquals(0, service.calculateFine("BOOK1"));
    }

    // no active borrow
    @Test
    void calculateFine_throws_whenNoActiveBorrow() {
        when(borrowStorage.findActiveBorrow("BOOK1")).thenReturn(null);

        assertThrows(IllegalStateException.class, () -> service.calculateFine("BOOK1"));
    }

    // invalid item code
    @Test
    void calculateFine_throws_whenItemCodeNull() {
        assertThrows(IllegalArgumentException.class, () -> service.calculateFine(null));
    }

    // =========================================================
    // isEligibleToBorrow()
    // =========================================================

    @Test
    void isEligibleToBorrow_returnsTrue_whenAllConditionsMet() {
        Member member = new Member(1, true, MembershipType.STUDENT);
        LibraryItem item = new LibraryItem("BOOK1", true);

        when(memberStorage.find(1)).thenReturn(member);
        when(itemStorage.find("BOOK1")).thenReturn(item);
        when(borrowStorage.countActiveBorrows(1)).thenReturn(0);
        when(borrowStorage.hasOverdueBorrows(eq(1), any())).thenReturn(false);

        assertTrue(service.isEligibleToBorrow(1, "BOOK1"));
    }

    @Test
    void isEligibleToBorrow_returnsFalse_whenMemberNull() {
        when(memberStorage.find(1)).thenReturn(null);

        assertFalse(service.isEligibleToBorrow(1, "BOOK1"));
    }

    @Test
    void isEligibleToBorrow_returnsFalse_whenItemNull() {
        when(memberStorage.find(1)).thenReturn(new Member(1, true, MembershipType.STUDENT));
        when(itemStorage.find("BOOK1")).thenReturn(null);

        assertFalse(service.isEligibleToBorrow(1, "BOOK1"));
    }

    @Test
    void isEligibleToBorrow_returnsFalse_whenMemberInactive() {
        Member member = new Member(1, false, MembershipType.STUDENT);

        when(memberStorage.find(1)).thenReturn(member);
        when(itemStorage.find("BOOK1")).thenReturn(new LibraryItem("BOOK1", true));

        assertFalse(service.isEligibleToBorrow(1, "BOOK1"));
    }

    @Test
    void isEligibleToBorrow_returnsFalse_whenItemNotAvailable() {
        when(memberStorage.find(1)).thenReturn(new Member(1, true, MembershipType.STUDENT));
        when(itemStorage.find("BOOK1")).thenReturn(new LibraryItem("BOOK1", false));

        assertFalse(service.isEligibleToBorrow(1, "BOOK1"));
    }

    @Test
    void isEligibleToBorrow_returnsFalse_whenAtCapacity() {
        Member member = new Member(1, true, MembershipType.STUDENT);

        when(memberStorage.find(1)).thenReturn(member);
        when(itemStorage.find("BOOK1")).thenReturn(new LibraryItem("BOOK1", true));
        when(borrowStorage.countActiveBorrows(1)).thenReturn(3);

        assertFalse(service.isEligibleToBorrow(1, "BOOK1"));
    }

    @Test
    void isEligibleToBorrow_returnsFalse_whenHasOverdue() {
        Member member = new Member(1, true, MembershipType.STUDENT);

        when(memberStorage.find(1)).thenReturn(member);
        when(itemStorage.find("BOOK1")).thenReturn(new LibraryItem("BOOK1", true));
        when(borrowStorage.hasOverdueBorrows(eq(1), any())).thenReturn(true);

        assertFalse(service.isEligibleToBorrow(1, "BOOK1"));
    }

    @Test
    void isEligibleToBorrow_returnsFalse_whenMemberIdInvalid() {
        assertFalse(service.isEligibleToBorrow(0, "BOOK1"));
    }

    @Test
    void isEligibleToBorrow_returnsFalse_whenItemCodeNull() {
        assertFalse(service.isEligibleToBorrow(1, null));
    }

    // =========================================================
    // getRemainingBorrowCapacity()
    // =========================================================

    @ParameterizedTest
    @CsvSource({
            "STUDENT,0,3",
            "STUDENT,2,1",
            "STAFF,3,2",
            "GUEST,1,0"
    })
    void getRemainingBorrowCapacity_returnsCorrectValue(MembershipType type, int activeBorrows, int expected) {
        Member member = new Member(1, true, type);

        when(memberStorage.find(1)).thenReturn(member);
        when(borrowStorage.countActiveBorrows(1)).thenReturn(activeBorrows);

        assertEquals(expected, service.getRemainingBorrowCapacity(1));
    }

    @Test
    void getRemainingBorrowCapacity_throws_whenMemberNotFound() {
        when(memberStorage.find(1)).thenReturn(null);

        assertThrows(IllegalStateException.class, () -> service.getRemainingBorrowCapacity(1));
    }

    // =========================================================
    // validateMemberStatus()
    // =========================================================

    @ParameterizedTest
    @CsvSource({
            "true,false,false,ACTIVE_GOOD_STANDING",
            "false,false,false,INACTIVE",
            "true,true,false,OVERDUE_ITEMS",
            "true,false,true,AT_CAPACITY",
            "false,true,true,SUSPENDED_MULTIPLE_ISSUES"
    })
    void validateMemberStatus_returnsExpectedStatus(boolean isActive, boolean hasOverdue, boolean atCapacity, String expectedStatus) {
        Member member = new Member(1, isActive, MembershipType.STUDENT);

        when(memberStorage.find(1)).thenReturn(member);
        when(borrowStorage.hasOverdueBorrows(eq(1), any())).thenReturn(hasOverdue);
        when(borrowStorage.countActiveBorrows(1)).thenReturn(atCapacity ? 3 : 0);

        assertEquals(expectedStatus, service.validateMemberStatus(1));
    }

    @ParameterizedTest
    @CsvSource({
            "0,INVALID_MEMBER_ID",
            "-1,INVALID_MEMBER_ID"
    })
    void validateMemberStatus_returnsInvalid_whenMemberIdNegativeOrZero(int memberId, String expected) {
        assertEquals(expected, service.validateMemberStatus(memberId));
    }

    @Test
    void validateMemberStatus_returnsMEMBER_NOT_FOUND_whenMemberNull() {
        when(memberStorage.find(1)).thenReturn(null);

        assertEquals("MEMBER_NOT_FOUND", service.validateMemberStatus(1));
    }


    //===========================================================================================


    /// SIDRIT RRUSTEMI (38 tests)

    // getFineCategory()
    @ParameterizedTest
    @CsvSource({
            "-5,NO_FINE_ON_TIME",
            "0,NO_FINE_ON_TIME",
            "1,LOW_FINE",
            "5,LOW_FINE",
            "6,MEDIUM_FINE",
            "14,MEDIUM_FINE",
            "15,HIGH_FINE",
            "30,HIGH_FINE"
    })
    void getFineCategory_returnsExpectedCategory(int overdueDays, String expectedCategory) {
        LocalDate dueDate = LocalDate.now().minusDays(overdueDays);
        BorrowRecord record = new BorrowRecord(1, "BOOK1", dueDate);
        when(borrowStorage.findActiveBorrow("BOOK1")).thenReturn(record);

        assertEquals(expectedCategory, service.getFineCategory("BOOK1"));
    }

    @Test
    void getFineCategory_returnsNO_FINE_RETURNED_whenAlreadyReturned() {
        BorrowRecord record = new BorrowRecord(1, "BOOK1", LocalDate.now().minusDays(10));
        record.markReturned();
        when(borrowStorage.findActiveBorrow("BOOK1")).thenReturn(record);

        assertEquals("NO_FINE_RETURNED", service.getFineCategory("BOOK1"));
    }

    @Test
    void getFineCategory_throws_whenNoActiveBorrow() {
        when(borrowStorage.findActiveBorrow("BOOK1")).thenReturn(null);

        assertThrows(IllegalStateException.class, () -> service.getFineCategory("BOOK1"));
    }

    // canRenewBorrow()
    @Test
    void canRenewBorrow_returnsTrue_whenAllConditionsMet() {
        Member member = new Member(1, true, MembershipType.STUDENT);
        LibraryItem item = new LibraryItem("BOOK1", true);
        BorrowRecord record = new BorrowRecord(1, "BOOK1", LocalDate.now().plusDays(5));

        when(memberStorage.find(1)).thenReturn(member);
        when(itemStorage.find("BOOK1")).thenReturn(item);
        when(borrowStorage.findActiveBorrow("BOOK1")).thenReturn(record);
        when(borrowStorage.hasOverdueBorrows(eq(1), any())).thenReturn(false);

        assertTrue(service.canRenewBorrow(1, "BOOK1"));
    }

    @Test
    void canRenewBorrow_returnsFalse_whenMemberNotFound() {
        when(memberStorage.find(1)).thenReturn(null);
        when(itemStorage.find("BOOK1")).thenReturn(new LibraryItem("BOOK1", true));
        when(borrowStorage.findActiveBorrow("BOOK1")).thenReturn(new BorrowRecord(1, "BOOK1", LocalDate.now().plusDays(5)));

        assertFalse(service.canRenewBorrow(1, "BOOK1"));
    }

    @Test
    void canRenewBorrow_returnsFalse_whenItemNotFound() {
        when(memberStorage.find(1)).thenReturn(new Member(1, true, MembershipType.STUDENT));
        when(itemStorage.find("BOOK1")).thenReturn(null);
        when(borrowStorage.findActiveBorrow("BOOK1")).thenReturn(new BorrowRecord(1, "BOOK1", LocalDate.now().plusDays(5)));

        assertFalse(service.canRenewBorrow(1, "BOOK1"));
    }

    @Test
    void canRenewBorrow_returnsFalse_whenNoActiveBorrow() {
        when(memberStorage.find(1)).thenReturn(new Member(1, true, MembershipType.STUDENT));
        when(itemStorage.find("BOOK1")).thenReturn(new LibraryItem("BOOK1", true));
        when(borrowStorage.findActiveBorrow("BOOK1")).thenReturn(null);

        assertFalse(service.canRenewBorrow(1, "BOOK1"));
    }

    @Test
    void canRenewBorrow_returnsFalse_whenNotTheBorrower() {
        Member member = new Member(1, true, MembershipType.STUDENT);
        LibraryItem item = new LibraryItem("BOOK1", true);
        BorrowRecord record = new BorrowRecord(2, "BOOK1", LocalDate.now().plusDays(5));

        when(memberStorage.find(1)).thenReturn(member);
        when(itemStorage.find("BOOK1")).thenReturn(item);
        when(borrowStorage.findActiveBorrow("BOOK1")).thenReturn(record);

        assertFalse(service.canRenewBorrow(1, "BOOK1"));
    }

    @Test
    void canRenewBorrow_returnsFalse_whenAlreadyReturned() {
        Member member = new Member(1, true, MembershipType.STUDENT);
        LibraryItem item = new LibraryItem("BOOK1", true);
        BorrowRecord record = new BorrowRecord(1, "BOOK1", LocalDate.now().plusDays(5));
        record.markReturned();

        when(memberStorage.find(1)).thenReturn(member);
        when(itemStorage.find("BOOK1")).thenReturn(item);
        when(borrowStorage.findActiveBorrow("BOOK1")).thenReturn(record);

        assertFalse(service.canRenewBorrow(1, "BOOK1"));
    }

    @Test
    void canRenewBorrow_returnsFalse_whenOverdue() {
        Member member = new Member(1, true, MembershipType.STUDENT);
        LibraryItem item = new LibraryItem("BOOK1", true);
        BorrowRecord record = new BorrowRecord(1, "BOOK1", LocalDate.now().minusDays(3));

        when(memberStorage.find(1)).thenReturn(member);
        when(itemStorage.find("BOOK1")).thenReturn(item);
        when(borrowStorage.findActiveBorrow("BOOK1")).thenReturn(record);

        assertFalse(service.canRenewBorrow(1, "BOOK1"));
    }

    @Test
    void canRenewBorrow_returnsFalse_whenMemberInactive() {
        Member member = new Member(1, false, MembershipType.STUDENT);
        LibraryItem item = new LibraryItem("BOOK1", true);
        BorrowRecord record = new BorrowRecord(1, "BOOK1", LocalDate.now().plusDays(5));

        when(memberStorage.find(1)).thenReturn(member);
        when(itemStorage.find("BOOK1")).thenReturn(item);
        when(borrowStorage.findActiveBorrow("BOOK1")).thenReturn(record);

        assertFalse(service.canRenewBorrow(1, "BOOK1"));
    }

    @Test
    void canRenewBorrow_returnsFalse_whenMemberHasOtherOverdueItems() {
        Member member = new Member(1, true, MembershipType.STUDENT);
        LibraryItem item = new LibraryItem("BOOK1", true);
        BorrowRecord record = new BorrowRecord(1, "BOOK1", LocalDate.now().plusDays(5));

        when(memberStorage.find(1)).thenReturn(member);
        when(itemStorage.find("BOOK1")).thenReturn(item);
        when(borrowStorage.findActiveBorrow("BOOK1")).thenReturn(record);
        when(borrowStorage.hasOverdueBorrows(eq(1), any())).thenReturn(true);

        assertFalse(service.canRenewBorrow(1, "BOOK1"));
    }

    // getTotalOverdueDays()
    @Test
    void getTotalOverdueDays_returns0_whenNoOverdueItems() {
        when(borrowStorage.findAll()).thenReturn(java.util.List.of(
                new BorrowRecord(1, "BOOK1", LocalDate.now().plusDays(5)),
                new BorrowRecord(1, "BOOK2", LocalDate.now().plusDays(3))
        ));

        assertEquals(0, service.getTotalOverdueDays(1));
    }

    @Test
    void getTotalOverdueDays_returnsSumOfOverdueDays_whenMultipleOverdueItems() {
        when(borrowStorage.findAll()).thenReturn(java.util.List.of(
                new BorrowRecord(1, "BOOK1", LocalDate.now().minusDays(5)),
                new BorrowRecord(1, "BOOK2", LocalDate.now().minusDays(3)),
                new BorrowRecord(2, "BOOK3", LocalDate.now().minusDays(10))
        ));

        assertEquals(8, service.getTotalOverdueDays(1));
    }

    @Test
    void getTotalOverdueDays_ignoresReturnedItems() {
        BorrowRecord returned = new BorrowRecord(1, "BOOK1", LocalDate.now().minusDays(5));
        returned.markReturned();

        when(borrowStorage.findAll()).thenReturn(java.util.List.of(
                returned,
                new BorrowRecord(1, "BOOK2", LocalDate.now().minusDays(3))
        ));

        assertEquals(3, service.getTotalOverdueDays(1));
    }

    @Test
    void getTotalOverdueDays_throws_whenMemberIdInvalid() {
        assertThrows(IllegalArgumentException.class, () -> service.getTotalOverdueDays(0));
    }

    // getDaysUntilDue()
    @ParameterizedTest
    @CsvSource({
            "5,5",
            "1,1",
            "0,0",
            "-3,-3"
    })
    void getDaysUntilDue_returnsCorrectDays(int daysUntilDue, int expected) {
        BorrowRecord record = new BorrowRecord(1, "BOOK1", LocalDate.now().plusDays(daysUntilDue));
        when(borrowStorage.findActiveBorrow("BOOK1")).thenReturn(record);

        assertEquals(expected, service.getDaysUntilDue("BOOK1"));
    }

    @Test
    void getDaysUntilDue_returns0_whenAlreadyReturned() {
        BorrowRecord record = new BorrowRecord(1, "BOOK1", LocalDate.now().plusDays(5));
        record.markReturned();
        when(borrowStorage.findActiveBorrow("BOOK1")).thenReturn(record);

        assertEquals(0, service.getDaysUntilDue("BOOK1"));
    }

    @Test
    void getDaysUntilDue_throws_whenNoActiveBorrow() {
        when(borrowStorage.findActiveBorrow("BOOK1")).thenReturn(null);

        assertThrows(IllegalStateException.class, () -> service.getDaysUntilDue("BOOK1"));
    }

    @Test
    void getDaysUntilDue_throws_whenItemCodeNull() {
        assertThrows(IllegalArgumentException.class, () -> service.getDaysUntilDue(null));
    }

    // calculateLateFeeWithDiscount()
    @ParameterizedTest
    @CsvSource({
            "10.0,0,10.0",
            "10.0,50,5.0",
            "10.0,100,0.0",
            "20.0,25,15.0",
            "15.0,10,13.5"
    })
    void calculateLateFeeWithDiscount_appliesDiscountCorrectly(double baseFine, int discount, double expected) {
        BorrowRecord record = new BorrowRecord(1, "BOOK1", LocalDate.now().minusDays(5));
        when(borrowStorage.findActiveBorrow("BOOK1")).thenReturn(record);
        when(penaltyPolicy.calculatePenalty(5)).thenReturn(baseFine);

        assertEquals(expected, service.calculateLateFeeWithDiscount("BOOK1", discount), 0.01);
    }

    @ParameterizedTest
    @CsvSource({
            "-1",
            "101",
            "150"
    })
    void calculateLateFeeWithDiscount_throws_whenDiscountInvalid(int invalidDiscount) {
        BorrowRecord record = new BorrowRecord(1, "BOOK1", LocalDate.now().minusDays(5));
        when(borrowStorage.findActiveBorrow("BOOK1")).thenReturn(record);

        assertThrows(IllegalArgumentException.class,
                () -> service.calculateLateFeeWithDiscount("BOOK1", invalidDiscount));
    }

    // getMembershipEligibility()
    @ParameterizedTest
    @CsvSource({
            "0,false,true,EXCELLENT_STANDING",
            "1,false,true,GOOD_STANDING",
            "2,false,true,GOOD_STANDING",
            "3,false,true,MODERATE_USAGE",
            "4,false,true,MODERATE_USAGE",
            "5,false,true,HEAVY_USAGE",
            "10,false,true,HEAVY_USAGE",
            "0,true,true,HAS_OVERDUE_ITEMS",
            "0,false,false,MEMBERSHIP_INACTIVE",
            "-1,false,true,INVALID_BORROW_COUNT"
    })
    void getMembershipEligibility_returnsExpectedStatus(int currentBorrows, boolean hasOverdue, boolean isActive, String expected) {
        assertEquals(expected, service.getMembershipEligibility(currentBorrows, hasOverdue, isActive));
    }

    // assessItemReturnStatus()
    @ParameterizedTest
    @CsvSource({
            "-5,EARLY_RETURN",
            "-1,EARLY_RETURN",
            "0,ON_TIME",
            "1,SLIGHTLY_LATE",
            "3,SLIGHTLY_LATE",
            "4,MODERATELY_LATE",
            "7,MODERATELY_LATE",
            "8,VERY_LATE",
            "14,VERY_LATE",
            "15,SEVERELY_OVERDUE",
            "30,SEVERELY_OVERDUE"
    })
    void assessItemReturnStatus_returnsExpectedStatus(int daysLate, String expected) {
        BorrowRecord record = new BorrowRecord(1, "BOOK1", LocalDate.now());
        when(borrowStorage.findActiveBorrow("BOOK1")).thenReturn(record);

        assertEquals(expected, service.assessItemReturnStatus("BOOK1", daysLate));
    }

    @Test
    void assessItemReturnStatus_returnsNO_ACTIVE_BORROW_whenNoRecord() {
        when(borrowStorage.findActiveBorrow("BOOK1")).thenReturn(null);

        assertEquals("NO_ACTIVE_BORROW", service.assessItemReturnStatus("BOOK1", 0));
    }

    @Test
    void assessItemReturnStatus_returnsALREADY_RETURNED_whenReturned() {
        BorrowRecord record = new BorrowRecord(1, "BOOK1", LocalDate.now());
        record.markReturned();
        when(borrowStorage.findActiveBorrow("BOOK1")).thenReturn(record);

        assertEquals("ALREADY_RETURNED", service.assessItemReturnStatus("BOOK1", 5));
    }

    // canBorrowItemType()
    @ParameterizedTest
    @CsvSource({
            "STUDENT,50,true",
            "STUDENT,100,true",
            "STUDENT,101,false",
            "STAFF,500,true",
            "STAFF,501,false",
            "GUEST,50,true",
            "GUEST,51,false"
    })
    void canBorrowItemType_respectsValueLimits(MembershipType type, int itemValue, boolean expected) {
        Member member = new Member(1, true, type);
        when(memberStorage.find(1)).thenReturn(member);
        when(borrowStorage.countActiveBorrows(1)).thenReturn(0);
        when(borrowStorage.hasOverdueBorrows(eq(1), any())).thenReturn(false);

        assertEquals(expected, service.canBorrowItemType(1, "BOOK", itemValue));
    }

    @Test
    void canBorrowItemType_returnsFalse_whenMemberIdInvalid() {
        assertFalse(service.canBorrowItemType(0, "BOOK", 50));
    }

    @Test
    void canBorrowItemType_returnsFalse_whenItemTypeNull() {
        assertFalse(service.canBorrowItemType(1, null, 50));
    }

    @Test
    void canBorrowItemType_returnsFalse_whenItemValueNegative() {
        assertFalse(service.canBorrowItemType(1, "BOOK", -1));
    }

    @Test
    void canBorrowItemType_returnsFalse_whenMemberNotFound() {
        when(memberStorage.find(1)).thenReturn(null);

        assertFalse(service.canBorrowItemType(1, "BOOK", 50));
    }

    @Test
    void canBorrowItemType_returnsFalse_whenMemberInactive() {
        Member member = new Member(1, false, MembershipType.STUDENT);
        when(memberStorage.find(1)).thenReturn(member);

        assertFalse(service.canBorrowItemType(1, "BOOK", 50));
    }

    @Test
    void canBorrowItemType_returnsFalse_whenNoCapacity() {
        Member member = new Member(1, true, MembershipType.STUDENT);
        when(memberStorage.find(1)).thenReturn(member);
        when(borrowStorage.countActiveBorrows(1)).thenReturn(3);

        assertFalse(service.canBorrowItemType(1, "BOOK", 50));
    }

    @Test
    void canBorrowItemType_returnsFalse_whenHasOverdue() {
        Member member = new Member(1, true, MembershipType.STUDENT);
        when(memberStorage.find(1)).thenReturn(member);
        when(borrowStorage.countActiveBorrows(1)).thenReturn(0);
        when(borrowStorage.hasOverdueBorrows(eq(1), any())).thenReturn(true);

        assertFalse(service.canBorrowItemType(1, "BOOK", 50));
    }

    // shouldSendReminder()
    @ParameterizedTest
    @CsvSource({
            "3,3,true",
            "2,3,false",
            "4,3,false",
            "0,0,true",
            "-1,2,true",
            "-5,3,true"
    })
    void shouldSendReminder_returnsExpected(int daysUntilDue, int daysBeforeDue, boolean expected) {
        BorrowRecord record = new BorrowRecord(1, "BOOK1", LocalDate.now().plusDays(daysUntilDue));
        when(borrowStorage.findActiveBorrow("BOOK1")).thenReturn(record);

        assertEquals(expected, service.shouldSendReminder("BOOK1", daysBeforeDue));
    }

    @ParameterizedTest
    @CsvSource({
            "-1",
            "8",
            "10"
    })
    void shouldSendReminder_returnsFalse_whenDaysBeforeDueOutOfRange(int invalidDays) {
        BorrowRecord record = new BorrowRecord(1, "BOOK1", LocalDate.now().plusDays(5));
        when(borrowStorage.findActiveBorrow("BOOK1")).thenReturn(record);

        assertFalse(service.shouldSendReminder("BOOK1", invalidDays));
    }

    @Test
    void shouldSendReminder_returnsFalse_whenNoActiveBorrow() {
        when(borrowStorage.findActiveBorrow("BOOK1")).thenReturn(null);

        assertFalse(service.shouldSendReminder("BOOK1", 3));
    }

    @Test
    void shouldSendReminder_returnsFalse_whenAlreadyReturned() {
        BorrowRecord record = new BorrowRecord(1, "BOOK1", LocalDate.now().plusDays(5));
        record.markReturned();
        when(borrowStorage.findActiveBorrow("BOOK1")).thenReturn(record);

        assertFalse(service.shouldSendReminder("BOOK1", 3));
    }
}