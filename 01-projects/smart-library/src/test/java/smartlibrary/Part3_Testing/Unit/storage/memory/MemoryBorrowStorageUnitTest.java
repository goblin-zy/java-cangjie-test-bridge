package smartlibrary.Part3_Testing.Unit.storage.memory;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.CsvSource;
import smartlibrary.model.BorrowRecord;
import smartlibrary.storage.memory.MemoryBorrowStorage;

import java.time.LocalDate;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

class MemoryBorrowStorageUnitTest {

    @Test 
    void save_shouldStoreRecord(){
        MemoryBorrowStorage storage = new MemoryBorrowStorage();
        BorrowRecord record = new BorrowRecord(1, "BOOK001", LocalDate.now().plusDays(7));
        
        storage.save(record);
        
        assertNotNull(storage.findActiveBorrow("BOOK001"));
        assertEquals(1, storage.countActiveBorrows(1));
    }
    
    @Test 
    void findActiveBorrow_shouldReturnMatchingNotReturnedRecord(){
        MemoryBorrowStorage storage = new MemoryBorrowStorage();
        BorrowRecord record = new BorrowRecord(1, "BOOK001", LocalDate.now().plusDays(7));
        storage.save(record);
        
        BorrowRecord found = storage.findActiveBorrow("BOOK001");
        
        assertNotNull(found);
        assertEquals("BOOK001", found.getItemCode());
        assertFalse(found.isReturned());
    }
    
    @Test 
    void findActiveBorrow_shouldReturnNullWhenNoMatchingRecord(){
        MemoryBorrowStorage storage = new MemoryBorrowStorage();
        
        BorrowRecord found = storage.findActiveBorrow("NONEXISTENT");
        
        assertNull(found);
    }
    
    @Test 
    void findActiveBorrow_shouldIgnoreReturnedRecords(){
        MemoryBorrowStorage storage = new MemoryBorrowStorage();
        BorrowRecord record = new BorrowRecord(1, "BOOK001", LocalDate.now().plusDays(7));
        storage.save(record);
        record.markReturned();
        
        BorrowRecord found = storage.findActiveBorrow("BOOK001");
        
        assertNull(found);
    }

    @ParameterizedTest
    @CsvSource({
        "1, 2",
        "2, 1",
        "3, 0"
    })
    void countActiveBorrows_shouldCountCorrectly(int memberId, int expected){
        MemoryBorrowStorage storage = new MemoryBorrowStorage();
        storage.save(new BorrowRecord(1, "BOOK001", LocalDate.now().plusDays(7)));
        storage.save(new BorrowRecord(1, "BOOK002", LocalDate.now().plusDays(7)));
        storage.save(new BorrowRecord(2, "BOOK003", LocalDate.now().plusDays(7)));
        
        assertEquals(expected, storage.countActiveBorrows(memberId));
    }

    @Test 
    void countActiveBorrows_shouldReturnZeroWhenNone(){
        MemoryBorrowStorage storage = new MemoryBorrowStorage();
        
        assertEquals(0, storage.countActiveBorrows(999));
    }
    
    @Test 
    void hasOverdueBorrows_shouldReturnTrueWhenMemberHasActiveOverdueBorrow(){
        MemoryBorrowStorage storage = new MemoryBorrowStorage();
        LocalDate pastDue = LocalDate.now().minusDays(5);
        BorrowRecord record = new BorrowRecord(1, "BOOK001", pastDue);
        storage.save(record);
        
        assertTrue(storage.hasOverdueBorrows(1, LocalDate.now()));
    }
    
    @Test 
    void hasOverdueBorrows_shouldReturnFalseWhenMemberHasNoOverdueBorrow(){
        MemoryBorrowStorage storage = new MemoryBorrowStorage();
        LocalDate futureDue = LocalDate.now().plusDays(5);
        BorrowRecord record = new BorrowRecord(1, "BOOK001", futureDue);
        storage.save(record);
        
        assertFalse(storage.hasOverdueBorrows(1, LocalDate.now()));
    }
    
    @Test 
    void hasOverdueBorrows_shouldIgnoreReturnedOverdueBorrow(){
        MemoryBorrowStorage storage = new MemoryBorrowStorage();
        LocalDate pastDue = LocalDate.now().minusDays(5);
        BorrowRecord record = new BorrowRecord(1, "BOOK001", pastDue);
        storage.save(record);
        record.markReturned();
        
        assertFalse(storage.hasOverdueBorrows(1, LocalDate.now()));
    }
    
    @Test 
    void findAll_shouldReturnAllSavedRecords(){
        MemoryBorrowStorage storage = new MemoryBorrowStorage();
        storage.save(new BorrowRecord(1, "BOOK001", LocalDate.now().plusDays(7)));
        storage.save(new BorrowRecord(2, "BOOK002", LocalDate.now().plusDays(7)));
        storage.save(new BorrowRecord(3, "BOOK003", LocalDate.now().plusDays(7)));
        
        List<BorrowRecord> all = storage.findAll();
        
        assertEquals(3, all.size());
    }
    
    @Test 
    void findByMember_returnsOnlyMemberRecords(){
        MemoryBorrowStorage storage = new MemoryBorrowStorage();
        storage.save(new BorrowRecord(1, "BOOK001", LocalDate.now().plusDays(7)));
        storage.save(new BorrowRecord(1, "BOOK002", LocalDate.now().plusDays(7)));
        storage.save(new BorrowRecord(2, "BOOK003", LocalDate.now().plusDays(7)));
        
        List<BorrowRecord> member1Records = storage.findByMember(1);
        
        assertEquals(2, member1Records.size());
        assertTrue(member1Records.stream().allMatch(r -> r.getMemberId() == 1));
    }
    
    @Test 
    void findByMember_returnsEmptyList_whenNoRecords(){
        MemoryBorrowStorage storage = new MemoryBorrowStorage();
        
        List<BorrowRecord> records = storage.findByMember(999);
        
        assertNotNull(records);
        assertTrue(records.isEmpty());
    }
}