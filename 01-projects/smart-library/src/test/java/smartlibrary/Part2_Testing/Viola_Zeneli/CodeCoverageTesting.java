package smartlibrary.Part2_Testing.Viola_Zeneli;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import smartlibrary.model.BorrowRecord;
import smartlibrary.model.LibraryItem;
import smartlibrary.model.Member;
import smartlibrary.notification.AlertService;
import smartlibrary.policy.BorrowPolicy;
import smartlibrary.policy.PenaltyPolicy;
import smartlibrary.service.impl.DefaultCirculationService;
import smartlibrary.storage.BorrowStorage;
import smartlibrary.storage.ItemStorage;
import smartlibrary.storage.MemberStorage;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

/// VIOLA ZENELI

/*
 * Method under test:
 * DefaultCirculationService.canRenewBorrow(int memberId, String itemCode)
 *
 * Code Coverage Testing types:
 *   - Statement Coverage
 *   - Branch Coverage
 *   - Condition Coverage
 *   - MC/DC
*/

class CodeCoverageTesting {

    private DefaultCirculationService service;

    private ItemStorage itemStorage;
    private MemberStorage memberStorage;
    private BorrowStorage borrowStorage;
    private BorrowPolicy borrowPolicy;
    private PenaltyPolicy penaltyPolicy;
    private AlertService alertService;

    private static final int VALID_MEMBER_ID = 1;
    private static final String VALID_ITEM_CODE = "BOOK-001";

    @BeforeEach
    void setUp() {
        itemStorage = mock(ItemStorage.class);
        memberStorage = mock(MemberStorage.class);
        borrowStorage = mock(BorrowStorage.class);
        borrowPolicy = mock(BorrowPolicy.class);
        penaltyPolicy = mock(PenaltyPolicy.class);
        alertService = mock(AlertService.class);

        service = new DefaultCirculationService(
                itemStorage,
                memberStorage,
                borrowStorage,
                borrowPolicy,
                penaltyPolicy,
                alertService
        );
    }


    /// Helper method: valid setup for reaching final return (2nd if condition false)

    private void stubAllValid() {
        Member member = mock(Member.class);
        when(member.isActive()).thenReturn(true);

        LibraryItem item = mock(LibraryItem.class);

        BorrowRecord record = mock(BorrowRecord.class);
        when(record.getMemberId()).thenReturn(VALID_MEMBER_ID);
        when(record.isReturned()).thenReturn(false);
        when(record.isOverdue(any())).thenReturn(false);

        when(memberStorage.find(VALID_MEMBER_ID)).thenReturn(member);
        when(itemStorage.find(VALID_ITEM_CODE)).thenReturn(item);
        when(borrowStorage.findActiveBorrow(VALID_ITEM_CODE)).thenReturn(record);
        when(borrowStorage.hasOverdueBorrows(eq(VALID_MEMBER_ID), any())).thenReturn(false);
    }


    /// STATEMENT COVERAGE

    // C1 = TRUE -> execution stops at first if (invalid memberId)
    @Test
    void SC1_endsAtFirstIf() {
        assertFalse(service.canRenewBorrow(-1, VALID_ITEM_CODE));
    }

    // C4 = TRUE -> execution stops at second if (member not found)
    @Test
    void SC2_endsAtSecondIf() {
        when(memberStorage.find(VALID_MEMBER_ID)).thenReturn(null);
        assertFalse(service.canRenewBorrow(VALID_MEMBER_ID, VALID_ITEM_CODE));
    }

    // All checks pass -> execution reaches final return
    @Test
    void SC3_endsAtFinalReturn() {
        stubAllValid();
        assertTrue(service.canRenewBorrow(VALID_MEMBER_ID, VALID_ITEM_CODE));
    }


    /// BRANCH COVERAGE

    // first if TRUE
    @Test
    void BC1_firstIfTrue() {
        assertFalse(service.canRenewBorrow(0, VALID_ITEM_CODE));
    }

    // first if FALSE, second if TRUE
    @Test
    void BC2_secondIfTrue() {
        when(memberStorage.find(VALID_MEMBER_ID)).thenReturn(null);
        assertFalse(service.canRenewBorrow(VALID_MEMBER_ID, VALID_ITEM_CODE));
    }

