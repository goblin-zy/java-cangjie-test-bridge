package smartlibrary.Part2_Testing.Megi_Almadhi;

import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.Mockito.*;

import java.time.LocalDate;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import smartlibrary.model.BorrowRecord;
import smartlibrary.notification.AlertService;
import smartlibrary.policy.BorrowPolicy;
import smartlibrary.policy.PenaltyPolicy;
import smartlibrary.service.impl.DefaultCirculationService;
import smartlibrary.storage.BorrowStorage;
import smartlibrary.storage.ItemStorage;
import smartlibrary.storage.MemberStorage;

@ExtendWith(MockitoExtension.class)
public class CodeCoverageTesting {

    @Mock
    private ItemStorage itemStorage;
    
    @Mock
    private BorrowStorage borrowStorage;

    @Mock
    private MemberStorage memberStorage;
    
    @Mock
    private BorrowPolicy borrowPolicy;
    
    @Mock
    private PenaltyPolicy penaltyPolicy;
    
    @Mock
    private AlertService alertService;

    private DefaultCirculationService circulationService;

    private static final String ITEM_CODE = "BOOK001";

    @BeforeEach
    void setup() {
        circulationService = new DefaultCirculationService(
            itemStorage,
            memberStorage,
            borrowStorage,
            borrowPolicy,
            penaltyPolicy,
            alertService
        );
    }

    // STATEMENT COVERAGE
    // Making sure every single line of code runs at least once

    @Test
    void testStatementCoverageWithNullItemCode() {
        // This makes the validation line throw an error
        assertThrows(IllegalArgumentException.class, 
            () -> circulationService.shouldSendReminder(null, 3));
    }

    @Test
    void testStatementCoverageWithInvalidDaysBeforeDue() {
        // This runs the line that checks if days is negative
        boolean result = circulationService.shouldSendReminder(ITEM_CODE, -1);
        assertFalse(result);
    }

    @Test
    void testStatementCoverageWithNoActiveBorrow() {
        // This runs the line that looks for a borrow record
        when(borrowStorage.findActiveBorrow(ITEM_CODE)).thenReturn(null);
        boolean result = circulationService.shouldSendReminder(ITEM_CODE, 3);
        assertFalse(result);
    }

    @Test
    void testStatementCoverageWithReturnedBook() {
        // This runs the line that checks if book is already returned
        BorrowRecord record = mock(BorrowRecord.class);
        when(record.isReturned()).thenReturn(true);
        when(borrowStorage.findActiveBorrow(ITEM_CODE)).thenReturn(record);
        boolean result = circulationService.shouldSendReminder(ITEM_CODE, 3);
        assertFalse(result);
    }

    @Test
    void testStatementCoverageWithExactMatch() {
        // This runs the lines that calculate days until due and check for exact match
        BorrowRecord record = mock(BorrowRecord.class);
        when(record.isReturned()).thenReturn(false);
        when(record.getDueDate()).thenReturn(LocalDate.now().plusDays(3));
        when(borrowStorage.findActiveBorrow(ITEM_CODE)).thenReturn(record);
        boolean result = circulationService.shouldSendReminder(ITEM_CODE, 3);
        assertTrue(result);
    }

    @Test
    void testStatementCoverageWithOverdueBook() {
        // This runs the line that checks if book is overdue
        BorrowRecord record = mock(BorrowRecord.class);
        when(record.isReturned()).thenReturn(false);
        when(record.getDueDate()).thenReturn(LocalDate.now().minusDays(2));
        when(borrowStorage.findActiveBorrow(ITEM_CODE)).thenReturn(record);
        boolean result = circulationService.shouldSendReminder(ITEM_CODE, 3);
        assertTrue(result);
    }

    // BRANCH COVERAGE
    // Making sure every if/else goes both ways (true and false)

    @Test
    void testBranchCoverageWhenDaysBeforeDueLessThanZeroIsTrue() {
        // Testing when "daysBeforeDue < 0" is TRUE
        boolean result = circulationService.shouldSendReminder(ITEM_CODE, -5);
        assertFalse(result);
    }

    @Test
    void testBranchCoverageWhenDaysBeforeDueLessThanZeroIsFalse() {
        // Testing when "daysBeforeDue < 0" is FALSE (it's not negative)
        when(borrowStorage.findActiveBorrow(ITEM_CODE)).thenReturn(null);
        boolean result = circulationService.shouldSendReminder(ITEM_CODE, 3);
        assertFalse(result);
    }

    @Test
    void testBranchCoverageWhenDaysBeforeDueGreaterThanSevenIsTrue() {
        // Testing when "daysBeforeDue > 7" is TRUE
        boolean result = circulationService.shouldSendReminder(ITEM_CODE, 10);
        assertFalse(result);
    }

    @Test
    void testBranchCoverageWhenDaysBeforeDueGreaterThanSevenIsFalse() {
        // Testing when "daysBeforeDue > 7" is FALSE (it's 7 or less)
        when(borrowStorage.findActiveBorrow(ITEM_CODE)).thenReturn(null);
        boolean result = circulationService.shouldSendReminder(ITEM_CODE, 5);
        assertFalse(result);
    }

