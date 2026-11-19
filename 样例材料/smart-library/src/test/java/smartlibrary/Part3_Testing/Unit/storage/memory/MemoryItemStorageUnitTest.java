package smartlibrary.Part3_Testing.Unit.storage.memory;

import org.junit.jupiter.api.Test;
import smartlibrary.model.LibraryItem;
import smartlibrary.storage.memory.MemoryItemStorage;

import static org.junit.jupiter.api.Assertions.*;

class MemoryItemStorageUnitTest {

    @Test 
    void save_shouldStoreItem(){
        MemoryItemStorage storage = new MemoryItemStorage();
        LibraryItem item = new LibraryItem("BOOK001", true);
        
        storage.save(item);
        
        assertNotNull(storage.find("BOOK001"));
        assertEquals(item, storage.find("BOOK001"));
    }
    
    @Test 
    void find_shouldReturnItemWhenExists(){
        MemoryItemStorage storage = new MemoryItemStorage();
        LibraryItem item = new LibraryItem("BOOK001", true);
        storage.save(item);
        
        LibraryItem found = storage.find("BOOK001");
        
        assertNotNull(found);
        assertEquals("BOOK001", found.getCode());
        assertTrue(found.isAvailable());
    }
    
    @Test 
    void find_shouldReturnNullWhenNotExists(){
        MemoryItemStorage storage = new MemoryItemStorage();
        
        LibraryItem found = storage.find("NONEXISTENT");
        
        assertNull(found);
    }
    
    @Test 
    void updateAvailability_shouldChangeAvailabilityWhenItemExists(){
        MemoryItemStorage storage = new MemoryItemStorage();
        LibraryItem item = new LibraryItem("BOOK001", true);
        storage.save(item);
        
        storage.updateAvailability("BOOK001", false);
        
        assertFalse(storage.find("BOOK001").isAvailable());
        
        storage.updateAvailability("BOOK001", true);
        
        assertTrue(storage.find("BOOK001").isAvailable());
    }
    
    @Test 
    void updateAvailability_shouldDoNothingWhenItemNotExists(){
        MemoryItemStorage storage = new MemoryItemStorage();
        
        // Should not throw exception
        assertDoesNotThrow(() -> storage.updateAvailability("NONEXISTENT", false));
    }
}