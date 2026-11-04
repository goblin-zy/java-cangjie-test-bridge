package smartlibrary.Part3_Testing.BottomUp_Integration;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.BeforeEach;
import smartlibrary.api.*;
import smartlibrary.api.impl.*;
import smartlibrary.model.*;
import smartlibrary.notification.impl.*;
import smartlibrary.policy.impl.*;
import smartlibrary.service.impl.*;
import smartlibrary.storage.memory.*;
import java.time.LocalDate;

import static org.junit.jupiter.api.Assertions.*;

class D_LibraryFacadeIntegrationTest {

    private LibraryFacade facade;
    private MemoryMemberStorage memberStorage;
    private MemoryItemStorage itemStorage;
    private MemoryBorrowStorage borrowStorage;
    private StubAlertService alertService;
    
    @BeforeEach
    void setup() {
        memberStorage = new MemoryMemberStorage();
        itemStorage = new MemoryItemStorage();
        borrowStorage = new MemoryBorrowStorage();
        alertService = new StubAlertService();
        
        DefaultCirculationService circulationService = new DefaultCirculationService(
            itemStorage,
            memberStorage,
            borrowStorage,
            new DefaultBorrowPolicy(),
            new DefaultPenaltyPolicy(),
            alertService
        );
        
        facade = new DefaultLibraryFacade(circulationService);
    }

    // Basic facade delegation
    @Test void borrowFlow_delegatesToCirculationService_andBorrowIsProcessed() {
        Member member = new Member(1, true, MembershipType.STUDENT);
        LibraryItem item = new LibraryItem("BOOK001", true);
        memberStorage.save(member);
        itemStorage.save(item);
        
        facade.borrowFlow(1, "BOOK001");
        
        assertFalse(itemStorage.find("BOOK001").isAvailable());
        assertNotNull(borrowStorage.findActiveBorrow("BOOK001"));
    }
    
    @Test void returnFlow_delegatesToCirculationService_andReturnIsProcessed() {
        Member member = new Member(1, true, MembershipType.STUDENT);
        LibraryItem item = new LibraryItem("BOOK001", true);
        memberStorage.save(member);
        itemStorage.save(item);
        
        facade.borrowFlow(1, "BOOK001");
        facade.returnFlow("BOOK001");
        
        assertTrue(itemStorage.find("BOOK001").isAvailable());
        assertNull(borrowStorage.findActiveBorrow("BOOK001"));
    }
    
    @Test void borrowThenReturn_fullFlow_updatesAvailability_andBorrowRecordStatus() {
        Member member = new Member(1, true, MembershipType.STUDENT);
        LibraryItem item = new LibraryItem("BOOK001", true);
        memberStorage.save(member);
        itemStorage.save(item);
        
        facade.borrowFlow(1, "BOOK001");
        assertFalse(itemStorage.find("BOOK001").isAvailable());
        
        facade.returnFlow("BOOK001");
        assertTrue(itemStorage.find("BOOK001").isAvailable());
        
        var allRecords = borrowStorage.findAll();
        assertEquals(1, allRecords.size());
        assertTrue(allRecords.get(0).isReturned());
    }

    // Error scenarios through facade
    @Test void borrowFlow_memberNotFound_throwsRuntimeException() {
        LibraryItem item = new LibraryItem("BOOK001", true);
        itemStorage.save(item);
        
        assertThrows(RuntimeException.class, () -> facade.borrowFlow(999, "BOOK001"));
    }
    
    @Test void borrowFlow_itemNotFound_throwsRuntimeException() {
        Member member = new Member(1, true, MembershipType.STUDENT);
        memberStorage.save(member);
        
        assertThrows(RuntimeException.class, () -> facade.borrowFlow(1, "INVALID"));
    }
    
    @Test void borrowFlow_itemNotAvailable_throwsRuntimeException() {
        Member member = new Member(1, true, MembershipType.STUDENT);
        LibraryItem item = new LibraryItem("BOOK001", false);
        memberStorage.save(member);
        itemStorage.save(item);
        
        assertThrows(RuntimeException.class, () -> facade.borrowFlow(1, "BOOK001"));
    }
    
    @Test void borrowFlow_inactiveMember_throwsRuntimeException() {
        Member member = new Member(1, false, MembershipType.STUDENT);
        LibraryItem item = new LibraryItem("BOOK001", true);
        memberStorage.save(member);
        itemStorage.save(item);
        
        assertThrows(RuntimeException.class, () -> facade.borrowFlow(1, "BOOK001"));
    }
    
    @Test void borrowFlow_borrowLimitReached_throwsRuntimeException() {
        Member member = new Member(1, true, MembershipType.GUEST); // GUEST max = 1
        LibraryItem item1 = new LibraryItem("BOOK001", true);
        LibraryItem item2 = new LibraryItem("BOOK002", true);
        memberStorage.save(member);
        itemStorage.save(item1);
        itemStorage.save(item2);
        
        facade.borrowFlow(1, "BOOK001");
        
        assertThrows(RuntimeException.class, () -> facade.borrowFlow(1, "BOOK002"));
    }
    
    @Test void borrowFlow_memberHasOverdue_throwsRuntimeException() {
        Member member = new Member(1, true, MembershipType.STUDENT);
        LibraryItem item1 = new LibraryItem("BOOK001", false);
        LibraryItem item2 = new LibraryItem("BOOK002", true);
        memberStorage.save(member);
        itemStorage.save(item1);
        itemStorage.save(item2);
        
        // Create overdue borrow
        LocalDate pastDue = LocalDate.now().minusDays(5);
        BorrowRecord overdueRecord = new BorrowRecord(1, "BOOK001", pastDue);
        borrowStorage.save(overdueRecord);
        
        assertThrows(RuntimeException.class, () -> facade.borrowFlow(1, "BOOK002"));
    }

    @Test void returnFlow_notOverdue_doesNotSendAlert() {
        Member member = new Member(1, true, MembershipType.STUDENT);
        LibraryItem item = new LibraryItem("BOOK001", true);
        memberStorage.save(member);
        itemStorage.save(item);
        
        facade.borrowFlow(1, "BOOK001");
        facade.returnFlow("BOOK001");
        
        // Alert service should not have been called for non-overdue return
        // Check that lastMessage is null or empty
        assertNull(alertService.getLastMessage());
    }
    
    @Test void returnFlow_overdue_sendsAlertToCorrectMemberWithMessage() {
        Member member = new Member(1, true, MembershipType.STUDENT);
        LibraryItem item = new LibraryItem("BOOK001", false);
        memberStorage.save(member);
        itemStorage.save(item);
        
        // Create overdue borrow
        LocalDate pastDue = LocalDate.now().minusDays(3);
        BorrowRecord overdueRecord = new BorrowRecord(1, "BOOK001", pastDue);
        borrowStorage.save(overdueRecord);
        
        facade.returnFlow("BOOK001");
        
        assertEquals(1, alertService.getLastMemberId());
        assertNotNull(alertService.getLastMessage());
        assertTrue(alertService.getLastMessage().contains("overdue"));
        assertTrue(alertService.getLastMessage().contains("BOOK001"));
    }
    
    @Test void returnFlow_noActiveBorrow_throwsRuntimeException() {
        assertThrows(RuntimeException.class, () -> facade.returnFlow("BOOK001"));
    }
}