    @Test
    void testBranchCoverageWhenRecordIsNull() {
        // Testing when "record == null" is TRUE (no record found)
        when(borrowStorage.findActiveBorrow(ITEM_CODE)).thenReturn(null);
        boolean result = circulationService.shouldSendReminder(ITEM_CODE, 3);
        assertFalse(result);
    }

    @Test
    void testBranchCoverageWhenRecordIsNotNull() {
        // Testing when "record == null" is FALSE (record exists)
        BorrowRecord record = mock(BorrowRecord.class);
        when(record.isReturned()).thenReturn(false);
        when(record.getDueDate()).thenReturn(LocalDate.now().plusDays(3));
        when(borrowStorage.findActiveBorrow(ITEM_CODE)).thenReturn(record);
        boolean result = circulationService.shouldSendReminder(ITEM_CODE, 3);
        assertTrue(result);
    }

    @Test
    void testBranchCoverageWhenRecordIsReturned() {
        // Testing when "record.isReturned()" is TRUE
        BorrowRecord record = mock(BorrowRecord.class);
        when(record.isReturned()).thenReturn(true);
        when(borrowStorage.findActiveBorrow(ITEM_CODE)).thenReturn(record);
        boolean result = circulationService.shouldSendReminder(ITEM_CODE, 3);
        assertFalse(result);
    }

    @Test
    void testBranchCoverageWhenRecordIsNotReturned() {
        // Testing when "record.isReturned()" is FALSE (still borrowed)
        BorrowRecord record = mock(BorrowRecord.class);
        when(record.isReturned()).thenReturn(false);
        when(record.getDueDate()).thenReturn(LocalDate.now().plusDays(3));
        when(borrowStorage.findActiveBorrow(ITEM_CODE)).thenReturn(record);
        boolean result = circulationService.shouldSendReminder(ITEM_CODE, 3);
        assertTrue(result);
    }

    @Test
    void testBranchCoverageWhenDaysUntilDueEqualsBeforeDue() {
        // Testing when "daysUntilDue == daysBeforeDue" is TRUE (perfect match)
        BorrowRecord record = mock(BorrowRecord.class);
        when(record.isReturned()).thenReturn(false);
        when(record.getDueDate()).thenReturn(LocalDate.now().plusDays(5));
        when(borrowStorage.findActiveBorrow(ITEM_CODE)).thenReturn(record);
        boolean result = circulationService.shouldSendReminder(ITEM_CODE, 5);
        assertTrue(result);
    }

    @Test
    void testBranchCoverageWhenDaysUntilDueDoesNotEqualBeforeDue() {
        // Testing when "daysUntilDue == daysBeforeDue" is FALSE (doesn't match)
        BorrowRecord record = mock(BorrowRecord.class);
        when(record.isReturned()).thenReturn(false);
        when(record.getDueDate()).thenReturn(LocalDate.now().plusDays(10));
        when(borrowStorage.findActiveBorrow(ITEM_CODE)).thenReturn(record);
        boolean result = circulationService.shouldSendReminder(ITEM_CODE, 3);
        assertFalse(result);
    }

    @Test
    void testBranchCoverageWhenDaysUntilDueIsNegative() {
        // Testing when "daysUntilDue < 0" is TRUE (book is overdue)
        BorrowRecord record = mock(BorrowRecord.class);
        when(record.isReturned()).thenReturn(false);
        when(record.getDueDate()).thenReturn(LocalDate.now().minusDays(3));
        when(borrowStorage.findActiveBorrow(ITEM_CODE)).thenReturn(record);
        boolean result = circulationService.shouldSendReminder(ITEM_CODE, 2);
        assertTrue(result);
    }

    @Test
    void testBranchCoverageWhenDaysUntilDueIsNotNegative() {
        // Testing when "daysUntilDue < 0" is FALSE (not overdue yet)
        BorrowRecord record = mock(BorrowRecord.class);
        when(record.isReturned()).thenReturn(false);
        when(record.getDueDate()).thenReturn(LocalDate.now().plusDays(7));
        when(borrowStorage.findActiveBorrow(ITEM_CODE)).thenReturn(record);
        boolean result = circulationService.shouldSendReminder(ITEM_CODE, 3);
        assertFalse(result);
    }

    // CONDITION COVERAGE
    // Testing each part of compound conditions (with || or &&) separately
    // Compound condition: (daysBeforeDue < 0 || daysBeforeDue > 7)

    @Test
    void testConditionCoverageFirstConditionTrue() {
        // Testing if "daysBeforeDue < 0" evaluates to TRUE
        boolean result = circulationService.shouldSendReminder(ITEM_CODE, -3);
        assertFalse(result);
    }

    @Test
    void testConditionCoverageFirstConditionFalse() {
        // Testing if "daysBeforeDue < 0" evaluates to FALSE
        when(borrowStorage.findActiveBorrow(ITEM_CODE)).thenReturn(null);
        boolean result = circulationService.shouldSendReminder(ITEM_CODE, 3);
        assertFalse(result);
    }

