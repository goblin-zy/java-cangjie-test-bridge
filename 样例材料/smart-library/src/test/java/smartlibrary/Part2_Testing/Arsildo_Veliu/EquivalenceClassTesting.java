package smartlibrary.Part2_Testing.Arsildo_Veliu;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.Mockito.*;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import smartlibrary.notification.AlertService;
import smartlibrary.policy.BorrowPolicy;
import smartlibrary.policy.PenaltyPolicy;
import smartlibrary.service.impl.DefaultCirculationService;
import smartlibrary.storage.BorrowStorage;
import smartlibrary.storage.ItemStorage;
import smartlibrary.storage.MemberStorage;

@ExtendWith(MockitoExtension.class)
public class EquivalenceClassTesting {

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

    // Class 1: Invalid Borrow Count (currentBorrows < 0)

    @Test
    void testInvalidBorrowCount_Negative() {
        // Testing with -1 (typical negative value)
        String result = circulationService.getMembershipEligibility(-1, false, true);
        assertEquals("INVALID_BORROW_COUNT", result);
    }

    @Test
    void testInvalidBorrowCount_LargeNegative() {
        // Testing with -100 (extreme negative value)
        String result = circulationService.getMembershipEligibility(-100, false, true);
        assertEquals("INVALID_BORROW_COUNT", result);
    }

    // Class 2: Inactive Membership (isActive = false)

    @Test
    void testInactiveMembership_NoBorrows() {
        // Member is inactive with no borrows
        String result = circulationService.getMembershipEligibility(0, false, false);
        assertEquals("MEMBERSHIP_INACTIVE", result);
    }

    @Test
    void testInactiveMembership_WithBorrows() {
        // Member is inactive with active borrows
        String result = circulationService.getMembershipEligibility(3, false, false);
        assertEquals("MEMBERSHIP_INACTIVE", result);
    }

    @Test
    void testInactiveMembership_WithOverdue() {
        // Member is inactive and has overdue items
        String result = circulationService.getMembershipEligibility(2, true, false);
        assertEquals("MEMBERSHIP_INACTIVE", result);
    }

    // Class 3: Has Overdue Items (hasOverdue = true, isActive = true)

    @Test
    void testHasOverdueItems_NoBorrows() {
        // Member has overdue items but no current borrows
        String result = circulationService.getMembershipEligibility(0, true, true);
        assertEquals("HAS_OVERDUE_ITEMS", result);
    }

    @Test
    void testHasOverdueItems_WithBorrows() {
        // Member has overdue items and current borrows
        String result = circulationService.getMembershipEligibility(3, true, true);
        assertEquals("HAS_OVERDUE_ITEMS", result);
    }

    // Class 4: Excellent Standing (currentBorrows == 0, no overdue, active)

    @Test
    void testExcellentStanding() {
        // Member has zero borrows, no overdue, and is active
        String result = circulationService.getMembershipEligibility(0, false, true);
        assertEquals("EXCELLENT_STANDING", result);
    }

    // Class 5: Good Standing (1 <= currentBorrows <= 2, no overdue, active)

    @Test
    void testGoodStanding_OneBorrow() {
        // Minimum boundary of good standing range
        String result = circulationService.getMembershipEligibility(1, false, true);
        assertEquals("GOOD_STANDING", result);
    }

    @Test
    void testGoodStanding_TwoBorrows() {
        // Maximum boundary of good standing range
        String result = circulationService.getMembershipEligibility(2, false, true);
        assertEquals("GOOD_STANDING", result);
    }

    // Class 6: Moderate Usage (3 <= currentBorrows <= 4, no overdue, active)

    @Test
    void testModerateUsage_ThreeBorrows() {
        // Minimum boundary of moderate usage range
        String result = circulationService.getMembershipEligibility(3, false, true);
        assertEquals("MODERATE_USAGE", result);
    }

    @Test
    void testModerateUsage_FourBorrows() {
        // Maximum boundary of moderate usage range
        String result = circulationService.getMembershipEligibility(4, false, true);
        assertEquals("MODERATE_USAGE", result);
    }

    // Class 7: Heavy Usage (currentBorrows > 4, no overdue, active)

    @Test
    void testHeavyUsage_FiveBorrows() {
        // Just above moderate usage boundary
        String result = circulationService.getMembershipEligibility(5, false, true);
        assertEquals("HEAVY_USAGE", result);
    }

    @Test
    void testHeavyUsage_TenBorrows() {
        // Typical heavy usage value
        String result = circulationService.getMembershipEligibility(10, false, true);
        assertEquals("HEAVY_USAGE", result);
    }

    @Test
    void testHeavyUsage_LargeBorrows() {
        // Extreme heavy usage value
        String result = circulationService.getMembershipEligibility(100, false, true);
        assertEquals("HEAVY_USAGE", result);
    }
}