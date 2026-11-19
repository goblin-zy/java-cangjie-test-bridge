package smartlibrary.Part2_Testing.Arsildo_Veliu;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
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
public class BoundaryValueTesting {

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

    // Testing around the boundary of 0 (due date = today)
    // N = 0 represents the due date boundary

    @Test
    void testBelowBoundary_OneDayOverdue() {
        // N-1: Book is 1 day overdue (due date was yesterday)
        BorrowRecord record = mock(BorrowRecord.class);
        when(record.isReturned()).thenReturn(false);
        when(record.getDueDate()).thenReturn(LocalDate.now().minusDays(1));
        when(borrowStorage.findActiveBorrow(ITEM_CODE)).thenReturn(record);
        
        int result = circulationService.getDaysUntilDue(ITEM_CODE);
        
        assertEquals(-1, result);
    }

    @Test
    void testAtBoundary_DueToday() {
        // N: Book is due today (boundary case)
        BorrowRecord record = mock(BorrowRecord.class);
        when(record.isReturned()).thenReturn(false);
        when(record.getDueDate()).thenReturn(LocalDate.now());
        when(borrowStorage.findActiveBorrow(ITEM_CODE)).thenReturn(record);
        
        int result = circulationService.getDaysUntilDue(ITEM_CODE);
        
        assertEquals(0, result);
    }

    @Test
    void testAboveBoundary_OneDayUntilDue() {
        // N+1: Book is due tomorrow (1 day remaining)
        BorrowRecord record = mock(BorrowRecord.class);
        when(record.isReturned()).thenReturn(false);
        when(record.getDueDate()).thenReturn(LocalDate.now().plusDays(1));
        when(borrowStorage.findActiveBorrow(ITEM_CODE)).thenReturn(record);
        
        int result = circulationService.getDaysUntilDue(ITEM_CODE);
        
        assertEquals(1, result);
    }

    // Additional boundary tests for edge cases

    @Test
    void testInvalidItemCode_Null() {
        // Testing validation boundary
        assertThrows(IllegalArgumentException.class, 
            () -> circulationService.getDaysUntilDue(null));
    }

    @Test
    void testInvalidItemCode_Empty() {
        // Testing validation boundary
        assertThrows(IllegalArgumentException.class, 
            () -> circulationService.getDaysUntilDue(""));
    }

    @Test
    void testNoActiveBorrow() {
        // Testing when no borrow record exists
        when(borrowStorage.findActiveBorrow(ITEM_CODE)).thenReturn(null);
        
        assertThrows(IllegalStateException.class, 
            () -> circulationService.getDaysUntilDue(ITEM_CODE));
    }

    @Test
    void testReturnedBook() {
        // Testing returned book boundary (always returns 0)
        BorrowRecord record = mock(BorrowRecord.class);
        when(record.isReturned()).thenReturn(true);
        when(borrowStorage.findActiveBorrow(ITEM_CODE)).thenReturn(record);
        
        int result = circulationService.getDaysUntilDue(ITEM_CODE);
        
        assertEquals(0, result);
    }
}