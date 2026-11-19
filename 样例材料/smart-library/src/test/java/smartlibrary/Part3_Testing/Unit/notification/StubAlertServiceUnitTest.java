package smartlibrary.Part3_Testing.Unit.notification;

import org.junit.jupiter.api.Test;
import smartlibrary.notification.impl.StubAlertService;

import static org.junit.jupiter.api.Assertions.*;

public class StubAlertServiceUnitTest {

    @Test 
    void sendAlert_storesLastMemberIdAndMessage(){
        StubAlertService alertService = new StubAlertService();
        
        alertService.sendAlert(1, "Test message");
        
        assertEquals(1, alertService.getLastMemberId());
        assertEquals("Test message", alertService.getLastMessage());
        
        alertService.sendAlert(2, "Another message");
        
        assertEquals(2, alertService.getLastMemberId());
        assertEquals("Another message", alertService.getLastMessage());
    }
}