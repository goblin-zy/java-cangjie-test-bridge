package smartlibrary.service.impl;

import smartlibrary.model.BorrowRecord;
import smartlibrary.model.LibraryItem;
import smartlibrary.model.Member;
import smartlibrary.notification.AlertService;
import smartlibrary.policy.BorrowPolicy;
import smartlibrary.policy.PenaltyPolicy;
import smartlibrary.service.CirculationService;
import smartlibrary.storage.BorrowStorage;
import smartlibrary.storage.ItemStorage;
import smartlibrary.storage.MemberStorage;

import java.time.LocalDate;

public class DefaultCirculationService implements CirculationService {

    private final ItemStorage itemStorage;
    private final MemberStorage memberStorage;
    private final BorrowStorage borrowStorage;
    private final BorrowPolicy borrowPolicy;
    private final PenaltyPolicy penaltyPolicy;
    private final AlertService alertService;

    public DefaultCirculationService(
            ItemStorage itemStorage,
            MemberStorage memberStorage,
            BorrowStorage borrowStorage,
            BorrowPolicy borrowPolicy,
            PenaltyPolicy penaltyPolicy,
            AlertService alertService) {

        if (itemStorage == null || memberStorage == null || borrowStorage == null ||
                borrowPolicy == null || penaltyPolicy == null || alertService == null) {
            throw new IllegalArgumentException("All dependencies must be non-null");
        }

        this.itemStorage = itemStorage;
        this.memberStorage = memberStorage;
        this.borrowStorage = borrowStorage;
        this.borrowPolicy = borrowPolicy;
        this.penaltyPolicy = penaltyPolicy;
        this.alertService = alertService;
    }

    @Override
    public void requestBorrow(int memberId, String itemCode) {
        LocalDate today = LocalDate.now();

        validateMemberId(memberId);
        validateItemCode(itemCode);

        Member member = getMemberOrThrow(memberId);
        LibraryItem item = getItemOrThrow(itemCode);

        int active = borrowStorage.countActiveBorrows(memberId);
        boolean hasOverdue = borrowStorage.hasOverdueBorrows(memberId, today);

        if (!item.isAvailable()) {
            throw new IllegalStateException("Item not available: " + itemCode);
        }

        if (!borrowPolicy.canBorrow(member, active, hasOverdue)) {
            throw new IllegalStateException("Borrow policy violation for member: " + memberId);
        }

        LocalDate dueDate = calculateDueDate(today, member);

        itemStorage.updateAvailability(itemCode, false);
        borrowStorage.save(new BorrowRecord(memberId, itemCode, dueDate));
    }

    @Override
    public void returnItem(String itemCode) {
        LocalDate today = LocalDate.now();

        validateItemCode(itemCode);

        BorrowRecord record = borrowStorage.findActiveBorrow(itemCode);
        if (record == null) {
            throw new IllegalStateException("No active borrow for item: " + itemCode);
        }

        boolean wasOverdue = record.isOverdue(today);
        int overdueDays = record.overdueDays(today);

        record.markReturned();
        itemStorage.updateAvailability(itemCode, true);

        if (wasOverdue) {
            double fine = penaltyPolicy.calculatePenalty(overdueDays);
            alertService.sendAlert(
                    record.getMemberId(),
                    String.format("Item %s was overdue by %d days. Fine: $%.2f",
                            itemCode, overdueDays, fine)
            );
        }
    }

    @Override
    public boolean canBorrowMore(int memberId) {
        validateMemberId(memberId);
        Member member = getMemberOrThrow(memberId);

        return borrowStorage.countActiveBorrows(memberId)
                < member.getMembershipType().getMaxLoans();
    }

    @Override
    public double calculateFine(String itemCode) {
        LocalDate today = LocalDate.now();
        validateItemCode(itemCode);

        BorrowRecord record = borrowStorage.findActiveBorrow(itemCode);
        if (record == null) {
            throw new IllegalStateException("No active borrow for item: " + itemCode);
        }

        if (record.isReturned()) {
            return 0;
        }

        int overdueDays = record.overdueDays(today);
        return overdueDays <= 0 ? 0 : penaltyPolicy.calculatePenalty(overdueDays);
    }

