package smartlibrary.Part2_Testing.Sidrit_Rrustemi;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import smartlibrary.model.Member;
import smartlibrary.model.MembershipType;
import smartlibrary.policy.impl.DefaultBorrowPolicy;

class CodeCoverageTesting {

    private DefaultBorrowPolicy borrowPolicy;

    @BeforeEach
    void setUp() {
        borrowPolicy = new DefaultBorrowPolicy();
    }

    // ========================================================================
    // STATEMENT COVERAGE
    // ========================================================================
    // Statement Coverage: Need to execute all statements at least once
    // In this method, there is only 1 return statement
    // Any test that executes the method achieves statement coverage

    @Test
    void statementCoverage_ExecuteReturnStatement() {
        Member member = mock(Member.class);
        MembershipType type = mock(MembershipType.class);

        when(member.isActive()).thenReturn(true);
        when(member.getMembershipType()).thenReturn(type);
        when(type.getMaxLoans()).thenReturn(5);

        boolean result = borrowPolicy.canBorrow(member, 2, false);

        assertTrue(result, "Statement coverage: return statement executed");
    }

    // ========================================================================
    // BRANCH COVERAGE (Decision Coverage)
    // ========================================================================
    // Branch Coverage: Need each decision to evaluate to both true and false
    // Decision: (C1 && C2 && C3 && C4)
    // Need: Decision = True (at least once) and Decision = False (at least once)

    @Test
    void branchCoverage_DecisionTrue() {
        // Test case where entire decision evaluates to TRUE
        // C1=T, C2=T, C3=T, C4=T
        Member member = mock(Member.class);
        MembershipType type = mock(MembershipType.class);

        when(member.isActive()).thenReturn(true);
        when(member.getMembershipType()).thenReturn(type);
        when(type.getMaxLoans()).thenReturn(5);

        boolean result = borrowPolicy.canBorrow(member, 2, false);

        assertTrue(result, "Branch coverage: decision evaluates to TRUE");
    }

    @Test
    void branchCoverage_DecisionFalse() {
        // Test case where entire decision evaluates to FALSE
        // C1=F (member is null)
        boolean result = borrowPolicy.canBorrow(null, 2, false);

        assertFalse(result, "Branch coverage: decision evaluates to FALSE");
    }

    // ========================================================================
    // CONDITION COVERAGE
    // ========================================================================
    // Condition Coverage: Each individual condition must be true and false at least once
    // C1: member != null          (need T and F)
    // C2: member.isActive()       (need T and F)
    // C3: activeBorrows < maxLoans (need T and F)
    // C4: !hasOverdue             (need T and F)

    @Test
    void conditionCoverage_C1_True_memberNotNull() {
        // C1 = TRUE
        Member member = mock(Member.class);
        MembershipType type = mock(MembershipType.class);

        when(member.isActive()).thenReturn(true);
        when(member.getMembershipType()).thenReturn(type);
        when(type.getMaxLoans()).thenReturn(5);

        // All conditions TRUE -> decision TRUE
        assertTrue(borrowPolicy.canBorrow(member, 2, false));
    }

    @Test
    void conditionCoverage_C1_False_memberIsNull() {
        // C1 = FALSE
        // Short-circuit evaluation applies
        assertFalse(borrowPolicy.canBorrow(null, 0, false));
    }

    // -------- C2: member.isActive() --------

    @Test
    void conditionCoverage_C2_True_memberIsActive() {
        // C2 = TRUE
        Member member = mock(Member.class);
        MembershipType type = mock(MembershipType.class);

        when(member.isActive()).thenReturn(true);
        when(member.getMembershipType()).thenReturn(type);
        when(type.getMaxLoans()).thenReturn(5);

        // All conditions TRUE -> decision TRUE
        assertTrue(borrowPolicy.canBorrow(member, 1, false));
    }

    @Test
    void conditionCoverage_C2_False_memberIsInactive() {
        // C2 = FALSE
        Member member = mock(Member.class);
        MembershipType type = mock(MembershipType.class);

        when(member.isActive()).thenReturn(false);
        when(member.getMembershipType()).thenReturn(type);
        when(type.getMaxLoans()).thenReturn(5);

        // Decision becomes FALSE due to inactive member
        assertFalse(borrowPolicy.canBorrow(member, 1, false));
    }

    // -------- C3: currentLoans < maxLoans --------

    @Test
    void conditionCoverage_C3_True_loansBelowLimit() {
        // C3 = TRUE (1 < 5)
        Member member = mock(Member.class);
        MembershipType type = mock(MembershipType.class);

        when(member.isActive()).thenReturn(true);
        when(member.getMembershipType()).thenReturn(type);
        when(type.getMaxLoans()).thenReturn(5);

        assertTrue(borrowPolicy.canBorrow(member, 1, false));
    }

    @Test
    void conditionCoverage_C3_False_loansAtLimit() {
        // C3 = FALSE (2 < 2 is false)
        Member member = mock(Member.class);
        MembershipType type = mock(MembershipType.class);

        when(member.isActive()).thenReturn(true);
        when(member.getMembershipType()).thenReturn(type);
        when(type.getMaxLoans()).thenReturn(2);

        assertFalse(borrowPolicy.canBorrow(member, 2, false));
    }

