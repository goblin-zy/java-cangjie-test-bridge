package smartlibrary.Part2_Testing.Sidrit_Rrustemi;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

import java.time.LocalDate;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

import smartlibrary.model.Member;
import smartlibrary.model.MembershipType;
import smartlibrary.notification.AlertService;
import smartlibrary.policy.BorrowPolicy;
import smartlibrary.policy.PenaltyPolicy;
import smartlibrary.service.impl.DefaultCirculationService;
import smartlibrary.storage.BorrowStorage;
import smartlibrary.storage.ItemStorage;
import smartlibrary.storage.MemberStorage;

class EquivalenceClassTesting {

    @Mock
    private ItemStorage itemStorage;

    @Mock
    private MemberStorage memberStorage;

    @Mock
    private BorrowStorage borrowStorage;

    @Mock
    private BorrowPolicy borrowPolicy;

    @Mock
    private PenaltyPolicy penaltyPolicy;

    @Mock
    private AlertService alertService;

    private DefaultCirculationService circulationService;

    @BeforeEach
    void setUp() {
        MockitoAnnotations.openMocks(this);

        circulationService = new DefaultCirculationService(
                itemStorage,
                memberStorage,
                borrowStorage,
                borrowPolicy,
                penaltyPolicy,
                alertService
        );
    }

    // Equivalence Class 1: Invalid Member ID (memberId <= 0)
    @Test
    void testInvalidMemberId() {
        assertEquals("INVALID_MEMBER_ID", circulationService.validateMemberStatus(0));
    }

    // Equivalence Class 2: Member Not Found (valid ID but doesn't exist)
    @Test
    void testMemberNotFound() {
        when(memberStorage.find(1)).thenReturn(null);

        assertEquals("MEMBER_NOT_FOUND", circulationService.validateMemberStatus(1));
    }

    // Equivalence Class 3: Suspended - Multiple Issues (inactive + overdue + at capacity)
    @Test
    void testSuspendedMultipleIssues() {
        Member member = mock(Member.class);
        MembershipType type = mock(MembershipType.class);

        when(member.isActive()).thenReturn(false);
        when(member.getMembershipType()).thenReturn(type);
        when(type.getMaxLoans()).thenReturn(3);
        when(memberStorage.find(2)).thenReturn(member);

        when(borrowStorage.hasOverdueBorrows(eq(2), any(LocalDate.class))).thenReturn(true);
        when(borrowStorage.countActiveBorrows(2)).thenReturn(3);

        String result = circulationService.validateMemberStatus(2);

        assertEquals("SUSPENDED_MULTIPLE_ISSUES", result);
    }

    // Equivalence Class 4: Suspended - Inactive and Overdue (inactive + overdue, not at capacity)
    @Test
    void testSuspendedInactiveOverdue() {
        Member member = mock(Member.class);
        MembershipType type = mock(MembershipType.class);

        when(member.isActive()).thenReturn(false);
        when(member.getMembershipType()).thenReturn(type);
        when(type.getMaxLoans()).thenReturn(5);
        when(memberStorage.find(3)).thenReturn(member);

        when(borrowStorage.hasOverdueBorrows(eq(3), any(LocalDate.class))).thenReturn(true);
        when(borrowStorage.countActiveBorrows(3)).thenReturn(2);

        String result = circulationService.validateMemberStatus(3);

        assertEquals("SUSPENDED_INACTIVE_OVERDUE", result);
    }

    // Equivalence Class 5: Suspended - Inactive and At Capacity (inactive + at capacity, no overdue)
    @Test
    void testSuspendedInactiveCapacity() {
        Member member = mock(Member.class);
        MembershipType type = mock(MembershipType.class);

        when(member.isActive()).thenReturn(false);
        when(member.getMembershipType()).thenReturn(type);
        when(type.getMaxLoans()).thenReturn(3);
        when(memberStorage.find(4)).thenReturn(member);

        when(borrowStorage.hasOverdueBorrows(eq(4), any(LocalDate.class))).thenReturn(false);
        when(borrowStorage.countActiveBorrows(4)).thenReturn(3);

        String result = circulationService.validateMemberStatus(4);

        assertEquals("SUSPENDED_INACTIVE_CAPACITY", result);
    }