    @Override
    public boolean isEligibleToBorrow(int memberId, String itemCode) {
        LocalDate today = LocalDate.now();

        if (memberId <= 0 || itemCode == null || itemCode.trim().isEmpty()) {
            return false;
        }

        Member member = memberStorage.find(memberId);
        LibraryItem item = itemStorage.find(itemCode);

        if (member == null || item == null) return false;

        int active = borrowStorage.countActiveBorrows(memberId);
        boolean hasOverdue = borrowStorage.hasOverdueBorrows(memberId, today);

        return member.isActive()
                && item.isAvailable()
                && active < member.getMembershipType().getMaxLoans()
                && !hasOverdue;
    }

    @Override
    public int getRemainingBorrowCapacity(int memberId) {
        validateMemberId(memberId);
        Member member = getMemberOrThrow(memberId);

        int activeBorrows = borrowStorage.countActiveBorrows(memberId);
        int maxLoans = member.getMembershipType().getMaxLoans();

        return Math.max(0, maxLoans - activeBorrows);
    }

    @Override
    public String validateMemberStatus(int memberId) {
        LocalDate today = LocalDate.now();

        if (memberId <= 0) {
            return "INVALID_MEMBER_ID";
        }

        Member member = memberStorage.find(memberId);
        if (member == null) {
            return "MEMBER_NOT_FOUND";
        }

        boolean isActive = member.isActive();
        boolean hasOverdue = borrowStorage.hasOverdueBorrows(memberId, today);
        boolean atCapacity = borrowStorage.countActiveBorrows(memberId)
                >= member.getMembershipType().getMaxLoans();

        if (!isActive && hasOverdue && atCapacity) {
            return "SUSPENDED_MULTIPLE_ISSUES";
        }
        if (!isActive && hasOverdue) {
            return "SUSPENDED_INACTIVE_OVERDUE";
        }
        if (!isActive && atCapacity) {
            return "SUSPENDED_INACTIVE_CAPACITY";
        }
        if (hasOverdue && atCapacity) {
            return "RESTRICTED_OVERDUE_CAPACITY";
        }
        if (!isActive) {
            return "INACTIVE";
        }
        if (hasOverdue) {
            return "OVERDUE_ITEMS";
        }
        if (atCapacity) {
            return "AT_CAPACITY";
        }

        return "ACTIVE_GOOD_STANDING";
    }

    @Override
    public String getFineCategory(String itemCode) {
        LocalDate today = LocalDate.now();
        validateItemCode(itemCode);

        BorrowRecord record = borrowStorage.findActiveBorrow(itemCode);
        if (record == null) {
            throw new IllegalStateException("No active borrow for item: " + itemCode);
        }

        if (record.isReturned()) {
            return "NO_FINE_RETURNED";
        }

        int overdueDays = record.overdueDays(today);

        if (overdueDays <= 0) {
            return "NO_FINE_ON_TIME";
        }
        if (overdueDays <= 5) {
            return "LOW_FINE";
        }
        if (overdueDays <= 14) {
            return "MEDIUM_FINE";
        }
        return "HIGH_FINE";
    }

    @Override
    public boolean canRenewBorrow(int memberId, String itemCode) {
        LocalDate today = LocalDate.now();

        if (memberId <= 0 || itemCode == null || itemCode.trim().isEmpty()) {
            return false;
        }

        Member member = memberStorage.find(memberId);
        LibraryItem item = itemStorage.find(itemCode);
        BorrowRecord record = borrowStorage.findActiveBorrow(itemCode);

        if (member == null || item == null || record == null) {
            return false;
        }

        return record.getMemberId() == memberId
                && !record.isReturned()
                && !record.isOverdue(today)
                && member.isActive()
                && !borrowStorage.hasOverdueBorrows(memberId, today);
    }

    @Override
    public int getTotalOverdueDays(int memberId) {
        LocalDate today = LocalDate.now();
        validateMemberId(memberId);

        return borrowStorage.findAll().stream()
                .filter(r -> r.getMemberId() == memberId && !r.isReturned())
                .mapToInt(r -> r.overdueDays(today))
                .sum();
    }

    private LocalDate calculateDueDate(LocalDate borrowDate, Member member) {
        return borrowDate.plusDays(member.getMembershipType().getMaxLoanDays());
    }

    private void validateMemberId(int memberId) {
        if (memberId <= 0) {
            throw new IllegalArgumentException("Member ID must be positive: " + memberId);
        }
    }

    private void validateItemCode(String itemCode) {
        if (itemCode == null || itemCode.trim().isEmpty()) {
            throw new IllegalArgumentException("Item code cannot be null or empty");
        }
    }