    // both ifs FALSE → final return
    @Test
    void BC3_bothIfFalse() {
        stubAllValid();
        assertTrue(service.canRenewBorrow(VALID_MEMBER_ID, VALID_ITEM_CODE));
    }


    /// CONDITION COVERAGE

    // C1 = TRUE (memberId <= 0)
    @Test
    void CC1_C1_true_memberIdInvalid() {
        assertFalse(service.canRenewBorrow(-1, VALID_ITEM_CODE));
    }

    // C2 = TRUE (itemCode is null)
    @Test
    void CC2_C2_true_itemCodeNull() {
        assertFalse(service.canRenewBorrow(VALID_MEMBER_ID, null));
    }

    // C3 = TRUE (itemCode is blank)
    @Test
    void CC3_C3_true_itemCodeEmpty() {
        assertFalse(service.canRenewBorrow(VALID_MEMBER_ID, "   "));
    }

    // C4 = TRUE (member == null)
    @Test
    void CC4_C4_true_memberNull() {
        when(memberStorage.find(VALID_MEMBER_ID)).thenReturn(null);
        assertFalse(service.canRenewBorrow(VALID_MEMBER_ID, VALID_ITEM_CODE));
    }

    // C5 = TRUE (item == null)
    @Test
    void CC5_C5_true_itemNull() {
        when(itemStorage.find(VALID_ITEM_CODE)).thenReturn(null);
        assertFalse(service.canRenewBorrow(VALID_MEMBER_ID, VALID_ITEM_CODE));
    }

    // C6 = TRUE (record == null)
    @Test
    void CC6_C6_true_recordNull() {
        when(borrowStorage.findActiveBorrow(VALID_ITEM_CODE)).thenReturn(null);
        assertFalse(service.canRenewBorrow(VALID_MEMBER_ID, VALID_ITEM_CODE));
    }

    // C7 = FALSE (borrow belongs to another member)
    @Test
    void CC7_C7_false_wrongMember() {
        stubAllValid();
        BorrowRecord record = borrowStorage.findActiveBorrow(VALID_ITEM_CODE);
        when(record.getMemberId()).thenReturn(99);

        assertFalse(service.canRenewBorrow(VALID_MEMBER_ID, VALID_ITEM_CODE));
    }

    // C8 = FALSE (record is returned)
    @Test
    void CC8_C8_false_recordReturned() {
        stubAllValid();
        BorrowRecord record = borrowStorage.findActiveBorrow(VALID_ITEM_CODE);
        when(record.isReturned()).thenReturn(true);

        assertFalse(service.canRenewBorrow(VALID_MEMBER_ID, VALID_ITEM_CODE));
    }

    // C9 = FALSE (record is overdue)
    @Test
    void CC9_C9_false_recordOverdue() {
        stubAllValid();
        BorrowRecord record = borrowStorage.findActiveBorrow(VALID_ITEM_CODE);
        when(record.isOverdue(any())).thenReturn(true);

        assertFalse(service.canRenewBorrow(VALID_MEMBER_ID, VALID_ITEM_CODE));
    }

    // C10 = FALSE (member inactive)
    @Test
    void CC10_C10_false_memberInactive() {
        stubAllValid();
        Member member = memberStorage.find(VALID_MEMBER_ID);
        when(member.isActive()).thenReturn(false);

        assertFalse(service.canRenewBorrow(VALID_MEMBER_ID, VALID_ITEM_CODE));
    }

    // C11 = FALSE (member has overdue borrows)
    @Test
    void CC11_C11_false_hasOverdueBorrows() {
        stubAllValid();
        when(borrowStorage.hasOverdueBorrows(eq(VALID_MEMBER_ID), any()))
                .thenReturn(true);

        assertFalse(service.canRenewBorrow(VALID_MEMBER_ID, VALID_ITEM_CODE));
    }

    // All conditions TRUE -> renewal allowed
    @Test
    void CC12_allConditionsTrue() {
        stubAllValid();
        assertTrue(service.canRenewBorrow(VALID_MEMBER_ID, VALID_ITEM_CODE));
    }