    // Equivalence Class 6: Restricted - Overdue and At Capacity (active + overdue + at capacity)
    @Test
    void testRestrictedOverdueCapacity() {
        Member member = mock(Member.class);
        MembershipType type = mock(MembershipType.class);

        when(member.isActive()).thenReturn(true);
        when(member.getMembershipType()).thenReturn(type);
        when(type.getMaxLoans()).thenReturn(4);
        when(memberStorage.find(5)).thenReturn(member);

        when(borrowStorage.hasOverdueBorrows(eq(5), any(LocalDate.class))).thenReturn(true);
        when(borrowStorage.countActiveBorrows(5)).thenReturn(4);

        String result = circulationService.validateMemberStatus(5);

        assertEquals("RESTRICTED_OVERDUE_CAPACITY", result);
    }

    // Equivalence Class 7: Inactive (only inactive, no other issues)
    @Test
    void testInactive() {
        Member member = mock(Member.class);
        MembershipType type = mock(MembershipType.class);

        when(member.isActive()).thenReturn(false);
        when(member.getMembershipType()).thenReturn(type);
        when(type.getMaxLoans()).thenReturn(5);
        when(memberStorage.find(6)).thenReturn(member);

        when(borrowStorage.hasOverdueBorrows(eq(6), any(LocalDate.class))).thenReturn(false);
        when(borrowStorage.countActiveBorrows(6)).thenReturn(1);

        String result = circulationService.validateMemberStatus(6);

        assertEquals("INACTIVE", result);
    }

    // Equivalence Class 8: Overdue Items (active + overdue, not at capacity)
    @Test
    void testOverdueItems() {
        Member member = mock(Member.class);
        MembershipType type = mock(MembershipType.class);

        when(member.isActive()).thenReturn(true);
        when(member.getMembershipType()).thenReturn(type);
        when(type.getMaxLoans()).thenReturn(5);
        when(memberStorage.find(7)).thenReturn(member);

        when(borrowStorage.hasOverdueBorrows(eq(7), any(LocalDate.class))).thenReturn(true);
        when(borrowStorage.countActiveBorrows(7)).thenReturn(2);

        String result = circulationService.validateMemberStatus(7);

        assertEquals("OVERDUE_ITEMS", result);
    }

    // Equivalence Class 9: At Capacity (active + at capacity, no overdue)
    @Test
    void testAtCapacity() {
        Member member = mock(Member.class);
        MembershipType type = mock(MembershipType.class);

        when(member.isActive()).thenReturn(true);
        when(member.getMembershipType()).thenReturn(type);
        when(type.getMaxLoans()).thenReturn(3);
        when(memberStorage.find(8)).thenReturn(member);

        when(borrowStorage.hasOverdueBorrows(eq(8), any(LocalDate.class))).thenReturn(false);
        when(borrowStorage.countActiveBorrows(8)).thenReturn(3);

        String result = circulationService.validateMemberStatus(8);

        assertEquals("AT_CAPACITY", result);
    }

    // Equivalence Class 10: Active Good Standing (active, no overdue, not at capacity)
    @Test
    void testActiveGoodStanding() {
        Member member = mock(Member.class);
        MembershipType type = mock(MembershipType.class);

        when(member.isActive()).thenReturn(true);
        when(member.getMembershipType()).thenReturn(type);
        when(type.getMaxLoans()).thenReturn(5);
        when(memberStorage.find(9)).thenReturn(member);

        when(borrowStorage.hasOverdueBorrows(eq(9), any(LocalDate.class))).thenReturn(false);
        when(borrowStorage.countActiveBorrows(9)).thenReturn(1);

        String result = circulationService.validateMemberStatus(9);

        assertEquals("ACTIVE_GOOD_STANDING", result);
    }
}