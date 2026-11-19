package smartlibrary.Part3_Testing.Unit.model;

import org.junit.jupiter.api.Test;
import smartlibrary.model.Member;
import smartlibrary.model.MembershipType;

import static org.junit.jupiter.api.Assertions.*;

public class MemberUnitTest {

    @Test 
    void constructor_setsIdActiveMembershipType(){
        Member member = new Member(1, true, MembershipType.STUDENT);
        
        assertEquals(1, member.getId());
        assertTrue(member.isActive());
        assertEquals(MembershipType.STUDENT, member.getMembershipType());
    }
}