package smartlibrary.model;

import java.time.LocalDate;
import java.util.Objects;

public class BorrowRecord {

    private final int memberId;
    private final String itemCode;
    private final LocalDate dueDate;
    private final LocalDate borrowDate;
    private boolean returned;
    private LocalDate returnDate;

    public BorrowRecord(int memberId, String itemCode, LocalDate dueDate) {
        if (memberId <= 0) {
            throw new IllegalArgumentException("Member ID must be positive");
        }
        if (itemCode == null || itemCode.trim().isEmpty()) {
            throw new IllegalArgumentException("Item code cannot be null or empty");
        }
        if (dueDate == null) {
            throw new IllegalArgumentException("Due date cannot be null");
        }

        this.memberId = memberId;
        this.itemCode = itemCode;
        this.dueDate = dueDate;
        this.borrowDate = LocalDate.now();
        this.returned = false;
    }

    public int getMemberId() {
        return memberId;
    }

    public String getItemCode() {
        return itemCode;
    }

    public LocalDate getDueDate() {
        return dueDate;
    }

    public LocalDate getBorrowDate() {
        return borrowDate;
    }

    public boolean isReturned() {
        return returned;
    }

    public LocalDate getReturnDate() {
        return returnDate;
    }

    public void markReturned() {
        this.returned = true;
        this.returnDate = LocalDate.now();
    }

    public boolean isOverdue(LocalDate today) {
        return !returned && today.isAfter(dueDate);
    }

    public int overdueDays(LocalDate today) {
        if (returned || !today.isAfter(dueDate)) return 0;
        return (int) java.time.temporal.ChronoUnit.DAYS.between(dueDate, today);
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        BorrowRecord that = (BorrowRecord) o;
        return memberId == that.memberId &&
                Objects.equals(itemCode, that.itemCode) &&
                Objects.equals(borrowDate, that.borrowDate);
    }
}