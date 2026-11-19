package smartlibrary.service;

public interface CirculationService {

    void requestBorrow(int memberId, String itemCode);
    void returnItem(String itemCode);
    boolean canBorrowMore(int memberId);
    double calculateFine(String itemCode);
    boolean isEligibleToBorrow(int memberId, String itemCode);

    int getRemainingBorrowCapacity(int memberId);
    int getDaysUntilDue(String itemCode);
    double calculateLateFeeWithDiscount(String itemCode, int discountPercent);
    int getTotalOverdueDays(int memberId);

    String validateMemberStatus(int memberId);
    String getFineCategory(String itemCode);
    String getMembershipEligibility(int currentBorrows, boolean hasOverdue, boolean isActive);
    String assessItemReturnStatus(String itemCode, int daysLate);

    boolean canRenewBorrow(int memberId, String itemCode);
    boolean canBorrowItemType(int memberId, String itemType, int itemValue);
    boolean shouldSendReminder(String itemCode, int daysBeforeDue);
}