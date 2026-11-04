package smartlibrary.Part3_Testing.Unit.model;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.CsvSource;
import smartlibrary.model.BorrowRecord;

import java.time.LocalDate;

import static org.junit.jupiter.api.Assertions.*;

public class BorrowRecordUnitTest {

    @Test 
    void constructor_setsFields_andReturnedFalse(){
        LocalDate dueDate = LocalDate.now().plusDays(7);
        BorrowRecord record = new BorrowRecord(1, "BOOK001", dueDate);
        
        assertEquals(1, record.getMemberId());
        assertEquals("BOOK001", record.getItemCode());
        assertEquals(dueDate, record.getDueDate());
        assertFalse(record.isReturned());
        assertNotNull(record.getBorrowDate());
        assertNull(record.getReturnDate());
    }
    
    @Test 
    void markReturned_setsReturnedTrue(){
        BorrowRecord record = new BorrowRecord(1, "BOOK001", LocalDate.now().plusDays(7));
        record.markReturned();
        
        assertTrue(record.isReturned());
    }
    
    @Test 
    void markReturned_setsReturnDate(){
        BorrowRecord record = new BorrowRecord(1, "BOOK001", LocalDate.now().plusDays(7));
        record.markReturned();
        
        assertNotNull(record.getReturnDate());
        assertEquals(LocalDate.now(), record.getReturnDate());
    }

    @ParameterizedTest
    @CsvSource({
        "-1, false",
        "0, false",
        "1, true",
        "5, true"
    })
    void isOverdue_returnsExpected_basedOnDaysAfterDue(int daysAfterDue, boolean expected){
        LocalDate dueDate = LocalDate.now();
        BorrowRecord record = new BorrowRecord(1, "BOOK001", dueDate);
        LocalDate checkDate = dueDate.plusDays(daysAfterDue);
        
        assertEquals(expected, record.isOverdue(checkDate));
    }

    @ParameterizedTest
    @CsvSource({
        "0, 0",
        "1, 1",
        "5, 5",
        "10, 10"
    })
    void overdueDays_returnsCorrectDays(int daysAfterDue, int expectedDays){
        LocalDate dueDate = LocalDate.now();
        BorrowRecord record = new BorrowRecord(1, "BOOK001", dueDate);
        LocalDate checkDate = dueDate.plusDays(daysAfterDue);
        
        assertEquals(expectedDays, record.overdueDays(checkDate));
    }

    @Test 
    void overdueDays_returns0_whenReturned(){
        LocalDate dueDate = LocalDate.now().minusDays(5);
        BorrowRecord record = new BorrowRecord(1, "BOOK001", dueDate);
        record.markReturned();
        LocalDate checkDate = LocalDate.now();
        
        assertEquals(0, record.overdueDays(checkDate));
    }

    @ParameterizedTest
    @CsvSource({
        "0, Member ID must be positive",
        "-1, Member ID must be positive",
        "-100, Member ID must be positive"
    })
    void constructor_throws_whenMemberIdInvalid(int memberId, String expectedMessage){
        IllegalArgumentException exception = assertThrows(
            IllegalArgumentException.class,
            () -> new BorrowRecord(memberId, "BOOK001", LocalDate.now().plusDays(7))
        );
        
        assertEquals(expectedMessage, exception.getMessage());
    }

    @ParameterizedTest
    @CsvSource({
        "'', Item code cannot be null or empty",
        "'  ', Item code cannot be null or empty"
    })
    void constructor_throws_whenItemCodeInvalid(String itemCode, String expectedMessage){
        IllegalArgumentException exception = assertThrows(
            IllegalArgumentException.class,
            () -> new BorrowRecord(1, itemCode, LocalDate.now().plusDays(7))
        );
        
        assertEquals(expectedMessage, exception.getMessage());
    }

    @Test 
    void constructor_throws_whenItemCodeNull(){
        IllegalArgumentException exception = assertThrows(
            IllegalArgumentException.class,
            () -> new BorrowRecord(1, null, LocalDate.now().plusDays(7))
        );
        
        assertEquals("Item code cannot be null or empty", exception.getMessage());
    }
    
    @Test 
    void constructor_throws_whenDueDateNull(){
        IllegalArgumentException exception = assertThrows(
            IllegalArgumentException.class,
            () -> new BorrowRecord(1, "BOOK001", null)
        );
        
        assertEquals("Due date cannot be null", exception.getMessage());
    }
    
    @Test 
    void equals_returnsTrue_forSameRecord(){
        LocalDate dueDate = LocalDate.now().plusDays(7);
        BorrowRecord record1 = new BorrowRecord(1, "BOOK001", dueDate);
        BorrowRecord record2 = record1;
        
        assertTrue(record1.equals(record2));
    }
    
    @Test 
    void equals_returnsFalse_forDifferentRecord(){
        LocalDate dueDate = LocalDate.now().plusDays(7);
        BorrowRecord record1 = new BorrowRecord(1, "BOOK001", dueDate);
        BorrowRecord record2 = new BorrowRecord(2, "BOOK002", dueDate);
        
        assertFalse(record1.equals(record2));
    }
}