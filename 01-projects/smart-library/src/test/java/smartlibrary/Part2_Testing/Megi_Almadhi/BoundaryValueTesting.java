package smartlibrary.Part2_Testing.Megi_Almadhi;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.Mockito.*;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import smartlibrary.model.Member;
import smartlibrary.model.MembershipType;
import smartlibrary.notification.AlertService;
import smartlibrary.policy.BorrowPolicy;
import smartlibrary.policy.PenaltyPolicy;
import smartlibrary.service.impl.DefaultCirculationService;
import smartlibrary.storage.BorrowStorage;
import smartlibrary.storage.ItemStorage;
import smartlibrary.storage.MemberStorage;

@ExtendWith(MockitoExtension.class)
public class BoundaryValueTesting {

    @Mock
    private ItemStorage itemStorage;
    
    @Mock
    private BorrowStorage borrowStorage;

    @Mock
    private MemberStorage memberStorage;
    
    @Mock
    private BorrowPolicy borrowPolicy;
    
    @Mock
    private PenaltyPolicy penaltyPolicy;
    
    @Mock
    private AlertService alertService;

    private DefaultCirculationService circulationService;

    private final int MEMBER_ID = 1;
    private Member member;

    @BeforeEach
    void setup() {
        // service with all required dependencies
        circulationService = new DefaultCirculationService(
            itemStorage,
            memberStorage,
            borrowStorage,
            borrowPolicy,
            penaltyPolicy,
            alertService
        );
        
        // mock member
        member = mock(Member.class);
        MembershipType type = mock(MembershipType.class);

        when(member.getMembershipType()).thenReturn(type);
        when(type.getMaxLoans()).thenReturn(5); // N = 5

        // When DefaultCirculationService asks for a member
        when(memberStorage.find(MEMBER_ID)).thenReturn(member);
    }

    @Test
    void belowBoundary() {
        when(borrowStorage.countActiveBorrows(MEMBER_ID)).thenReturn(4); // N-1
        int result = circulationService.getRemainingBorrowCapacity(MEMBER_ID);
        assertEquals(1, result);
    }

    @Test
    void atBoundary() {
        when(borrowStorage.countActiveBorrows(MEMBER_ID)).thenReturn(5); // N
        int result = circulationService.getRemainingBorrowCapacity(MEMBER_ID);
        assertEquals(0, result);
    }

    @Test
    void aboveBoundary() {
        when(borrowStorage.countActiveBorrows(MEMBER_ID)).thenReturn(6); // N+1
        int result = circulationService.getRemainingBorrowCapacity(MEMBER_ID);
        assertEquals(0, result); // Math.max ensures this stays at 0
    }
}