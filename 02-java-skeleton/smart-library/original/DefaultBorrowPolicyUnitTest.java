package smartlibrary.Part3_Testing.Unit.policy;

import org.junit.jupiter.api.Test;
import smartlibrary.model.Member;
import smartlibrary.model.MembershipType;
import smartlibrary.policy.impl.DefaultBorrowPolicy;

import static org.junit.jupiter.api.Assertions.*;

public class DefaultBorrowPolicyUnitTest {

    @Test 
    void canBorrow_returnsFalse_whenMemberIsNull(){
        DefaultBorrowPolicy policy = new DefaultBorrowPolicy();
        
        assertFalse(policy.canBorrow(null, 0, false));
    }
    
    @Test 
    void canBorrow_returnsFalse_whenMemberInactive(){
        DefaultBorrowPolicy policy = new DefaultBorrowPolicy();
        Member inactiveMember = new Member(1, false, MembershipType.STUDENT);
        
        assertFalse(policy.canBorrow(inactiveMember, 0, false));
    }
    
    @Test 
    void canBorrow_returnsFalse_whenActiveBorrowsEqualsMax(){
        DefaultBorrowPolicy policy = new DefaultBorrowPolicy();
        Member member = new Member(1, true, MembershipType.STUDENT);
        int maxLoans = member.getMembershipType().getMaxLoans();
        
        assertFalse(policy.canBorrow(member, maxLoans, false));
    }
    
    @Test 
    void canBorrow_returnsTrue_whenActiveBorrowsLessThanMax_andNoOverdue_andMemberActive(){
        DefaultBorrowPolicy policy = new DefaultBorrowPolicy();
        Member member = new Member(1, true, MembershipType.STUDENT);
        
        assertTrue(policy.canBorrow(member, 0, false));
        assertTrue(policy.canBorrow(member, 1, false));
        assertTrue(policy.canBorrow(member, 2, false));
    }
    
    @Test 
    void canBorrow_returnsFalse_whenHasOverdueTrue(){
        DefaultBorrowPolicy policy = new DefaultBorrowPolicy();
        Member member = new Member(1, true, MembershipType.STUDENT);
        
        assertFalse(policy.canBorrow(member, 0, true));
    }
}