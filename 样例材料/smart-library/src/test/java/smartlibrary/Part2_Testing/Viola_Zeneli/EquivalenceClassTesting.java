package smartlibrary.Part2_Testing.Viola_Zeneli;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.CsvSource;
import smartlibrary.model.BorrowRecord;
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

/// VIOLA ZENELI

/*
 * Method under test:
 * DefaultCirculationService.assessItemReturnStatus(String itemCode, int daysLate)
 *
 * Testing technique: Weak Robust Equivalence Class Testing
 *
 * ECs covered:
 *   EC-1  Invalid itemCode
 *   EC-2  No active borrow
 *   EC-3  Already returned
 *   EC-4–EC-9  Active borrow, not returned (parameterized)
*/

class EquivalenceClassTesting {

    private DefaultCirculationService service;

    private ItemStorage itemStorage = mock(ItemStorage.class);
    private MemberStorage memberStorage = mock(MemberStorage.class);
    private BorrowStorage borrowStorage = mock(BorrowStorage.class);
    private BorrowPolicy borrowPolicy = mock(BorrowPolicy.class);
    private PenaltyPolicy penaltyPolicy = mock(PenaltyPolicy.class);
    private AlertService alertService = mock(AlertService.class);

    private static final String VALID_ITEM = "BOOK-001";

    // Fixed date used for deterministic tests
    private static final LocalDate FIXED_DUE_DATE = LocalDate.of(2026, 2, 21);

    @BeforeEach
    void setUp() {
        service = new DefaultCirculationService(
                itemStorage,
                memberStorage,
                borrowStorage,
                borrowPolicy,
                penaltyPolicy,
                alertService
        );
    }

    // EC_1
    @Test
    void EC1_invalidItemCode_shouldThrowException() {
        assertThrows(
                IllegalArgumentException.class,
                () -> service.assessItemReturnStatus(null, 2)
        );
    }

    // EC_2
    @Test
    void EC2_noActiveBorrow_shouldReturnNoActiveBorrow() {
        when(borrowStorage.findActiveBorrow("BOOK-404")).thenReturn(null);

        String result = service.assessItemReturnStatus("BOOK-404", 2);

        assertEquals("NO_ACTIVE_BORROW", result);
    }

    // EC_3
    @Test
    void EC3_alreadyReturnedItem_shouldReturnAlreadyReturned() {
        BorrowRecord record = new BorrowRecord(1, VALID_ITEM, FIXED_DUE_DATE);
        record.markReturned();

        when(borrowStorage.findActiveBorrow(VALID_ITEM)).thenReturn(record);

        String result = service.assessItemReturnStatus(VALID_ITEM, 2);

        assertEquals("ALREADY_RETURNED", result);
    }

    // EC_4 - EC_9 (Parameterized)
    @ParameterizedTest
    @CsvSource({
            "-1, EARLY_RETURN",
            "0, ON_TIME",
            "2, SLIGHTLY_LATE",
            "5, MODERATELY_LATE",
            "10, VERY_LATE",
            "20, SEVERELY_OVERDUE"
    })
    void EC4_to_EC9_activeBorrowNotReturned_cases(int daysLate, String expectedStatus) {

        BorrowRecord record = new BorrowRecord(1, VALID_ITEM, FIXED_DUE_DATE);

        when(borrowStorage.findActiveBorrow(VALID_ITEM)).thenReturn(record);

        String result = service.assessItemReturnStatus(VALID_ITEM, daysLate);

        assertEquals(expectedStatus, result);
    }
}

