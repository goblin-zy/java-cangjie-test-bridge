package smartlibrary.Part2_Testing.Viola_Zeneli;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.CsvSource;
import org.junit.jupiter.params.provider.ValueSource;
import smartlibrary.notification.AlertService;
import smartlibrary.policy.BorrowPolicy;
import smartlibrary.policy.PenaltyPolicy;
import smartlibrary.service.impl.DefaultCirculationService;
import smartlibrary.storage.BorrowStorage;
import smartlibrary.storage.ItemStorage;
import smartlibrary.storage.MemberStorage;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

/// VIOLA ZENELI

/*
 * Method under test:
 * DefaultCirculationService.calculateLateFeeWithDiscount(String itemCode, int discountPercent)
 *
 * Testing technique: Robust Boundary Value Testing
 * Boundaries tested for discountPercent: -1, 0, 1, 50 , 99, 100, 101
*/

class BoundaryValueTesting {

    // Constant test values
    private static final String VALID_ITEM_CODE = "BOOK-001";
    private static final double BASE_FINE = 50.0;

    // Class under test
    private DefaultCirculationService service;

    // Dependencies are mocked to isolate the method under test
    private ItemStorage itemStorage = mock(ItemStorage.class);
    private MemberStorage memberStorage = mock(MemberStorage.class);
    private BorrowStorage borrowStorage = mock(BorrowStorage.class);
    private BorrowPolicy borrowPolicy = mock(BorrowPolicy.class);
    private PenaltyPolicy penaltyPolicy = mock(PenaltyPolicy.class);
    private AlertService alertService = mock(AlertService.class);

    @BeforeEach
    void setUp() {
        // Real service is created so the tested method runs real logic
        DefaultCirculationService realService =
                new DefaultCirculationService(
                        itemStorage,
                        memberStorage,
                        borrowStorage,
                        borrowPolicy,
                        penaltyPolicy,
                        alertService
                );

        // Spy allows controlling calculateFine() while keeping real behavior (overriding it)
        service = spy(realService);

        // Base fine is fixed to make calculations predictable
        doReturn(BASE_FINE).when(service).calculateFine(VALID_ITEM_CODE);
    }

    /*
     * Valid boundary and nominal values
     * Verifies correct fee calculation at and around boundaries
    */
    @ParameterizedTest
    @CsvSource({
            "0, 50.0",     // min boundary
            "1, 49.5",     // just above min
            "50, 25.0",    // nominal value
            "99, 0.5",     // just below max
            "100, 0.0"     // max boundary
    })
    void validDiscounts_shouldReturnExpectedLateFee(int discount, double expected) {
        assertEquals(expected,
                service.calculateLateFeeWithDiscount(VALID_ITEM_CODE, discount));
    }

    /*
     * Invalid boundary values
     * Verifies exception handling outside the valid range
     */
    @ParameterizedTest
    @ValueSource(ints = {-1, 101})
    void invalidDiscounts_shouldThrowException(int discount) {
        assertThrows(IllegalArgumentException.class,
                () -> service.calculateLateFeeWithDiscount(VALID_ITEM_CODE, discount));
    }
}