    private Member getMemberOrThrow(int memberId) {
        Member member = memberStorage.find(memberId);
        if (member == null) {
            throw new IllegalStateException("Member not found: " + memberId);
        }
        return member;
    }

    private LibraryItem getItemOrThrow(String itemCode) {
        LibraryItem item = itemStorage.find(itemCode);
        if (item == null) {
            throw new IllegalStateException("Item not found: " + itemCode);
        }
        return item;
    }

    @Override
    public int getDaysUntilDue(String itemCode) {
        LocalDate today = LocalDate.now();
        validateItemCode(itemCode);

        BorrowRecord record = borrowStorage.findActiveBorrow(itemCode);
        if (record == null) {
            throw new IllegalStateException("No active borrow for item: " + itemCode);
        }

        if (record.isReturned()) {
            return 0;
        }

        return (int) java.time.temporal.ChronoUnit.DAYS.between(today, record.getDueDate());
    }

    @Override
    public double calculateLateFeeWithDiscount(String itemCode, int discountPercent) {
        if (discountPercent < 0 || discountPercent > 100) {
            throw new IllegalArgumentException("Discount must be between 0 and 100");
        }

        double baseFine = calculateFine(itemCode);
        double discount = baseFine * (discountPercent / 100.0);

        return Math.max(0, baseFine - discount);
    }

    @Override
    public String getMembershipEligibility(int currentBorrows, boolean hasOverdue, boolean isActive) {
        if (currentBorrows < 0) {
            return "INVALID_BORROW_COUNT";
        }

        if (!isActive) {
            return "MEMBERSHIP_INACTIVE";
        }

        if (hasOverdue) {
            return "HAS_OVERDUE_ITEMS";
        }

        if (currentBorrows == 0) {
            return "EXCELLENT_STANDING";
        } else if (currentBorrows <= 2) {
            return "GOOD_STANDING";
        } else if (currentBorrows <= 4) {
            return "MODERATE_USAGE";
        } else {
            return "HEAVY_USAGE";
        }
    }

    @Override
    public String assessItemReturnStatus(String itemCode, int daysLate) {
        validateItemCode(itemCode);

        BorrowRecord record = borrowStorage.findActiveBorrow(itemCode);
        if (record == null) {
            return "NO_ACTIVE_BORROW";
        }

        if (record.isReturned()) {
            return "ALREADY_RETURNED";
        }

        if (daysLate < 0) {
            return "EARLY_RETURN";
        } else if (daysLate == 0) {
            return "ON_TIME";
        } else if (daysLate <= 3) {
            return "SLIGHTLY_LATE";
        } else if (daysLate <= 7) {
            return "MODERATELY_LATE";
        } else if (daysLate <= 14) {
            return "VERY_LATE";
        } else {
            return "SEVERELY_OVERDUE";
        }
    }

    @Override
    public boolean canBorrowItemType(int memberId, String itemType, int itemValue) {
        if (memberId <= 0 || itemType == null || itemValue < 0) {
            return false;
        }

        Member member = memberStorage.find(memberId);
        if (member == null) {
            return false;
        }

        LocalDate today = LocalDate.now();

        boolean isActive = member.isActive();
        boolean hasCapacity = borrowStorage.countActiveBorrows(memberId)
                < member.getMembershipType().getMaxLoans();
        boolean noOverdue = !borrowStorage.hasOverdueBorrows(memberId, today);
        boolean valueLimitOk = itemValue <= getValueLimit(member);

        return isActive && hasCapacity && noOverdue && valueLimitOk;
    }

    @Override
    public boolean shouldSendReminder(String itemCode, int daysBeforeDue) {
        validateItemCode(itemCode);

        if (daysBeforeDue < 0 || daysBeforeDue > 7) {
            return false;
        }

        BorrowRecord record = borrowStorage.findActiveBorrow(itemCode);
        if (record == null || record.isReturned()) {
            return false;
        }

        LocalDate today = LocalDate.now();
        int daysUntilDue = (int) java.time.temporal.ChronoUnit.DAYS
                .between(today, record.getDueDate());

        if (daysUntilDue == daysBeforeDue) {
            return true;
        }

        return daysUntilDue < 0;
    }

    private int getValueLimit(Member member) {
        return switch (member.getMembershipType()) {
            case STUDENT -> 100;
            case STAFF -> 500;
            case GUEST -> 50;
        };
    }
}