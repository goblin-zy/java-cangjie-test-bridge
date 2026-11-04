package smartlibrary.Part3_Testing.BottomUp_Integration;

import org.junit.jupiter.api.Test;
import smartlibrary.model.*;
import smartlibrary.storage.memory.*;
import java.time.LocalDate;

import static org.junit.jupiter.api.Assertions.*;

// Storage-only integration (Memory storages together)

class A_MemoryStoragesIntegrationTest {

    @Test void saveMember_thenFind_returnsSameMember() {
        MemoryMemberStorage storage = new MemoryMemberStorage();
        Member member = new Member(1, true, MembershipType.STUDENT);
        
        storage.save(member);
        Member found = storage.find(1);
        
        assertNotNull(found);
        assertEquals(1, found.getId());
        assertTrue(found.isActive());
        assertEquals(MembershipType.STUDENT, found.getMembershipType());
    }
    
    @Test void saveItem_thenFind_returnsSameItem() {
        MemoryItemStorage storage = new MemoryItemStorage();
        LibraryItem item = new LibraryItem("BOOK001", true);
        
        storage.save(item);
        LibraryItem found = storage.find("BOOK001");
        
        assertNotNull(found);
        assertEquals("BOOK001", found.getCode());
        assertTrue(found.isAvailable());
    }
    
    @Test void updateAvailability_changesItemAvailability() {
        MemoryItemStorage storage = new MemoryItemStorage();
        LibraryItem item = new LibraryItem("BOOK002", true);
        storage.save(item);
        
        storage.updateAvailability("BOOK002", false);
        
        LibraryItem found = storage.find("BOOK002");
        assertFalse(found.isAvailable());
    }
    
    @Test void saveBorrowRecord_thenFindActiveBorrow_returnsRecord() {
        MemoryBorrowStorage storage = new MemoryBorrowStorage();
        LocalDate dueDate = LocalDate.now().plusDays(7);
        BorrowRecord record = new BorrowRecord(1, "BOOK001", dueDate);
        
        storage.save(record);
        BorrowRecord found = storage.findActiveBorrow("BOOK001");
        
        assertNotNull(found);
        assertEquals(1, found.getMemberId());
        assertEquals("BOOK001", found.getItemCode());
        assertFalse(found.isReturned());
    }
    
    @Test void findActiveBorrow_whenReturned_returnsNull() {
        MemoryBorrowStorage storage = new MemoryBorrowStorage();
        LocalDate dueDate = LocalDate.now().plusDays(7);
        BorrowRecord record = new BorrowRecord(1, "BOOK001", dueDate);
        storage.save(record);
        
        record.markReturned();
        BorrowRecord found = storage.findActiveBorrow("BOOK001");
        
        assertNull(found);
    }
    
    @Test void countActiveBorrows_countsOnlyNotReturned() {
        MemoryBorrowStorage storage = new MemoryBorrowStorage();
        LocalDate dueDate = LocalDate.now().plusDays(7);
        
        BorrowRecord record1 = new BorrowRecord(1, "BOOK001", dueDate);
        BorrowRecord record2 = new BorrowRecord(1, "BOOK002", dueDate);
        BorrowRecord record3 = new BorrowRecord(1, "BOOK003", dueDate);
        
        storage.save(record1);
        storage.save(record2);
        storage.save(record3);
        
        record2.markReturned();
        
        int count = storage.countActiveBorrows(1);
        assertEquals(2, count);
    }
    
    @Test void hasOverdueBorrows_whenAnyOverdueAndNotReturned_returnsTrue() {
        MemoryBorrowStorage storage = new MemoryBorrowStorage();
        LocalDate pastDue = LocalDate.now().minusDays(5);
        BorrowRecord record = new BorrowRecord(1, "BOOK001", pastDue);
        storage.save(record);
        
        boolean hasOverdue = storage.hasOverdueBorrows(1, LocalDate.now());
        
        assertTrue(hasOverdue);
    }
    
    @Test void findAll_returnsAllSavedRecords() {
        MemoryBorrowStorage storage = new MemoryBorrowStorage();
        LocalDate dueDate = LocalDate.now().plusDays(7);
        
        BorrowRecord record1 = new BorrowRecord(1, "BOOK001", dueDate);
        BorrowRecord record2 = new BorrowRecord(2, "BOOK002", dueDate);
        
        storage.save(record1);
        storage.save(record2);
        
        var allRecords = storage.findAll();
        
        assertEquals(2, allRecords.size());
    }

}
