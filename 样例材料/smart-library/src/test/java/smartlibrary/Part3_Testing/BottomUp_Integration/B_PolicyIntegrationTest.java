package smartlibrary.Part3_Testing.BottomUp_Integration;

import org.junit.jupiter.api.Test;
import smartlibrary.model.*;
import smartlibrary.policy.*;
import smartlibrary.policy.impl.*;

import static org.junit.jupiter.api.Assertions.*;

class B_PolicyIntegrationTest {

    @Test void borrowPolicy_withRealMember_rejectsInactive() {
        BorrowPolicy policy = new DefaultBorrowPolicy();
        Member inactiveMember = new Member(1, false, MembershipType.STUDENT);
        
        boolean canBorrow = policy.canBorrow(inactiveMember, 0, false);
        
        assertFalse(canBorrow);
    }
    
    @Test void borrowPolicy_withRealMember_rejectsAtCapacity() {
        BorrowPolicy policy = new DefaultBorrowPolicy();
        Member member = new Member(1, true, MembershipType.STUDENT);
        int activeBorrows = 3; // STUDENT max is 3
        
        boolean canBorrow = policy.canBorrow(member, activeBorrows, false);
        
        assertFalse(canBorrow);
    }
    
    @Test void borrowPolicy_withRealMember_rejectsWhenOverdue() {
        BorrowPolicy policy = new DefaultBorrowPolicy();
        Member member = new Member(1, true, MembershipType.STUDENT);
        
        boolean canBorrow = policy.canBorrow(member, 0, true);
        
        assertFalse(canBorrow);
    }
    
    @Test void borrowPolicy_withRealMember_allowsWhenAllGood() {
        BorrowPolicy policy = new DefaultBorrowPolicy();
        Member member = new Member(1, true, MembershipType.STUDENT);
        
        boolean canBorrow = policy.canBorrow(member, 0, false);
        
        assertTrue(canBorrow);
    }

    @Test void penaltyPolicy_calculatesCorrectFine_for1DayOverdue() {
        PenaltyPolicy policy = new DefaultPenaltyPolicy();
        
        double fine = policy.calculatePenalty(1);
        
        assertEquals(1.0, fine, 0.01); // 1 day * $1.00
    }
    
    @Test void penaltyPolicy_calculatesCorrectFine_for5DaysOverdue() {
        PenaltyPolicy policy = new DefaultPenaltyPolicy();
        
        double fine = policy.calculatePenalty(5);
        
        assertEquals(5.0, fine, 0.01); // 5 days * $1.00 (within grace period)
    }
    
    @Test void penaltyPolicy_calculatesCorrectFine_for6DaysOverdue() {
        PenaltyPolicy policy = new DefaultPenaltyPolicy();
        
        double fine = policy.calculatePenalty(6);
        
        assertEquals(12.0, fine, 0.01); // 6 days * $2.00 (after grace period)
    }
    
    @Test void penaltyPolicy_capsAt100_for50PlusDaysOverdue() {
        PenaltyPolicy policy = new DefaultPenaltyPolicy();
        
        double fine = policy.calculatePenalty(60);
        
        assertEquals(100.0, fine, 0.01); // Capped at $100
    }
}