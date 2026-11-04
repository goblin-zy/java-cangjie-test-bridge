package smartlibrary.Part3_Testing.Unit.model;

import org.junit.jupiter.api.Test;
import smartlibrary.model.LibraryItem;

import static org.junit.jupiter.api.Assertions.*;

public class LibraryItemUnitTest {

    @Test 
    void constructor_setsCodeAndAvailability(){
        LibraryItem item = new LibraryItem("BOOK001", true);
        
        assertEquals("BOOK001", item.getCode());
        assertTrue(item.isAvailable());
    }
    
    @Test 
    void setAvailable_updatesAvailability(){
        LibraryItem item = new LibraryItem("BOOK001", true);
        
        item.setAvailable(false);
        assertFalse(item.isAvailable());
        
        item.setAvailable(true);
        assertTrue(item.isAvailable());
    }
}