package smartlibrary.Part2_Testing.Arsildo_Veliu;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

import java.time.LocalDate;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import smartlibrary.model.Member;
import smartlibrary.model.MembershipType;
import smartlibrary.service.impl.DefaultCirculationService;
import smartlibrary.storage.BorrowStorage;
import smartlibrary.storage.MemberStorage;

@ExtendWith(MockitoExtension.class)
public class CodeCoverageTesting {

    @Mock
    private MemberStorage memberStorage;

    @Mock
    private BorrowStorage borrowStorage;

    @Mock
    private Member member;

    private DefaultCirculationService service;

    private static final int MEMBER_ID = 1;
    private static final LocalDate TODAY = LocalDate.now();

    @BeforeEach
    void setUp() {
        service = new DefaultCirculationService(
                mock(), memberStorage, borrowStorage, mock(), mock(), mock()
        );
    }

    //Statement Coverage

    @Test
    @DisplayName("Valid borrow - all statements executed")
    void validBorrowStatementCoverage() {
        validMemberSetup(MembershipType.STUDENT);

        boolean result = service.canBorrowItemType(MEMBER_ID, "BOOK", 50);

        assertTrue(result);
    }

    //Branch Coverage

    @Test
    @DisplayName("Invalid member id")
    void invalidMemberId() {
        assertFalse(service.canBorrowItemType(0, "BOOK", 10));
    }

    @Test
    @DisplayName("Null item type")
    void nullItemType() {
        assertFalse(service.canBorrowItemType(MEMBER_ID, null, 10));
    }

    @Test
    @DisplayName("Negative item value")
    void negativeItemValue() {
        assertFalse(service.canBorrowItemType(MEMBER_ID, "BOOK", -1));
    }

    @Test
    @DisplayName("Member not found")
    void memberNotFound() {
        when(memberStorage.find(MEMBER_ID)).thenReturn(null);

        assertFalse(service.canBorrowItemType(MEMBER_ID, "BOOK", 10));
    }

    //Condition Coverage

    @Test
    @DisplayName("Member is inactive")
    void inactiveMember() {
        validMemberSetup(MembershipType.STUDENT);
        when(member.isActive()).thenReturn(false);

        assertFalse(service.canBorrowItemType(MEMBER_ID, "BOOK", 50));
    }

    @Test
    @DisplayName("Borrow limit reached")
    void noBorrowCapacity() {
        validMemberSetup(MembershipType.STUDENT);
        when(borrowStorage.countActiveBorrows(MEMBER_ID)).thenReturn(5);

        assertFalse(service.canBorrowItemType(MEMBER_ID, "BOOK", 50));
    }

    @Test
    @DisplayName("Member has overdue items")
    void hasOverdueItems() {
        validMemberSetup(MembershipType.STUDENT);
        when(borrowStorage.hasOverdueBorrows(MEMBER_ID, TODAY)).thenReturn(true);

        assertFalse(service.canBorrowItemType(MEMBER_ID, "BOOK", 50));
    }

    @Test
    @DisplayName("Item value too high")
    void valueLimitExceeded() {
        validMemberSetup(MembershipType.STUDENT);

        assertFalse(service.canBorrowItemType(MEMBER_ID, "BOOK", 150));
    }

    //MC/DC

    @Test
    @DisplayName("MC/DC base case - all conditions true")
    void mcdcBaseCase() {
        validMemberSetup(MembershipType.STUDENT);

        assertTrue(service.canBorrowItemType(MEMBER_ID, "BOOK", 50));
    }

    @Test
    @DisplayName("MC/DC isActive flipped")
    void mcdcInactiveMember() {
        validMemberSetup(MembershipType.STUDENT);
        when(member.isActive()).thenReturn(false);

        assertFalse(service.canBorrowItemType(MEMBER_ID, "BOOK", 50));
    }

    @Test
    @DisplayName("MC/DC capacity flipped")
    void mcdcNoCapacity() {
        validMemberSetup(MembershipType.STUDENT);
        when(borrowStorage.countActiveBorrows(MEMBER_ID)).thenReturn(5);

        assertFalse(service.canBorrowItemType(MEMBER_ID, "BOOK", 50));
    }

    @Test
    @DisplayName("MC/DC overdue flipped")
    void mcdcOverdue() {
        validMemberSetup(MembershipType.STUDENT);
        when(borrowStorage.hasOverdueBorrows(MEMBER_ID, TODAY)).thenReturn(true);

        assertFalse(service.canBorrowItemType(MEMBER_ID, "BOOK", 50));
    }

    @Test
    @DisplayName("MC/DC value limit flipped")
    void mcdcValueLimit() {
        validMemberSetup(MembershipType.STUDENT);

        assertFalse(service.canBorrowItemType(MEMBER_ID, "BOOK", 150));
    }

    //Value limit check

    @Test
    @DisplayName("Staff member higher value limit")
    void staffValueLimit() {
        validMemberSetup(MembershipType.STAFF);

        assertTrue(service.canBorrowItemType(MEMBER_ID, "BOOK", 500));
    }

    @Test
    @DisplayName("Guest member lower value limit")
    void guestValueLimit() {
        validMemberSetup(MembershipType.GUEST);

        assertFalse(service.canBorrowItemType(MEMBER_ID, "BOOK", 100));
    }

    //helper

    // setup for a valid member that can borrow
    private void validMemberSetup(MembershipType type) {
        when(memberStorage.find(MEMBER_ID)).thenReturn(member);
        when(member.isActive()).thenReturn(true);
        when(member.getMembershipType()).thenReturn(type);
        when(borrowStorage.countActiveBorrows(MEMBER_ID)).thenReturn(1);
        when(borrowStorage.hasOverdueBorrows(MEMBER_ID, TODAY)).thenReturn(false);
    }
}