    @Test
    void testConditionCoverageSecondConditionTrue() {
        // Testing if "daysBeforeDue > 7" evaluates to TRUE
        boolean result = circulationService.shouldSendReminder(ITEM_CODE, 15);
        assertFalse(result);
    }

    @Test
    void testConditionCoverageSecondConditionFalse() {
        // Testing if "daysBeforeDue > 7" evaluates to FALSE
        when(borrowStorage.findActiveBorrow(ITEM_CODE)).thenReturn(null);
        boolean result = circulationService.shouldSendReminder(ITEM_CODE, 2);
        assertFalse(result);
    }

    // Compound condition: (record == null || record.isReturned())

    @Test
    void testConditionCoverageRecordNullTrue() {
        // Testing if "record == null" evaluates to TRUE
        when(borrowStorage.findActiveBorrow(ITEM_CODE)).thenReturn(null);
        boolean result = circulationService.shouldSendReminder(ITEM_CODE, 3);
        assertFalse(result);
    }

    @Test
    void testConditionCoverageRecordNullFalse() {
        // Testing if "record == null" evaluates to FALSE
        BorrowRecord record = mock(BorrowRecord.class);
        when(record.isReturned()).thenReturn(false);
        when(record.getDueDate()).thenReturn(LocalDate.now().plusDays(3));
        when(borrowStorage.findActiveBorrow(ITEM_CODE)).thenReturn(record);
        boolean result = circulationService.shouldSendReminder(ITEM_CODE, 3);
        assertTrue(result);
    }

    @Test
    void testConditionCoverageRecordIsReturnedTrue() {
        // Testing if "record.isReturned()" evaluates to TRUE
        BorrowRecord record = mock(BorrowRecord.class);
        when(record.isReturned()).thenReturn(true);
        when(borrowStorage.findActiveBorrow(ITEM_CODE)).thenReturn(record);
        boolean result = circulationService.shouldSendReminder(ITEM_CODE, 3);
        assertFalse(result);
    }

    @Test
    void testConditionCoverageRecordIsReturnedFalse() {
        // Testing if "record.isReturned()" evaluates to FALSE
        BorrowRecord record = mock(BorrowRecord.class);
        when(record.isReturned()).thenReturn(false);
        when(record.getDueDate()).thenReturn(LocalDate.now().plusDays(3));
        when(borrowStorage.findActiveBorrow(ITEM_CODE)).thenReturn(record);
        boolean result = circulationService.shouldSendReminder(ITEM_CODE, 3);
        assertTrue(result);
    }

    // MC/DC (Modified Condition/Decision Coverage)
    // Demonstrates that each condition independently affects the decision outcome
    // For compound condition: (daysBeforeDue < 0 || daysBeforeDue > 7)
    
    @Test
    void testMcdcDaysBeforeDueBothConditionsFalse() {
        // Base case: both conditions evaluate to FALSE
        // daysBeforeDue is within valid range (0 to 7)
        when(borrowStorage.findActiveBorrow(ITEM_CODE)).thenReturn(null);
        boolean result = circulationService.shouldSendReminder(ITEM_CODE, 3);
        assertFalse(result);
    }

    @Test
    void testMcdcDaysBeforeDueFirstConditionTrue() {
        // First condition "daysBeforeDue < 0" independently causes decision to be TRUE
        // Second condition remains FALSE
        boolean result = circulationService.shouldSendReminder(ITEM_CODE, -2);
        assertFalse(result);
    }

    @Test
    void testMcdcDaysBeforeDueSecondConditionTrue() {
        // Second condition "daysBeforeDue > 7" independently causes decision to be TRUE
        // First condition remains FALSE
        boolean result = circulationService.shouldSendReminder(ITEM_CODE, 10);
        assertFalse(result);
    }

    // For compound condition: (record == null || record.isReturned())
    
    @Test
    void testMcdcRecordBothConditionsFalse() {
        // Base case: both conditions evaluate to FALSE
        // Record exists and is not returned
        BorrowRecord record = mock(BorrowRecord.class);
        when(record.isReturned()).thenReturn(false);
        when(record.getDueDate()).thenReturn(LocalDate.now().plusDays(3));
        when(borrowStorage.findActiveBorrow(ITEM_CODE)).thenReturn(record);
        boolean result = circulationService.shouldSendReminder(ITEM_CODE, 3);
        assertTrue(result);
    }

    @Test
    void testMcdcRecordFirstConditionTrue() {
        // First condition "record == null" independently causes decision to be TRUE
        // This shows that a null record alone affects the outcome
        when(borrowStorage.findActiveBorrow(ITEM_CODE)).thenReturn(null);
        boolean result = circulationService.shouldSendReminder(ITEM_CODE, 3);
        assertFalse(result);
    }

    @Test
    void testMcdcRecordSecondConditionTrue() {
        // Second condition "record.isReturned()" independently causes decision to be TRUE
        // Record exists but is marked as returned
        BorrowRecord record = mock(BorrowRecord.class);
        when(record.isReturned()).thenReturn(true);
        when(borrowStorage.findActiveBorrow(ITEM_CODE)).thenReturn(record);
        boolean result = circulationService.shouldSendReminder(ITEM_CODE, 3);
        assertFalse(result);
    }
}