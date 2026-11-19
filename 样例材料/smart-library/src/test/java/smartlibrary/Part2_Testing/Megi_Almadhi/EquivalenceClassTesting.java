package smartlibrary.Part2_Testing.Megi_Almadhi;

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

    // Testing what happens when we pass bad item codes
    
    @Test
    void testInvalidItemCode_Null() {
        // Passing null should throw an error
        assertThrows(IllegalArgumentException.class, 
            () -> circulationService.getFineCategory(null));
    }

    @Test
    void testInvalidItemCode_Empty() {
        // Empty string should also throw an error
        assertThrows(IllegalArgumentException.class, 
            () -> circulationService.getFineCategory(""));
    }

    @Test
    void testInvalidItemCode_WhitespaceOnly() {
        // Just spaces shouldn't work either
        assertThrows(IllegalArgumentException.class, 
            () -> circulationService.getFineCategory("   "));
    }

    // Testing when there's no borrow record for the item
    
    @Test
    void testNoActiveBorrow() {
        // If the item was never borrowed, we should get an error
        when(borrowStorage.findActiveBorrow(ITEM_CODE)).thenReturn(null);
        
        assertThrows(IllegalStateException.class, 
            () -> circulationService.getFineCategory(ITEM_CODE));
    }

    // Testing when the item has already been returned
    
    @Test
    void testReturnedItem() {
        // Book is already returned, so no fine
        BorrowRecord record = mock(BorrowRecord.class);
        when(record.isReturned()).thenReturn(true);
        when(borrowStorage.findActiveBorrow(ITEM_CODE)).thenReturn(record);
        
        String result = circulationService.getFineCategory(ITEM_CODE);
        
        assertEquals("NO_FINE_RETURNED", result);
    }

    // Testing when book is returned early or on time (not overdue)
    
    @Test
    void testOnTime_NegativeDays() {
        // Book returned 5 days early - no fine
        BorrowRecord record = mock(BorrowRecord.class);
        when(record.isReturned()).thenReturn(false);
        when(record.overdueDays(any(LocalDate.class))).thenReturn(-5);
        when(borrowStorage.findActiveBorrow(ITEM_CODE)).thenReturn(record);
        
        String result = circulationService.getFineCategory(ITEM_CODE);
        
        assertEquals("NO_FINE_ON_TIME", result);
    }

    @Test
    void testOnTime_ZeroDays() {
        // Book returned exactly on due date - no fine
        BorrowRecord record = mock(BorrowRecord.class);
        when(record.isReturned()).thenReturn(false);
        when(record.overdueDays(any(LocalDate.class))).thenReturn(0);
        when(borrowStorage.findActiveBorrow(ITEM_CODE)).thenReturn(record);
        
        String result = circulationService.getFineCategory(ITEM_CODE);
        
        assertEquals("NO_FINE_ON_TIME", result);
    }

    // Testing low fine category (1-5 days overdue)
    
    @Test
    void testLowFine_MinimumBoundary() {
        // 1 day late - should be low fine
        BorrowRecord record = mock(BorrowRecord.class);
        when(record.isReturned()).thenReturn(false);
        when(record.overdueDays(any(LocalDate.class))).thenReturn(1);
        when(borrowStorage.findActiveBorrow(ITEM_CODE)).thenReturn(record);
        
        String result = circulationService.getFineCategory(ITEM_CODE);
        
        assertEquals("LOW_FINE", result);
    }

    @Test
    void testLowFine_MiddleValue() {
        // 3 days late - still low fine
        BorrowRecord record = mock(BorrowRecord.class);
        when(record.isReturned()).thenReturn(false);
        when(record.overdueDays(any(LocalDate.class))).thenReturn(3);
        when(borrowStorage.findActiveBorrow(ITEM_CODE)).thenReturn(record);
        
        String result = circulationService.getFineCategory(ITEM_CODE);
        
        assertEquals("LOW_FINE", result);
    }

    @Test
    void testLowFine_MaximumBoundary() {
        // 5 days late - last day of low fine
        BorrowRecord record = mock(BorrowRecord.class);
        when(record.isReturned()).thenReturn(false);
        when(record.overdueDays(any(LocalDate.class))).thenReturn(5);
        when(borrowStorage.findActiveBorrow(ITEM_CODE)).thenReturn(record);
        
        String result = circulationService.getFineCategory(ITEM_CODE);
        
        assertEquals("LOW_FINE", result);
    }

    // Testing medium fine category (6-14 days overdue)
    
    @Test
    void testMediumFine_MinimumBoundary() {
        // 6 days late - now it's medium fine
        BorrowRecord record = mock(BorrowRecord.class);
        when(record.isReturned()).thenReturn(false);
        when(record.overdueDays(any(LocalDate.class))).thenReturn(6);
        when(borrowStorage.findActiveBorrow(ITEM_CODE)).thenReturn(record);
        
        String result = circulationService.getFineCategory(ITEM_CODE);
        
        assertEquals("MEDIUM_FINE", result);
    }

    @Test
    void testMediumFine_MiddleValue() {
        // 10 days late - middle of medium fine range
        BorrowRecord record = mock(BorrowRecord.class);
        when(record.isReturned()).thenReturn(false);
        when(record.overdueDays(any(LocalDate.class))).thenReturn(10);
        when(borrowStorage.findActiveBorrow(ITEM_CODE)).thenReturn(record);
        
        String result = circulationService.getFineCategory(ITEM_CODE);
        
        assertEquals("MEDIUM_FINE", result);
    }

    @Test
    void testMediumFine_MaximumBoundary() {
        // 14 days late - last day of medium fine
        BorrowRecord record = mock(BorrowRecord.class);
        when(record.isReturned()).thenReturn(false);
        when(record.overdueDays(any(LocalDate.class))).thenReturn(14);
        when(borrowStorage.findActiveBorrow(ITEM_CODE)).thenReturn(record);
        
        String result = circulationService.getFineCategory(ITEM_CODE);
        
        assertEquals("MEDIUM_FINE", result);
    }

    // Testing high fine category (more than 14 days overdue)
    
    @Test
    void testHighFine_JustOverBoundary() {
        // 15 days late - now it's high fine
        BorrowRecord record = mock(BorrowRecord.class);
        when(record.isReturned()).thenReturn(false);
        when(record.overdueDays(any(LocalDate.class))).thenReturn(15);
        when(borrowStorage.findActiveBorrow(ITEM_CODE)).thenReturn(record);
        
        String result = circulationService.getFineCategory(ITEM_CODE);
        
        assertEquals("HIGH_FINE", result);
    }

    @Test
    void testHighFine_VeryHighValue() {
        // 100 days late - way overdue, definitely high fine
        BorrowRecord record = mock(BorrowRecord.class);
        when(record.isReturned()).thenReturn(false);
        when(record.overdueDays(any(LocalDate.class))).thenReturn(100);
        when(borrowStorage.findActiveBorrow(ITEM_CODE)).thenReturn(record);
        
        String result = circulationService.getFineCategory(ITEM_CODE);
        
        assertEquals("HIGH_FINE", result);
    }
}