    // -------- C4: !hasOverdueBooks --------

    @Test
    void conditionCoverage_C4_True_noOverdueBooks() {
        // C4 = TRUE (!false)
        Member member = mock(Member.class);
        MembershipType type = mock(MembershipType.class);

        when(member.isActive()).thenReturn(true);
        when(member.getMembershipType()).thenReturn(type);
        when(type.getMaxLoans()).thenReturn(5);

        assertTrue(borrowPolicy.canBorrow(member, 1, false));
    }

    @Test
    void conditionCoverage_C4_False_hasOverdueBooks() {
        // C4 = FALSE (!true)
        Member member = mock(Member.class);
        MembershipType type = mock(MembershipType.class);

        when(member.isActive()).thenReturn(true);
        when(member.getMembershipType()).thenReturn(type);
        when(type.getMaxLoans()).thenReturn(5);

        assertFalse(borrowPolicy.canBorrow(member, 1, true));
    }

    // ========================================================================
    // MC/DC COVERAGE (Modified Condition/Decision Coverage)
    // ========================================================================
    // MC/DC: Each condition must independently affect the decision outcome
    // For each condition Ci, need two test cases where:
    // - Ci differs (T->F or F->T)
    // - All other conditions stay the same
    // - Decision outcome changes

    // Base test case: C1=T, C2=T, C3=T, C4=T -> Decision=TRUE
    @Test
    void mcdc_BaseCase_AllTrue() {
        Member member = mock(Member.class);
        MembershipType type = mock(MembershipType.class);

        when(member.isActive()).thenReturn(true);
        when(member.getMembershipType()).thenReturn(type);
        when(type.getMaxLoans()).thenReturn(5);

        boolean result = borrowPolicy.canBorrow(member, 2, false);

        assertTrue(result, "MC/DC Base: All conditions true -> Decision TRUE");
    }

    // MC/DC for C1 (member != null)
    // Pair: Test1(C1=T, C2=T, C3=T, C4=T -> TRUE) vs Test2(C1=F, C2=T, C3=T, C4=T -> FALSE)
    @Test
    void mcdc_C1_IndependentEffect() {
        // When C1 changes from T to F, decision changes from TRUE to FALSE
        // C1=F, C2=T, C3=T, C4=T
        boolean result = borrowPolicy.canBorrow(null, 2, false);

        assertFalse(result, "MC/DC C1: Changing C1 from T to F changes decision from TRUE to FALSE");
    }

    // MC/DC for C2 (member.isActive())
    // Pair: Test1(C1=T, C2=T, C3=T, C4=T -> TRUE) vs Test3(C1=T, C2=F, C3=T, C4=T -> FALSE)
    @Test
    void mcdc_C2_IndependentEffect() {
        // When C2 changes from T to F, decision changes from TRUE to FALSE
        // C1=T, C2=F, C3=T, C4=T
        Member member = mock(Member.class);
        MembershipType type = mock(MembershipType.class);

        when(member.isActive()).thenReturn(false);
        when(member.getMembershipType()).thenReturn(type);
        when(type.getMaxLoans()).thenReturn(5);

        boolean result = borrowPolicy.canBorrow(member, 2, false);

        assertFalse(result, "MC/DC C2: Changing C2 from T to F changes decision from TRUE to FALSE");
    }

    // MC/DC for C3 (activeBorrows < maxLoans)
    // Pair: Test1(C1=T, C2=T, C3=T, C4=T -> TRUE) vs Test4(C1=T, C2=T, C3=F, C4=T -> FALSE)
    @Test
    void mcdc_C3_IndependentEffect() {
        // When C3 changes from T to F, decision changes from TRUE to FALSE
        // C1=T, C2=T, C3=F, C4=T
        Member member = mock(Member.class);
        MembershipType type = mock(MembershipType.class);

        when(member.isActive()).thenReturn(true);
        when(member.getMembershipType()).thenReturn(type);
        when(type.getMaxLoans()).thenReturn(5);

        boolean result = borrowPolicy.canBorrow(member, 5, false);

        assertFalse(result, "MC/DC C3: Changing C3 from T to F changes decision from TRUE to FALSE");
    }

    // MC/DC for C4 (!hasOverdue)
    // Pair: Test1(C1=T, C2=T, C3=T, C4=T -> TRUE) vs Test5(C1=T, C2=T, C3=T, C4=F -> FALSE)
    @Test
    void mcdc_C4_IndependentEffect() {
        // When C4 changes from T to F, decision changes from TRUE to FALSE
        // C1=T, C2=T, C3=T, C4=F
        Member member = mock(Member.class);
        MembershipType type = mock(MembershipType.class);

        when(member.isActive()).thenReturn(true);
        when(member.getMembershipType()).thenReturn(type);
        when(type.getMaxLoans()).thenReturn(5);

        boolean result = borrowPolicy.canBorrow(member, 2, true);

        assertFalse(result, "MC/DC C4: Changing C4 from T to F changes decision from TRUE to FALSE");
    }
}