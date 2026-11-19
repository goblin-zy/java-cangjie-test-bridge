package smartlibrary.notification.impl;

import smartlibrary.notification.AlertService;

public class StubAlertService implements AlertService {

    private int lastMemberId;
    private String lastMessage;

    @Override
    public void sendAlert(int memberId, String message) {
        this.lastMemberId = memberId;
        this.lastMessage = message;
    }

    public int getLastMemberId() {
        return lastMemberId;
    }

    public String getLastMessage() {
        return lastMessage;
    }
}
