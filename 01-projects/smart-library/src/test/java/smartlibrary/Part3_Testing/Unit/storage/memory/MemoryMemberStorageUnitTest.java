package smartlibrary.Part3_Testing.Unit.storage.memory;

import org.junit.jupiter.api.Test;
import smartlibrary.model.Member;
import smartlibrary.model.MembershipType;
import smartlibrary.storage.memory.MemoryMemberStorage;

import static org.junit.jupiter.api.Assertions.*;

class MemoryMemberStorageUnitTest {

    @Test 
    void save_shouldStoreMember(){
        MemoryMemberStorage storage = new MemoryMemberStorage();
        Member member = new Member(1, true, MembershipType.STUDENT);
        
        storage.save(member);
        
        assertNotNull(storage.find(1));
        assertEquals(member, storage.find(1));
    }
    
    @Test 
    void find_shouldReturnMemberWhenExists(){
        MemoryMemberStorage storage = new MemoryMemberStorage();
        Member member = new Member(1, true, MembershipType.STUDENT);
        storage.save(member);
        
        Member found = storage.find(1);
        
        assertNotNull(found);
        assertEquals(1, found.getId());
        assertEquals(MembershipType.STUDENT, found.getMembershipType());
    }
    
    @Test 
    void find_shouldReturnNullWhenNotExists(){
        MemoryMemberStorage storage = new MemoryMemberStorage();
        
        Member found = storage.find(999);
        
        assertNull(found);
    }
}