    /// MC/DC

    // Decision1 -> D1: C1 || C2 || C3

    // D1 – C1 independently affects decision (memberId <= 0)
    @Test
    void MCDC_D1_C1_independent() {
        assertFalse(service.canRenewBorrow(-1, VALID_ITEM_CODE));
    }

    // D1 – C2 independently affects decision (itemCode == null)
    @Test
    void MCDC_D1_C2_independent() {
        assertFalse(service.canRenewBorrow(VALID_MEMBER_ID, null));
    }

    // D1 – C3 independently affects decision (itemCode is empty or blank)
    @Test
    void MCDC_D1_C3_independent() {
        assertFalse(service.canRenewBorrow(VALID_MEMBER_ID, ""));
    }

    // Decision2 -> D2: C4 || C5 || C6

    // D2 – C4 independently affects decision (member == null)
    @Test
    void MCDC_D2_C4_independent() {
        when(memberStorage.find(VALID_MEMBER_ID)).thenReturn(null);
        assertFalse(service.canRenewBorrow(VALID_MEMBER_ID, VALID_ITEM_CODE));
    }

    // D2 – C5 independently affects decision (item == null)
    @Test
    void MCDC_D2_C5_independent() {
        when(itemStorage.find(VALID_ITEM_CODE)).thenReturn(null);
        assertFalse(service.canRenewBorrow(VALID_MEMBER_ID, VALID_ITEM_CODE));
    }

    // D2 – C6 independently affects decision (record == null)
    @Test
    void MCDC_D2_C6_independent() {
        when(borrowStorage.findActiveBorrow(VALID_ITEM_CODE)).thenReturn(null);
        assertFalse(service.canRenewBorrow(VALID_MEMBER_ID, VALID_ITEM_CODE));
    }


    // Decision3 -> D3: C7 && C8 && C9 && C10 && C11

    // D3 – C7 independently affects decision (borrow belongs to different member)
    @Test
    void MCDC_D3_C7_independent() {
        stubAllValid();
        BorrowRecord record = borrowStorage.findActiveBorrow(VALID_ITEM_CODE);
        when(record.getMemberId()).thenReturn(99);
        assertFalse(service.canRenewBorrow(VALID_MEMBER_ID, VALID_ITEM_CODE));
    }

    // D3 – C8 independently affects decision (borrow already returned)
    @Test
    void MCDC_D3_C8_independent_isReturned() {
        stubAllValid();
        BorrowRecord record = borrowStorage.findActiveBorrow(VALID_ITEM_CODE);
        when(record.isReturned()).thenReturn(true);
        assertFalse(service.canRenewBorrow(VALID_MEMBER_ID, VALID_ITEM_CODE));
    }

    // D3 – C9 independently affects decision (borrow is overdue)
    @Test
    void MCDC_D3_C9_independent() {
        stubAllValid();
        BorrowRecord record = borrowStorage.findActiveBorrow(VALID_ITEM_CODE);
        when(record.isOverdue(any())).thenReturn(true);
        assertFalse(service.canRenewBorrow(VALID_MEMBER_ID, VALID_ITEM_CODE));
    }

    // D3 – C10 independently affects decision (member is inactive)
    @Test
    void MCDC_D3_C10_independent() {
        stubAllValid();
        Member member = memberStorage.find(VALID_MEMBER_ID);
        when(member.isActive()).thenReturn(false);
        assertFalse(service.canRenewBorrow(VALID_MEMBER_ID, VALID_ITEM_CODE));
    }

    // D3 – C11 independently affects decision (member has other overdue borrows)
    @Test
    void MCDC_D3_C11_independent() {
        stubAllValid();
        when(borrowStorage.hasOverdueBorrows(eq(VALID_MEMBER_ID), any())).thenReturn(true);
        assertFalse(service.canRenewBorrow(VALID_MEMBER_ID, VALID_ITEM_CODE));
    }

    // D3 – Baseline case (all conditions TRUE)
    @Test
    void MCDC_D3_allTrue() {
        stubAllValid();
        assertTrue(service.canRenewBorrow(VALID_MEMBER_ID, VALID_ITEM_CODE));
    }
}

