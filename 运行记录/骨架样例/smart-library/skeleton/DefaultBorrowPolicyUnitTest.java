package smartlibrary.Part3_Testing.Unit.policy;

import org.junit.jupiter.api.Test;
import smartlibrary.model.Member;
import smartlibrary.model.MembershipType;
import smartlibrary.policy.impl.DefaultBorrowPolicy;

import static org.junit.jupiter.api.Assertions.*;

public class DefaultBorrowPolicyUnitTest {

    @Test 
    void canBorrow_returnsFalse_whenMemberIsNull(){
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }
    
    @Test 
    void canBorrow_returnsFalse_whenMemberInactive(){
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }
    
    @Test 
    void canBorrow_returnsFalse_whenActiveBorrowsEqualsMax(){
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }
    
    @Test 
    void canBorrow_returnsTrue_whenActiveBorrowsLessThanMax_andNoOverdue_andMemberActive(){
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }
    
    @Test 
    void canBorrow_returnsFalse_whenHasOverdueTrue(){
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }
}