package smartlibrary.Part2_Testing.Sidrit_Rrustemi;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

import java.time.LocalDate;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.CsvSource;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

import smartlibrary.model.BorrowRecord;
import smartlibrary.notification.AlertService;
import smartlibrary.policy.BorrowPolicy;
import smartlibrary.policy.PenaltyPolicy;
import smartlibrary.service.impl.DefaultCirculationService;
import smartlibrary.storage.BorrowStorage;
import smartlibrary.storage.ItemStorage;
import smartlibrary.storage.MemberStorage;

class BoundaryValueTesting {

    @Mock
    private BorrowStorage borrowStorage;

    @Mock
    private ItemStorage itemStorage;

    @Mock
    private MemberStorage memberStorage;

    @Mock
    private PenaltyPolicy penaltyPolicy;

    @Mock
    private BorrowPolicy borrowPolicy;

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

    @ParameterizedTest(name = "daysBeforeDue={0}, daysUntilDue={1}, expected={2}")
    @CsvSource({
            "-1, 3, false",    // below min boundary
            "0, 0, true",      // min boundary
            "0, 1, false",     // min boundary, not due today
            "1, 1, true",      // just above min
            "3, -1, true",     // overdue item
            "3, 3, true",      // nominal/typical
            "6, 6, true",      // just below max
            "7, 7, true",      // max boundary
            "8, 7, false"      // above max boundary
    })
    void shouldSendReminder_BVT(int daysBeforeDue, int daysUntilDue, boolean expected) {
        BorrowRecord activeRecord = mock(BorrowRecord.class);
        when(activeRecord.isReturned()).thenReturn(false);
        when(activeRecord.getDueDate()).thenReturn(LocalDate.now().plusDays(daysUntilDue));
        when(borrowStorage.findActiveBorrow("item")).thenReturn(activeRecord);

        boolean result = circulationService.shouldSendReminder("item", daysBeforeDue);
        assertEquals(expected, result);
    }
}