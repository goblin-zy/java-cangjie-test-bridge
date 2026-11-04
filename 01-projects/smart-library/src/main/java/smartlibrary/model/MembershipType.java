package smartlibrary.model;

public enum MembershipType {
    STUDENT(3, 14),
    STAFF(5, 30),
    GUEST(1, 7);

    private final int maxLoans;
    private final int maxLoanDays;

    MembershipType(int maxLoans, int maxLoanDays) {
        this.maxLoans = maxLoans;
        this.maxLoanDays = maxLoanDays;
    }

    public int getMaxLoans() {
        return maxLoans;
    }

    public int getMaxLoanDays() {
        return maxLoanDays;
    }
}
